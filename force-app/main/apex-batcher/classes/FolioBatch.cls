public with sharing class FolioBatch implements Database.Batchable<SObject>, Database.AllowsCallouts, Database.Stateful, Database.RaisesPlatformEvents {
  private List<User> userRecords;

  public FolioBatch(List<Id> userIds) {
    this.userRecords = [SELECT Id, Name FROM User WHERE Id IN :userIds];
  }

  public Database.QueryLocator start(Database.BatchableContext info) {
    String query = 'SELECT Id, UniqueString__c FROM Folio__c';
    return Database.getQueryLocator(query);
  }

  public void execute(Database.BatchableContext info, List<SObject> scope) {
    List<Folio__c> folios = (List<Folio__c>) scope;
    for (Folio__c folio : folios) {
      // Process each folio with the userRecords
      System.debug(
        'Processing Folio: ' +
          folio.UniqueString__c +
          ' for Users: ' +
          userRecords
      );
    }
  }
  public void finish(Database.BatchableContext info) {
    System.debug('Folio Batch Finished.');
  }
}
