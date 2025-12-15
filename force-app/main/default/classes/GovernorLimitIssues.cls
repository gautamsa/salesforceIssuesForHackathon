/**
 * ISSUE: Governor Limit Violations
 * 
 * This class demonstrates various governor limit issues that can cause
 * code to fail in production with larger datasets.
 * 
 * PROBLEMS TO IDENTIFY:
 * 1. SOQL queries inside loops
 * 2. Too many SOQL queries (limit is 100)
 * 3. Too many DML statements (limit is 150)
 * 4. Heap size issues
 * 5. CPU time limit issues
 */
public class GovernorLimitIssues {
    
    // BAD: SOQL query inside loop (100 query limit)
    public void updateContactsBad(List<Id> accountIds) {
        for(Id accId : accountIds) {
            // ISSUE: SOQL inside loop - will fail after 100 iterations
            List<Contact> contacts = [SELECT Id, Phone FROM Contact WHERE AccountId = :accId];
            for(Contact con : contacts) {
                con.Phone = '555-1234';
            }
            update contacts;
        }
    }
    
    // BAD: Multiple queries without bulkification
    public void processAccountsBad(List<Account> accounts) {
        for(Account acc : accounts) {
            // ISSUE: Query 1
            Integer contactCount = [SELECT COUNT() FROM Contact WHERE AccountId = :acc.Id];
            
            // ISSUE: Query 2
            Integer oppCount = [SELECT COUNT() FROM Opportunity WHERE AccountId = :acc.Id];
            
            // ISSUE: Query 3
            List<Case> cases = [SELECT Id FROM Case WHERE AccountId = :acc.Id];
            
            // Will fail if accounts list has more than 33 items (100/3 = 33)
        }
    }
    
    // BAD: Excessive DML operations
    public void createTestDataBad(Integer count) {
        // ISSUE: Will fail if count > 150
        for(Integer i = 0; i < count; i++) {
            Account acc = new Account(Name = 'Test ' + i);
            insert acc; // DML operation in loop
        }
    }
    
    // BAD: Heap size issue - loading too much data
    public void loadAllDataBad() {
        // ISSUE: Loading all accounts into memory - heap size limit
        List<Account> allAccounts = [SELECT Id, Name, (SELECT Id FROM Contacts), 
                                     (SELECT Id FROM Opportunities) FROM Account];
        
        // Processing all at once can cause heap size issues
        for(Account acc : allAccounts) {
            // Process account
        }
    }
    
    // BAD: CPU time limit - inefficient algorithm
    public void inefficientSort(List<Integer> numbers) {
        // ISSUE: Bubble sort - O(n²) complexity, can exceed CPU time limit
        Integer n = numbers.size();
        for(Integer i = 0; i < n; i++) {
            for(Integer j = 0; j < n - i - 1; j++) {
                if(numbers[j] > numbers[j + 1]) {
                    Integer temp = numbers[j];
                    numbers[j] = numbers[j + 1];
                    numbers[j + 1] = temp;
                }
            }
        }
    }
    
    // BAD: Too many field updates
    public void updateManyFields(Account acc) {
        // ISSUE: Each field update counts toward DML limit in some contexts
        acc.Name = 'New Name';
        acc.Phone = '555-1234';
        acc.Fax = '555-5678';
        acc.Website = 'www.test.com';
        acc.Industry = 'Technology';
        // ... many more fields
        update acc;
    }
}

