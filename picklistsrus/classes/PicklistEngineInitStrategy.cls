/**
 * A way to initialize data and metadata for ReusablePicklistEngine.
 */
public abstract class PicklistEngineInitStrategy {
    public final List<String> fieldNamesFixedOrder {public get; set;}
    public final SObject record {public get; set;}
    public final String typeName {public get; set;}
    public final String typeLabel {public get; set;}
    
    /**
     * Initialize for the SObject type represented by describe, and optionally,
     * the record represented by existingId. existingId can be null if, e.g.,
     * this is a create page.
     */
    protected PicklistEngineInitStrategy(Schema.DescribeSObjectResult describe, 
                                         Id existingId) {
        fieldNamesFixedOrder = createFieldNamesList(describe);
        typeName = describe.name;
        typeLabel = describe.label;
        record = createOrRetrieveRecord(describe, existingId);
        
    }
    
    private List<String> createFieldNamesList(
        Schema.DescribeSObjectResult describe) {
            
        List<String> fields = new List<String>();
        for (Schema.SObjectField field : describe.fields.getMap().values()) {
            Schema.DescribeFieldResult fieldDesc = field.getDescribe();
            String fieldName = fieldDesc.getName();
            
            if (filterField(fieldDesc) 
                && !'OwnerId'.equals(fieldName) 
                && !'Name'.equals(fieldName)
                && !'Deleted'.equals(fieldName)
                && !'Id'.equals(fieldName)) {
                fields.add(fieldName);
            }
        }
        fields.sort();
        return fields;
    }
    
    /*
     * Should return true if the field should be displayed in this context.
     */
    protected abstract boolean filterField(Schema.DescribeFieldResult field);
    
    /*
     * Creates a new object or retrieves the one with the Id provided to 
     * the constructor.
     */
    protected abstract SObject createOrRetrieveRecord(
        Schema.DescribeSObjectResult describe,
        Id existingId);
}