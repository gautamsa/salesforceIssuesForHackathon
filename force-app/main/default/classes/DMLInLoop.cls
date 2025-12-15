/**
 * ISSUE: DML Operations Inside Loops
 * 
 * This class demonstrates the common mistake of performing DML operations
 * inside loops, which can quickly hit governor limits.
 * 
 * PROBLEMS TO IDENTIFY:
 * 1. DML operations inside loops (governor limit violation)
 * 2. Missing bulkification
 * 3. No error handling
 * 4. Inefficient code that will fail with large datasets
 */
public class DMLInLoop {
    
    // BAD: DML inside loop
    public void updateAccountsBad(List<Account> accounts) {
        for(Account acc : accounts) {
            acc.Phone = '555-1234';
            // ISSUE: DML inside loop - will fail if more than 150 records
            update acc;
        }
    }
    
    // BAD: Multiple DML operations in loop
    public void createContactsBad(List<Account> accounts) {
        for(Account acc : accounts) {
            Contact con = new Contact();
            con.FirstName = 'Test';
            con.LastName = 'Contact';
            con.AccountId = acc.Id;
            // ISSUE: DML inside loop
            insert con;
            
            // ISSUE: Another DML in the same loop
            Task t = new Task();
            t.Subject = 'Follow up';
            t.WhatId = acc.Id;
            insert t;
        }
    }
    
    // BAD: Nested loops with DML
    public void processOpportunitiesBad(List<Account> accounts) {
        for(Account acc : accounts) {
            List<Opportunity> opps = [SELECT Id FROM Opportunity WHERE AccountId = :acc.Id];
            for(Opportunity opp : opps) {
                opp.StageName = 'Closed Won';
                // ISSUE: DML in nested loop - worst case scenario
                update opp;
            }
        }
    }
    
    // BAD: SOQL query inside loop
    public void updateRelatedContactsBad(List<Account> accounts) {
        for(Account acc : accounts) {
            // ISSUE: SOQL query inside loop
            List<Contact> contacts = [SELECT Id FROM Contact WHERE AccountId = :acc.Id];
            for(Contact con : contacts) {
                con.Phone = acc.Phone;
                // ISSUE: DML inside nested loop
                update con;
            }
        }
    }
}

