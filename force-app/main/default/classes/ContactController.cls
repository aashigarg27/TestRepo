/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 04-17-2025
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class ContactController {
   
 @AuraEnabled(cacheable=true)
    public static List<Contact> findContactbyAccountId(String accountId) {
        return
        [Select Id, FirstName, LastName, Email FROM Contact where AccountId =:accountId 
        Limit 10];
            }
}