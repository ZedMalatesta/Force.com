public class ExchangeRateUpdateUtil {
    @future(callout=true)
    public static void futureRateUpdate() {
        try{
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
                    CurrencyRate__c newCur = new CurrencyRate__c(Id=rates[0].Id, Name=cur, Rate__c=CurRates.get(cur));
                    update newCur;              
                }
            }  
        }
        catch (Exception e){
            String day = string.valueOf(system.now().day());
            String month = string.valueOf(system.now().month());
            String hour = string.valueOf(system.now().hour());
            String minute = string.valueOf(system.now().minute() + 1);
            String second = string.valueOf(system.now().second());
            String year = string.valueOf(system.now().year());
            String strSchedule = '0 ' + minute + ' ' + hour + ' ' + day + ' ' + month + ' ?' + ' ' + year;
            id chronid = System.schedule('RetryExchangeRateUpdate:'+strSchedule, strSchedule, new ExchangeRateUpdate());
            System.abortJob(chronid);
        }
        
    }
}