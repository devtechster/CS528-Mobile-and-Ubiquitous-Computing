public with sharing class EFTHelperHandler 
{
    public static void createCaseMethod(List<EFT_Transaction_Status__c> eftList)
    {
        //EFT_Transaction_Status__c

        String methodString = 'Credit Card Address Verify';
        String eftStatusString = 'Declined';
        String statusString = 'Open';
        List<Case> caseList = new List<Case>();

        List<SalesHeader__c> salesHeaderList = [
                                                SELECT Account__c
                                                    ,  Contact__c
                                                FROM SalesHeader__c
                                                ];
        
        SalesHeader__c salesHeadObj = new SalesHeader__c();
        for(SalesHeader__c salesHeaderInstance : salesHeaderList)
        {
            salesHeadObj.Account__c = salesHeaderInstance.Account__c;
            salesHeadObj.Contact__c = salesHeaderInstance.Contact__c;
        }

            for (EFT_Transaction_Status__c eftIterator : eftList) 
            {
                if( (eftIterator.Method__c == methodString) && (eftIterator.Transaction_Status__c == eftStatusString) && (eftIterator.Status__c == statusString) )
                {
                    Case caseInstance = new Case();

                    caseInstance.AccountId = salesHeadObj.Account__c;
                    caseInstance.ContactId = salesHeadObj.Contact__c;
                    // caseInstance.RecordTypeId = 'Assignment';
                    //caseInstance.OwnerId = 'AVS Queue';
                    caseInstance.Origin = 'Phone';
                    caseInstance.Reason = 'Address Did Not Verify';
                    caseInstance.Priority = 'High';
                    caseInstance.Status = 'New';
                    caseInstance.Type = 'Address Did Not Verify';
                    caseInstance.Subject = Account.Name + '--' + caseInstance.Type;

                    // Open_Sales_Order__c SalesHeader__c.Id
                    // Transaction_Status__c EFT_Transaction_Status__c.Transaction_Status__c
                    // Sales_Order_Number__c SalesHeader__c.Name
                    // Order_Date__c EFT_Transaction_Status__c.Transaction_Date__c
                    // caseList.add(caseInstance);
                }
                insert(caseList);
            }
    }
}
