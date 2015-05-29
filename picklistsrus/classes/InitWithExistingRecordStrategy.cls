/**
 * Initialize data for ReusablePicklistEngine in a mode that edits or displays
 * an existing record.
 */
public abstract class InitWithExistingRecordStrategy extends 
                      PicklistEngineInitStrategy {

    protected InitWithExistingRecordStrategy(Id recordId) {
        super(recordId.getSObjectType().getDescribe(), recordId);
    }
    
    protected override SObject createOrRetrieveRecord(
        Schema.DescribeSObjectResult describe, Id existingId) {
     	String selectClause = 'SELECT Name';
        for (String fieldName : fieldNamesFixedOrder) {
            selectClause += (', ' + fieldName);
        }
        return Database.query(
            selectClause +
            ' FROM ' + describe.getName() + 
            ' WHERE Id = ' + '\'' + existingId + '\'');
    }
}