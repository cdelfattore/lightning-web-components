/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an org are executed whenever Apex code is deployed
 * to a production org to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production org. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the org size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@IsTest
private class OpportunityLineItemTest
{

    @IsTest
    private static void opportunityTypeRollup()
    {
        Opportunity opp = new Opportunity(
            Name = 'Test Opp',
            StageName = 'Closed Won',
            CloseDate = Date.today().addDays(30)
        );
        insert opp;

        List<Product2> products = new List<Product2>();
        Product2 prodA = new Product2(
            Name = 'A'
        );
        products.add(prodA);

        Product2 prodB = new Product2(
            Name = 'B'
        );
        products.add(prodB);

        insert products;

        List<PricebookEntry> pbes = new List<PricebookEntry>();
        PricebookEntry pbeA = new PricebookEntry(
            Pricebook2Id = Test.getStandardPricebookId(),
            Product2Id = prodA.Id,
            UnitPrice = 10.00,
            IsActive = true
        );
        pbes.add(pbeA);

        PricebookEntry pbeB = new PricebookEntry(
            Pricebook2Id = Test.getStandardPricebookId(),
            Product2Id = prodB.Id,
            UnitPrice = 15.00,
            IsActive = true
        );
        pbes.add(pbeB);

        insert pbes;

        List<OpportunityLineItem> olis = new List<OpportunityLineItem>();
        OpportunityLineItem oliA = new OpportunityLineItem(
            OpportunityId = opp.Id,
            Type__c = 'Baseball',
            PricebookEntryId = pbeA.Id,
            TotalPrice = 10.0,
            Quantity = 1
        );
        olis.add(oliA);

        OpportunityLineItem oliB = new OpportunityLineItem(
            OpportunityId = opp.Id,
            Type__c = 'Basketball',
            PricebookEntryId = pbeB.Id,
            TotalPrice = 15.0,
            Quantity = 1
        );
        olis.add(oliB);

        OpportunityLineItem oliC = new OpportunityLineItem(
            OpportunityId = opp.Id,
            Type__c = 'Basketball',
            PricebookEntryId = pbeB.Id,
            TotalPrice = 30.0,
            Quantity = 2
        );
        olis.add(oliC);

        insert olis;

        Test.startTest();

        Integer start = Limits.getCpuTime();
        System.debug(start);

        oliA.Type__c = 'Golf';
        update oliA;

        Integer stop = Limits.getCpuTime();
        System.debug(stop);
        System.debug(stop - start);

        Test.stopTest();

        Opportunity oppAfterUpdate = [SELECT Id, Description FROM Opportunity WHERE Id = :opp.Id LIMIT 1];
        // System.debug('Basketball,Golf');
        // System.debug(oppAfterUpdate.Description);
        System.assertEquals('Basketball,Golf', oppAfterUpdate.Description);
    }
}