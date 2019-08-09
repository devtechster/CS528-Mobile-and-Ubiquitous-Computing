trigger EFTTransactionStatusTrigger on EFT_Transaction_Status__c (After insert) 
{
    if(Trigger.isInsert && Trigger.isAfter)
    {
        EFTHelper.eftHelperMethod(Trigger.new);
    }
}