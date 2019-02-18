@istest(SeeAllData=true)
public class ExchangeRateUpdateTest {
    static testmethod void test() {
        Test.startTest();
        String CRON_EXP = '0 0 0 10 JAN 1 2019';
        String jobId = System.schedule('Sample_Heading', CRON_EXP, new ExchangeRateUpdate());   
        Test.stopTest();
    }
}