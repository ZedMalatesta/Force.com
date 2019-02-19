@isTest
public class TranslationWorkbenchControllerTest {
    public static testMethod void testMyController() {
        TranslationWorkbenchController controller = new TranslationWorkbenchController();
        
        List<selectOption> testlistOfLang = new List<selectOption>();
        testlistOfLang.add(new selectOption('en','English'));
        testlistOfLang.add(new selectOption('ru','Russian'));
        testlistOfLang.add(new selectOption('de','German'));

        system.assertEquals(testlistOfLang, controller.listOfLang);
        system.assertEquals('en', controller.selectedLang);
    }
}