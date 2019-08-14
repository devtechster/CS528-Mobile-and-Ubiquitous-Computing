public class ExtClass {
    public String accountId{get; set;}
    public List<Contact> contactList{get; set;}
    public void execQuery(){
         contactList = [
                     SELECT  FirstName
                         ,LastName
                         ,Name
                     From  Contact
                     Where  AccountId = :accountId
                 ];
    }
    public List<Contact> getContacts(){
        return contactList;
    }
    public String getMessage(){
        return 'Hello';
    }
    @RemoteAction
    public static Contact getPhoneNumber(String Id){
        return [SELECT  Name
                    ,Phone
                    ,Email
               FROM    Contact
               WHERE  ID = :Id
               LIMIT  1];
  }
}