public class BLDR_PicklistDetailController {
    public final ReusablePicklist__mdt picklist {public get; set;}
    public final ReusablePicklistOption__mdt[] pickOptions {public get; set;}
    public final PicklistUsage__mdt[] pickUsages {public get; set;}
    public final Map<Id, Boolean> optionCanBeMovedUp {public get; set;}
    public final Map<Id, Id> optionsToPriors {public get; set;}
    public final Map<Id, Boolean> optionCanBeMovedDown {public get; set;}
    public final Map<Id, Id> optionsToSuccessors {public get; set;}
    public Id selected {public get; public set;}
    public final Map<Id, String> usagesToSObjectLabels {public get; set;}
    public final Map<Id, String> usagesToFieldLabels {public get; set;}
    public final String picklistPrefix {public get; set;}
    public final String optionPrefix {public get; set;}
    public final String usagePrefix {public get; set;}
    
    public BLDR_PicklistDetailController() {
        picklist = [SELECT Id, Label, QualifiedApiName, NamespacePrefix, DeveloperName, AlphaSort__c 
                    FROM ReusablePicklist__MDT
                    WHERE QualifiedApiName = :ApexPages.currentPage().getParameters().get('apiName')];
        BLDR_MetadataUtil.checkMetadataAPIConnection();
        picklistPrefix = BLDR_MetadataUtil.reusablePicklistPrefix;
        optionPrefix = BLDR_MetadataUtil.reusablePicklistOptionPrefix;
        usagePrefix = BLDR_MetadataUtil.picklistUsagePrefix;
        pickOptions = createOptionsList();
        optionCanBeMovedUp = new Map<Id, Boolean>();
        optionsToPriors = new Map<Id, Id>();
        optionCanBeMovedDown = new Map<Id, Boolean>();
        optionsToSuccessors = new Map<Id, Id>();
        makeOptionsMaps();
        usagesToSObjectLabels = new Map<Id, String>();
        usagesToFieldLabels = new Map<Id, String>();
        pickUsages = createUsagesList();
    }
    
    public PageReference createOption() {
        PageReference retVal = Page.BLDR_OptionCreate;
        retVal.getParameters().put('picklistApiName', picklist.QualifiedApiName);
        return retVal;
    }
    
    public PageReference createUsage() {
        PageReference retVal = Page.BLDR_UsageCreate;
        retVal.getParameters().put('picklistApiName', picklist.QualifiedApiName);
        return retVal;
    }
    
    public PageReference renameOption() {
        PageReference retVal = Page.BLDR_OptionRename;
        retVal.getParameters().put('id', selected);
        retVal.getParameters().put('picklistApiName', picklist.QualifiedApiName);
        return retVal;
    }
    
    public PageReference deleteOption() {
        return deleteComponent(new BLDR_ReusablePicklistOption(selected));
    }
    
    public PageReference deleteUsage() {
        return deleteComponent(new BLDR_PicklistUsage(selected));
    }
    
    PageReference deleteComponent(BLDR_CustomMetadata component) {
        BLDR_MetadataService.DeleteResult result = BLDR_MetadataUtil.deleteMd(component);
        if (BLDR_MetadataUtil.checkResult(result)) {
            PageReference thisPage = ApexPages.currentPage();
        	thisPage.setRedirect(true);
        	return thisPage;
        }
        return null;
    }
    
    public PageReference edit() {
        PageReference retVal = Page.BLDR_PicklistEdit;
        retVal.getParameters().put('id', picklist.Id);
        retVal.getParameters().put('cancelUrl', ApexPages.currentPage().getUrl());
        return retVal;
    }
    
    public PageReference deletePicklist() {
        return new BLDR_PicklistDeleter(picklist.Id).doDelete();
    }
    
    public PageReference backToList() {
        return Page.BLDR_ReusablePicklistsList;
    }
    
    public Map<String, Boolean> getIsCmdEditable() {
        return BLDR_MetadataUtil.isCmdEditable;
    }
    
    public Map<String, Boolean> getIsCmdDeletable() {
        return BLDR_MetadataUtil.isCmdDeletable;
    }
    
    public String getNewUsageLabel() {
        return 'Use for ' + (pickUsages.isEmpty() ? 'a' : 'Another') + ' Field';
    }
    
