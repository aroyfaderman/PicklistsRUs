public class BLDR_ReusablePicklistOption extends BLDR_CustomMetadata {
    
    public BLDR_ReusablePicklistOption(Id optionId) {
        super([SELECT DeveloperName, QualifiedApiName, MasterLabel, Picklist__c, SortOrder__c from ReusablePicklistOption__mdt where Id = :optionId]);
    }
    
    public BLDR_ReusablePicklistOption() {
        super(ReusablePicklistOption__mdt.sObjectType);
    }
    
    public String getPicklist() {
        return (String) getValue(ReusablePicklistOption__mdt.fields.Picklist__c);
    }
    
    public void setPicklist(String picklist) {
        setValue(ReusablePicklistOption__mdt.fields.Picklist__c, picklist);
    }
    
    public Double getSortOrder() {
        return (Double) getValue(ReusablePicklistOption__mdt.fields.SortOrder__c);
    }
    
    public void setSortOrder(Double sortOrder) {
        setValue(ReusablePicklistOption__mdt.fields.SortOrder__c, sortOrder);
    }

}