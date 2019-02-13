public class ProductController {
    
    private String sortOrder = 'Name';
     
    public List<Product2> getProducts() {  
    List<Product2> results = Database.query(
        'SELECT Id, Name, Author__c, Publisher__c ' +
        'FROM Product2 ' +
        'ORDER BY ' + sortOrder + ' ASC ' +
        'LIMIT 10'
    );
    return results;
    }
    
}