//Trigger for Clonig the Account Record after insertion.
trigger AccountTrigger on Account (after insert) 
{

  if(Trigger.isAfter && Trigger.isInsert)
  {
  TrigAccHandler.isAfterInsertMethod(trigger.new);
  }

}