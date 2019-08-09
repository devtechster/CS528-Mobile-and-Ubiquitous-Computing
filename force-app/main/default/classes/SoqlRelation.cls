/*
Create a custom object 'A', 'B' and 'C'. 
Establish 'Master Detail' relationship between them such that ‘C’ is junction object.
*/
public with sharing class SoqlRelation 
{

        /***************************************************************************************
    Write a SOQL query on Contact to retrieve all active contacts belonging to 'media' Industry.
    Also display the name of the account to which it is associated to.
    (Here media record not found hence assured with Consulting Record)
    *****************************************************************************************/

    public void soqlOnCon()
    {
        //wORKS ONLY FOR QUERY EDITOR NOT ON THE DEBUG LOG
        List<Contact> activeContacts = [
                                        SELECT Name,
            									Contact.AccountId,
		                                        Contact.Account.Name
                                        FROM Contact
                                        WHERE Contact.Account.Industry = 'Consulting'
                                        ];
        /*for(Integer i=0;i<activeContacts.size();i++)
        {
            System.debug(activeContacts[i]);
            System.debug(activeContacts[i]);
            System.debug(activeContacts[i]);
        }*/
        for(Contact objContact : activeContacts){
            system.debug('Contact Details : '+objContact);
            system.debug('Contact Details : '+objContact.Account.Name);
        }
    }

   /*
    Write SOQL query on 'C'(created above) to retrieve all records of 
    'C' with name 'John' along with parent details. 
    */
    public void soqlOnCustomObject()
    {
        List<C__c> CustomCList = new List<C__c>();
        CustomCList =   [
                        SELECT  Name,
                                A__r.Id,
                                B__r.Id
                        FROM C__c
                        WHERE Name LIKE '%John%'
                        ];

            for(C__c cItr : CustomCList)
            {
                System.debug('Contact Details: '+cItr.Name);
                System.debug('A Details: '+ cItr.A__c);
                System.debug('B Details: '+ cItr.B__c);
            }
    }

    /**************************************************************************************************
    Write a SOQL query on Account and find all associated contact records of the Account which contains 
    the word 'John'. 
    Print all Account and Contact records retrieved above.
    *****************************************************************************************************/
    public void queryAcc() {
        List<Account> accountList = [
                                        SELECT 
                                                Id, 
                                                Name, 
                                        (
                                        SELECT 
                                                Id, 
                                                FirstName, 
                                                LastName 
                                        FROM    Contacts 
                                        WHERE   FirstName LIKE '%John%'
                                        OR      LastName LIKE '%John%'
                                        ) 
                                        FROM Account];

        if(accountList == null) 
        {
            return;
        }

        for(Account account : accountList) {
            if(account.Contacts.isEmpty()) 
            {
                continue;
            }
            System.debug('Account : ' + account.Name);
                
                for(Contact contact : account.Contacts) {

                    System.debug('Contact : ' + contact.FirstName + ' ' + contact.LastName);
                }
        }
    }

    /**************************************************************************
    Write a SOQL query to find all Account records, 
    which have at least an opportunity record which is 'Closed Won'.
    ***************************************************************************/

        public void soqlonAcc() 
        {
        List<Account> accountList = [
                                        SELECT 
                                                Id,
                                                Name,
                                                (
                                                   SELECT   Id, 
                                                            AccountId 
                                                    FROM    Opportunity 
                                                    WHERE   Stage ='Closed Won'
                                                )    
                                        FROM    Account
                                        ];

        for(Account accInstance : accountList){

            System.debug('Account Details :' + accInstance) ;
            
            for(Opportunity opIns : accInstance.Opportunity){
            
            System.debug('Opportunity Details :' + opIns.AccountId) ;

            }
        }
    }


 
}