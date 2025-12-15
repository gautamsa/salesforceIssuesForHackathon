/**
 * ISSUE: Missing Null Checks and Error Handling
 * 
 * This class demonstrates the importance of null checks and proper error handling
 * to prevent NullPointerException and other runtime errors.
 * 
 * PROBLEMS TO IDENTIFY:
 * 1. Missing null checks before accessing object properties
 * 2. No try-catch blocks for error handling
 * 3. No validation of input parameters
 * 4. Direct property access without null safety
 */
public class MissingNullChecks {
    
    // BAD: No null check before accessing properties
    public String getAccountName(Account acc) {
        // ISSUE: Will throw NullPointerException if acc is null
        return acc.Name;
    }
    
    // BAD: No null check for nested properties
    public String getContactEmail(Contact con) {
        // ISSUE: Will fail if con is null or con.Account is null
        return con.Account.Name;
    }
    
    // BAD: No null check in list operations
    public void processAccounts(List<Account> accounts) {
        // ISSUE: Will fail if accounts is null
        for(Account acc : accounts) {
            // ISSUE: Will fail if acc.Name is null
            System.debug('Account: ' + acc.Name.toUpperCase());
        }
    }
    
    // BAD: No validation before DML
    public void updateAccount(Account acc) {
        // ISSUE: No null check, no field validation
        acc.Phone = '555-1234';
        update acc; // Will fail if acc is null or has validation errors
    }
    
    // BAD: No error handling for DML operations
    public void createContact(String firstName, String lastName, Id accountId) {
        Contact con = new Contact();
        con.FirstName = firstName; // ISSUE: No null check
        con.LastName = lastName;    // ISSUE: No null check
        con.AccountId = accountId;  // ISSUE: No validation
        // ISSUE: No try-catch, will throw exception on failure
        insert con;
    }
    
    // BAD: No null check before SOQL
    public List<Contact> getContacts(Id accountId) {
        // ISSUE: No validation that accountId is not null
        return [SELECT Id, Name FROM Contact WHERE AccountId = :accountId];
    }
    
    // BAD: Accessing map/collection without null check
    public String getValueFromMap(Map<String, String> dataMap, String key) {
        // ISSUE: Will throw NullPointerException if dataMap is null
        // ISSUE: Will return null if key doesn't exist (no handling)
        return dataMap.get(key);
    }
}

