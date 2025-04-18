import { LightningElement, api, wire} from 'lwc';
import findContactbyAccountId from '@salesforce/apex/ContactController.findContactbyAccountId';

export default class ContactRecordList extends LightningElement {
    columns = [
            {
                label: 'First Name',
                fieldName: 'FirstName'
            },
            {
                label: 'Last Name',
                fieldName: 'LastName'
            },                      
            {
                label: 'Email',
                fieldName: 'Email',
                type : 'Email'
            }

    ];
    @api accountId;
    @wire(findContactbyAccountId , {accountId: '$accountId'}) contacts;
}