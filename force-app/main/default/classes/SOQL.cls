/**
* The SOQL class serves as a primer into the Salesforce Object Query Language in Apex.
* It covers fundamental aspects such as SELECT statements, WHERE clauses, Relationship queries, and LIMIT keyword.
*
* This class introduces developers to the concept of retrieving data from Salesforce using SOQL. It provides
* a step-by-step guide on how to construct SOQL queries, filter results using WHERE clause, retrieve related
* records, and manage data volume using the LIMIT keyword.
* 
* Topics covered in this class include:
* - Understanding the structure of a SOQL query.
* - Crafting basic SELECT statements in SOQL.
* - Applying filters using the WHERE clause in SOQL.
* - Fetching related records using Relationship queries.
* - Controlling the amount of data retrieved using the LIMIT keyword.
* 
* Users of this class can expect to gain a solid understanding of SOQL in Apex and
* be prepared to handle data retrieval tasks in Salesforce development.
* 
* @author Michael Strauß
*/

public with sharing class SOQL {
    
    /**
     * Question 1
     * Update/Uncomment the template code to create a method
     * Returns all leads from Salesforce Org
     * @return List of all leads with Id, LastName, Company, Phone, Email
     * Update the corresponding test class and testGetAllLeads method to cover this method
     */
    public static List<Lead> viewLeads() {
        
        List<Lead> listOfLeads = [SELECT Id, LastName, Company, Phone, Email FROM Lead];
        
        return listOfLeads;
        
        }
               

    /**
     * Question 2
     * Update/Uncomment the template code to create a method
     * Returns all contacts with first name of John.
     * @return A list of Contact records.
     * Update the corresponding test class and testGetContactsByFirstName method to cover this method
     */

    public static List<Contact> findJohn() {
    
        List<Contact> listOfJohns = [SELECT Id, Name, Email FROM Contact WHERE FirstName = 'John'];

        return listOfJohns;
    
        }
    

    /**
     * Question 3
     * Update/Uncomment the template code to create a method
     * Returns the Contact Id for all contacts with last name of Smith or Jones
     * @return A list of Contact Ids.
     * Update the corresponding test class and testGetContactIdsByLastName method to cover this method
     */
    public static List<Id> findLastNames () {
        
        List<Id> listOfLastNames = new List <Id>();
        
        for (Contact con : [SELECT Id, Name, Email FROM Contact WHERE LastName = 'Smith' OR LastName = 'Jones']) {
            listOfLastNames.add(con.Id);    
            }
            return listOfLastNames;
        }
 


    /**
     * Question 4
     * Update/Uncomment the template code to create a method
     * Returns List of closed won opportunities for a specific Account.
     * Example: yourMethodName('001XXXXXXXXXXXX') should return the list of closed won opportunities for the Account with the Id
     * @param accountId The ID of the Account.
     * @return A list of Opportunities with important opportunities fields
     * Update the corresponding test class and testGetClosedWonOpportunityCountByAccount method to cover this method
     */
    public static List<Opportunity> findClosedWonOpps(Id accountId) {
        
        List<Opportunity> listOfClosedWonOpps = [SELECT Id, Name, StageName, CloseDate, Amount, Account.Id, Account.Name FROM Opportunity WHERE StageName = 'Closed Won' AND AccountId = :accountId];
        
            return listOfClosedWonOpps;
        }

    /**
     * Question 5
     * Update/Uncomment the template code to create a method
     * Returns the total count of Account records.
     * @return The Integer count of Account records.
     * Update the corresponding test class and testGetAccountCount method to cover this method
     */
    public static Integer countAccounts() {
        
        Integer accountCount = [SELECT COUNT() FROM Account];
        
            return accountCount;
        }

    /**
     * Question 6
     * Update/Uncomment the template code to create a method
     * Return Key Value pair of Task Id and Task records for any tasks due date within the next 7 days.
     * @return A map of Task Ids to Task records.
     * Update the corresponding test class and testGetTasksDueNextWeek method to cover this method
     */
    public static Map <Id, Task> tasksWithinSevenDays() {
    
        //Create new map to store key value pairs (Task ID and Task record)
        Map<Id,Task> mapOfTasks = new Map<Id, Task>();

        //Calculate date today + 7 days
        Date today = Date.today();
        Date todayPlusSevenDays = today.addDays(7);

        //Find list of tasks due within the next 7 days
        List<Task> tasksNextSevenDays = [SELECT Id, Subject, ActivityDate FROM Task WHERE ActivityDate >= :today AND ActivityDate <= :todayPlusSevenDays];

        //Loop through all task records and add task record + task ID to the map that was initialized at the beginnning of the method
        for(task t : tasksNextSevenDays){
            mapOfTasks.put(t.Id, t);
        }

        //return all Task records and their IDs due in the next 7 days
        return mapOfTasks;
    }

    /**
     * Question 7
     * Update/Uncomment the template code to create a method
     * Retrieves all Contacts that have a example.com domain in their Email.
     * @return A list of Contact records.
     * Update the corresponding test class and testGetContactsByEmailDomain method to cover this method
     */
    public static List<Contact> findContactsByEmailDomain (String domain) {
    
        List<Contact> emailDomainContacts = [SELECT Id, Name, Email FROM Contact WHERE Email LIKE :('%' + domain)];
    
        return emailDomainContacts;
    
        }

    /**
     * Question 8
     * Retrieves all Opportunities that have a specific keyword in their Name.
     * Example: getOpportunitiesByNameKeyword('keyword') should return all Opportunities that have 'keyword' in their Name.
     * @param keyword The keyword to search for in the Opportunity Name.
     * @return A list of Opportunity records.
     */
    public static List<Opportunity> getOpportunitiesByNameKeyword(String keyword) {
         
        // If the keyword is null, return an empty list
        if (keyword == null) {
            return new List<Opportunity>();
        }

        // Convert keyword to lowercase
        String keywordLowerCase = '%' + keyword.toLowerCase() + '%';
        
        List<Opportunity> oppsWithKeyword = [SELECT Name, StageName, CloseDate, Account.Id FROM Opportunity WHERE Name LIKE :keywordLowerCase];

        return oppsWithKeyword; // Replace null with the variable you used to store the result
    }

    /**
     * Question 9
     * Retrieves all Cases that Case Origin is not Web or Email or Blank
     * @return A list of Case records.
     */
    public static List<Case> getFilterCaseOrigins() {
        
        List<Case> caseOrigin = [SELECT Id, Status, AccountId, Origin FROM Case WHERE Origin NOT IN ('', 'Web', 'Email')];
        
        return caseOrigin; // Replace null with the variable you used to store the result
    }

    /**
     * Question 10
     * Update/Uncomment the template code to create a method
     * Retrieves all Leads that have a specific Lead Source or contain a specific keyword in their Title.
     * Example: yourMethodName('Web', 'Engineer') should return all Leads that have 'Web' in their Lead Source or 'Engineer' in their Title.
     * @param leadSource The Lead Source to search for.
     * @param keyword The keyword to search for in the Lead Title.
     * @return A list of Lead records.
     * Update the corresponding test class and testGetLeadsBySourceOrTitle method to cover this method
     */
    
    public static List<Lead> findLeadsWithKeyword (String leadSource, String keyword) {
    
        String leadQuery = 'SELECT Id, LastName, Name, Company, Phone, Email, LeadSource, Title FROM Lead';
    
        // List to store conditions
        List<String> listForLeadSourceAndTitle = new List<String>();
    
        // Add condition for Lead Source
        if (leadSource != null && leadSource != '') {
            listForLeadSourceAndTitle.add('LeadSource LIKE \'%' + leadSource + '%\'');
        }
    
        // Add condition for Title
        if (keyword != null && keyword != '') {
            listForLeadSourceAndTitle.add('Title LIKE \'%' + keyword + '%\'');
        }        
    
        // Combine conditions with OR if more than one
        if (listForLeadSourceAndTitle.size() > 0) {
            leadQuery += ' WHERE ' + String.join(listForLeadSourceAndTitle, ' OR ');
        }
    
        // Execute the SOQL query
        List<Lead> leads = Database.query(leadQuery);
    
        return leads;
    
        }    

    /**
     * Question 11
     * Returns the names of all Contacts associated with an Account.
     * Example: getContactNamesByAccount('001XXXXXXXXXXXX') should return the list of Contact LastNames for the Account with the Id
     * @param accountId The ID of the Account.
     * @return A list of Contact LastName.
     */
    public static List<String> getContactNamesByAccount(Id accountId) {
        
    // Create a list to hold the Contact LastNames
    List<String> contactLastNames = new List<String>();

    // Query the Contacts
    List<Contact> contacts = [SELECT Id, Name FROM Contact WHERE AccountId = :accountId];

    // Loop through each Contact and add the LastName to the list
    for (Contact con : contacts) {
        contactLastNames.add(con.Name);
        }

    // Return the list of Contact LastNames
    return contactLastNames; // Replace null with the variable you used to store the result
    }

    /**
     * Question 12
     * Returns the total revenue for all Opportunities in a specific Stage or if the amount is greater than 10000.
     * Example: getTotalRevenueByStage('Closed Won') should return the total revenue for all Opportunities in the 'Closed Won' Stage.
     * @param stage The Stage value to filter Opportunities.
     * @return The total revenue.
     */
    public static Decimal getTotalRevenueByStage(String stage) {
        
        // Initialize variables
        Decimal totalRevenue = 0;
       
        // Query to retrieve opportunities by stage and aggregate the amount
        List<AggregateResult> results = [
            SELECT SUM(Amount) totalAmount FROM Opportunity WHERE StageName IN ('Closed Won', 'Closed Lost')
            ];

        // Check if there are any results
        if (!results.isEmpty()) {
        // Retrieve total revenue from the first result
        totalRevenue = (Decimal)results[0].get('totalAmount');
        }

        // Return the total revenue
        return totalRevenue;
    }

    /**
     * Question 13
     * Retrieves the first 10 Accounts ordered by Name.
     * @return A list of the first 10 Accounts ordered by Name.
     */
    public static List<Account> getFirstTenAccounts() {
        
        List<Account> accountsOrderedByName = 
            [SELECT Id, Name FROM Account ORDER BY Name ASC LIMIT 10];
            
        return accountsOrderedByName; // Replace null with the variable you used to store the result
    }
    
    /**
     * Question 14
     * Retrieves the Opportunities with an Amount greater than 100,000, ordered by CloseDate, and limited to 5 records.
     * @return A list of Opportunities with an Amount greater than 100,000, ordered by CloseDate, and limited to 5 records.
     */
    public static List<Opportunity> getHighValueOpportunities() {
        
        List<Opportunity> oppsList = [
            SELECT Id, Name, Amount, CloseDate FROM Opportunity WHERE Amount > 100000 ORDER BY CloseDate ASC LIMIT 5];
            

        return oppsList; // Replace null with the variable you used to store the result
    }
    
    /**
     * Question 15
     * Retrieves the Contacts with the most recent Birthdate, ordered by Birthdate, and limited to 3 records.
     * @return A list of Contacts
     */
    public static List<Contact> getBirthdateContacts() {
        
        List<Contact> contactBirthdays = [
            SELECT Id, Name, Birthdate FROM Contact ORDER BY Birthdate DESC Limit 3
        ];

        return contactBirthdays; // Replace null with the variable you used to store the result
    }
    
    /**
     * Question 16
     * Retrieves the Cases in the Open Status, ordered by CreatedDate, and limited to 10 records with an offset of 5.
     * @return A list of Cases
     */
    public static List<Case> getCasesWithStatus() {
        List<Case> listOfCases = [
            SELECT Id, CaseNumber, Status, CreatedDate FROM Case WHERE Status = 'Open' ORDER BY CreatedDate ASC LIMIT 10 OFFSET 5
        ];

        return listOfCases; // Replace null with the variable you used to store the result
    }

    /**
     * Question 17
     * Returns Set of Case Ids for a specific Account.
     * Example: getCaseIdsByAccount('001XXXXXXXXXXXX') should return the set of Case Ids for the Account with the Id
     * @param accountId The ID of the Account.
     * @return A set of Case Ids.
     */
    public static Set<Id> getCaseIdsByAccount(Id accountId) {
        
        // Create a set to hold the Case Ids
        Set<Id> caseIds = new Set<Id>();
        
        // Query the Cases
        List<Case> listOfCases = [SELECT Id, CaseNumber, Status, CreatedDate FROM Case WHERE AccountId = :accountId];

        // Loop through each Case and add the Id to the set
        for (Case c : listOfCases) {
           caseIds.add(c.Id);
        }

        return caseIds; // Replace null with the variable you used to store the result
    }

    /**
     * Question 18
     * Return Map of Account Ids to Account Names Not in a specific Country.
     * Example: getAccountIdsToNamesNotInCountry('United States') should return the map of Account Ids to Account Names for Accounts that are not in the United States.
     * @param country The country to filter Accounts.
     * @return A map of Account Ids to Account Names.
     */
    public static Map<Id, String> getAccountIdsToNamesNotInCountry(String country) {
        
        // Create a map to hold the Account Ids to Account Names
        Map<Id, String> accountIdsToNames = new Map<Id, String>();

        // Query the Accounts
        List<Account> listOfAccounts = [SELECT Name, Id, BillingCountry FROM Account WHERE BillingCountry != :country];

        // Loop through each Account and add the Id and Name to the map
        for(Account acc : listOfAccounts){
            accountIdsToNames.put(acc.Id, acc.Name);
        }

        return accountIdsToNames; // Replace null with the variable you used to store the result
    }

    /**
     * Question 19
     * Retrieves the Account Name for a given Contact.
     * Example: getAccountNameForContact('003XXXXXXXXXXXX') should return the Account Name for the Contact with the Id
     * @param contactId The Id of the Contact.
     * @return The Account Name of the Contact.
     */
    public static String getAccountNameForContact(String contactId) {
        // Initialize a variable to store the Acount Name
        String accName = null;

        // Query the Contact to fetch the related Account's Name using Limit of 1 in case muliple Contacts are related to the Account
        Contact c = [SELECT Name, Id, Account.Name FROM Contact WHERE Id = :contactId Limit 1];
        
        // Update variable accName with Account Name from query
        accName = c.Account.Name;

        return accName; // Replace null with the variable you used to store the result
    }   

    /**
     * Question 20
     * Returns single Account that has related opportunities in the same query
     * Example: getAccountAndOpportunitiesFromAccountId('001XXXXXXXXXXXX') should return the Account Name for the Account with the Id and all related Opportunities
     * @param accountId The ID of the Account.
     * @return An Account record with related Opportunities.
     */
    public static Account getAccountAndOpportunitiesFromAccountId(Id accountId) {

        Account accountWithOpportunities = [
            SELECT Id, Name,
                (SELECT Id, Name, StageName, CloseDate FROM Opportunities)
            FROM Account WHERE Id = :accountId LIMIT 1];

        return accountWithOpportunities; // Replace null with the variable you used to store the result
    }

    /**
     * Question 21
     * Retrieves all contacts that have the Mailing State similar to the Account Billing State.
     * Example: getAccountsWithContactsByState('001XXXXXXXXXXXX') should return a list of Contacts that have the same Mailing State as the Account with the Id
     * @param Account Id
     * @return List of contacts with the same Mailing State as the Account Billing State
     */
    public static List<Contact> getAccountsWithContactsByState(Id accountId) {
        
           // Query the Account to get its Billing State
            Account acc = [SELECT BillingState FROM Account WHERE Id = :accountId LIMIT 1];
            String billingState = acc.BillingState;

            // Use a SOQL query to retrieve contacts with Mailing State similar to the Account's Billing State
            List<Contact> contactsForAccount = [SELECT Id, Name, MailingState 
                                        FROM Contact WHERE MailingState = :billingState];

        return contactsForAccount;
    }
        
    
    
    
    

    /**
     * Question 22
     * Extracts email domains from them leads, then finds Accounts with matching website domains
     * If Lead Email = test@test.com return account with website = www.test.com
     * Example: findAccountsByLeadEmailDomains([set of lead ids]) should return a list of Accounts with matching email domains
     * @param A set of Lead Ids.
     * @return A list of Accounts with matching email domains.
     */
    
     public static List<Account> findAccountsByLeadEmailDomains(Set<Id> leadIds) {
        // Query the Leads and collect their email domains
        Set<String> emailDomains = new Set<String>();
        system.debug('my test for select Lead: '+ [SELECT Email, Id FROM Lead WHERE Id IN :leadIds AND Email != null]);
        for (Lead lead : [SELECT Email, Id FROM Lead WHERE Id IN :leadIds AND Email != null]) {
            String leadEmail = lead.Email;
            Integer atIndex = leadEmail.indexOf('@');
            if (atIndex != -1) {
                emailDomains.add(leadEmail.substring(atIndex + 1).toLowerCase());
                System.debug('MyTestForLeadEmail'+ leadEmail.substring(atIndex + 1).toLowerCase());
            }
        }
    
        // Collect distinct website domains from the Accounts
        Set<String> websiteDomains = new Set<String>();
        for (Account acc : [SELECT Website, Id FROM Account WHERE Website != null]) {
            String website = acc.Website;
            if (website.startsWith('www.')) {
                websiteDomains.add(website.substring(4));
            }
        }
    
        // Find common domains between email and website domains
        Set<String> commonDomains = new Set<String>();
        for (String emailDomain : emailDomains) {
            for (String websiteDomain : websiteDomains) {
                if (emailDomain == websiteDomain) {
                    commonDomains.add(emailDomain);
                    break;
                }
            }
        }
        System.debug('CommonDomains ' + commonDomains);
    
        // Query Accounts with matching website domains
        List<Account> matchedAccounts = new List<Account>();
        if (!commonDomains.isEmpty()) {
            for (String commonDomain : commonDomains) {
                string domain = '%' + commonDomain + '%';
                List<Account> acc = [select Id, Name, Website from Account where Website LIKE :domain];
                for (Account a : acc) {
                    matchedAccounts.add(a);
                }
            }
        }
        return matchedAccounts;
    }
    
    
    
     
    

    /**
     * Question 23
     * Clones and Inserts Opportunity Line Items from an original Opportunity to a list of cloned Opportunities.
     * Adds a randomized number between 1 to 3 to the quantity of each line item.
     * Example: cloneLineItems('001XXXXXXXXXXXX', [list of opportunity ids]) should clone the line items from the Opportunity with the Id to each Opportunity in the list
     * @param Original Opportunity Id
     * @param List of cloned Opportunity Ids
     */
    public static void cloneLineItems(Id origOppId, List<Id> cloneOppIds) {
        // Query the original Opportunity Line Items
        List<OpportunityLineItem> origLineItems = [SELECT Id, Quantity, UnitPrice, PricebookEntryId FROM OpportunityLineItem WHERE OpportunityId = :origOppId];
    
        // Create a list to hold the new line items
        List<OpportunityLineItem> newLineItems = new List<OpportunityLineItem>();
    
        // Generate a random number between 1 and 3
        Integer randomQuantity = (Integer)Math.floor(Math.random() * 3) + 1;
    
        // Loop through each cloned Opportunity Id
        for (Id cloneOppId : cloneOppIds) {
            // Loop through each original line item
            for (OpportunityLineItem origItem : origLineItems) {
                // Clone the original line item
                OpportunityLineItem newItem = origItem.clone(false, true); // Shallow clone with different IDs
    
                // Adjust the quantity by adding the random number
                newItem.Quantity = (Integer)(origItem.Quantity * randomQuantity);
    
                // Set the cloned line item's OpportunityId to the current cloned Opportunity Id
                newItem.OpportunityId = cloneOppId;
    
                // Add the cloned line item to the list
                newLineItems.add(newItem);
            }
        }
    
        // Insert the new line items
        insert newLineItems;
    }
    
    
    
    /**
     * Question 24
     * Retrieves the Opportunity Name, Account Name, and Owner Name for Opportunities that have a Stage of 'Closed Won'.
     * Example: getOpportunityDetailsForClosedWon()
     * @return A list of filtered Opportunity
     */
    public static List<Opportunity> getOpportunityDetailsForClosedWon() {        
        // Query Opportunities with Stage = 'Closed Won' and retrieve necessary fields
        return [SELECT Id, Name, Account.Name, Owner.Name FROM Opportunity WHERE StageName = 'Closed Won'];
        }

    /**
     * Question 25
     * Sets the 'Primary_Contact__c' field for all Closed Won Opportunities to first Contact on the Account.
     * Example: setPrimaryContact() should set the 'Primary_Contact__c' field for every Opportunity in the org
     */
    public static void setPrimaryContact() {
        // Use the getOpportunityDetailsForClosedWon() method to get the Opportunities
        List<Opportunity> closedWonOpps = getOpportunityDetailsForClosedWon();
        
        // Create a set to hold Account Ids
        Set<Id> accountIds = new Set<Id>();
        
        // Extract Account Ids from the Opportunities
        for (Opportunity opp : closedWonOpps) {
            accountIds.add(opp.AccountId);
        }
        
        // Create a map to hold Account Id to Contact Id mapping
        Map<Id, Id> accountIdToContactIdMap = new Map<Id, Id>();
        
        // Query the Contacts related to the Accounts
        for (Contact con : [SELECT Id, AccountId FROM Contact WHERE AccountId IN :accountIds ORDER BY CreatedDate ASC OFFSET 1]) {
            // Add the second Contact for each Account to the map
            accountIdToContactIdMap.put(con.AccountId, con.Id); // Map Account Id to Contact Id
        }
        
        // Loop through each Opportunity
        for (Opportunity opp : closedWonOpps) {
            // Check if the Opportunity's Account has an associated Contact
            if (accountIdToContactIdMap.containsKey(opp.AccountId)) {
                // Assign the second Contact Id to the Opportunity's Primary_Contact__c field
                opp.Primary_Contact__c = accountIdToContactIdMap.get(opp.AccountId);
            }
        }
        
        // Update the Opportunities
        update closedWonOpps;
    } 
}       