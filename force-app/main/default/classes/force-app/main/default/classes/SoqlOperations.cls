/**
 * @File Name          : SoqlOperations.cls
 * @Description        :
 * @Author             : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Group              :
 * @Last Modified By   : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Last Modified On   : 8/13/2019, 7:12:44 PM
 * @Modification Log   :
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    8/13/2019, 6:51:10 PM   ChangeMeIn@UserSettingsUnder.SFDoc     Initial Version
**/
public with sharing class SoqlOperations
{
   /***************************************************************************************** */
    /*
    * Write a SOQL query to retrieve/print all active Users.
    * Prepare a Map having User Id as key and User record as value. (Hint: Use Map<Id, User>)
    */
   /***************************************************************************************** */
    public void activeU()
    {
        List<User> activeUserList = [Select Id from User WHERE IsActive = true];

        System.debug(activeUserList);
    }

   /*************************************************************************************** */
    /*Create a multi-select picklist on Account object called as 'Enrollment Year'
    with values - 2010, 2011, 2012, 2013, 2014, 2015 and 2016.
    Get all account records where in selected 'Enrollment Year' is:
    a. 2010
    b. 2013 and 2014*/
    /***************************************************************************************** */

    public void yearPicklist()
    {
        List<Account> ac = [Select Id,Name from Account WHERE Enrollment_Year__c INCLUDES ('2013;2014')];

        List<Account> ac2 = [Select Id,Name from Account WHERE Enrollment_Year__c INCLUDES ('2010')];

        System.debug(ac);
        System.debug(ac2);
    }

    /**************************************************************************************** */
    /*
    Write a SOQL query to find all Account records where 'Billing State' is not 'Maharashtra' and 'Kerala'.
    Order the results by Billing State in descending order with null values at the end.
    Display first 10,000 records only. Note: Do not use AND operator.
    */
    /**************************************************************************************** */

    public void billing()
    {
        List<Account> ac = [SELECT BillingState
                            FROM Account
                            WHERE BillingState != 'Maharashtra;Kerala'
                            ORDER BY BillingState
                            DESC NULLS LAST
                            LIMIT 10000];

        System.debug(ac);
    }
    /***************************************************************************************** */
    /*
    Write a SOQL query to display 100 opportunity records with amount greater than 10,000 order by created date.
    Skip first 50 records and include records from recycle bin.
    */
    //*********************************************************************************** */
    public void opportunityFetch()
    {
        List<Opportunity> listOfOpportunities = [
                                                    SELECT  Amount,
                                                            AccountId,
                                                            Name
                                                    FROM Opportunity
                                                    WHERE Amount > 10000 ORDER BY Id LIMIT 100 OFFSET 50 ALL ROWS
                                                ];
            System.debug(listOfOpportunities);
    }

}