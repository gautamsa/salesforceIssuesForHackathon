/**
 * ISSUE: Poor Exception Handling and Error Management
 * 
 * This class demonstrates common mistakes in exception handling and
 * error management in Apex.
 * 
 * PROBLEMS TO IDENTIFY:
 * 1. No try-catch blocks for DML operations
 * 2. Catching generic Exception instead of specific exceptions
 * 3. Swallowing exceptions without logging
 * 4. Not handling partial failures in bulk operations
 * 5. No user-friendly error messages
 */
public class ExceptionHandlingIssues {
    
    // BAD: No exception handling
    public void createAccount(String name) {
        Account acc = new Account(Name = name);
        // ISSUE: Will throw exception if validation rules fail, required fields missing, etc.
        insert acc;
    }
    
    // BAD: Catching generic Exception
    public void updateAccount(Account acc) {
        try {
            update acc;
        } catch(Exception e) {
            // ISSUE: Too generic - catches all exceptions
            // ISSUE: No logging or error handling
            System.debug('Error: ' + e.getMessage());
        }
    }
    
    // BAD: Swallowing exceptions
    public void deleteAccount(Id accountId) {
        try {
            Account acc = [SELECT Id FROM Account WHERE Id = :accountId];
            delete acc;
        } catch(Exception e) {
            // ISSUE: Exception is caught but nothing is done
            // Caller has no way to know if operation succeeded
        }
    }
    
    // BAD: No handling of partial failures in bulk operations
    public void updateAccounts(List<Account> accounts) {
        // ISSUE: If one record fails, entire operation fails
        // No way to identify which records succeeded/failed
        update accounts;
    }
    
    // BAD: Catching exception but not handling DML errors properly
    public void processAccounts(List<Account> accounts) {
        try {
            insert accounts;
        } catch(DmlException e) {
            // ISSUE: Not checking which records failed
            // ISSUE: Not providing useful error information
            System.debug('DML Error: ' + e.getMessage());
        }
    }
    
    // BAD: No validation before DML
    public void createContact(String firstName, String lastName, Id accountId) {
        Contact con = new Contact();
        con.FirstName = firstName;
        con.LastName = lastName;
        con.AccountId = accountId;
        // ISSUE: No validation, no exception handling
        insert con;
    }
    
    // BAD: Not checking for required fields
    public void updateAccountPhone(Id accountId, String phone) {
        Account acc = [SELECT Id FROM Account WHERE Id = :accountId];
        acc.Phone = phone;
        // ISSUE: No check if phone is valid format
        // ISSUE: No exception handling
        update acc;
    }
    
    // BAD: Catching exception but rethrowing without context
    public void processData(List<Account> accounts) {
        try {
            update accounts;
        } catch(Exception e) {
            // ISSUE: Loses original exception context
            throw new Exception('Update failed');
        }
    }
    
    // BAD: No handling for query exceptions
    public Account getAccountByName(String name) {
        // ISSUE: Will throw exception if no records found or multiple records
        return [SELECT Id, Name FROM Account WHERE Name = :name LIMIT 1];
    }
    
    // BAD: Not using Database methods for partial success
    public void bulkUpdateAccounts(List<Account> accounts) {
        // ISSUE: Using DML statement instead of Database methods
        // Can't handle partial failures
        update accounts;
    }
}

