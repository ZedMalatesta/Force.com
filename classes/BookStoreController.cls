global without sharing class BookStoreController {
 
    @RemoteAction
    global static List<Book_Store__c> findAll() {
        return [SELECT Id, Name, Location__Latitude__s, Location__Longitude__s
                    FROM Book_Store__c];
    }
    
}