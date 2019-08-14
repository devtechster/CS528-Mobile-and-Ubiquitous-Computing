/**
 * @File Name          : SoqlAggregate.cls
 * @Description        :
 * @Author             : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Group              :
 * @Last Modified By   : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Last Modified On   : 8/13/2019, 7:00:39 PM
 * @Modification Log   :
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    8/13/2019, 6:51:24 PM   ChangeMeIn@UserSettingsUnder.SFDoc     Initial Version
**/
public with sharing class SoqlAggregate
{
    /**************************************************************************************************
    Write a SOQL query to retrieve sum of all closed Opportunity amount for current fiscal year.
    Store this information in a map with key as year and value as sum of amount.
    Iterate this map to display statistics.
    ****************************************************************************************************/
    public void closeOpportunityData()
    {
        Integer currentYear = datetime.now().year();

        // Integer currentYear = [SELECT FISCAL_YEAR FROM Organization];

        List<AggregateResult> agg = [
                                        SELECT  SUM(Amount) amtAlias ,Closedate
                                        FROM    Opportunity
                                        WHERE   StageName = 'Closed Won' AND closeDate = THIS_FISCAL_YEAR
                                        Group BY CloseDate
                                    ] ;

        Map<Integer , Decimal> sumOfYear = new Map<Integer,Decimal>();

        for(AggregateResult argRes : agg)
        {
           // System.debug(argRes);
            sumOfYear.put(currentYear,(Decimal) argRes.get('amtAlias'))  ;
        }

        System.debug('Sum Of Year' + sumOfYear);

    }

    /****************************************************************************************************
    Find total number of distinct Lead records on basis of 'Lead Source' having greater than 10 leads.
    Print this information.
    *******************************************************************************************************/
    public void leadSourceCount()
    {
        //Use of Alias because we cannot access fields directly.
        List<AggregateResult> leadList =[
                                            SELECT   LeadSource leadAlias
                                                ,    count_distinct(id) countAlias
                                            FROM     Lead
                                            GROUP BY LeadSource
                                            HAVING   count_distinct(id) > 10
                                        ];
        for(AggregateResult leadRecord : leadList)
        {
            System.debug(leadRecord.get('leadAlias') + ' : ' + leadRecord.get('countAlias'));
            //return leadRecord;
        }
    }

    /*****************************************************************************************
    Write a SOQL query to find total number of Lead records by status by Lead Source.
    Store this information in map and display the same.
    *******************************************************************************************/

    public void totalLeads()
    {
        List<Lead> leadObject =[Select Id , LeadSource,Name from Lead] ;

        Map< String,Map<String,Integer> > mapOf = new Map< String,Map<String,Integer> >();

            for(Lead  leadInstance :leadObject)
            {
                if(mapOf.containsKey(leadInstance.LeadSource))
                {
                    map<String,Integer> mapLsi = mapOf.get(leadInstance.LeadSource);
                    Integer val = mapLsi.get(leadInstance.LeadSource) ;
                    val++ ;
                    mapLsi.put(leadInstance.LeadSource ,val) ;
                    mapOf.put(leadInstance.LeadSource , mapLsi);
                }
                else
                {
                    Map<String,Integer> leadMapStore=  new Map<String,Integer>();
                    leadMapStore.put(leadInstance.LeadSource,1);
                    mapOf.put(leadInstance.LeadSource,leadMapStore);
                }
            }
    }
}