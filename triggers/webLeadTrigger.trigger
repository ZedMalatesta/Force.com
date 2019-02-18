trigger webLeadTrigger on Lead (before delete, before insert, before update, after delete, after insert, after update) {
    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
        }  
    }
}