    ReusablePicklistOption__mdt[] createOptionsList() {
        String selectAndFrom = 'SELECT Id, QualifiedApiName, NamespacePrefix, Label, SortOrder__c FROM ReusablePicklistOption__mdt ';
        String orderBy = 'ORDER BY ' + (picklist.AlphaSort__c ?  'Label ' : 'SortOrder__c ');
        ReusablePicklistOption__mdt[] options;
        String picklistName = picklist.QualifiedApiName;
        String picklistNs = picklist.NamespacePrefix;
        if (String.isBlank(picklistNs)) {
            options = Database.query(
                selectAndFrom + 
                'WHERE NamespacePrefix=null AND Picklist__c = :picklistName ' +
                orderBy);
        } else {
            //Namespace for Picklist__c specified in the option
            ReusablePicklistOption__mdt[] optionsSpecNamespace =
                Database.query(selectAndFrom +
                               'WHERE Picklist__c = :picklistName ' +
                               orderBy);
            
            //Also options where no ns is specified for Picklist__c but that are in
            //picklist ns.
            String picklistDevName = picklist.DeveloperName;
            ReusablePicklistOption__mdt[] optionsDefaultedNamespace = 
                Database.query(selectAndFrom + 
                               'WHERE NamespacePrefix = :picklistNs ' +
                               '  AND Picklist__c = :picklistDevName ' +
                               orderBy);
            
            options = new List<ReusablePicklistOption__mdt>();
            Integer specIndex=0;
            Integer defaultedIndex=0;
            // Merge the sorted lists
            while (specIndex < optionsSpecNamespace.size()) {
                ReusablePicklistOption__mdt nsSpecOption = optionsSpecNamespace[specIndex];
                if (defaultedIndex < optionsDefaultedNamespace.size()) {
                    ReusablePicklistOption__mdt nsDefOption = 
                        optionsDefaultedNamespace[defaultedIndex];
                    boolean specFirst = picklist.AlphaSort__c ?
                        nsSpecOption.Label < nsDefOption.Label :
                    nsSpecOption.SortOrder__c < nsDefOption.SortOrder__c;
                    if (specFirst) {
                        options.add(nsSpecOption);
                        specIndex++;
                    } else {
                        options.add(nsDefOption);
                        defaultedIndex++;
                    }
                } else {
                    options.add(nsSpecOption);
                    specIndex++;
                }
            }
            // Add any remaining namespace-defaulted options to the list to complete
            // the merge.
            while (defaultedIndex < optionsDefaultedNamespace.size()) {
                options.add(optionsDefaultedNamespace[defaultedIndex++]);
            }
        }
        return options;
    }
    
