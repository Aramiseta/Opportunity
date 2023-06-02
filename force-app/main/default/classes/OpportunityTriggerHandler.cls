public with sharing class OpportunityTriggerHandler {

    public static void isAfterUpdate(List<Opportunity> newList, Map<Id, Opportunity> newMap) {
        setSupportFlag(newList, newMap);
    }

    public static void setSupportFlag(List<Opportunity> newList, Map<Id, Opportunity> newMap){
        Set<Id> accId = new Set<Id>();
        Map<Id, String> mapOfLicenses = new Map<Id, String>();
        List<Account> accountsToUpdate = new List<Account>();

        for (Opportunity opp: newList){
            if (opp.StageName == 'Ordered'  &&
            opp.RecordTypeId == Schema.SObjectType.Opportunity.RecordTypeInfosByName.get(OpportunityConstans.CLOSED_WON).getRecordTypeId())
            {
                accId.add(opp.AccountId);
            }
        }

        for (OpportunityLineItem oli : [SELECT OpportunityId, LicenseType__c
        FROM OpportunityLineItem
        WHERE OpportunityId IN :Trigger.newMap.keySet()]) {
            mapOfLicenses.put(oli.OpportunityId, oli.LicenseType__c);
        }
        List<Opportunity> oppList = OpportunitySelector.getOpportunityByAccountId(accId);

        for (Opportunity opp : oppList) {
            Account acc = getAccount(opp.AccountId);
            String licenseType = mapOfLicenses.get(opp.Id);

            if (licenseType == OpportunityLineItemConstans.STANDARD_LICENSE) {
                acc.SupportExpirationDate__c = Date.today().addMonths(AccountConstans.STANDARD_LICENSE_SUPPORT);
            } else if (licenseType == OpportunityLineItemConstans.ONE_TIME_CONTRACT) {
                acc.SupportExpirationDate__c = Date.today().addMonths(AccountConstans.ONE_TIME_CONTRACT_SUPPORT);
            }
            accountsToUpdate.add(acc);
        }
     
        if (!accountsToUpdate.isEmpty()) {
            database.update(accountsToUpdate);
        }
    }
    public static Account getAccount(Id accId) {
        return [SELECT Id FROM Account WHERE Id = :accID];
    }

    public class NoAccountException extends Exception {}
}

