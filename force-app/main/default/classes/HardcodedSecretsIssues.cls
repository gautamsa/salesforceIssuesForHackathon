/**
 * ISSUE: Hardcoded IDs, Credentials, and Secrets
 * 
 * This class demonstrates security issues related to hardcoding sensitive
 * information like IDs, credentials, API keys, and other secrets in Apex code.
 * 
 * PROBLEMS TO IDENTIFY:
 * 1. Hardcoded record IDs
 * 2. Hardcoded credentials and passwords
 * 3. Hardcoded API keys and tokens
 * 4. Hardcoded URLs and endpoints
 * 5. Hardcoded user IDs and usernames
 * 6. Not using Custom Settings, Custom Metadata, or Named Credentials
 */
public class HardcodedSecretsIssues {
    
    // BAD: Hardcoded record ID
    public Account getDefaultAccount() {
        // ISSUE: Hardcoded ID - will break in different orgs/environments
        // Also exposes internal record structure
        return [SELECT Id, Name FROM Account WHERE Id = '001000000000000AAA'];
    }
    
    // BAD: Hardcoded user ID
    public void assignToDefaultUser(Account acc) {
        // ISSUE: Hardcoded user ID - different in each org
        acc.OwnerId = '005000000000000AAA';
        update acc;
    }
    
    // BAD: Hardcoded API key
    public void callExternalAPI() {
        // ISSUE: API key hardcoded in source code - visible to anyone with code access
        String apiKey = 'sk_live_51H3ll0W0r1dK3y1234567890';
        String endpoint = 'https://api.example.com/data';
        
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setHeader('Authorization', 'Bearer ' + apiKey);
        req.setMethod('GET');
        
        Http http = new Http();
        HttpResponse res = http.send(req);
    }
    
    // BAD: Hardcoded password
    public void authenticateUser(String username) {
        // ISSUE: Password hardcoded - major security vulnerability
        String password = 'MySecurePassword123!';
        
        // Authentication logic using hardcoded password
        // This is extremely dangerous!
    }
    
    // BAD: Hardcoded credentials in multiple places
    public class APIClient {
        // ISSUE: Hardcoded username
        private static final String USERNAME = 'admin@example.com';
        
        // ISSUE: Hardcoded password
        private static final String PASSWORD = 'P@ssw0rd123';
        
        // ISSUE: Hardcoded API endpoint
        private static final String API_URL = 'https://api.unsafe.com/v1';
        
        public void connect() {
            // Using hardcoded credentials
            String auth = USERNAME + ':' + PASSWORD;
            // Make API call
        }
    }
    
    // BAD: Hardcoded OAuth token
    public void makeAuthenticatedRequest() {
        // ISSUE: OAuth token hardcoded - tokens expire and should be refreshed
        String accessToken = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c';
        
        HttpRequest req = new HttpRequest();
        req.setHeader('Authorization', 'Bearer ' + accessToken);
        req.setEndpoint('https://api.example.com/data');
        req.setMethod('GET');
        
        Http http = new Http();
        HttpResponse res = http.send(req);
    }
    
    // BAD: Hardcoded profile ID
    public void createUserWithProfile() {
        // ISSUE: Profile ID hardcoded - different in each org
        User u = new User();
        u.Username = 'test@example.com';
        u.Email = 'test@example.com';
        u.ProfileId = '00e000000000000AAA'; // Hardcoded profile ID
        insert u;
    }
    
    // BAD: Hardcoded permission set ID
    public void assignPermissionSet(Id userId) {
        // ISSUE: Permission set ID hardcoded
        PermissionSetAssignment psa = new PermissionSetAssignment();
        psa.AssigneeId = userId;
        psa.PermissionSetId = '0PS000000000000AAA'; // Hardcoded
        insert psa;
    }
    
    // BAD: Hardcoded custom setting values
    public void getConfiguration() {
        // ISSUE: Hardcoded configuration values instead of using Custom Settings
        String apiEndpoint = 'https://production-api.example.com';
        Integer timeout = 30000;
        Boolean enableLogging = true;
        
        // Should use Custom Settings or Custom Metadata instead
    }
    
    // BAD: Hardcoded webhook secret
    public Boolean validateWebhook(String signature, String payload) {
        // ISSUE: Webhook secret hardcoded - should use Named Credentials or Custom Metadata
        String secret = 'whsec_1234567890abcdef';
        
        // Validation logic using hardcoded secret
        return true;
    }
    
    // BAD: Hardcoded database connection string
    public void connectToDatabase() {
        // ISSUE: Database credentials hardcoded
        String connectionString = 'jdbc:mysql://localhost:3306/mydb?user=admin&password=secret123';
        
        // Connection logic
    }
    
    // BAD: Hardcoded encryption key
    public String encryptData(String data) {
        // ISSUE: Encryption key hardcoded - major security risk
        String encryptionKey = 'MySecretEncryptionKey12345';
        
        // Encryption logic using hardcoded key
        return 'encrypted_data';
    }
    
    // BAD: Hardcoded Salesforce org ID
    public void checkOrg() {
        // ISSUE: Org ID hardcoded - different for each org
        String orgId = '00D000000000000EAA';
        
        if(UserInfo.getOrganizationId() == orgId) {
            // Org-specific logic
        }
    }
    
    // BAD: Hardcoded email addresses
    public void sendNotification() {
        // ISSUE: Email addresses hardcoded - should use Custom Settings or Custom Metadata
        String adminEmail = 'admin@company.com';
        String supportEmail = 'support@company.com';
        
        // Send emails to hardcoded addresses
    }
    
    // BAD: Hardcoded feature flags
    public void processFeature() {
        // ISSUE: Feature flags hardcoded - should use Custom Metadata
        Boolean enableNewFeature = true;
        Boolean enableBetaFeature = false;
        
        if(enableNewFeature) {
            // Feature logic
        }
    }
    
    // BAD: Hardcoded queue ID
    public void assignToQueue(Case c) {
        // ISSUE: Queue ID hardcoded - different in each org
        c.OwnerId = '00G000000000000AAA'; // Hardcoded queue ID
        update c;
    }
}

