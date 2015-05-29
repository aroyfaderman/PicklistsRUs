public class BLDR_ReusablePicklist extends BLDR_CustomMetadata {
    public BLDR_ReusablePicklist(Id picklistId) {
        super([SELECT  DeveloperName, QualifiedApiName, MasterLabel, AlphaSort__c from ReusablePicklist__mdt where Id = :picklistId]);
        setAlphaSort(((ReusablePicklist__mdt)existingRecord).AlphaSort__c);
    }
    
    public BLDR_ReusablePicklist() {
        super(ReusablePicklist__mdt.sObjectType);
    }
    
    public Boolean getAlphaSort() {
        return (Boolean) getValue(ReusablePicklist__mdt.fields.AlphaSort__c);
    }
    
    public void setAlphaSort(Boolean alphaSort) {
        setValue(ReusablePicklist__mdt.fields.AlphaSort__c, alphaSort);
    }
}