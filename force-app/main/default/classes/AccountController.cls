/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 04-20-2025
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class AccountController {
    public string accountId{get;set;}
    public Account actObj {get; set;}
    public AccountController(){
    actObj = new Account();
    }
@AuraEnabled(cacheable = true)
public static List<Account> getAccounts(){
return [select id, name, phone, industry, AccountNumber from Account Limit 10];
}
}
// @AuraEnabled
// public static List<Account> getAccountRecordsList(){
//     return [select id, name, phone, industry from Account Limit 10];
// }
// public pageReference retrieveAccountDetail(){
//     if(accountId != null){
//         actObj = [select id, name, phone, industry from Account where id = :accountId];
//     }
//     return null;
//     }
// }