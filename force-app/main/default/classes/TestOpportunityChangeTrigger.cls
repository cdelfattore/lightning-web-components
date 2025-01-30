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
@isTest
private class TestOpportunityChangeTrigger {

    @isTest
    static void testCreateAndUpdateOpportunity()
    {
            // Enable all Change Data Capture entities for notifications.
            Test.enableChangeDataCapture();

            Opportunity oppInsert = new Opportunity(
                Name = 'Sell 100 Widgets',
                StageName = 'Prospecting',
                CloseDate = Date.today().addMonths(3)
            );
            insert oppInsert;

            // Call deliver to fire the trigger and deliver the test change event.
            Test.getEventBus().deliver();
            
            Opportunity[] oppRecords = [SELECT Id,StageName FROM Opportunity];
            Opportunity opp = oppRecords[0];
            opp.StageName = 'Closed Won';
            update opp;

            Test.getEventBus().deliver();

            Task[] taskList = [SELECT Id,Subject FROM Task];
            System.assertEquals(1, taskList.size(), 'The change event trigger did not create the expected task.');

    }
}