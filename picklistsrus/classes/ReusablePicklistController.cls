public with sharing class ReusablePicklistController {
    /*
     * The API name of the SObject Type for the record we're creating or 
     * editing
     */
    public final String typeName {public get; set;}
    
    /* 
     * A list of all field names to render, except for the 'Name' field (which 
     * always goes first), in alphabetical order
     */
    public final List<String> fieldNamesFixedOrder {public get; set;}
    
    /*
     * A map from lowercase field names to the names of their reusable 
     * picklists
     */
    public final Map<String, String> picklistsByField {public get; set;}
    
    /*
     * A map from reusable picklist names to lists of their select options
     */
    public final Map<String, SelectOption[]> selectOptionsByPicklist {
        public get; set;
    }
    
    /*
     * A map of field names to whether or not they use a reusable picklist
     */
    public final Map<String, Boolean> doesFieldUsePicklist{public get; set;}
    
    /*
     * The record we're creating or editing
     */
    public final SObject record {public get; set;}
    
    final String typeLabel {get; set;}
    
    public boolean readOnly {public get; set;}
    
    public ReusablePicklistController() {
        Map<String, Schema.SObjectField> fieldsByName = 
            new Map<String, Schema.SObjectField>();
        Id id = ApexPages.currentPage().getParameters().get('id');
        readOnly = id != null && ApexPages.currentPage().getParameters().get('e') == null;
        DescribeSObjectResult type;
        PicklistEngineInitStrategy initStrategy;
        if (id == null) {
            initStrategy = new InitStrategyForCreate(ApexPages.currentPage().getParameters().get('type'));
        } else if (readOnly) {
            initStrategy = new InitStrategyForDetail(id);
        } else {
            initStrategy = new InitStrategyForEdit(id);
        }
        typeName = initStrategy.typeName;
        typeLabel = initStrategy.typeLabel;
        fieldNamesFixedOrder = initStrategy.fieldNamesFixedOrder;
        record = initStrategy.record;
        picklistsByField = createPicklistsByFieldMap();
        doesFieldUsePicklist = createDoesFieldUsePicklistMap();
        Map<String, ReusablePicklistOption__mdt[]> optionsByPicklist =
            getPicklistOptionsByPicklist();
        selectOptionsByPicklist = new Map<String, SelectOption[]>();
        for (String picklist : optionsByPicklist.keySet()) {
            List<SelectOption> selectOptionsForPicklist = new List<SelectOption>();
            selectOptionsForPicklist.add(new SelectOption('', '--None Selected--'));
            for (ReusablePicklistOption__mdt option : optionsByPicklist.get(picklist)) {
                selectOptionsForPicklist.add(new SelectOption(option.QualifiedApiName, option.Label));
            }
            selectOptionsByPicklist.put(picklist, selectOptionsForPicklist);
        }
    }
    
    /*
     * Returns the title for the page
     */
    public String getTitle() {
        if (record.Id == null) {
            return 'New ' + typeLabel;
        }
        return (readonly ? '' : 'Edit ') + typeLabel + ': ' + record.get('Name');
    }
    
    public PageReference save() {
        upsert record;
        ApexPages.PageReference detail = Page.ReusablePicklistEngine;
        detail.getParameters().put('id', (String) record.get('Id'));
        detail.setRedirect(true);
        return detail;
    }
    
    public PageReference saveAndNew() {
        upsert record;
        PageReference create = Page.ReusablePicklistEngine;
        create.getParameters().put('type', typeName);
        create.getParameters().put('retUrl', ApexPages.currentPage().getParameters().get('retUrl'));
        create.setRedirect(true);
        return create;
    }
    
    public PageReference cancel() {
        ApexPages.PageReference lastPage = new ApexPages.PageReference(EncodingUtil.urlDecode(ApexPages.currentPage().getParameters().get('retUrl'), 'UTF-8'));
		lastPage.setRedirect(true);
        return lastPage;
    }
    
    public PageReference edit() {
        ApexPages.PageReference edit = Page.ReusablePicklistEngine;
        edit.getParameters().put('id', (String) record.get('Id'));
        edit.getParameters().put('e', '');
        edit.getParameters().put('retUrl', ApexPages.currentPage().getUrl());
        edit.setRedirect(true);
        return edit;
    }
    
    public PageReference remove() {
        delete record;
        ApexPages.PageReference tab = Page.ReusablePicklistTab;
        tab.getParameters().put('type', typeName);
        return tab;
    }
    
    /* 
     * Returns a map from field names to the names of picklists they use.
     */
    Map<String, String> createPicklistsByFieldMap() {
        String[] splitTypeName = NamespaceUtil.split(typeName, true);
        PicklistUsage__mdt[] usages;
        if (splitTypeName.size() == 1) {
            //No namespace on the type
            usages = [SELECT NamespacePrefix, 
                             Picklist__c, 
                             Field__c
                      FROM PicklistUsage__mdt
                      WHERE NamespacePrefix=null AND
                            SObjectType__c = :typeName];
        } else {
            System.assert(splitTypeName.size() == 2);
            //SObjectType__c includes a namespace
            PicklistUsage__mdt[] usagesSpecNamespace =
                [SELECT NamespacePrefix, Picklist__c, Field__c
                 FROM PicklistUsage__mdt
                 WHERE SObjectType__c = :typeName];
            //Otherwise assume usage namespace for SObjectType__c
            PicklistUsage__mdt[] usagesDefaultedNamespace = 
                [SELECT NamespacePrefix, Picklist__c, Field__c
                 FROM PicklistUsage__mdt
                 WHERE NamespacePrefix = :splitTypeName[0] AND
                       SObjectType__c = :splitTypeName[1]];
            usages = new List<PicklistUsage__mdt>();
            usages.addAll(usagesSpecNamespace);
            usages.addAll(usagesDefaultedNamespace); 
        }
        Map<String, String> picklistsByFieldMap = new Map<String, String>();
        for (PicklistUsage__mdt usage : usages) {
            picklistsByFieldMap.put(
                NamespaceUtil.qualifyIfNeeded(usage.NamespacePrefix, usage.Field__c, true),
                NamespaceUtil.qualifyIfNeeded(usage.NamespacePrefix, usage.Picklist__c, false));
        }
        return picklistsByFieldMap;
    }
    
    /*
     * Returns a map that maps the names of all editable fields for this object to 
     * true or false, depending on whether they use a reusable picklist.
     */
    Map<String, Boolean> createDoesFieldUsePicklistMap() {
        Map<String, Boolean> theMap = new Map<String, Boolean>();
        theMap = new Map<String, Boolean>();
        for (String fieldName : fieldNamesFixedOrder) {
            if (picklistsByField.containsKey(fieldName)) {
                theMap.put(fieldName, true);
            } else {
                theMap.put(fieldName, false);
            }
        }
        return theMap;
    }
    
    /* 
     * Accumulates reusable picklist options in a sortable form, by picklist
     */
    Map<String, ReusablePicklistOption__mdt[]> getPicklistOptionsByPicklist() {
        ReusablePicklist__mdt[] picklists = [SELECT NamespacePrefix,
                                                  DeveloperName,
                                                  QualifiedApiName, 
                                                  AlphaSort__c
                                              FROM ReusablePicklist__mdt
                                              WHERE QualifiedApiName IN :picklistsByField.values()];
        Map<String, ReusablePicklistOption__mdt[]> theMap = new Map<String, ReusablePicklistOption__mdt[]>();
        for (ReusablePicklist__mdt picklist : picklists) {
            String selectAndFrom = 'SELECT QualifiedApiName, Label, SortOrder__c FROM ReusablePicklistOption__mdt ';
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
            theMap.put(picklist.QualifiedApiName, options);
        }
        return theMap;
    }
    
}