trigger OpportunityLineItem on OpportunityLineItem (after update)
{
    Set<Id> opportunityIds = new Set<Id>();
    for (OpportunityLineItem oli : trigger.new)
    {
        // System.debug(oli.OpportunityId);
        opportunityIds.add(oli.OpportunityId);
    }

    // If this needs to process immedialty it can be done in the service method.
    //OpportunityService.updateDescription(opportunityIds);

    // Else pass the ids to a batch class to process.
    Database.executeBatch(new OpportunityDescriptionUpdateBatch(opportunityIds));
}