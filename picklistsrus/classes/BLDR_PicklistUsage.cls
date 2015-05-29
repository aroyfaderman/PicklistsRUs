public class BLDR_PicklistUsage extends BLDR_CustomMetadata {
	public BLDR_PicklistUsage() {
        super(PicklistUsage__mdt.sObjectType);
    }
    
    public BLDR_PicklistUsage(Id usageId) {
        super([SELECT DeveloperName, QualifiedApiName, MasterLabel, Picklist__c, SObjectType__c, Field__c
               FROM PicklistUsage__mdt
               WHERE Id = :usageId]);
    }
    
    public String getPicklist() {
        return (String) getValue(PicklistUsage__mdt.fields.Picklist__c);
    }
    
    public void setPicklist(String picklist) {
        setValue(PicklistUsage__mdt.fields.Picklist__c, picklist);
    }
    
    public String getSObjectType() {
        return (String) getValue(PicklistUsage__mdt.fields.SObjectType__c);
    }
    
    public void setSObjectType(String sObjectType) {
        setValue(PicklistUsage__mdt.fields.SObjectType__c, sObjectType);
    }
    
    public String getField() {
        return (String) getValue(PicklistUsage__mdt.fields.Field__c);
    }
    
    public void setField(String field) {
        setValue(PicklistUsage__mdt.fields.Field__c, field);
    }

}