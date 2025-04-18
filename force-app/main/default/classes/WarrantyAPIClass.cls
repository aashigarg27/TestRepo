/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 04-14-2025
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class WarrantyAPIClass {
    public class WarrantyDTO{
        public String externalWarrantyId;
        public String serialNumber;
        public String status;
        public String validTill;
    }
    @future(callout=true)
    public static void fetchWarrantyData() {
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:TestNamedCredentials/v3/f1bbe8a1-9066-4923-9383-23e2e3085eeb');
        req.setMethod('GET');

        Http http = new Http();
        HttpResponse res; // create res
        try {
            
            res = http.send(req);
            if(res.getStatusCode() == 200){
                List<WarrantyDTO> warrantyList = (List<WarrantyDTO>)JSON.deserialize(res.getBody(), List<WarrantyDTO>.class);
                system.debug('warrantyList->' + warrantyList );
                Set<String> serialNumbers = new Set<String>();
                for (WarrantyDTO dto : warrantyList) {
                  serialNumbers.add(dto.serialNumber);
               }
                Map<String, Warranty__c> existingWarranties = new Map<String, Warranty__c>();
                for(Warranty__c war : [SELECT External_Warranty_Id__c, Serial_Number__c, Status__c, Valid_Till__c FROM Warranty__c where Serial_Number__c IN :serialNumbers]){
                    existingWarranties.put(war.Serial_Number__c, war);
                }

                List<Warranty__c> warrantiesToCreate = new List<Warranty__c>();
                List<Warranty__c> warrantiesToUpdate = new List<Warranty__c>();
                // for exisiting update status and valid till
                for(WarrantyDTO dto : warrantyList){
                    if(existingWarranties.containsKey(dto.serialNumber)){
                        Warranty__c warranty = existingWarranties.get(dto.serialNumber);
                        warranty.Status__c = dto.status;
                        warranty.Valid_Till__c = Date.valueOf(dto.validTill);
                        warrantiesToUpdate.add(warranty);
                    }
                
            
                    else{
                        Warranty__c newWarranty = new Warranty__c(
                            External_Warranty_Id__c = dto.externalWarrantyId,
                            Serial_Number__c = dto.serialNumber,
                            Status__c = dto.status,
                            Valid_Till__c = Date.valueOf(dto.validTill)
                             );
                             warrantiesToCreate.add(newWarranty);
                    }
                }
                
                Database.insert(warrantiesToCreate, false);
                Database.update(warrantiesToUpdate, false);
                
                
       
        }
    }
         catch (Exception e) {
            System.debug('Failed to retrieve data. Status: ' + res.getStatusCode());
        }
    
    }
}