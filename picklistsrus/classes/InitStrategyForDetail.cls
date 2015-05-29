/**
 *  Initialize data for ReusablePicklistEngine in Detail mode.
 */
public class InitStrategyForDetail extends InitWithExistingRecordStrategy {
	public InitStrategyForDetail(Id recordId) {
        super(recordId);
    }
    
    public override boolean filterField(Schema.DescribeFieldResult field) {
        if (field.accessible) {
            System.debug(field.type);
        }
        return field.accessible && field.type != Schema.DisplayType.ADDRESS && field.type != Schema.DisplayType.LOCATION;
    }
}