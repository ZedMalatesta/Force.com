public class Product2ControllerExtension implements Product2ControllerInterface {
    
    private final Product2 prod;
    
    public string selectedCurrency{get; set;}
    public string selectedCurrencyView{get; set;}
    
    public string searchString {get; set;}
    private decimal previousCurrMult{get; set;}
    
    public List<SelectOption> ListOfCurr{get;set;}
    
    public List<PriceBookEntry> ProductsWithPrices{get;set;}
    
    public Product2ControllerExtension(ApexPages.StandardController stdController) {
        ProductsWithPrices = [SELECT Product2.Id, Product2.Name, Product2.Author__c, Product2.ImageName__C, UnitPrice FROM PriceBookEntry where Pricebook2.IsStandard = true]; //WHERE Pricebook2Id IN (SELECT Id FROM PriceBook2 WHERE Name = '')];
        this.prod = (Product2)stdController.getRecord();
        
        selectedCurrency='USD';
        List<CurrencyRate__c> curRate = [SELECT Rate__c, Symbol__c FROM CurrencyRate__c where Name=:selectedCurrency];
        if (!String.isBlank(curRate[0].Symbol__c)){
            selectedCurrencyView=curRate[0].Symbol__c;
        }
        else{
            selectedCurrencyView=selectedCurrency;
        }
        previousCurrMult=curRate[0].Rate__c.setScale(2);
        ListOfCurr = new List<selectOption>();
        ListOfCurr.add(new selectOption('BYN','BYN'));
        for (CurrencyRate__c cur : [SELECT Name FROM CurrencyRate__c]){
            ListOfCurr.add(new selectOption(cur.Name,cur.Name));
        }      
    }
    
    public Product2ControllerExtension(ApexPages.StandardSetController stdController) {
        ProductsWithPrices = [SELECT Product2.Id, Product2.Name, Product2.Author__c, Product2.ImageName__C, UnitPrice FROM PriceBookEntry where Pricebook2.IsStandard = true]; //WHERE Pricebook2Id IN (SELECT Id FROM PriceBook2 WHERE Name = '')];
        this.prod = (Product2)stdController.getRecord();
        
        selectedCurrency='USD';
        
        List<CurrencyRate__c> curRate = [SELECT Rate__c, Symbol__c FROM CurrencyRate__c where Name=:selectedCurrency];
        if (!String.isBlank(curRate[0].Symbol__c)){
            selectedCurrencyView=curRate[0].Symbol__c;
        }
        else{
            selectedCurrencyView=selectedCurrency;
        }
        previousCurrMult=curRate[0].Rate__c.setScale(2);
        ListOfCurr = new List<selectOption>();
        ListOfCurr.add(new selectOption('BYN','BYN'));
        for (CurrencyRate__c cur : [SELECT Name FROM CurrencyRate__c]){
            ListOfCurr.add(new selectOption(cur.Name,cur.Name));
        }        
    }
    
    public void product2CurrencyState(){         
        if (selectedCurrency!='BYN'){
            List<CurrencyRate__c> curRate = [SELECT Rate__c, Symbol__c FROM CurrencyRate__c where Name=:selectedCurrency]; 
            decimal multiplier = curRate[0].Rate__c.setScale(2);  
            for (PriceBookEntry pbe : ProductsWithPrices){
                System.debug(pbe.UnitPrice);
                pbe.UnitPrice = (pbe.UnitPrice*previousCurrMult/multiplier).setScale(2);
            }     
            if (!String.isBlank(curRate[0].Symbol__c)){
                selectedCurrencyView=curRate[0].Symbol__c;
            }
            else{
                selectedCurrencyView=selectedCurrency;
            }
            previousCurrMult=multiplier;
        }
        else{
            for (PriceBookEntry pbe : ProductsWithPrices){
                System.debug(pbe.UnitPrice);
                pbe.UnitPrice = (pbe.UnitPrice*previousCurrMult).setScale(2);    
            }    
            previousCurrMult=1;
            selectedCurrencyView=selectedCurrency;
        }
    }   
    
    public void doSearch() {
        ProductsWithPrices = [SELECT Product2.Id, Product2.Name, Product2.Author__c, Product2.ImageName__C, UnitPrice 
                              FROM PriceBookEntry 
                              WHERE Pricebook2.IsStandard = true 
                              AND (Product2.Name 
                                   LIKE :('%' + searchString + '%') 
                                   OR Product2.Author__c LIKE :('%' + searchString + '%'))]; 
    }
}