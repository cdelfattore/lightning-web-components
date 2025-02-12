/**
 * @description Batch class to handle the updation of the Description field on Opportunity
 * @author cdelfattore
 * @since 2025-02-12
 */
public with sharing class OpportunityDescriptionUpdateBatch implements Database.Batchable<sObject>
{
    private Set<Id> opportunityIds;

    public OpportunityDescriptionUpdateBatch(Set<Id> opportunityIds)
    {
        this.opportunityIds = opportunityIds;
    }

    public Database.QueryLocator start(Database.BatchableContext bc)
    {
        return Database.getQueryLocator([SELECT Id, Description, (SELECT Id, Type__c FROM OpportunityLineItems ORDER BY Type__c) FROM Opportunity WHERE Id IN :this.opportunityIds]);
    }

    public void execute(Database.BatchableContext bc, List<sObject> scope)
    {
        OpportunityService.updateDescription((List<Opportunity>) scope);
    }

    public void finish(Database.BatchableContext info)
    {

    }
}