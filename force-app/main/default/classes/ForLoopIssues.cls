/**
 * ISSUE: Various For Loop Problems
 * 
 * This class demonstrates multiple for loop-related issues including:
 * nested loops, SOQL/DML in loops, inefficient iterations, and more.
 * 
 * PROBLEMS TO IDENTIFY:
 * 1. Nested loops with SOQL/DML operations
 * 2. Inefficient loop structures
 * 3. Modifying collections while iterating
 * 4. Unnecessary iterations
 * 5. Missing break/continue optimizations
 * 6. Loops without proper exit conditions
 * 7. CPU time limit violations from nested loops
 */
public class ForLoopIssues {
    
    // BAD: Nested loops with SOQL query
    public void processAccountsAndContacts(List<Id> accountIds) {
        for(Id accId : accountIds) {
            // ISSUE: SOQL query in outer loop
            Account acc = [SELECT Id, Name FROM Account WHERE Id = :accId];
            
            // ISSUE: SOQL query in nested loop
            List<Contact> contacts = [SELECT Id, Name FROM Contact WHERE AccountId = :accId];
            for(Contact con : contacts) {
                // ISSUE: DML operation in nested loop
                con.Phone = '555-1234';
                update con;
            }
        }
    }
    
    // BAD: Triple nested loops
    public void processAccountsContactsAndTasks(List<Id> accountIds) {
        for(Id accId : accountIds) {
            // ISSUE: Query in outer loop
            List<Contact> contacts = [SELECT Id FROM Contact WHERE AccountId = :accId];
            
            for(Contact con : contacts) {
                // ISSUE: Query in second level loop
                List<Task> tasks = [SELECT Id FROM Task WHERE WhoId = :con.Id];
                
                for(Task t : tasks) {
                    // ISSUE: DML in triple nested loop - worst performance
                    t.Status = 'Completed';
                    update t;
                }
            }
        }
    }
    
    // BAD: Modifying collection while iterating
    public void removeItemsBad(List<Account> accounts) {
        // ISSUE: Modifying list while iterating - can cause issues
        for(Integer i = 0; i < accounts.size(); i++) {
            if(accounts[i].Name == 'Test') {
                accounts.remove(i); // ISSUE: Modifying during iteration
                // Index will be off after removal
            }
        }
    }
    
    // BAD: Inefficient nested loop with O(n²) complexity
    public void findDuplicatesBad(List<Account> accounts) {
        // ISSUE: O(n²) complexity - inefficient for large lists
        for(Integer i = 0; i < accounts.size(); i++) {
            for(Integer j = i + 1; j < accounts.size(); j++) {
                if(accounts[i].Name == accounts[j].Name) {
                    // Found duplicate
                    System.debug('Duplicate found: ' + accounts[i].Name);
                }
            }
        }
    }
    
    // BAD: Loop with SOQL query for each iteration
    public void updateRelatedRecords(List<Id> accountIds) {
        for(Id accId : accountIds) {
            // ISSUE: Query in loop
            List<Contact> contacts = [SELECT Id FROM Contact WHERE AccountId = :accId];
            
            for(Contact con : contacts) {
                // ISSUE: Another query in nested loop
                List<Opportunity> opps = [SELECT Id FROM Opportunity WHERE AccountId = :accId];
                
                for(Opportunity opp : opps) {
                    // ISSUE: DML in triple nested loop
                    opp.StageName = 'Closed Won';
                    update opp;
                }
            }
        }
    }
    
    // BAD: Loop without proper exit condition
    public void processUntilComplete(List<Account> accounts) {
        Integer attempts = 0;
        // ISSUE: No maximum attempt limit - could run forever
        while(attempts < 1000) {
            for(Account acc : accounts) {
                // ISSUE: Query in loop
                List<Contact> contacts = [SELECT Id FROM Contact WHERE AccountId = :acc.Id];
                if(contacts.isEmpty()) {
                    continue; // Skip if no contacts
                }
                // Process contacts
            }
            attempts++;
            // ISSUE: No actual completion check
        }
    }
    
    // BAD: Unnecessary nested loop
    public void matchAccountsAndContacts(List<Account> accounts, List<Contact> contacts) {
        // ISSUE: O(n*m) complexity - very inefficient
        for(Account acc : accounts) {
            for(Contact con : contacts) {
                if(con.AccountId == acc.Id) {
                    // Match found
                    con.Phone = acc.Phone;
                    // ISSUE: DML in nested loop
                    update con;
                }
            }
        }
    }
    
