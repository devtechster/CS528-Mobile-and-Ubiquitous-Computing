/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* Day 10– Programmatic Model 2
* Advanced concepts / Collections/SOQL Queries/DML Operations
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Adhiraj N. B.
* @modifiedBy     Adhiraj N. B.
* @maintainedBy   Adhiraj N. B.
* @version        1.0
* ──────────────────────────────────────────────────────────────────────────────────────────────────*/

public with sharing class SoqlQueriesAssignment 
{
    /************************************************************************************
    1. Query on Account object/ records and show/print each account record using: - Day 1
        a. Traditional for loop
        b. Advanced for loop
    ***********************************************************************************/
            public void loopQuery1()
        {
            // Using Traditional For looop
            List<Account> listOfAccount = [
                                            SELECT   AccountNumber,
                                                    Name,
                                                    NumberOfEmployees 
                                            FROM     Account
                                        ];

            for(Integer iterator=0; iterator< listOfAccount.size(); iterator++)
            {
            System.debug(listOfAccount[iterator]);
            }
            
            //Using Advance For loop
            Account accountPrintInstance = new Account();
            for(Account accountInstace : [
                                            SELECT   AccountNumber,
                                                    Name,
                                                    NumberOfEmployees 
                                            FROM     Account
                                        ])
            {
            accountPrintInstance = accountInstace;
            listOfAccount.add(accountPrintInstance);
            }
            System.debug('List of Accounts using Advanced For Loop :' + listOfAccount);
        }

    /***********************************************************************************
    4. -Create an Account Record with Name = “Eternus”. 
        -Create associated contacts. 
        -Create a Custom field called Contact Count on Account. 
        -Query on Contact where Account.Name =“Eternus” and count the associated contacts. 
        -Update the custom field on Accounts with that count. 
    *************************************************************************************/
    public void childToParentQueryMethod()
    {

        List <Contact> conList = [
                                    SELECT   AccountId,
                                            Account.Contact_Count__c 
                                    FROM     Contact 
                                    WHERE    Account.Name = 'Eternus'
                                ];
        Integer counter = conList.size();
        System.debug(counter);

        Account acc = new Account();
        acc.Id = conList[0].AccountId;
        acc.Contact_Count__c = counter;
        update acc;
        
        //For Bulkifying the Code.
        //conList[0].Account.Contact_Count__c = counter;
        //update conList[0];
    }

        /***************************************************************************************
        5. Write a SQOL Query to show Child Parent relationship and print the result. 
            For example:
            Account is parent and Contact is child. 
            Then Query on Child 
        **************************************************************************************/
        public void parentToChildMethod()
        {
            List<Account> accountList = [SELECT 
                                    ID,
                                    Name,
                                    (SELECT Id,Name from Contacts)
                                    FROM Account];
            System.debug(accountList);
        } 
}