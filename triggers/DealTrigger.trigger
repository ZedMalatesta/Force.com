trigger DealTrigger on ProductRequest__c (after update){
    for(Id prodReqId : Trigger.newMap.keySet())
    {
        if(Trigger.oldMap.get(prodReqId).State__c != Trigger.newMap.get(prodReqId).State__c && Trigger.newMap.get(prodReqId).State__c == false)
        {
            Database.LeadConvert lc = new Database.LeadConvert();
            lc.setLeadId(Trigger.newMap.get(prodReqId).Lead__c);
            
            LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
            lc.setConvertedStatus(convertStatus.MasterLabel);
            
            Database.convertLead(lc);
        }
    }
}