    PicklistUsage__mdt[] createUsagesList() {
        
        PicklistUsage__mdt[] unsortedUsages;

        String picklistName = picklist.QualifiedApiName;
        String picklistNs = picklist.NamespacePrefix;
        if (String.isBlank(picklistNs)) {
            unsortedUsages = [SELECT Id, QualifiedApiName, NamespacePrefix, SObjectType__c, Field__c
                             FROM PicklistUsage__mdt
                             WHERE NamespacePrefix=null AND Picklist__c = :picklistName];
        } else {
            unsortedUsages = new List<PicklistUsage__mdt>();
            //Namespace for Picklist__c specified in the option
            unsortedUsages.addAll([SELECT Id, QualifiedApiName, NamespacePrefix, SObjectType__c, Field__c
                                   FROM PicklistUsage__mdt
                                   WHERE Picklist__c = :picklistName]);
            
            //Also usages where no ns is specified for Picklist__c but that are in
            //picklist ns.
            String picklistDevName = picklist.DeveloperName;
            unsortedUsages.addAll([SELECT Id, QualifiedApiName, NamespacePrefix, SObjectType__c, Field__c
                                   FROM PicklistUsage__mdt
                                   WHERE NamespacePrefix = :picklistNs
                                     AND Picklist__c = :picklistDevName]);
        }
        
        Map<String, Map<String, PicklistUsage__mdt>> usagesByObjectAndField = new Map<String, Map<String, PicklistUsage__mdt>>();
        
        for (PicklistUsage__mdt usage : unsortedUsages) {
            String sObjectName = NamespaceUtil.qualifyIfNeeded(usage.NamespacePrefix, usage.SObjectType__c, true);
            String fieldName = NamespaceUtil.qualifyIfNeeded(usage.NamespacePrefix, usage.Field__c, true);
            Map<String, PicklistUsage__mdt> usagesForObject = usagesByObjectAndField.get(sObjectName);
            if (usagesForObject == null) {
                usagesForObject = new Map<String, PicklistUsage__mdt>();
                usagesByObjectAndField.put(sObjectName, usagesForObject);
            }
            usagesForObject.put(fieldName, usage);
        }
        String[] objectLabels = new List<String>();
        Map<String, String[]> objectLabelsToSortedFieldLabels = new Map<String, String[]>();
        Map<String, Map<String, PicklistUsage__mdt>> usagesByObjectAndFieldLabels = new Map<String, Map<String, PicklistUsage__mdt>>();
        EntityDefinition[] entitiesWithFields = [SELECT QualifiedApiName, 
                                                        Label, 
                                                        (SELECT QualifiedApiName,
                                                               Label
                                                        FROM Fields)
                                                 FROM EntityDefinition
                                                 WHERE QualifiedApiName IN :usagesByObjectAndField.keySet()];
        for (EntityDefinition entity : entitiesWithFields) {
            String objectName = entity.QualifiedApiName;
            String objectLabel = entity.Label;
            objectLabels.add(objectLabel);
            String[] fieldLabels = new List<String>();
            Map<String, PicklistUsage__mdt> usagesByFieldLabels = usagesByObjectAndFieldLabels.get(objectLabel);
            if (usagesByFieldLabels == null) {
                usagesByFieldLabels = new Map<String, PicklistUsage__mdt>();
                usagesByObjectAndFieldLabels.put(objectLabel, usagesByFieldLabels);
            }
            for (FieldDefinition field : entity.Fields) {
                String fieldName = field.QualifiedApiName;
                String fieldLabel = field.Label;
                if (usagesByObjectAndField.get(objectName).containsKey(fieldName)) {
                    PicklistUsage__mdt usage = usagesByObjectAndField.get(objectName).get(fieldName);
                    usagesToSObjectLabels.put(usage.Id, objectLabel);
                    usagesToFieldLabels.put(usage.Id, fieldLabel);
                    usagesByFieldLabels.put(fieldLabel, usage);
                    fieldLabels.add(fieldLabel);
                }
            }
            fieldLabels.sort();
            objectLabelsToSortedFieldLabels.put(objectLabel, fieldLabels);
        }
        objectLabels.sort();
        PicklistUsage__mdt[] sortedUsages = new List<PicklistUsage__mdt>();

        for (String objectLabel : objectLabels) {
            for (String fieldLabel : objectLabelsToSortedFieldLabels.get(objectLabel)) {
                sortedUsages.add(usagesByObjectAndFieldLabels.get(objectLabel).get(fieldLabel));
            }
        }
        
        return sortedUsages;
    }
    
    void makeOptionsMaps() {
        if (pickOptions.isEmpty()) {
            return;
        }
        ReusablePicklistOption__mdt priorOption = null;
        for (ReusablePicklistOption__mdt option : pickOptions) {
            if (priorOption != null && 
                !picklist.AlphaSort__c &&
                getIsCmdEditable().get(optionPrefix + priorOption.QualifiedApiName) &&
                getIsCmdEditable().get(optionPrefix + option.QualifiedApiName)) {
                optionCanBeMovedUp.put(option.Id, true);
                optionCanBeMovedDown.put(priorOption.Id, true);
                optionsToPriors.put(option.Id, priorOption.Id);
                optionsToSuccessors.put(priorOption.Id, option.Id);
            } else {
                optionCanBeMovedUp.put(option.Id, false);
                if (priorOption != null) {
                    optionCanBeMovedDown.put(priorOption.Id, false);
                }
            }
            priorOption = option;
        }
        optionCanBeMovedDown.put(pickOptions[pickOptions.size() - 1].Id, false);
    }
    
    public PageReference moveUp() {
        return switchPlaces(selected, optionsToPriors.get(selected));
    }
    
    public PageReference moveDown() {
        return switchPlaces(selected, optionsToSuccessors.get(selected));
    }
    
    PageReference switchPlaces(Id option1Id, Id option2Id) {
        BLDR_ReusablePicklistOption option1 = new BLDR_ReusablePicklistOption(option1Id);
        BLDR_ReusablePicklistOption option2 = new BLDR_ReusablePicklistOption(option2Id);
        option1.setSortOrder(Double.valueOf(option2.existingRecord.get(ReusablePicklistOption__mdt.fields.SortOrder__c)));
        option2.setSortOrder(Double.valueOf(option1.existingRecord.get(ReusablePicklistOption__mdt.fields.SortOrder__c)));
        BLDR_MetadataService.SaveResult[] results = BLDR_MetadataUtil.updateMd(new BLDR_CustomMetadata[] {option1, option2});
        if (BLDR_MetadataUtil.checkResult(results)) {
        	PageReference reloadPage = ApexPages.currentPage();
        	reloadPage.setRedirect(true);
            return reloadPage;
        }
        return null;
    }
}