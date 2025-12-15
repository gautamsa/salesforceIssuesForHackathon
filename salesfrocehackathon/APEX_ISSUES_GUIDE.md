# Apex Learning Guide: Common Issues and Mistakes

This repository contains Apex classes with intentional issues designed to help beginners learn Apex best practices. Each class demonstrates specific problems that are common when starting to learn Apex development.

## Overview

The classes in this project are **intentionally problematic** and should **NOT** be used in production. They are educational examples to help you:
- Identify common coding mistakes
- Understand Salesforce governor limits
- Learn security best practices
- Improve code quality and structure

## Classes and Their Issues

### 1. AccountQueryInjection.cls
**Issue Type:** Security Vulnerability - SOQL Injection

**Problems Demonstrated:**
- Direct string concatenation in SOQL queries
- Missing input validation
- No access modifiers
- No error handling

**Why It's Bad:**
- Vulnerable to SOQL injection attacks
- Malicious users could manipulate queries to access unauthorized data
- Can cause security breaches

**How to Fix:**
- Use bind variables (`:variableName`) instead of string concatenation
- Use `String.escapeSingleQuotes()` if you must concatenate
- Validate and sanitize all user inputs
- Add proper access modifiers (public/private/global)

**Example Fix:**
```apex
// BAD (from the class):
String query = 'SELECT Id, Name FROM Account WHERE Name = \'' + name + '\'';

// GOOD:
List<Account> accounts = [SELECT Id, Name FROM Account WHERE Name = :name];
```

---

### 2. DMLInLoop.cls
**Issue Type:** Governor Limit Violation

**Problems Demonstrated:**
- DML operations inside loops
- SOQL queries inside loops
- Nested loops with DML
- Missing bulkification

**Why It's Bad:**
- Salesforce limits: 150 DML statements per transaction
- Will fail with more than 150 records
- Inefficient and can cause timeout errors
- Violates Salesforce best practices

**How to Fix:**
- Collect all records to update/insert in a list
- Perform DML operations outside the loop
- Use bulk DML operations (insert/update/delete on collections)

**Example Fix:**
```apex
// BAD (from the class):
for(Account acc : accounts) {
    acc.Phone = '555-1234';
    update acc; // DML in loop
}

// GOOD:
List<Account> accountsToUpdate = new List<Account>();
for(Account acc : accounts) {
    acc.Phone = '555-1234';
    accountsToUpdate.add(acc);
}
update accountsToUpdate; // Single DML operation
```

---

### 3. MissingNullChecks.cls
**Issue Type:** Null Pointer Exceptions

**Problems Demonstrated:**
- Missing null checks before accessing properties
- No validation of input parameters
- No error handling (try-catch blocks)
- Accessing nested properties without null safety

**Why It's Bad:**
- Will throw `NullPointerException` at runtime
- Causes production errors and user frustration
- No graceful error handling
- Can crash entire transactions

**How to Fix:**
- Always check for null before accessing object properties
- Validate input parameters
- Use try-catch blocks for error handling
- Use safe navigation or conditional checks

**Example Fix:**
```apex
// BAD (from the class):
public String getAccountName(Account acc) {
    return acc.Name; // Will fail if acc is null
}

// GOOD:
public String getAccountName(Account acc) {
    if(acc != null && acc.Name != null) {
        return acc.Name;
    }
    return null; // or throw custom exception
}
```

---

### 4. GovernorLimitIssues.cls
**Issue Type:** Multiple Governor Limit Violations

**Problems Demonstrated:**
- SOQL queries inside loops (100 query limit)
- Too many DML statements (150 DML limit)
- Heap size issues
- CPU time limit issues
- Inefficient algorithms

**Why It's Bad:**
- Salesforce has strict governor limits
- Code will fail in production with larger datasets
- Can cause entire transaction to fail
- Poor performance and scalability

**How to Fix:**
- Bulkify all operations
- Query once, process many times
- Use efficient algorithms
- Monitor heap size and CPU time
- Use batch classes for large datasets

**Example Fix:**
```apex
// BAD (from the class):
for(Id accId : accountIds) {
    List<Contact> contacts = [SELECT Id FROM Contact WHERE AccountId = :accId];
}

// GOOD:
List<Contact> allContacts = [SELECT Id, AccountId FROM Contact WHERE AccountId IN :accountIds];
Map<Id, List<Contact>> contactsByAccount = new Map<Id, List<Contact>>();
for(Contact con : allContacts) {
    if(!contactsByAccount.containsKey(con.AccountId)) {
        contactsByAccount.put(con.AccountId, new List<Contact>());
    }
    contactsByAccount.get(con.AccountId).add(con);
}
```

---

### 5. PoorCodeStructure.cls
**Issue Type:** Code Quality and Best Practices

**Problems Demonstrated:**
- Missing access modifiers
- Poor naming conventions
- Hard-coded values (magic numbers/strings)
- No constants for reusable values
- Methods doing too many things
- No documentation

