public with sharing class EFTHelper 
{
    public static void eftHelperMethod(List<EFT_Transaction_Status__c> eftList)
    {
        EFTHelperHandler.createCaseMethod(eftList);
    }

}
