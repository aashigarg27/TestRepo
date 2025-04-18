/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 04-12-2025
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public class OpportunityHandlerClass {
    public static void HandleAfterInsert(List<Opportunity>newOpp){
        Set<Id>accountIds = new Set<Id>();
        for(Opportunity opp : newOpp){
            if(opp.AccountId != null){
                accountIds.add(opp.AccountId);
            }
        }
         Map<Id, Account> existingAccounts = new Map<Id, Account>(
            [SELECT Id, AnnualRevenue FROM Account WHERE Id IN :accountIds]
        );
         Map<Id,Decimal> map1 = new  Map<Id,Decimal>();
            for(Opportunity opp : newOpp){
            if(!map1.ContainsKey(opp.AccountId)){
                map1.put(opp.AccountId,opp.Amount);
            }           
            else{
                map1.put(opp.AccountId, map1.get(opp.AccountId)+opp.Amount);
            }
        }
        List<Account>accountsToUpdate = new List<Account>();
        for(Id accIds : accountIds){
            Account acc = existingAccounts.get(accIds);
            Decimal currentRevenue = acc.AnnualRevenue != null ? acc.AnnualRevenue : 0;
            Decimal newRevenue = currentRevenue + map1.get(accIds);
            accountsToUpdate.add(new Account(Id = accIds, AnnualRevenue = newRevenue));
        }
         update accountsToUpdate;
    }
    public static void HandleAfterUpdate(Map<Id,Opportunity>newOpp,Map<Id,Opportunity>oldOpp){
        Set<Id>accountIds = new Set<Id>();
        for(Opportunity opp : newOpp.values()){
            if(opp.AccountId != null && opp.Amount != oldOpp.get(opp.Id).Amount){
                accountIds.add(opp.AccountId);
            }
        }
        Map<Id,Decimal> map1 = new  Map<Id,Decimal>();
        List<Opportunity>oppList = new Map<Id,Opportunity>(newOpp).values();
            for(Opportunity opp : oppList){
            if(!map1.ContainsKey(opp.AccountId)){
                map1.put(opp.AccountId,opp.Amount);
            }           
            else{
                map1.put(opp.AccountId, map1.get(opp.AccountId)+opp.Amount);
            }
        }
        List<Opportunity>oppListOld = new Map<Id,Opportunity>(OldOpp).values();
          for(Opportunity opp : oppListOld){
            if(!map1.ContainsKey(opp.AccountId)){
                map1.put(opp.AccountId,opp.Amount);
            }           
            else{
                map1.put(opp.AccountId, map1.get(opp.AccountId)-opp.Amount);
            }
        }
        
        
         Map<Id, Account> existingAccounts = new Map<Id, Account>(
            [SELECT Id, AnnualRevenue FROM Account WHERE Id IN :accountIds]
        );
           List<Account> accountsToUpdate = new List<Account>();
        
 
        for(Id accIds : accountIds){
            Account acc = existingAccounts.get(accIds);
            Decimal currentRevenue = acc.AnnualRevenue != null ? acc.AnnualRevenue : 0;
            Decimal newRevenue = currentRevenue + map1.get(accIds);
            accountsToUpdate.add(new Account(Id = accIds, AnnualRevenue = newRevenue));
        }
         update accountsToUpdate;
    }     
    public static void HandleAfterDelete(List<Opportunity>oldOpp){
       Set<Id>accountIds = new Set<Id>();
        for(Opportunity opp : OldOpp){
            if(opp.AccountId != null){
                accountIds.add(opp.AccountId);
            }
        }
        Map<Id,Decimal> map1 = new  Map<Id,Decimal>();
            for(Opportunity opp : OldOpp){
            if(!map1.ContainsKey(opp.AccountId)){
                map1.put(opp.AccountId,opp.Amount);
            }           
            else{
                map1.put(opp.AccountId, map1.get(opp.AccountId)+opp.Amount);
            }
        }
        Map<Id, Account> existingAccounts = new Map<Id, Account>(
            [SELECT Id, AnnualRevenue FROM Account WHERE Id IN :accountIds]
        );
        List<Account>accountsToUpdate = new List<Account>();
        for(Id accIds : accountIds){
            Account acc = existingAccounts.get(accIds);
            Decimal currentRevenue = acc.AnnualRevenue != null ? acc.AnnualRevenue : 0;
            Decimal newRevenue = currentRevenue - map1.get(accIds);
            accountsToUpdate.add(new Account(Id = accIds, AnnualRevenue = newRevenue));
        }
         update accountsToUpdate;
    }
    
    public static void handleOppTypeAfterUpdate(Map<Id,Opportunity>newOpp,Map<Id,Opportunity>oldOpp){
        Set<Id>accountIds = new Set<Id>();
        for(Opportunity opp : newOpp.values()){
            if(opp.AccountId != null && opp.Account_Type__c != 'Client' && opp.StageName != OldOpp.get(opp.Id).StageName && opp.StageName == 'Closed Won'){
                accountIds.add(opp.AccountId);
            }
        }
        if(accountIds.isempty()){
            return;
        }
        
        List<Account>accList = [SELECT Id, Type__c FROM Account WHERE Id IN :accountIds];
        List<Account>accountsToUpdate = new List<Account>();
        for(Account acc : accList){
            if(acc.Type__c != 'Client'){
            accountsToUpdate.add(new Account(Id = acc.Id, Type__c = 'Client'));
            }
        }
    List<Opportunity>oppList = [Select Id, Account_Type__c,AccountId from Opportunity where AccountId In :accountIds];
    List<Opportunity>oppToUpdate = new List<Opportunity>();
    for(Opportunity opp : oppList){
        oppToUpdate.add(new Opportunity(Id = opp.Id, Account_Type__c = 'Client'));
    }
    update accountsToUpdate;
    update oppToUpdate;
    }    
}