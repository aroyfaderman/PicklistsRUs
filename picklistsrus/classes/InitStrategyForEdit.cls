/**
 *  Initialize data for ReusablePicklistEngine in Edit mode.
 */
public class InitStrategyForEdit extends InitWithExistingRecordStrategy {
	public InitStrategyForEdit(Id recordId) {
        super(recordId);
    }
    
    public override boolean filterField(Schema.DescribeFieldResult field) {
        return field.updateable;
    }
}