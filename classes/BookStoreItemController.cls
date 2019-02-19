public class BookStoreItemController {
    
    public final Book_Store__c BookStore {get; set;}

    public BookStoreItemController() {
        BookStore = [SELECT Id, Name, ContactPhone__c FROM Book_Store__c 
                   WHERE Id = :ApexPages.currentPage().getParameters().get('id')];
    }

    public PageReference back(){
        PageReference Page = new PageReference('/BookStoreMap');
        Page.setRedirect(true);
        return Page;
    }
}