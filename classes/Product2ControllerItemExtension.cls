public class Product2ControllerItemExtension {
    private final Product2 prod;
    
    public string selectedCurrency{get; set;}
    
    private decimal previousCurrMult{get; set;} 
    
    public List<SelectOption> ListOfCurr{get;set;}
    
    public PriceBookEntry ProductWithPrice{get;set;}
    
    public Product2ControllerItemExtension(ApexPages.StandardController stdController) {
        Id prodID = ApexPages.currentPage().getParameters().get('Id');
        ProductWithPrice = [SELECT Product2.Id, Product2.Name, Product2.Author__c, Product2.Publisher__c, Product2.PageNumber__c, Product2.ImageName__C, Product2.Quantity__c, UnitPrice FROM PriceBookEntry where Product2Id = :prodID and Pricebook2.IsStandard = true]; //WHERE Pricebook2Id IN (SELECT Id FROM PriceBook2 WHERE Name = '')];
        this.prod = (Product2)stdController.getRecord();
        
        selectedCurrency=ApexPages.currentPage().getParameters().get('curr');
        previousCurrMult=NationalBankCallout.currencyBankCallout('USD').setScale(2);
        System.debug(selectedCurrency);
        product2CurrencyState();
        ListOfCurr = new List<selectOption>();
        ListOfCurr.add(new selectOption('USD','USD'));
        ListOfCurr.add(new selectOption('BYN','BYN'));
        ListOfCurr.add(new selectOption('EUR','EUR'));
    }
    
    public void product2CurrencyState(){         
        if (selectedCurrency!='BYN'){
            decimal multiplier = NationalBankCallout.currencyBankCallout(selectedCurrency).setScale(2);
            ProductWithPrice.UnitPrice = (ProductWithPrice.UnitPrice*previousCurrMult/multiplier).setScale(2);
            previousCurrMult=multiplier;
        }
        else{
            ProductWithPrice.UnitPrice = (ProductWithPrice.UnitPrice*previousCurrMult).setScale(2);
            previousCurrMult=1;
        }
    }
}