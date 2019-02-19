public class Product2ControllerItemExtension implements Product2ControllerInterface  {
    
    private final Product2 prod;

    public string leadFisrtName {get; set;} 
    public string leadLastName {get; set;} 
    public string leadPhone {get; set;}  
    public string leadEmail {get; set;}
    
    public string errorMess {get; set;}
    
    public string selectedCurrency{get; set;}
    public string selectedCurrencyView{get; set;}
    
    private decimal previousCurrMult{get; set;} 
    
    public List<SelectOption> ListOfCurr{get;set;}
    
    public PriceBookEntry ProductWithPrice{get;set;}
    
    public Product2ControllerItemExtension(ApexPages.StandardController stdController) {
        Id prodID = ApexPages.currentPage().getParameters().get('Id');
        ProductWithPrice = [SELECT Product2.Id, Product2.Name, Product2.Author__c, Product2.Publisher__c, Product2.PageNumber__c, Product2.Description, Product2.ImageName__C, Product2.Quantity__c, UnitPrice FROM PriceBookEntry where Product2Id = :prodID and Pricebook2.IsStandard = true]; //WHERE Pricebook2Id IN (SELECT Id FROM PriceBook2 WHERE Name = '')];
        this.prod = (Product2)stdController.getRecord();
        
        errorMess = '';   
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
    
    public PageReference back(){
        PageReference Page = new PageReference('/BookListAura');
        Page.setRedirect(true);
        return Page;
    }
        
    public void product2RequestCreate(){
        try{
            Lead newLead = new Lead(FirstName = leadFisrtName, LastName = leadLastName, Phone = leadPhone, Email=leadEmail, Company='Independ');
            String LeadID=null;
            List<Lead> lds = [SELECT Id, Email, Phone FROM Lead where Email = :newLead.Email or Phone = :newLead.Phone];    
            if (!lds.isEmpty()){
                Lead leadToUpdate = lds[0];
                leadToUpdate.Email=newLead.Email;
                leadToUpdate.Phone=newLead.Phone;
                LeadID=leadToUpdate.ID;
                update leadToUpdate;
            }
            else{
               insert newLead;
               List<Lead> lds2 = [SELECT Id FROM Lead where Email = :newLead.Email or Phone = :newLead.Phone];
               LeadID=lds2[0].Id;
            }
            ProductRequest__c pr = new ProductRequest__c(Lead__c=LeadID, Product__c=ApexPages.currentPage().getParameters().get('Id'), State__c=true);
            insert pr;
            errorMess = '';        
        }
        catch(Exception e){
            System.debug(e.getCause());
            errorMess = e.getMessage();
        }
    }
}