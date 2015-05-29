public class BLDR_UsageCreateController {
    public final SelectOption[] entityOptions {public get; set;}
    public SelectOption[] fieldOptions {public get; public set;}
    public final Map<String, String> entitiesByApiNames {public get; set;}
    public final BLDR_PicklistUsage usage {public get; set;}
    public final String picklistLabel {public get; set;}
    
    public BLDR_UsageCreateController() {
        usage = new BLDR_PicklistUsage();
        usage.setPicklist(ApexPages.currentPage().getParameters().get('picklistApiName'));
        picklistLabel = [SELECT Label
                         FROM ReusablePicklist__mdt
                         WHERE QualifiedApiName = :usage.getPicklist()].Label;
        EntityDefinition[] entities = [SELECT Id, DurableId, QualifiedApiName, Label, KeyPrefix 
                                       FROM EntityDefinition
                                       WHERE IsCustomizable = TRUE
                                       ORDER BY Label];
        entityOptions = new List<SelectOption>();
        entitiesByApiNames = new Map<String, Id>();
        entityOptions.add(new SelectOption('', '--Please Select an SObject Type--'));
        for (EntityDefinition entity : entities) {
            if (!String.isBlank(entity.Label) && !entity.KeyPrefix.startsWith('m')) {
                entityOptions.add(new SelectOption(entity.QualifiedApiName, entity.Label));
                entitiesByApiNames.put(entity.QualifiedApiName, entity.Id);
            }
        }
        fieldOptions = new List<SelectOption>();
    }
    
    public PageReference save() {
        if (String.isBlank(usage.getSObjectType())) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Please select an sObject type', '', 'Entity__c'));
			return null;
        }
        if (String.isBlank(usage.getField())) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Please select a field', '', 'Field__c'));
        	return null;
        }
        String entityLabel = [SELECT MasterLabel 
                              FROM EntityDefinition 
                              WHERE QualifiedApiName = :usage.getSObjectType()].MasterLabel;
        String fieldLabel = [SELECT MasterLabel
                             FROM FieldDefinition
                             WHERE QualifiedApiName = :usage.getField()
                               AND EntityDefinition.QualifiedApiName = :usage.getSObjectType()].MasterLabel;
        String trimmedEntityLabel = entityLabel.left(20).trim();
        String trimmedFieldLabel = fieldLabel.left(39 - trimmedEntityLabel.length()).trim();
        usage.recordLabel = trimmedEntityLabel + ' ' + trimmedFieldLabel;
        String[] entityNameSplit = NamespaceUtil.split(usage.getSObjectType(), true);
        String entityDevName = entityNameSplit[entityNameSplit.size() - 1];
        String[] fieldNameSplit = NamespaceUtil.split(usage.getField(), true);
        String fieldDevName = entityNameSplit[fieldNameSplit.size() - 1];
        //Pass in only 36 total to allow for appending up to 4 digits;
        String entityNameTrimmed = entityDevName.left(18);
        String fieldNameTrimmed = fieldDevName.left(35 - entityNameTrimmed.length());
        usage.recordDevName = BLDR_DevNameUtil.uniquify(
            entityDevName + '_' + fieldDevName,
            [SELECT DeveloperName FROM PicklistUsage__mdt]
        );
        BLDR_MetadataService.SaveResult result = BLDR_MetadataUtil.create(usage);
        if (BLDR_MetadataUtil.checkResult(result)) {
            PageReference createTab = Page.BLDR_TabCreate;
            createTab.getParameters().put('entityDefId', entitiesByApiNames.get(usage.getSObjectType()));
            createTab.getParameters().put('picklistName', usage.getPicklist());
            createTab.setRedirect(true);
            return createTab;
        } else {
        	return null;
        }
    }
    
    public PageReference cancel() {
        PageReference detail = Page.BLDR_PicklistDetail;
        detail.getParameters().put('apiName', usage.getPicklist());
        return detail;
    }
    
    public PageReference calcFieldOptions() {
        usage.setField(null);
        fieldOptions = new List<SelectOption>();
        String sObjectType = usage.getSObjectType();
        if (String.isBlank(sObjectType)) {
            return null;
        }
        FieldDefinition[] fields = [SELECT QualifiedApiName, DeveloperName, NamespacePrefix, Label, DataType
                                  FROM FieldDefinition
                                  WHERE EntityDefinition.QualifiedApiName = :sObjectType
                                   AND IsCalculated=FALSE
                                   ORDER BY Label];        
        PicklistUsage__mdt[] existingUsages = new List<PicklistUsage__mdt>();
        existingUsages.addAll([SELECT NamespacePrefix, Field__c
                               FROM PicklistUsage__mdt
                               WHERE SObjectType__c = :sObjectType]);
        String[] sObjectTypeSplit = NamespaceUtil.split(sObjectType, true);
        if (sObjectTypeSplit.size() == 2) {
            String nsPref = sObjectTypeSplit[0];
            String unqualName = sObjectTypeSplit[1];
            existingUsages.addAll([SELECT NamespacePrefix, Field__c
                                   FROM PicklistUsage__mdt
                                   WHERE NamespacePrefix = :nsPref
                                   AND SObjectType__c = :unqualName
                                  ]);
        }
        Set<String> fieldsToFilterOut = new Set<String>();
        for (PicklistUsage__mdt existingUsage : existingUsages) {
            String nsPrefix = existingUsage.NamespacePrefix;
            fieldsToFilterOut.add(NamespaceUtil.qualifyIfNeeded((nsPrefix == null ? null : nsPrefix.toLowerCase()), existingUsage.Field__c.toLowerCase(), true));
        }
        for (FieldDefinition field : fields) {
            if (!String.isBlank(field.Label) &&
                field.QualifiedApiName != 'Name' &&
                field.DataType.startsWith('Text(') &&
                !fieldsToFilterOut.contains(field.QualifiedApiName.toLowerCase())) {
                
                    if (fieldOptions.isEmpty()) {
                        fieldOptions.add(new SelectOption('', '--Please Select a Field--'));
                    }
                fieldOptions.add(new SelectOption(field.QualifiedApiName, field.Label));
            }
        }
        if (fieldOptions.isEmpty()) {
            fieldOptions.add(new SelectOption('', '--No Qualifying Fields--'));
        }
        return null;
    }
}