/**
 * ISSUE: Input Validation and Sanitization Problems
 * 
 * This class demonstrates security issues related to missing or inadequate
 * input validation and sanitization, which can lead to XSS attacks, injection
 * attacks, and other security vulnerabilities.
 * 
 * PROBLEMS TO IDENTIFY:
 * 1. Missing input validation
 * 2. No sanitization of user input
 * 3. Accepting null values without checks
 * 4. Not validating data types
 * 5. Missing length validation
 * 6. Not escaping HTML/JavaScript in output
 * 7. Accepting special characters without sanitization
 * 8. No regex validation for expected formats
 */
public class InputValidationIssues {
    
    // BAD: No input validation - accepts any string
    public void createAccount(String accountName) {
        // ISSUE: No validation - could be null, empty, or malicious input
        Account acc = new Account();
        acc.Name = accountName; // Direct assignment without validation
        insert acc;
    }
    
    // BAD: No sanitization of HTML input - XSS vulnerability
    public void updateAccountDescription(Id accountId, String description) {
        // ISSUE: HTML/JavaScript in description not sanitized - XSS risk
        // Attacker could input: <script>alert('XSS')</script>
        Account acc = [SELECT Id, Description FROM Account WHERE Id = :accountId];
        acc.Description = description; // No sanitization
        update acc;
    }
    
    // BAD: No length validation
    public void createContact(String firstName, String lastName) {
        // ISSUE: No length check - could exceed field limits or cause issues
        Contact con = new Contact();
        con.FirstName = firstName; // Could be 1000+ characters
        con.LastName = lastName; // Could be 1000+ characters
        insert con; // Will fail if exceeds field length
    }
    
    // BAD: No type validation
    public void updateAccountRevenue(Id accountId, String revenueString) {
        // ISSUE: No validation that revenueString is a valid number
        // Could be: "abc", "null", "999999999999999999999"
        Decimal revenue = Decimal.valueOf(revenueString); // Will throw exception
        Account acc = [SELECT Id, AnnualRevenue FROM Account WHERE Id = :accountId];
        acc.AnnualRevenue = revenue;
        update acc;
    }
    
    // BAD: No email format validation
    public void createUser(String email) {
        // ISSUE: No email format validation
        // Could be: "notanemail", "test@", "@domain.com", or malicious input
        User u = new User();
        u.Username = email;
        u.Email = email;
        // Will fail or create invalid user
        insert u;
    }
    
    // BAD: No phone number validation
    public void updateContactPhone(Id contactId, String phone) {
        // ISSUE: No phone format validation
        // Could be: "abc", "123", "+++", or malicious input
        Contact con = [SELECT Id, Phone FROM Contact WHERE Id = :contactId];
        con.Phone = phone; // No validation
        update con;
    }
    
    // BAD: Accepting null without handling
    public void processAccountData(String name, String industry) {
        // ISSUE: No null check - if name or industry is null, processing might fail
        // Should validate inputs before processing
        Account acc = new Account();
        acc.Name = name; // Could be null
        acc.Industry = industry; // Could be null
        insert acc;
    }
    
    // BAD: No URL validation
    public void updateAccountWebsite(Id accountId, String website) {
        // ISSUE: No URL validation - could be malicious JavaScript or invalid URL
        // Could be: "javascript:alert('XSS')", "http://", or "not a url"
        Account acc = [SELECT Id, Website FROM Account WHERE Id = :accountId];
        acc.Website = website; // No validation
        update acc;
    }
    
    // BAD: No date validation
    public void createOpportunity(String closeDateString) {
        // ISSUE: No date format validation
        // Could be: "invalid", "2024-13-45", or past dates when not allowed
        Date closeDate = Date.valueOf(closeDateString); // Will throw exception if invalid
        Opportunity opp = new Opportunity();
        opp.Name = 'Test Opp';
        opp.CloseDate = closeDate;
        opp.StageName = 'Prospecting';
        insert opp;
    }
    
    // BAD: No ID format validation
    public Account getAccountById(String accountIdString) {
        // ISSUE: No validation that string is a valid Salesforce ID format
        // Could be: "invalid", "123", or malicious input
        Id accountId = Id.valueOf(accountIdString); // Will throw exception if invalid
        return [SELECT Id, Name FROM Account WHERE Id = :accountId];
    }
    
    // BAD: No special character sanitization
    public void createCase(String subject, String description) {
        // ISSUE: Special characters not sanitized - could cause SOQL injection or other issues
        // Could contain: ', ", \, %, _, or other special characters
        Case c = new Case();
        c.Subject = subject; // No sanitization
        c.Description = description; // No sanitization
        insert c;
    }
    
    // BAD: No regex validation for expected format
    public void processOrderNumber(String orderNumber) {
        // ISSUE: No validation that orderNumber matches expected format (e.g., ORD-12345)
        // Could be: "invalid", "ORD-", "ORD-abc", or malicious input
        // Should validate format with regex: ^ORD-\\d{5}$
        // Process order without validation
    }
    
    // BAD: Accepting user input for field names
    public void updateField(Id recordId, String fieldName, String fieldValue) {
        // ISSUE: Field name from user input - extremely dangerous
        // Attacker could specify any field name, including system fields
        Account acc = [SELECT Id FROM Account WHERE Id = :recordId];
        acc.put(fieldName, fieldValue); // No validation of field name
        update acc;
    }
    
    // BAD: No validation of list size
    public void processIds(List<String> idList) {
        // ISSUE: No validation of list size - could be empty, null, or extremely large
        // Could cause governor limit issues or unexpected behavior
        for(String idStr : idList) {
            // Process each ID without validation
        }
    }
    
    // BAD: No validation of numeric ranges
    public void updateAccountEmployees(Id accountId, Integer employeeCount) {
        // ISSUE: No range validation - could be negative, zero, or extremely large
        // Could be: -1, 0, 999999999999
        Account acc = [SELECT Id, NumberOfEmployees FROM Account WHERE Id = :accountId];
        acc.NumberOfEmployees = employeeCount; // No validation
        update acc;
    }
    
    // BAD: No validation of picklist values
    public void updateAccountIndustry(Id accountId, String industry) {
        // ISSUE: No validation that industry is a valid picklist value
        // Could be: "Invalid", "Hacking", or any arbitrary string
        Account acc = [SELECT Id, Industry FROM Account WHERE Id = :accountId];
        acc.Industry = industry; // No validation against picklist values
        update acc; // Will fail if not valid picklist value
    }
    
    // BAD: No validation of file uploads
    public void processFile(Blob fileContent, String fileName) {
        // ISSUE: No validation of file type, size, or name
        // Could be: executable file, extremely large file, or malicious filename
        // File name could contain: "../../", "script.exe", or other dangerous patterns
        // Process file without validation
    }
    
    // BAD: No validation of JSON input
    public void processJsonData(String jsonString) {
        // ISSUE: No validation of JSON structure or content
        // Could be: invalid JSON, extremely large, or contain malicious data
        Map<String, Object> data = (Map<String, Object>)JSON.deserializeUntyped(jsonString);
        // Process data without validation
    }
}