    // BAD: Loop with multiple DML operations
    public void createRelatedRecords(List<Account> accounts) {
        for(Account acc : accounts) {
            // ISSUE: DML 1 in loop
            Contact con = new Contact();
            con.FirstName = 'Test';
            con.LastName = 'Contact';
            con.AccountId = acc.Id;
            insert con;
            
            // ISSUE: DML 2 in same loop
            Opportunity opp = new Opportunity();
            opp.Name = 'Test Opp';
            opp.AccountId = acc.Id;
            opp.StageName = 'Prospecting';
            opp.CloseDate = Date.today().addDays(30);
            insert opp;
            
            // ISSUE: DML 3 in same loop
            Task t = new Task();
            t.Subject = 'Follow up';
            t.WhatId = acc.Id;
            insert t;
            
            // Will fail if accounts has more than 50 items (150/3 = 50)
        }
    }
    
    // BAD: Loop with inefficient data access
    public void processAccountData(List<Id> accountIds) {
        for(Id accId : accountIds) {
            // ISSUE: Query 1
            Account acc = [SELECT Id, Name FROM Account WHERE Id = :accId];
            
            // ISSUE: Query 2 in same iteration
            List<Contact> contacts = [SELECT Id FROM Contact WHERE AccountId = :accId];
            
            // ISSUE: Query 3 in same iteration
            List<Opportunity> opps = [SELECT Id FROM Opportunity WHERE AccountId = :accId];
            
            // ISSUE: Nested loop with another query
            for(Contact con : contacts) {
                List<Task> tasks = [SELECT Id FROM Task WHERE WhoId = :con.Id];
                // Process tasks
            }
        }
    }
    
    // BAD: Loop with COUNT() queries
    public void checkRecordCounts(List<Id> accountIds) {
        for(Id accId : accountIds) {
            // ISSUE: COUNT() query in loop
            Integer contactCount = [SELECT COUNT() FROM Contact WHERE AccountId = :accId];
            
            // ISSUE: Another COUNT() query
            Integer oppCount = [SELECT COUNT() FROM Opportunity WHERE AccountId = :accId];
            
            // ISSUE: Nested loop if conditions met
            if(contactCount > 0) {
                List<Contact> contacts = [SELECT Id FROM Contact WHERE AccountId = :accId];
                for(Contact con : contacts) {
                    // Process contact
                }
            }
        }
    }
    
    // BAD: Infinite loop risk
    public void processWithRetry(List<Account> accounts) {
        Integer retryCount = 0;
        // ISSUE: No maximum retry limit check
        while(retryCount < 10000) {
            for(Account acc : accounts) {
                // ISSUE: Query in loop
                List<Contact> contacts = [SELECT Id FROM Contact WHERE AccountId = :acc.Id];
                
                if(contacts.isEmpty()) {
                    retryCount++;
                    continue; // Retry logic but no proper exit
                }
                
                // Process contacts
            }
            // ISSUE: No break condition - could loop forever
        }
    }
    
    // BAD: Loop with unnecessary iterations
    public void processAccountsInefficiently(List<Account> accounts) {
        // ISSUE: Iterating through all accounts even if we only need some
        for(Account acc : accounts) {
            // ISSUE: Query to check if we should process
            List<Contact> contacts = [SELECT Id FROM Contact WHERE AccountId = :acc.Id];
            
            // ISSUE: Only processing if contacts exist, but queried for all
            if(contacts.isEmpty()) {
                continue; // Skip - but already wasted a query
            }
            
            // Process account
        }
    }
    
    // BAD: Loop with string concatenation (heap size issue)
    public void buildLargeString(List<Account> accounts) {
        String result = '';
        // ISSUE: String concatenation in loop - creates new string each time
        for(Account acc : accounts) {
            result += acc.Name + ', '; // ISSUE: Inefficient string building
        }
        // Can cause heap size issues with large lists
    }
    
    // BAD: Loop with map operations inside
    public void processWithMapLookup(List<Id> accountIds) {
        // ISSUE: Creating map inside loop instead of before
        for(Id accId : accountIds) {
            Map<Id, Account> accountMap = new Map<Id, Account>();
            // ISSUE: Query in loop to populate map
            List<Account> accounts = [SELECT Id, Name FROM Account WHERE Id = :accId];
            accountMap.putAll(accounts);
            
            // Use map
        }
    }
}

