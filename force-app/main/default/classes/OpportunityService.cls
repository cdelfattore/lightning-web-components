/**
 * @description Basic service class that does not use apex enterprise patterns.
 * @author cdelfattore
 * @since 2025-02-15
 */
public with sharing class OpportunityService
{
    public static void updateDescription(Set<Id> opportunityIds)
    {
        updateDescription([SELECT Description, (SELECT Id, Type__c FROM OpportunityLineItems ORDER BY Type__c) FROM Opportunity WHERE Id IN :opportunityIds]);
    }

    public static void updateDescription(List<Opportunity> opportunitiesWithLineItems)
    {
        for (Opportunity opp : opportunitiesWithLineItems)
        {
            // Need a set to make sure we only add the type once.
            Set<String> typeSet = new Set<String>();
            for (OpportunityLineItem oli : opp.OpportunityLineItems)
            {
                typeSet.add(oli.Type__c);
            }

            List<String> types = new List<String>(typeSet);
            types.sort();
            opp.Description = '';
            for (String type : types)
            {
                opp.Description += type + ',';
                
            }
            opp.Description = opp.Description.removeEnd(',');
            
        }

        update opportunitiesWithLineItems;
    }
}