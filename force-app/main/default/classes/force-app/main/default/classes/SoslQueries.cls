/**
 * @File Name          : SoslQueries.cls
 * @Description        :
 * @Author             : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Group              :
 * @Last Modified By   : phUser@phDomain.com
 * @Last Modified On   : 8/13/2019, 8:03:27 PM
 * @Modification Log   :
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    8/13/2019, 8:02:56 PM   ChangeMeIn@UserSettingsUnder.SFDoc     Initial Version
**/

public with sharing class SoslQueries
{
    public static void searchWord()
    {
        List<List<SObject>> testWordList = [FIND '*test' IN ALL FIELDS RETURNING Account , Contact, User, Lead];
        System.debug(testWordList);
    }

    public static void dmlMethods()
    {
        String leadLastName = 'LeadRecord ';
        String leadCompany  = 'Company';

        List<Lead> listOfLeads = new List<Lead>();
        Lead leadInstace = new Lead();

        for(Integer i=0;i<100;i++)
        {
            leadInstace.LastName = 'LeadRecord ' + i;
            leadInstace.Company = 'Company ' + i;
            listOfLeads.add(leadInstace);
        }
        System.debug(listOfLeads);
    }
}