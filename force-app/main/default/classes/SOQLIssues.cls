/**
 * ISSUE: Various SOQL Query Problems
 * 
 * This class demonstrates multiple SOQL-related issues including:
 * queries in loops, inefficient queries, missing filters, and more.
 * 
 * PROBLEMS TO IDENTIFY:
 * 1. SOQL queries inside loops (governor limit violation)
 * 2. Missing WHERE clause filters (inefficient queries)
 * 3. Querying unnecessary fields (performance issues)
 * 4. Not using bind variables properly
 * 5. Missing null checks before queries
 * 6. Querying all records without limits
 * 7. Using COUNT() queries inefficiently
 */
public class SOQLIssues {
    
    // BAD: SOQL query inside for loop
    public void updateAccountContacts(List<Id> accountIds) {
        for(Id accId : accountIds) {
            // ISSUE: SOQL inside loop - will fail after 100 iterations
            List<Contact> contacts = [SELECT Id, Name, Email FROM Contact WHERE AccountId = :accId];
            for(Contact con : contacts) {
                con.Email = 'updated@example.com';
            }
            update contacts;
        }
    }
    
    // BAD: Querying all records without WHERE clause
    public List<Account> getAllAccounts() {
        // ISSUE: No WHERE clause - queries all accounts, can cause heap size issues
        return [SELECT Id, Name, Phone, Industry, BillingCity FROM Account];
    }
    
    // BAD: Querying unnecessary fields
    public void processAccounts(List<Id> accountIds) {
        for(Id accId : accountIds) {
            // ISSUE: Querying all fields when only Name is needed
            Account acc = [SELECT Id, Name, Phone, Fax, Website, Industry, 
                          BillingStreet, BillingCity, BillingState, BillingPostalCode,
                          ShippingStreet, ShippingCity, ShippingState, ShippingPostalCode,
                          Description, AnnualRevenue, NumberOfEmployees, OwnerId
                          FROM Account WHERE Id = :accId];
            System.debug('Account Name: ' + acc.Name);
        }
    }
    
    // BAD: Multiple SOQL queries in loop without bulkification
    public void processAccountData(List<Id> accountIds) {
        for(Id accId : accountIds) {
            // ISSUE: Query 1 inside loop
            Account acc = [SELECT Id, Name FROM Account WHERE Id = :accId];
            
            // ISSUE: Query 2 inside loop
            Integer contactCount = [SELECT COUNT() FROM Contact WHERE AccountId = :accId];
            
            // ISSUE: Query 3 inside loop
            List<Opportunity> opps = [SELECT Id, Amount FROM Opportunity WHERE AccountId = :accId];
            
            // ISSUE: Query 4 inside loop
            List<Case> cases = [SELECT Id, Status FROM Case WHERE AccountId = :accId];
            
            // Will fail if accountIds has more than 25 items (100/4 = 25)
        }
    }
    
    // BAD: Query without LIMIT clause
    public List<Contact> searchContacts(String searchTerm) {
        // ISSUE: No LIMIT clause - could return thousands of records
        return [SELECT Id, Name, Email FROM Contact WHERE Name LIKE :('%' + searchTerm + '%')];
    }
    
    // BAD: Nested queries in loops
    public void processAccountsWithRelatedData(List<Id> accountIds) {
        for(Id accId : accountIds) {
            // ISSUE: SOQL query inside loop
            Account acc = [SELECT Id, Name, (SELECT Id FROM Contacts), 
                          (SELECT Id FROM Opportunities) FROM Account WHERE Id = :accId];
            
            // ISSUE: Another query inside the same loop
            List<Task> tasks = [SELECT Id, Subject FROM Task WHERE WhatId = :accId];
            
            // ISSUE: Processing nested results inefficiently
            for(Contact con : acc.Contacts) {
                // Process contact
            }
        }
    }
    
    // BAD: Using COUNT() queries inefficiently
    public void checkAccountCounts(List<Id> accountIds) {
        for(Id accId : accountIds) {
            // ISSUE: COUNT() query inside loop
            Integer contactCount = [SELECT COUNT() FROM Contact WHERE AccountId = :accId];
            
            // ISSUE: Another COUNT() query
            Integer oppCount = [SELECT COUNT() FROM Opportunity WHERE AccountId = :accId];
            
            if(contactCount > 10 || oppCount > 5) {
                // Process account
            }
        }
    }
    
    // BAD: Querying without null checks
    public List<Contact> getContactsByAccount(Id accountId) {
        // ISSUE: No null check before query
        return [SELECT Id, Name FROM Contact WHERE AccountId = :accountId];
    }
    
    // BAD: Query with inefficient WHERE clause
    public List<Account> searchAccounts(String name) {
        // ISSUE: Using functions in WHERE clause - can't use index
        return [SELECT Id, Name FROM Account WHERE UPPER(Name) = :name.toUpperCase()];
    }
    
    // BAD: Querying in a while loop
    public void processAllAccounts() {
        Integer offset = 0;
        Integer batchSize = 200;
        
        while(true) {
            // ISSUE: Query in while loop without proper exit condition
            List<Account> accounts = [SELECT Id, Name FROM Account LIMIT :batchSize OFFSET :offset];
            
            if(accounts.isEmpty()) {
                break;
            }
            
            // Process accounts
            offset += batchSize;
            
            // ISSUE: No check for governor limits - could run indefinitely
        }
    }
    
    // BAD: Querying with ORDER BY without LIMIT
    public List<Account> getTopAccounts() {
        // ISSUE: ORDER BY without LIMIT - queries all records then sorts
        return [SELECT Id, Name, AnnualRevenue FROM Account 
                WHERE AnnualRevenue != null 
                ORDER BY AnnualRevenue DESC];
    }
    
    // BAD: Using Database.query with dynamic SOQL in loop
    public void dynamicQueryInLoop(List<String> industries) {
        for(String industry : industries) {
            // ISSUE: Dynamic query construction in loop
            String query = 'SELECT Id, Name FROM Account WHERE Industry = \'' + industry + '\'';
            List<Account> accounts = Database.query(query);
            // Process accounts
        }
    }
    
    // BAD: Querying same data multiple times
    public void inefficientDataAccess(List<Id> accountIds) {
        for(Id accId : accountIds) {
            // ISSUE: Query 1
            Account acc1 = [SELECT Id, Name FROM Account WHERE Id = :accId];
            
            // ISSUE: Query 2 - same account queried again
            Account acc2 = [SELECT Id, Phone FROM Account WHERE Id = :accId];
            
            // ISSUE: Query 3 - same account queried again
            Account acc3 = [SELECT Id, Industry FROM Account WHERE Id = :accId];
        }
    }
}

