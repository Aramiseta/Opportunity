@isTest
public with sharing class OpportunityTriggerHandlerTest {

    @TestSetup
    static void setup(){
        Account acc = TestDataFactory.createAccount();
        insert acc;
        Opportunity opp = TestDataFactory.createOpportunity(acc.Id);
        insert opp;
        Product2 pro = TestDataFactory.createProduct2();
        PricebookEntry standardPriceEntry = TestDataFactory.createPricebookEntry(pro.Id);
        OpportunityLineItem lineItem = TestDataFactory.createOpportunityLineItem(opp.Id, standardPriceEntry.Id, 
                                                                                 OpportunityLineItemConstans.STANDARD_LICENSE);
        insert lineItem;
    }

    @isTest
    static void OpportunityProductWithStandardLicense() {
        Opportunity opp = getOpportunities();
        Account acc = getAccounts();
        opp.StageName = OpportunityConstans.ORDERED_STAGE;
        opp.RecordTypeId = Schema.SObjectType.Opportunity.RecordTypeInfosByName.get(OpportunityConstans.CLOSED_WON).getRecordTypeId();

        Test.startTest();
            update opp;
        Test.stopTest();

        Account updatedAccount = [SELECT IsSupported__c, SupportExpirationDate__c FROM Account WHERE Id =: acc.Id];
        System.assertEquals(true, updatedAccount.IsSupported__c, 'Flag should be set as true');
        System.assertEquals(Date.today().addMonths(AccountConstans.STANDARD_LICENSE_SUPPORT), updatedAccount.SupportExpirationDate__c, 
        'Support expiration date should be set up 1 year from today');
   } 

    @isTest
    static void OpportunityProductWithOneTimeContract() {
        Opportunity opp = getOpportunities();
        Account acc = getAccounts();
        OpportunityLineItem oLI = getOpportunityLineItem();
        oLI.LicenseType__c = OpportunityLineItemConstans.ONE_TIME_CONTRACT;
        update oLI;

        opp.StageName = OpportunityConstans.ORDERED_STAGE;
        opp.RecordTypeId = Schema.SObjectType.Opportunity.RecordTypeInfosByName.get(OpportunityConstans.CLOSED_WON).getRecordTypeId();

        Test.startTest();
            update opp;
        Test.stopTest();

        Account updatedAccount = [SELECT IsSupported__c, SupportExpirationDate__c FROM Account WHERE Id =: acc.Id];
        System.assertEquals(true, updatedAccount.IsSupported__c, 'Flag should be set as true');
        System.assertEquals(Date.today().addMonths(AccountConstans.ONE_TIME_CONTRACT_SUPPORT), updatedAccount.SupportExpirationDate__c, 
        'Support expiration date should be set up 3 months from today');
    }

    @isTest
    static void OpportunityProductWithOtherContract() {
        Opportunity opp = getOpportunities();
        Account acc = getAccounts();
        OpportunityLineItem oLI = getOpportunityLineItem();
        oLI.LicenseType__c = OpportunityLineItemConstans.DEMO;
        update oLI;

        opp.StageName = OpportunityConstans.ORDERED_STAGE;
        opp.RecordTypeId = Schema.SObjectType.Opportunity.RecordTypeInfosByName.get(OpportunityConstans.CLOSED_WON).getRecordTypeId();

        Test.startTest();
            update opp;
        Test.stopTest();

        Account updatedAccount = [SELECT IsSupported__c, SupportExpirationDate__c FROM Account WHERE Id =: acc.Id];
        System.assertEquals(false, updatedAccount.IsSupported__c, 'Flag should be set as false');
        System.assertEquals(null, updatedAccount.SupportExpirationDate__c, 'There should be no expiration date');
    }

    @isTest
    static void OpportunityProductWithProspectingStageAndContractWithSupport() {
        Opportunity opp = getOpportunities();
        Account acc = getAccounts();
        OpportunityLineItem oLI = getOpportunityLineItem();

        opp.StageName = OpportunityConstans.PROSPECTING;
        opp.RecordTypeId = Schema.SObjectType.Opportunity.RecordTypeInfosByName.get(OpportunityConstans.CLOSED_WON).getRecordTypeId();

        Test.startTest();
            update opp;
        Test.stopTest();

        Account updatedAccount = [SELECT IsSupported__c, SupportExpirationDate__c FROM Account WHERE Id =: acc.Id];
        System.assertEquals(false, updatedAccount.IsSupported__c, 'Flag should be set as false');
        System.assertEquals(null, updatedAccount.SupportExpirationDate__c, 'There should be no expiration date');
    }
 
   public static Opportunity getOpportunities(){
    return [SELECT ID FROM Opportunity LIMIT 1];
   }

   public static Account getAccounts(){
    return [SELECT ID FROM Account LIMIT 1];
   }

   public static OpportunityLineItem getOpportunityLineItem(){
    return [SELECT ID, LicenseType__c FROM OpportunityLineItem LIMIT 1];
   }
}
