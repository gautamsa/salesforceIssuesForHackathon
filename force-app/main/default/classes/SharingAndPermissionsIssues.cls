/**
 * ISSUE: Sharing and Permissions Violations
 * 
 * This class demonstrates security issues related to sharing and permissions.
 * Classes should use 'with sharing' or 'inherited sharing' to enforce the
 * context user's object and field-level permissions (FLS).
 * 
 * PROBLEMS TO IDENTIFY:
 * 1. Missing 'with sharing' keyword - bypasses sharing rules
 * 2. Using 'without sharing' without justification
 * 3. Not respecting field-level security (FLS)
 * 4. Accessing records user shouldn't see
 * 5. No documentation for 'without sharing' usage
 */
public class SharingAndPermissionsIssues {
    
    // BAD: No sharing declaration - defaults to 'without sharing'
    // ISSUE: Bypasses sharing rules and can access records user shouldn't see
    public List<Account> getAllAccounts() {
        // ISSUE: Returns all accounts regardless of sharing rules
        return [SELECT Id, Name, AnnualRevenue FROM Account];
    }
    
    // BAD: Explicitly using 'without sharing' without justification
    public class AccountProcessor {
        // ISSUE: No documentation explaining why 'without sharing' is needed
        public List<Account> processAccounts() {
            // ISSUE: Can access accounts user shouldn't see
            return [SELECT Id, Name, Phone FROM Account];
        }
    }
    
    // BAD: Not respecting field-level security
    public void updateAccountRevenue(Id accountId, Decimal revenue) {
        // ISSUE: No FLS check - user might not have access to AnnualRevenue field
        Account acc = [SELECT Id, AnnualRevenue FROM Account WHERE Id = :accountId];
        acc.AnnualRevenue = revenue;
        // ISSUE: Update without checking if user has edit access
        update acc;
    }
    
    // BAD: Accessing sensitive fields without permission check
    public List<Account> getAccountsWithSensitiveData() {
        // ISSUE: Querying sensitive fields without FLS check
        // User might not have access to AnnualRevenue or other fields
        return [SELECT Id, Name, AnnualRevenue, NumberOfEmployees, 
                BillingAddress, ShippingAddress FROM Account];
    }
    
    // BAD: Cross-object access without sharing
    public List<Contact> getContactsForAccount(Id accountId) {
        // ISSUE: No sharing enforcement - can access contacts user shouldn't see
        Account acc = [SELECT Id FROM Account WHERE Id = :accountId];
        // ISSUE: Accessing related contacts without sharing check
        return [SELECT Id, Name, Email, Phone FROM Contact WHERE AccountId = :acc.Id];
    }
    
    // BAD: Using without sharing in inner class without reason
    public class DataAccessor {
        // ISSUE: No sharing keyword - defaults to system context
        public List<Opportunity> getAllOpportunities() {
            // ISSUE: Returns all opportunities, ignoring sharing rules
            return [SELECT Id, Name, Amount, StageName FROM Opportunity];
        }
    }
    
    // BAD: Mixed sharing contexts causing confusion
    public void processData() {
        // ISSUE: This method runs in system context (no sharing)
        List<Account> accounts = [SELECT Id FROM Account];
        
        // ISSUE: Calling method that might expect user context
        processAccounts(accounts);
    }
    
    private void processAccounts(List<Account> accounts) {
        // ISSUE: Unclear what sharing context this runs in
        for(Account acc : accounts) {
            // Process account
            System.debug('Processing account: ' + acc.Id);
        }
    }
    
    // BAD: Querying all records without sharing enforcement
    public List<Case> getAllCases() {
        // ISSUE: No 'with sharing' - can see all cases regardless of ownership
        return [SELECT Id, Subject, Status, OwnerId FROM Case];
    }
    
    // BAD: Updating records user shouldn't have access to
    public void updateAccountOwner(Id accountId, Id newOwnerId) {
        // ISSUE: No sharing check - can update accounts user doesn't own
        Account acc = [SELECT Id, OwnerId FROM Account WHERE Id = :accountId];
        acc.OwnerId = newOwnerId;
        update acc;
    }
    
    // BAD: Deleting records without sharing check
    public void deleteAccount(Id accountId) {
        // ISSUE: No sharing enforcement - can delete accounts user shouldn't access
        Account acc = [SELECT Id FROM Account WHERE Id = :accountId];
        delete acc;
    }
    
}

