global class ExchangeRateUpdate implements Schedulable, Database.AllowsCallouts {
    global void execute(SchedulableContext ctx) {
        ExchangeRateUpdateUtil.futureRateUpdate();       
    }
}