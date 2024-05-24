global class BatchApplicationPurge implements Database.Batchable<sObject> {
       // The start method is called at the beginning of the process
       // This method returns a SOQL query locator containing the records to be processed
       global Database.QueryLocator start(Database.BatchableContext BC){
               return Database.getQueryLocator([SELECT Id FROM Application__c where Status__c='Rejected' OR Position__r.Status__c='Canceled']);  
       }
       // The executeBatch method is called for each chunk of records returned from start.  
       global void execute(Database.BatchableContext BC, sObject[] scope){
              delete scope;
       }
       // The finish method is called at the end of processing all records.
       global void finish(Database.BatchableContext BC){  
     

       }
}