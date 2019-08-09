public with sharing class TrigAccHandler {

      public static void isAfterInsertMethod(List<Account> listNewAccount)
    {
        TriggerHelperHandler.duplicateAccountMethod(listNewAccount);
    }
}
