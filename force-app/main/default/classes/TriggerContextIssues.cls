/**
 * ISSUE: Trigger Context Variable Misuse
 * 
 * This class demonstrates common mistakes when working with triggers
 * and trigger context variables.
 * 
 * PROBLEMS TO IDENTIFY:
 * 1. Not checking trigger context (before/after, insert/update)
 * 2. Accessing fields that aren't available in before context
 * 3. Not handling bulk operations properly
 * 4. Missing recursion prevention
 */
public class TriggerContextIssues {
    
    // BAD: Not checking if it's insert or update
    public void processAccounts(List<Account> accounts, Boolean isInsert) {
        for(Account acc : accounts) {
            // ISSUE: In before insert, Id will be null
            System.debug('Account Id: ' + acc.Id);
            
            // ISSUE: In before context, related records aren't saved yet
            if(acc.AnnualRevenue > 1000000) {
                // This might not work in before context
            }
        }
    }
    
    // BAD: Not checking trigger operation
    public void handleAccountTrigger(List<Account> newAccounts, Map<Id, Account> oldMap) {
        for(Account acc : newAccounts) {
            // ISSUE: oldMap will be null on insert - will throw NullPointerException
            if(acc.Name != oldMap.get(acc.Id).Name) {
                // Do something
            }
        }
    }
    
    // BAD: No recursion prevention
    public static Boolean hasRun = false;
    
    public void processOnce(List<Account> accounts) {
        // ISSUE: Static variable approach can fail in bulk scenarios
        if(!hasRun) {
            hasRun = true;
            // Process accounts
        }
    }
    
    // BAD: Not handling bulk operations
    public void updateRelatedRecords(List<Account> accounts) {
        // ISSUE: SOQL inside loop
        for(Account acc : accounts) {
            List<Contact> contacts = [SELECT Id FROM Contact WHERE AccountId = :acc.Id];
            // Process contacts
        }
    }
    
    // BAD: Accessing fields not available in before context
    public void checkRelatedData(List<Account> accounts) {
        for(Account acc : accounts) {
            // ISSUE: In before insert, this query might not return expected results
            Integer contactCount = [SELECT COUNT() FROM Contact WHERE AccountId = :acc.Id];
        }
    }
    
    // BAD: Not checking if field actually changed
    public void handleFieldChange(List<Account> newAccounts, Map<Id, Account> oldMap) {
        for(Account acc : newAccounts) {
            // ISSUE: No null check, no check if field actually changed
            if(acc.Phone != oldMap.get(acc.Id).Phone) {
                // Process change
            }
        }
    }
}

