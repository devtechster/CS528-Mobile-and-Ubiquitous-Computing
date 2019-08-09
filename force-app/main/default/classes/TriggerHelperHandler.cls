public with sharing class TriggerHelperHandler 
{
    public static Boolean boolRun2 = false;

    public static void duplicateAccountMethod(List<Account> listNewAccount) 
    {
        System.debug('Trigger New List : ' + listNewAccount);
        
        List<Account> iterativeAccountList = listNewAccount;
        
        List<Account> clonedList= new List<Account> ();

        
        if(!boolRun2)
        {
//            System.debug('Boolean inside If before forloop:'+boolRun2);
            for (Account accountIterator : iterativeAccountList) 
            {
                Account accountInstance = new Account();
                accountInstance.Name = accountIterator.Name;
                clonedList.add(accountInstance);
            }
            boolRun2 = true;
            
            // System.debug('Clone List : '+clonedList);
            // System.debug('Boolean inside If after forloop:'+boolRun2);
            
            Database.insert (clonedList);
            
        }
    }
}