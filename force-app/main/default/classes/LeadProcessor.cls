global class LeadProcessor implements Database.Batchable<sObject>, Database.Stateful {
//Use a QueryLocator in the start method to collect all Lead records in the org.
//The execute method must update all Lead records in the org with the LeadSource value of 'Dreamforce'.
    // instance member to retain state across transactions
    global Integer allLeads = 0;
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
            'SELECT ID, LeadSource FROM  Lead'
        );
    }
    global void execute(Database.BatchableContext bc, List<Lead> scope){
        // process each batch of records
        List<Lead> leads = new List<Lead>();
        for (Lead lead : scope) {
            lead.LeadSource = 'Dreamforce';
			leads.add(lead);
			allLeads = allLeads + 1;
        }
        update leads;
    }    
    global void finish(Database.BatchableContext bc){
        System.debug(allLeads + ' records processed. Shazam!');
        AsyncApexJob job = [SELECT Id, Status, NumberOfErrors, 
            JobItemsProcessed,
            TotalJobItems, CreatedBy.Email
            FROM AsyncApexJob
            WHERE Id = :bc.getJobId()];
    }    

}