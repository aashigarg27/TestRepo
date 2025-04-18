/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 04-14-2025
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
global class WarrantyScheduler implements Schedulable{
    public void execute(SchedulableContext sc)
    {
        WarrantyAPIClass.fetchWarrantyData();
}
}