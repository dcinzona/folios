// If there are more users than folios, we are batching by users
// We need to create sub-batches where the total number of users * folios per batch is less than 100

public with sharing class BatchByUsers implements Database.Batchable<SObject>, Database.AllowsCallouts, Database.Stateful, Database.RaisesPlatformEvents {
  private List<Folio_Process_Request__e> folioRequests = new List<Folio_Process_Request__e>();

  public Database.QueryLocator start(Database.BatchableContext info) {
    String query = 'SELECT Id, Name FROM User WHERE IsActive = true';
    return Database.getQueryLocator(query);
  }

  public void execute(Database.BatchableContext info, List<SObject> scope) {
    List<User> users = (List<User>) scope;
    List<Id> userIds = new List<Id>();
    for (User u : users) {
      userIds.add(u.Id);
    }
    String userIdsCsv = String.join(userIds, ',');
    this.folioRequests.add(
      new Folio_Process_Request__e(UserIds__c = userIdsCsv)
    );
  }

  public void finish(Database.BatchableContext info) {
    // Finalization logic if needed
    EventBus.publish(this.folioRequests);
    System.debug('Batch By Users Finished.');
  }
}
