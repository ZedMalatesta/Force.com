global class ExchangeRateUpdate implements Schedulable {
    global void execute(SchedulableContext ctx) {
        List<String> currencies = new List<String>{'USD','EUR'};
            Map<String,Decimal> CurRates = new Map<String,Decimal>();
            for (String cur : currencies) { 
                CurRates.put(cur, NationalBankCallout.currencyBankCallout(cur));
            } 
            for (String cur : currencies) {        
                List<CurrencyRate__c> rates = [SELECT Id, Name FROM CurrencyRate__c where Name=:cur];
                if (rates.isEmpty()){
                    CurrencyRate__c newCur = new CurrencyRate__c(Name=cur, Rate__c=CurRates.get(cur));
                    insert newCur;
                }
                else{
                    CurrencyRate__c newCur = new CurrencyRate__c(Id=rates[0].Id, Name=cur, Rate__c=NationalBankCallout.currencyBankCallout(cur));
                    update newCur;              
                }
            }  
    }
}