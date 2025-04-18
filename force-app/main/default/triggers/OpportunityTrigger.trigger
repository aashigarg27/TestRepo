/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 04-09-2025
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
trigger OpportunityTrigger on Opportunity (after insert, after update, after delete){
    if(Trigger.isAfter){
        if(Trigger.isInsert){
            OpportunityHandlerClass.HandleAfterInsert(Trigger.new);
        }
        if(Trigger.isUpdate){
            OpportunityHandlerClass.HandleAfterUpdate(Trigger.newMap, Trigger.oldMap);
            OpportunityHandlerClass.handleOppTypeAfterUpdate(Trigger.newMap, Trigger.oldMap);
            
        }
        if(Trigger.isDelete){
            OpportunityHandlerClass.HandleAfterDelete(Trigger.old);
        }
    }
	
}