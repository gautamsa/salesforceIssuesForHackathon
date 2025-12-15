/**
 * ISSUE: Poor Code Structure and Best Practices
 * 
 * This class demonstrates poor coding practices including:
 * - Missing or incorrect access modifiers
 * - Poor naming conventions
 * - Hard-coded values
 * - Missing comments/documentation
 * - No separation of concerns
 * 
 * PROBLEMS TO IDENTIFY:
 * 1. Missing access modifiers
 * 2. Poor variable/method naming
 * 3. Hard-coded values (magic numbers/strings)
 * 4. No constants for reusable values
 * 5. Methods doing too many things
 */
public class PoorCodeStructure {
    
    // BAD: Missing access modifier, poor naming
    String x;
    Integer y;
    
    // BAD: Method name doesn't describe what it does
    void doStuff(Account a) {
        // Hard-coded value
        a.Phone = '555-1234';
        update a;
    }
    
    // BAD: Hard-coded values, no constants
    public void updateAccountStatus(Account acc) {
        // ISSUE: Magic string - what does 'Active' mean?
        acc.Industry = 'Technology';
        acc.Type = 'Customer';
        acc.AnnualRevenue = 1000000; // Magic number
        update acc;
    }
    
    // BAD: Method doing too many things
    public void processAccount(Account acc) {
        // Issue: This method does validation, DML, creates related records, sends email
        if(acc.Name != null) {
            insert acc;
            
            Contact con = new Contact();
            con.FirstName = 'Default';
            con.LastName = 'Contact';
            con.AccountId = acc.Id;
            insert con;
            
            // Send email (not shown but implied)
            // Too many responsibilities in one method
        }
    }
    
    // BAD: No access modifier, poor naming
    List<Account> getData(String s) {
        // ISSUE: What does 's' represent? What data is being retrieved?
        return [SELECT Id FROM Account WHERE Name = :s];
    }
    
    // BAD: Inconsistent naming, no documentation
    public void updAcc(Account a) {
        a.Name = 'Updated';
        update a;
    }
    
    // BAD: Hard-coded field names that could break
    public void updateField(Account acc, String fieldName, String value) {
        // ISSUE: Using string-based field access - no compile-time checking
        acc.put(fieldName, value);
        update acc;
    }
    
    // BAD: No error handling, hard-coded values
    public void createTestAccount() {
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.Phone = '555-1234';
        acc.Industry = 'Technology';
        insert acc;
    }
}

