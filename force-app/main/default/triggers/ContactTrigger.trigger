trigger ContactTrigger on Contact (before insert,after insert) 
{

    if(Trigger.isBefore && Trigger.isInsert)
    {
        TrigContactHandler.contactHandlerMethod(Trigger.new);
    }

    if(Trigger.isAfter && Trigger.isInsert)
    {
        TrigContactHandler.populateCaller(Trigger.new);
    }
}
