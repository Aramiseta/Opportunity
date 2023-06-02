trigger OpportunityTrigger on Opportunity (after update) {
    if (Trigger.isAfter && Trigger.isUpdate) {
        OpportunityTriggerHandler.isAfterUpdate(Trigger.new, Trigger.newMap);
    }
}