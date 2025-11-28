trigger FolioProcessRequestTrigger on Folio_Process_Request__e(after insert) {
  try {
    for (Folio_Process_Request__e event : Trigger.New) {
      List<Id> userIds = String.isBlank(event.UserIds__c)
        ? new List<Id>()
        : event.UserIds__c.split(',');
      if (!userIds.isEmpty() && userIds.size() < 100) {
        Integer batchSize = userIds.size() > 1 ? 1 : 100; // user id size will either be 1 or 100
        Database.executeBatch(new FolioBatch(new List<Id>(userIds)), batchSize);
      } else {
        if (userIds.size() > 100) {
          System.debug(
            'FolioProcessRequestTrigger: Too many User Ids provided: ' +
            userIds.size()
          );
        } else {
          System.debug('FolioProcessRequestTrigger: No User Ids provided.');
        }
      }
    }
  } catch (Exception e) {
    System.debug(
      'FolioProcessRequestTrigger: Error processing Folio Process Request events: ' +
      e.getMessage()
    );
  }

}
