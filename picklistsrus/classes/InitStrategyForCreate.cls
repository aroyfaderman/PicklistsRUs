/**
 *  Initialize data for ReusablePicklistEngine in Create mode.
 */
public class InitStrategyForCreate extends PicklistEngineInitStrategy {
	
    public InitStrategyForCreate(String typeName) {
        super(Schema.describeSObjects(new String[] {typeName})[0], null);
    }
    
    protected override boolean filterField(Schema.DescribeFieldResult field) {
        return field.createable;
    }
    
    protected override SObject createOrRetrieveRecord(Schema.DescribeSObjectResult describe, Id existingId) {
        return describe.getSObjectType().newSObject();
    }
}