/**
 * ISSUE: SOQL Injection Vulnerability
 * 
 * This class demonstrates a common security vulnerability where user input
 * is directly concatenated into a SOQL query without proper sanitization.
 * 
 * PROBLEMS TO IDENTIFY:
 * 1. Direct string concatenation in SOQL query (SOQL Injection)
 * 2. Missing access modifiers
 * 3. No input validation
 * 4. No error handling
 */
public class AccountQueryInjection {
    
    // Missing access modifier - should be private/public
    String searchTerm;
    
    // Method without access modifier - defaults to private
    List<Account> searchAccounts(String name) {
        // ISSUE: Direct string concatenation - vulnerable to SOQL injection
        String query = 'SELECT Id, Name, Phone FROM Account WHERE Name = \'' + name + '\'';
        return Database.query(query);
    }
    
    // Another example with LIKE clause
    List<Account> searchAccountsLike(String searchText) {
        // ISSUE: Still vulnerable to injection
        String query = 'SELECT Id, Name FROM Account WHERE Name LIKE \'%' + searchText + '%\'';
        return Database.query(query);
    }
    
    // Method that accepts user input without validation
    List<Account> getAccountsByIndustry(String industry) {
        // ISSUE: No validation, direct concatenation
        return Database.query('SELECT Id, Name FROM Account WHERE Industry = \'' + industry + '\'');
    }
}

