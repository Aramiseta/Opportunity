public class OpportunitySelector {
    public static List<Opportunity> getOpportunityByAccountId(Set<Id> ids) {
        return [
            SELECT Id, AccountId
            FROM Opportunity
            WHERE AccountId IN :ids];
    }
}