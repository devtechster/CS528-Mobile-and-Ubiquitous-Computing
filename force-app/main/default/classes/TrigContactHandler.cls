public with sharing class TrigContactHandler {
    
    public static void contactHandlerMethod(List<Contact> listOfContacts)
    {
        TrigContactHelperHandler.checkDuplicateContact(listOfContacts);
    }

    public static void populateCaller(List<Contact> listOfContacts)
    {
        TrigContactHelperHandler.populateAssociatedAccount(listOfContacts);
    }
}
