public abstract class BLDR_CustomMetadata {
    
    final String typeName {get; set;}
    String originalDevName {get; set;}
    public String recordName {public get; public set;}
    public String recordDevName {public get; public set;}
    public String recordLabel {public get; public set;}
    final Map<Schema.SObjectField, Object> customFieldValues {get; set;}
    final Set<Schema.SObjectField> fieldsToNull {get; set;}
    public final SObject existingRecord {public get; set;}
    
    
    BLDR_CustomMetadata(Schema.SObjectType metadataType, SObject existingRecordOrNull) {
        this.typeName = metadataType.getDescribe().name.removeEnd('__mdt');
        customFieldValues = new Map<Schema.SObjectField, Object>();
        fieldsToNull = new Set<Schema.SObjectField>();
        existingRecord = existingRecordOrNull;
    }
    
    protected BLDR_CustomMetadata(Schema.SObjectType typeForNewRecord) {
        this(typeForNewRecord, null);
    }
    
    protected BLDR_CustomMetadata(SObject existingRecord) {
        this(existingRecord.getSObjectType(), existingRecord);
		recordName = String.valueOf(existingRecord.get('QualifiedApiName'));
        recordLabel = String.valueOf(existingRecord.get('MasterLabel'));
        recordDevName = String.valueOf(existingRecord.get('DeveloperName'));
        originalDevName = recordName;
    }
    
    protected void setValue(Schema.SObjectField field, Object value) {
        if (value == null) {
            customFieldValues.remove(field);
            fieldsToNull.add(field);
        } else {
            customFieldValues.put(field, value);
            fieldsToNull.remove(field);
        }
    }
    
    protected Object getValue(Schema.SObjectField field) {
        return customFieldValues.get(field);
    }
    
    public BLDR_MetadataService.CustomMetadata buildMetadata() {
        BLDR_MetadataService.CustomMetadata metadata = new BLDR_MetadataService.CustomMetadata();
        if (String.isBlank(recordName)) {
            recordName = recordDevName;
        }
        metadata.fullName = typeName + '.' + recordName;
        metadata.label = recordLabel;
        BLDR_MetadataService.CustomMetadataValue[] values = new List<BLDR_MetadataService.CustomMetadataValue>();
        for (Schema.SObjectField field : customFieldValues.keySet()) {
            BLDR_MetadataService.CustomMetadataValue cmVal = new BLDR_MetadataService.CustomMetadataValue();
            cmVal.field = field.getDescribe().getName();
            cmVal.value = String.valueOf(customFieldValues.get(field));
            values.add(cmVal);
        }
        for (Schema.SObjectField field : fieldsToNull) {
            BLDR_MetadataService.CustomMetadataValue cmVal = new BLDR_MetadataService.CustomMetadataValue();
            cmVal.field = field.getDescribe().getName();
            //value stays null
            values.add(cmVal);
        }
        metadata.values = values;
        return metadata;
    }
    
    public String getOldFullNameForRenameOrDelete() {
        return typeName + '.' + originalDevName;
    }
    
    public String getNewFullNameForRename() {
        return typeName + '.' + recordDevName;
    }
    
}