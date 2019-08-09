/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* Day 9 – Programmatic Model 1
* Introduction to the APEX Language and Collections.
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Adhiraj N. B.
* @modifiedBy     Adhiraj N. B.
* @maintainedBy   Adhiraj N. B.
* @version        1.0
* ──────────────────────────────────────────────────────────────────────────────────────────────────*/
public with sharing class ProgramaticModelOneAssignment 
{

    /* 
    Write a method which will accept integer parameter and build and print array of up to that
    integer parameter.
    (For example: If your method accepts (integer) 5 as parameter then build array of any
    datatype but array size should be accepted parameter so in this case your array size should
    be 5 )
    */

    public void acceptIntegreMethod(Integer size)
    {
        // i for iteration in the loop;
        
        Integer[] intList = new List<Integer>();

        for(Integer i =0; i< size; i++)
        {
            intList.add(i);
        }
        System.debug(intList);

    }

    /*
        Method which will accept array of integers as parameters write a code to
        a. Sort the array in ascending order   
        b. Sort the array in descending order
        c. Print the Maximum number in the array
        d. Print the Minimum number in the array
    */
        public void arrayOperations(List<Integer> ascendList)
    {
        List<Integer> decendList = new List<Integer>();
        ascendList.sort();

        System.debug('List in Ascending Order :'+ascendList);

        for(Integer i=ascendList.size()-1; i>=0 ;i--)
        {
            decendList.add(ascendList[i]);
        }
        System.debug('List in Descending Order :'+decendList);

        System.debug('Min Number from List:'+ascendList[0]);
        System.debug('Max Number from List:'+decendList[0]);
        
    }


    /* e. Print duplicates and its occurrences in the array. For ex: if array is [2,2,3,4,4,5] then
        your output will be as follows:
        Number : Appearance
        2 : 2
        3: 1
        4 :2
        5 :1
    */   
        public void countOccurences()
    {
        Map<Integer, Integer> occur = new Map<Integer, Integer>();
        
        List<Integer> givenArray = new List<Integer>{2,2,3,4,4,5};
        
        Integer counter =1;
        
        Integer len = givenArray.size();

        for(Integer a=0;a<len;a++)
        {
                for(Integer b=a; b < (len-1); b++)
            {
                if(givenArray[b] == givenArray[b+1])
                {
                    counter = counter + 1;
                }
                occur.put(givenArray[b],counter);
            }  
            counter = 1; 
        }   
    } 

    /**
    3. Method which will calculate the simple interest (Accept necessary parameters)
    */
        public void calculateSimpleIntrest(Decimal principle, Decimal intrest, Decimal timePeriod)
        {
        //r = intrest / 100 
        // (Accured Amount) = P ( 1 + r t)

        Decimal rateOfIntrest = (intrest/100 );
        Decimal accuredAmount = principle * ( 1 + (rateOfIntrest * timePeriod)) ;
        System.debug('Simple Intrest:' +accuredAmount);

        }
    }