**Why It's Bad:**
- Hard to maintain and understand
- Difficult to debug
- Not reusable
- Violates coding standards
- Makes code reviews difficult

**How to Fix:**
- Use proper access modifiers (public/private/global)
- Follow naming conventions (PascalCase for classes, camelCase for variables)
- Extract constants for magic values
- Write single-responsibility methods
- Add meaningful comments and documentation

**Example Fix:**
```apex
// BAD (from the class):
void doStuff(Account a) {
    a.Phone = '555-1234';
    update a;
}

// GOOD:
private static final String DEFAULT_PHONE = '555-1234';

public void updateAccountPhone(Account account) {
    if(account != null) {
        account.Phone = DEFAULT_PHONE;
        update account;
    }
}
```

---

### 6. TriggerContextIssues.cls
**Issue Type:** Trigger Context Mistakes

**Problems Demonstrated:**
- Not checking trigger context (before/after, insert/update)
- Accessing fields not available in before context
- Not handling bulk operations properly
- Missing recursion prevention
- Not checking if fields actually changed

**Why It's Bad:**
- Will fail in certain trigger contexts
- Can cause infinite recursion
- Not bulkified for large data volumes
- Can cause unexpected behavior

**How to Fix:**
- Always check trigger operation (isInsert, isUpdate, etc.)
- Understand before vs after context
- Check if oldMap is null before accessing
- Use proper recursion prevention
- Bulkify all operations

**Example Fix:**
```apex
// BAD (from the class):
if(acc.Name != oldMap.get(acc.Id).Name) {
    // Will fail on insert
}

// GOOD:
if(Trigger.isUpdate && oldMap != null && oldMap.containsKey(acc.Id)) {
    if(acc.Name != oldMap.get(acc.Id).Name) {
        // Process field change
    }
}
```

---

### 7. ExceptionHandlingIssues.cls
**Issue Type:** Poor Exception Handling

**Problems Demonstrated:**
- No try-catch blocks for DML operations
- Catching generic Exception instead of specific exceptions
- Swallowing exceptions without logging
- Not handling partial failures in bulk operations
- No user-friendly error messages
- Not using Database methods for partial success

**Why It's Bad:**
- Users get cryptic error messages
- No way to handle partial failures in bulk operations
- Difficult to debug production issues
- Poor user experience
- Can cause entire transaction to fail when only one record has issues

**How to Fix:**
- Use try-catch blocks for all DML operations
- Catch specific exceptions (DmlException, QueryException, etc.)
- Log errors appropriately
- Use Database methods (insert, update, delete) for partial success handling
- Provide meaningful error messages
- Handle bulk operation failures gracefully

**Example Fix:**
```apex
// BAD (from the class):
public void updateAccounts(List<Account> accounts) {
    update accounts; // All fail if one fails
}

// GOOD:
public void updateAccounts(List<Account> accounts) {
    Database.SaveResult[] results = Database.update(accounts, false);
    for(Integer i = 0; i < results.size(); i++) {
        if(!results[i].isSuccess()) {
            Database.Error[] errors = results[i].getErrors();
            System.debug('Account ' + accounts[i].Name + ' failed: ' + errors[0].getMessage());
        }
    }
}
```

---

## Key Salesforce Governor Limits to Remember

1. **SOQL Queries:** 100 per transaction
2. **DML Statements:** 150 per transaction
3. **DML Rows:** 10,000 per transaction
4. **CPU Time:** 10,000 milliseconds (10 seconds)
5. **Heap Size:** 6 MB synchronous, 12 MB asynchronous
6. **Callout Timeout:** 120 seconds
7. **Email Invocations:** 10 per transaction

## Best Practices Summary

1. **Always bulkify** - Write code that handles 1 record or 200 records
2. **Use bind variables** - Never concatenate strings into SOQL queries
3. **Check for null** - Always validate before accessing object properties
4. **Handle errors** - Use try-catch blocks appropriately
5. **Use proper access modifiers** - Make code maintainable
6. **Follow naming conventions** - Make code readable
7. **Extract constants** - Avoid magic numbers and strings
8. **Write single-responsibility methods** - Keep methods focused
9. **Document your code** - Help others understand your intent
10. **Test thoroughly** - Write test classes with good coverage

## Learning Exercise

For each class in this repository:
1. Read the code and identify all issues
2. Understand why each issue is problematic
3. Write corrected versions of the methods
4. Create test classes to verify your fixes work
5. Compare your solutions with Salesforce best practices

## Additional Resources

- [Apex Developer Guide](https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/)
- [Apex Best Practices](https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_best_practices.htm)
- [Governor Limits](https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_gov_limits.htm)
- [Security Best Practices](https://developer.salesforce.com/docs/atlas.en-us.secure_coding_guide.meta/secure_coding_guide/)

## Note

These classes are intentionally problematic and should **NEVER** be deployed to production. They are educational tools only. Always follow Salesforce best practices and coding standards in your production code.

