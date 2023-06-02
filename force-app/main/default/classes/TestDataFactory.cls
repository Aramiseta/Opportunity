@isTest
public with sharing class TestDataFactory {
    Id pricebookId = Test.getStandardPricebookId();

    public static Account createAccount() {
        return new Account(Name='testAccount');
    }

    public static Opportunity createOpportunity(Id accountId){
        return new Opportunity(Name = 'testOpp', 
                               AccountId = accountId,
                               StageName = Prospecting,
                               CloseDate = Date.today().addMonths(1));
    }

    public static Product2 createProduct2(){
        Product2 product = new Product2(
            Name = 'Product',
            ProductCode = '123',
            isActive = true
        );
        insert product;
        return product;
    }

    public static PricebookEntry createPricebookEntry(Id productId){
        PricebookEntry standardPriceEntry = new PricebookEntry();
        standardPriceEntry.IsActive = true;
        standardPriceEntry.Product2Id = productId;
        standardPriceEntry.Pricebook2Id = Test.getStandardPricebookId();
        standardPriceEntry.UnitPrice = 10;
        standardPriceEntry.UseStandardPrice = false;
        insert standardPriceEntry;
         
        return standardPriceEntry;
    }

    public static OpportunityLineItem createOpportunityLineItem(Id oppId, Id pricebookEntryId, String licenseType){
        return new OpportunityLineItem(
        OpportunityId = oppId,
        Quantity = 1,
        PricebookEntryId = pricebookEntryId,
        TotalPrice = 10.00,
        LicenseType__c = licenseType);
    }
}