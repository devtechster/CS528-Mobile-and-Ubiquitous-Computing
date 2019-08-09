    /**
    * ─────────────────────────────────────────────────────────────────────────────────────────────────┐
    * Day 9 – Programmatic Model 1
    * Advanced concepts / Collections/SOQL Queries/DML Operations
    * ──────────────────────────────────────────────────────────────────────────────────────────────────
    * @author         Adhiraj N. B.
    * @modifiedBy     Adhiraj N. B.
    * @maintainedBy   Adhiraj N. B.
    * @version        1.0
    * ──────────────────────────────────────────────────────────────────────────────────────────────────*/

    public with sharing class Searches 
{
    /**
    2. Implement following Searching algorithm using Apex & Collections - Day 1
    a. Binary Search
    b. Linear Search
    */

    public Integer binarySearch(List<Integer> arr, Integer left, Integer right, Integer key) 
            { 
                if (right >= left)
            { 
                    Integer mid = left + (right - left) / 2; 
                    // If the element is present at the middle itself 
                    if (arr[mid] == key) 
                    {
                        return mid; 
                    }  
                    // If element is smaller than mid, then it can only be present in left subarray.
                    if (arr[mid] > key) 
                    {
                        return binarySearch(arr, left, mid - 1, key);
                    }  
                    // Else the element can only be present in right subarray.
                return binarySearch(arr, mid + 1, right, key); 
            } 
                else
            {
                return -1;
            }
            } 


    public void linearSearch(List<Integer> linear,Integer x)
    {
            Integer length = linear.size();

            for(Integer searchNum = 0; searchNum < length ; searchNum++)
            {
                if(linear[searchNum] == x) 
                {
                    System.debug('Number Present at index :'+linear[searchNum]);
                }
                else
                {
                    System.debug('Not Found');
                }
            } 
    }
}
