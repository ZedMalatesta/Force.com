public class NationalBankCallout {   
    public static Decimal currencyBankCallout (String name){
        HttpRequest req = new HttpRequest();
        req.setEndpoint('http://www.nbrb.by/API/ExRates/Rates/'+name+'?ParamMode=2');
        req.setMethod('GET');
        
        Http http = new Http();
        HTTPResponse res = http.send(req);
        
        JSONParser parser = JSON.createParser(res.getBody());
        parser.nextValue();
        parser.nextValue();
        parser.nextValue();
        parser.nextValue();
        parser.nextValue();
        parser.nextValue();
        parser.nextValue();
        Decimal gpa = parser.getDecimalValue();
        return gpa;
   }
}