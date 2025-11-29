public with sharing class FolioBatch implements Database.Batchable<SObject>, Database.AllowsCallouts, Database.Stateful, Database.RaisesPlatformEvents {
  private List<User> userRecords;
  public class CalloutPayload {
    public List<PayloadFolios> folios;
    public Set<String> userNames;
    public CalloutPayload(List<User> users) {
      this.folios = new List<PayloadFolios>();
      this.userNames = new Set<String>();
      for (User u : users) {
        this.userNames.add(u.Username);
      }
    }
  }
  public class PayloadFolios {
    public String folioUniqueString;
    public Id folioId;
  }

  private CalloutPayload payload;

  public FolioBatch(List<Id> userIds) {
    this.userRecords = [
      SELECT Id, Name, Username
      FROM User
      WHERE Id IN :userIds
    ];
  }

  public Database.QueryLocator start(Database.BatchableContext info) {
    String query = 'SELECT Id, UniqueString__c FROM Folio__c';
    return Database.getQueryLocator(query);
  }

  public void execute(Database.BatchableContext info, List<SObject> scope) {
    List<Folio__c> folios = (List<Folio__c>) scope;
    this.payload = new CalloutPayload(this.userRecords);
    System.debug(
      'Executing FolioBatch with record counts: \nfolios: ' +
        folios.size() +
        '\nusers: ' +
        userRecords.size()
    );
    for (Folio__c folio : folios) {
      PayloadFolios payloadFolio = new PayloadFolios();
      payloadFolio.folioUniqueString = folio.UniqueString__c;
      payloadFolio.folioId = folio.Id;
      this.payload.folios.add(payloadFolio);
    }
    System.debug('Execute the callout here, then process the results');
    // async callout logic would go here
    FolioCalloutAsync calloutJob = new FolioCalloutAsync(
      JSON.serializePretty(this.payload)
    );
    System.enqueueJob(calloutJob);
  }

  public void finish(Database.BatchableContext info) {
    System.debug('FolioBatch.finish() entered.');
    System.debug('Folio Batch Finished.');
  }
}
