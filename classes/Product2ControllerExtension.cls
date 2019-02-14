public class Product2ControllerExtension {
    
    private final Product2 prod;
    
    public string selectedCurrency{get; set;}
    private decimal previousCurrMult{get; set;}
    
    public List<SelectOption> ListOfCurr{get;set;}
    
    public List<PriceBookEntry> ProductsWithPrices{get;set;}
    
    public Product2ControllerExtension(ApexPages.StandardController stdController) {
        ProductsWithPrices = [SELECT Product2.Id, Product2.Name, Product2.Author__c, Product2.ImageName__C, UnitPrice FROM PriceBookEntry where Pricebook2.IsStandard = true]; //WHERE Pricebook2Id IN (SELECT Id FROM PriceBook2 WHERE Name = '')];
        this.prod = (Product2)stdController.getRecord();
        
        selectedCurrency='USD';
        previousCurrMult=NationalBankCallout.currencyBankCallout(selectedCurrency).setScale(2);
        ListOfCurr = new List<selectOption>();
        ListOfCurr.add(new selectOption('USD','USD'));
        ListOfCurr.add(new selectOption('BYN','BYN'));
        ListOfCurr.add(new selectOption('EUR','EUR'));
    }
    
    public Product2ControllerExtension(ApexPages.StandardSetController stdController) {
        ProductsWithPrices = [SELECT Product2.Id, Product2.Name, Product2.Author__c, Product2.ImageName__C, UnitPrice FROM PriceBookEntry where Pricebook2.IsStandard = true]; //WHERE Pricebook2Id IN (SELECT Id FROM PriceBook2 WHERE Name = '')];
        this.prod = (Product2)stdController.getRecord();
        
        selectedCurrency='USD';
        previousCurrMult=NationalBankCallout.currencyBankCallout(selectedCurrency).setScale(2);
        ListOfCurr = new List<selectOption>();
        ListOfCurr.add(new selectOption('USD','USD'));
        ListOfCurr.add(new selectOption('BYN','BYN'));
        ListOfCurr.add(new selectOption('EUR','EUR'));
    }
    
    public void product2CurrencyState(){         
        if (selectedCurrency!='BYN'){
            decimal multiplier = NationalBankCallout.currencyBankCallout(selectedCurrency).setScale(2);
            for (PriceBookEntry pbe : ProductsWithPrices){
                System.debug(pbe.UnitPrice);
                pbe.UnitPrice = (pbe.UnitPrice*previousCurrMult/multiplier).setScale(2);
            }     
            previousCurrMult=multiplier;
        }
        else{
            for (PriceBookEntry pbe : ProductsWithPrices){
                System.debug(pbe.UnitPrice);
                pbe.UnitPrice = (pbe.UnitPrice*previousCurrMult).setScale(2);    
            }    
            previousCurrMult=1;
        }
    }
}