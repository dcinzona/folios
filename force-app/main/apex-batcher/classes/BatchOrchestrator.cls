public with sharing class BatchOrchestrator {
  public static List<AsyncApexJob> getRunningBatchJobs() {
    List<AsyncApexJob> runningJobs = [
      SELECT
        Id,
        ApexClass.Name,
        Status,
        JobItemsProcessed,
        TotalJobItems,
        CreatedDate
      FROM AsyncApexJob
      WHERE
        Status IN ('Processing', 'Queued')
        AND ApexClass.Name IN ('BatchByUsers', 'FolioBatch')
    ];
    return runningJobs;
  }
  public static void runBatchJob() {
    List<AsyncApexJob> runningJobs = getRunningBatchJobs();
    if (!runningJobs.isEmpty()) {
      System.debug('A batch job is already running. Exiting.');
      return;
    }
    // query users count and folios count
    Integer userCount = [SELECT COUNT() FROM User WHERE IsActive = TRUE];
    Integer folioCount = [SELECT COUNT() FROM Folio__c];
    if (userCount > folioCount) {
      Database.executeBatch(new BatchByUsers(), 100);
    } else {
      Database.executeBatch(new BatchByUsers(), 1);
    }
  }
}
