/**
Contact Duplicate Check Trigger Create a new Trigger on Contact that will check for 
duplicates before allowing a new record into the database. 

Validate against the email address and phone number fields.
An error be thrown with the error message – “A Contact with the same email address or 
phone number already exists in system.” 
Should be bulk safe in nature and must be capable of handling at least 200 records at a time.
*/
public with sharing class TrigContactHelperHandler
{
    public static void checkDuplicateContact(List<Contact> listOfContacts)
    {
        List<String> lastNameList = new List<String>();
        List<String> emailList = new List<String>();
        List<String> phoneList = new List<String>();
        
        String errorMessage = 'A Contact with the same email address or phone number already exists in system.';
        
        //Retriving over Trigger.new list
        for(Contact contactIterator : listOfContacts)
        {
            // Contact contactInstance = new Contact();
            // contactInstance.LastName = contactIterator.LastName;
            lastNameList.add(contactIterator.LastName);
            emailList.add(contactIterator.Email);
            phoneList.add(contactIterator.Phone);
        }

        //Validating/Checking trigger condition 
        List<Contact> newContactList = [    
                                            SELECT id
                                                ,  Email
                                                ,  Phone
                                                ,  LastName
                                            FROM   Contact
                                            WHERE LastName IN :lastNameList
                                            AND (
                                                Email IN :emailList 
                                            OR  Phone IN :phoneList
                                                )
                                        ];
        //Error message display.
        if( newContactList.size() > 0 )
        {
            for(Contact contactIterator : listOfContacts)
            {
                contactIterator.LastName.addError(errorMessage);
            }
        }
    }

/** ABC Containers require the ability to automatically associate a Contact created in their 
    Salesforce Instance with the respective Account based on the email domain specified in the 
    primary email address of the Contact. 
    The association should happen real time as soon as a Contact record is created within the system. */
    
    public static void populateAssociatedAccount(List<Contact> listOfContacts)
    {

        String emailOfContact = '@abc.com';

        Set<String> emailContactSet = new Set<String>();

        List<Contact> popContactList = new List<Contact>();
        
        Map<String, Id> collectedDataMap = new Map<String, Id>();

            for(Contact contactObject : listOfContacts)
        {
            if(contactObject.Email != null && contactObject.AccountId !=null)
            {
                popContactList.add(contactObject);
                emailContactSet.add(contactObject.Email);
            }
        }

        List<Contact> newContactList = [
                                            SELECT 
                                                    Email,
                                                    AccountId 
                                            FROM    Contact 
                                            WHERE   Email 
                                            IN      :emailContactSet AND AccountId != NULL
                                        ];

        for(Contact contactIterator : newContactList)
        {
            collectedDataMap.put(contactIterator.Email,contactIterator.AccountId);
        }

        List<Contact> putConList = new List<Contact>();

            for(Contact contactIterator2 : popContactList)
            {
                if(collectedDataMap.get(contactIterator2.Email) != NULL) 
                {
                    Contact contactObj = new Contact(Id = contactIterator2.Id);
                    contactObj.AccountId= collectedDataMap.get(contactIterator2.Email);
                    putConList.add(contactObj);
                }
            }                   
            update putConList;
    }
}


