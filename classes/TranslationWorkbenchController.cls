public without sharing class TranslationWorkbenchController {
   
    public string selectedLang{get;set;}
    
    public List<selectoption> listOfLang {get;set;}
    
    public ApexPages.StandardController stdCntrlr {get; set;}
    
    public ApexPages.StandardSetController stdSetCntrlr {get; set;}
    
    public TranslationWorkbenchController() {  
        selectedLang='en';
        listOfLang = new List<selectOption>();
        listOfLang.add(new selectOption('en','English'));
        listOfLang.add(new selectOption('ru','Russian'));
        listOfLang.add(new selectOption('de','German'));
    }
    
    public TranslationWorkbenchController(ApexPages.StandardController controller) {
        stdCntrlr = controller;
        
        selectedLang='en';
        listOfLang = new List<selectOption>();
        listOfLang.add(new selectOption('en','English'));
        listOfLang.add(new selectOption('ru','Russian'));
        listOfLang.add(new selectOption('de','German'));
    }
    
    public TranslationWorkbenchController(ApexPages.StandardSetController controller) {
        stdSetCntrlr = controller;
        
        selectedLang='en';
        listOfLang = new List<selectOption>();
        listOfLang.add(new selectOption('en','English'));
        listOfLang.add(new selectOption('ru','Russian'));
        listOfLang.add(new selectOption('de','German'));
    } 
}