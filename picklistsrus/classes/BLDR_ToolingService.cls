//Generated by wsdl2apex

public class BLDR_ToolingService {

    
    public class ChildRelationship {
        public Boolean cascadeDelete;
        public String childSObject;
        public Boolean deprecatedAndHidden;
        public String field;
        public String junctionIdListName;
        public String[] junctionReferenceTo;
        public String relationshipName;
        public Boolean restrictedDelete;
        private String[] cascadeDelete_type_info = new String[]{'cascadeDelete','urn:tooling.soap.sforce.com',null,'1','1','false'};
        private String[] childSObject_type_info = new String[]{'childSObject','urn:tooling.soap.sforce.com',null,'1','1','false'};
        private String[] deprecatedAndHidden_type_info = new String[]{'deprecatedAndHidden','urn:tooling.soap.sforce.com',null,'1','1','false'};
        private String[] field_type_info = new String[]{'field','urn:tooling.soap.sforce.com',null,'1','1','false'};
        private String[] junctionIdListName_type_info = new String[]{'junctionIdListName','urn:tooling.soap.sforce.com',null,'0','1','false'};
        private String[] junctionReferenceTo_type_info = new String[]{'junctionReferenceTo','urn:tooling.soap.sforce.com',null,'0','-1','false'};
        private String[] relationshipName_type_info = new String[]{'relationshipName','urn:tooling.soap.sforce.com',null,'0','1','false'};
        private String[] restrictedDelete_type_info = new String[]{'restrictedDelete','urn:tooling.soap.sforce.com',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:tooling.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'cascadeDelete','childSObject','deprecatedAndHidden','field','junctionIdListName','junctionReferenceTo','relationshipName','restrictedDelete'};
    }

    public virtual class sObject_x {
        public String[] fieldsToNull;
        public String Id;
        private String[] fieldsToNull_type_info = new String[]{'fieldsToNull','urn:tooling.soap.sforce.com',null,'0','-1','true'};
        private String[] Id_type_info = new String[]{'Id','urn:tooling.soap.sforce.com',null,'1','1','true'};
        private String[] apex_schema_type_info = new String[]{'urn:tooling.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'fieldsToNull','Id'};
    }

    public class FilteredLookupInfo {
        public String[] controllingFields;
        public Boolean dependent;
        public Boolean optionalFilter;
        private String[] controllingFields_type_info = new String[]{'controllingFields','urn:tooling.soap.sforce.com',null,'0','-1','false'};
        private String[] dependent_type_info = new String[]{'dependent','urn:tooling.soap.sforce.com',null,'1','1','false'};
        private String[] optionalFilter_type_info = new String[]{'optionalFilter','urn:tooling.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:tooling.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'controllingFields','dependent','optionalFilter'};
    }
    
    public class Field {
        public Boolean autoNumber;
        public Integer byteLength;
        public Boolean calculated;
        public String calculatedFormula;
        public Boolean cascadeDelete;
        public Boolean caseSensitive;
        public String controllerName;
        public Boolean createable;
        public Boolean custom;
        public String defaultValueFormula;
        public Boolean defaultedOnCreate;
        public Boolean dependentPicklist;
        public Boolean deprecatedAndHidden;
        public Integer digits;
        public Boolean displayLocationInDecimal;
        public Boolean encrypted;
        public Boolean externalId;
        public String extraTypeInfo;
        public Boolean filterable;
        public BLDR_ToolingService.FilteredLookupInfo filteredLookupInfo;
        public Boolean groupable;
        public Boolean highScaleNumber;
        public Boolean htmlFormatted;
        public Boolean idLookup;
        public String inlineHelpText;
        public String label;
        public Integer length;
        public String mask;
        public String maskType;
        public String name;
        public Boolean nameField;
        public Boolean namePointing;
        public Boolean nillable;
        public Boolean permissionable;
        public BLDR_ToolingService.PicklistEntry[] picklistValues;
        public Integer precision;
        public String referenceTargetField;
        public String[] referenceTo;
        public String relationshipName;
        public Integer relationshipOrder;
        public Boolean restrictedDelete;
        public Boolean restrictedPicklist;
        public Integer scale;
        public String soapType;
        public Boolean sortable;
        public String type_x;
        public Boolean unique;
        public Boolean updateable;
        public Boolean writeRequiresMasterRead;
        private String[] autoNumber_type_info = new String[]{'autoNumber','urn:tooling.soap.sforce.com',null,'1','1','false'};
        private String[] byteLength_type_info = new String[]{'byteLength','urn:tooling.soap.sforce.com',null,'1','1','false'};
        private String[] calculated_type_info = new String[]{'calculated','urn:tooling.soap.sforce.com',null,'1','1','false'};
        private String[] calculatedFormula_type_info = new String[]{'calculatedFormula','urn:tooling.soap.sforce.com',null,'0','1','false'};
        private String[] cascadeDelete_type_info = new String[]{'cascadeDelete','urn:tooling.soap.sforce.com',null,'0','1','false'};
        private String[] caseSensitive_type_info = new String[]{'caseSensitive','urn:tooling.soap.sforce.com',null,'1','1','false'};
        private String[] controllerName_type_info = new String[]{'controllerName','urn:tooling.soap.sforce.com',null,'0','1','false'};
        private String[] createable_type_info = new String[]{'createable','urn:tooling.soap.sforce.com',null,'1','1','false'};
        private String[] custom_type_info = new String[]{'custom','urn:tooling.soap.sforce.com',null,'1','1','false'};
        private String[] defaultValueFormula_type_info = new String[]{'defaultValueFormula','urn:tooling.soap.sforce.com',null,'0','1','false'};
        private String[] defaultedOnCreate_type_info = new String[]{'defaultedOnCreate','urn:tooling.soap.sforce.com',null,'1','1','false'};
        private String[] dependentPicklist_type_info = new String[]{'dependentPicklist','urn:tooling.soap.sforce.com',null,'0','1','false'};
        private String[] deprecatedAndHidden_type_info = new String[]{'deprecatedAndHidden','urn:tooling.soap.sforce.com',null,'1','1','false'};
        private String[] digits_type_info = new String[]{'digits','urn:tooling.soap.sforce.com',null,'1','1','false'};
        private String[] displayLocationInDecimal_type_info = new String[]{'displayLocationInDecimal','urn:tooling.soap.sforce.com',null,'0','1','false'};
        private String[] encrypted_type_info = new String[]{'encrypted','urn:tooling.soap.sforce.com',null,'0','1','false'};
        private String[] externalId_type_info = new String[]{'externalId','urn:tooling.soap.sforce.com',null,'0','1','false'};
        private String[] extraTypeInfo_type_info = new String[]{'extraTypeInfo','urn:tooling.soap.sforce.com',null,'0','1','false'};
        private String[] filterable_type_info = new String[]{'filterable','urn:tooling.soap.sforce.com',null,'1','1','false'};
        private String[] filteredLookupInfo_type_info = new String[]{'filteredLookupInfo','urn:tooling.soap.sforce.com',null,'0','1','false'};
        private String[] groupable_type_info = new String[]{'groupable','urn:tooling.soap.sforce.com',null,'1','1','false'};
        private String[] highScaleNumber_type_info = new String[]{'highScaleNumber','urn:tooling.soap.sforce.com',null,'0','1','false'};
        private String[] htmlFormatted_type_info = new String[]{'htmlFormatted','urn:tooling.soap.sforce.com',null,'0','1','false'};
        private String[] idLookup_type_info = new String[]{'idLookup','urn:tooling.soap.sforce.com',null,'1','1','false'};
        private String[] inlineHelpText_type_info = new String[]{'inlineHelpText','urn:tooling.soap.sforce.com',null,'0','1','false'};
        private String[] label_type_info = new String[]{'label','urn:tooling.soap.sforce.com',null,'1','1','false'};
        private String[] length_type_info = new String[]{'length','urn:tooling.soap.sforce.com',null,'1','1','false'};
        private String[] mask_type_info = new String[]{'mask','urn:tooling.soap.sforce.com',null,'0','1','false'};
        private String[] maskType_type_info = new String[]{'maskType','urn:tooling.soap.sforce.com',null,'0','1','false'};
        private String[] name_type_info = new String[]{'name','urn:tooling.soap.sforce.com',null,'1','1','false'};
        private String[] nameField_type_info = new String[]{'nameField','urn:tooling.soap.sforce.com',null,'1','1','false'};
        private String[] namePointing_type_info = new String[]{'namePointing','urn:tooling.soap.sforce.com',null,'1','1','false'};
        private String[] nillable_type_info = new String[]{'nillable','urn:tooling.soap.sforce.com',null,'1','1','false'};
        private String[] permissionable_type_info = new String[]{'permissionable','urn:tooling.soap.sforce.com',null,'1','1','false'};
        private String[] picklistValues_type_info = new String[]{'picklistValues','urn:tooling.soap.sforce.com',null,'0','-1','false'};
        private String[] precision_type_info = new String[]{'precision','urn:tooling.soap.sforce.com',null,'1','1','false'};
        private String[] referenceTargetField_type_info = new String[]{'referenceTargetField','urn:tooling.soap.sforce.com',null,'0','1','false'};
        private String[] referenceTo_type_info = new String[]{'referenceTo','urn:tooling.soap.sforce.com',null,'0','-1','false'};
        private String[] relationshipName_type_info = new String[]{'relationshipName','urn:tooling.soap.sforce.com',null,'0','1','false'};
        private String[] relationshipOrder_type_info = new String[]{'relationshipOrder','urn:tooling.soap.sforce.com',null,'0','1','false'};
        private String[] restrictedDelete_type_info = new String[]{'restrictedDelete','urn:tooling.soap.sforce.com',null,'0','1','false'};
        private String[] restrictedPicklist_type_info = new String[]{'restrictedPicklist','urn:tooling.soap.sforce.com',null,'1','1','false'};
        private String[] scale_type_info = new String[]{'scale','urn:tooling.soap.sforce.com',null,'1','1','false'};
        private String[] soapType_type_info = new String[]{'soapType','urn:tooling.soap.sforce.com',null,'1','1','false'};
        private String[] sortable_type_info = new String[]{'sortable','urn:tooling.soap.sforce.com',null,'1','1','false'};
        private String[] type_x_type_info = new String[]{'type','urn:tooling.soap.sforce.com',null,'1','1','false'};
        private String[] unique_type_info = new String[]{'unique','urn:tooling.soap.sforce.com',null,'1','1','false'};
        private String[] updateable_type_info = new String[]{'updateable','urn:tooling.soap.sforce.com',null,'1','1','false'};
        private String[] writeRequiresMasterRead_type_info = new String[]{'writeRequiresMasterRead','urn:tooling.soap.sforce.com',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:tooling.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'autoNumber','byteLength','calculated','calculatedFormula','cascadeDelete','caseSensitive','controllerName','createable','custom','defaultValueFormula','defaultedOnCreate','dependentPicklist','deprecatedAndHidden','digits','displayLocationInDecimal','encrypted','externalId','extraTypeInfo','filterable','filteredLookupInfo','groupable','highScaleNumber','htmlFormatted','idLookup','inlineHelpText','label','length','mask','maskType','name','nameField','namePointing','nillable','permissionable','picklistValues','precision','referenceTargetField','referenceTo','relationshipName','relationshipOrder','restrictedDelete','restrictedPicklist','scale','soapType','sortable','type_x','unique','updateable','writeRequiresMasterRead'};
    }

    public class PicklistEntry {
        public Boolean active;
        public Boolean defaultValue;
        public String label;
        public String validFor;
        public String value;
        private String[] active_type_info = new String[]{'active','urn:tooling.soap.sforce.com',null,'1','1','false'};
        private String[] defaultValue_type_info = new String[]{'defaultValue','urn:tooling.soap.sforce.com',null,'1','1','false'};
        private String[] label_type_info = new String[]{'label','urn:tooling.soap.sforce.com',null,'1','1','false'};
        private String[] validFor_type_info = new String[]{'validFor','urn:tooling.soap.sforce.com',null,'0','1','false'};
        private String[] value_type_info = new String[]{'value','urn:tooling.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:tooling.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'active','defaultValue','label','validFor','value'};
    }

    public class describeSObjectResponse_element {
        public BLDR_ToolingService.DescribeSObjectResult result;
        private String[] result_type_info = new String[]{'result','urn:tooling.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:tooling.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }

    public class DataType {
        public String DurableId;
        public BLDR_ToolingService.QueryResult Fields;
        public Boolean IsComplex;
        public String Name;
        public String Namespace;
        public String NamespacePrefix;
        public String ServiceId;
        private String[] DurableId_type_info = new String[]{'DurableId','urn:tooling.soap.sforce.com',null,'0','1','true'};
        private String[] Fields_type_info = new String[]{'Fields','urn:tooling.soap.sforce.com',null,'0','1','true'};
        private String[] IsComplex_type_info = new String[]{'IsComplex','urn:tooling.soap.sforce.com',null,'0','1','true'};
        private String[] Name_type_info = new String[]{'Name','urn:tooling.soap.sforce.com',null,'0','1','true'};
        private String[] Namespace_type_info = new String[]{'Namespace','urn:tooling.soap.sforce.com',null,'0','1','true'};
        private String[] NamespacePrefix_type_info = new String[]{'NamespacePrefix','urn:tooling.soap.sforce.com',null,'0','1','true'};
        private String[] ServiceId_type_info = new String[]{'ServiceId','urn:tooling.soap.sforce.com',null,'0','1','true'};
        private String[] apex_schema_type_info = new String[]{'urn:tooling.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'DurableId','Fields','IsComplex','Name','Namespace','NamespacePrefix','ServiceId'};
    }

    public class describeValueType_element {
        public String type_x;
        private String[] type_x_type_info = new String[]{'type','urn:tooling.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:tooling.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'type_x'};
    }
    
    public class queryResponse_element {
        public BLDR_ToolingService.QueryResult result;
        private String[] result_type_info = new String[]{'result','urn:tooling.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:tooling.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    
    public class QueryResult {
        public Boolean done;
        public String entityTypeName;
        public String nextRecordsUrl;
        public String queryLocator;
        public BLDR_ToolingService.sObject_x[] records;
        public Integer size;
        public Integer totalSize;
        private String[] done_type_info = new String[]{'done','urn:tooling.soap.sforce.com',null,'1','1','false'};
        private String[] entityTypeName_type_info = new String[]{'entityTypeName','urn:tooling.soap.sforce.com',null,'1','1','false'};
        private String[] nextRecordsUrl_type_info = new String[]{'nextRecordsUrl','urn:tooling.soap.sforce.com',null,'0','1','false'};
        private String[] queryLocator_type_info = new String[]{'queryLocator','urn:tooling.soap.sforce.com',null,'1','1','false'};
        private String[] records_type_info = new String[]{'records','urn:tooling.soap.sforce.com',null,'0','-1','false'};
        private String[] size_type_info = new String[]{'size','urn:tooling.soap.sforce.com',null,'1','1','false'};
        private String[] totalSize_type_info = new String[]{'totalSize','urn:tooling.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:tooling.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'done','entityTypeName','nextRecordsUrl','queryLocator','records','size','totalSize'};
    }

    public class SessionHeader_element {
        public String sessionId;
        private String[] sessionId_type_info = new String[]{'sessionId','urn:tooling.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:tooling.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'sessionId'};
    }

    public class describeSObject_element {
        public String type_x;
        private String[] type_x_type_info = new String[]{'type','urn:tooling.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:tooling.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'type_x'};
    }
    
    public class User_x {
    	public BLDR_ToolingService.QueryResult DelegatedUsers;
    	public String FirstName;
		public String LastName;
		public BLDR_ToolingService.QueryResult ManagedUsers;
		public String Name;
		public BLDR_ToolingService.QueryResult UserPreferences;
		public String Username;
		public String WorkspaceId;
		public String[] fieldsToNull;
		public String Id;
		private String[] DelegatedUsers_type_info = new String[]{'DelegatedUsers','urn:tooling.soap.sforce.com',null,'0','1','true'};
		private String[] FirstName_type_info = new String[]{'FirstName','urn:tooling.soap.sforce.com',null,'0','1','true'};
		private String[] LastName_type_info = new String[]{'LastName','urn:tooling.soap.sforce.com',null,'0','1','true'};
		private String[] ManagedUsers_type_info = new String[]{'ManagedUsers','urn:tooling.soap.sforce.com',null,'0','1','true'};
		private String[] Name_type_info = new String[]{'Name','urn:tooling.soap.sforce.com',null,'0','1','true'};
		private String[] UserPreferences_type_info = new String[]{'UserPreferences','urn:tooling.soap.sforce.com',null,'0','1','true'};
		private String[] Username_type_info = new String[]{'Username','urn:tooling.soap.sforce.com',null,'0','1','true'};
		private String[] WorkspaceId_type_info = new String[]{'WorkspaceId','urn:tooling.soap.sforce.com',null,'0','1','true'};
		private String[] fieldsToNull_type_info = new String[]{'fieldsToNull','urn:tooling.soap.sforce.com',null,'0','-1','true'};
		private String[] Id_type_info = new String[]{'Id','urn:tooling.soap.sforce.com',null,'1','1','true'};
		private String[] apex_schema_type_info = new String[]{'urn:tooling.soap.sforce.com','true','false'};
		private String[] field_order_type_info = new String[]{'DelegatedUsers','FirstName','LastName','ManagedUsers','Name','UserPreferences','Username','WorkspaceId','fieldsToNull','Id'};
    }
    
    public class ActionOverride {
        public Boolean isAvailableInTouch;
        public String name;
        public String pageId;
        public String url;
        private String[] isAvailableInTouch_type_info = new String[]{'isAvailableInTouch','urn:tooling.soap.sforce.com',null,'1','1','false'};
        private String[] name_type_info = new String[]{'name','urn:tooling.soap.sforce.com',null,'1','1','false'};
        private String[] pageId_type_info = new String[]{'pageId','urn:tooling.soap.sforce.com',null,'1','1','false'};
        private String[] url_type_info = new String[]{'url','urn:tooling.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:tooling.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'isAvailableInTouch','name','pageId','url'};
    }

    public class NamedLayoutInfo {
        public String name;
        private String[] name_type_info = new String[]{'name','urn:tooling.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:tooling.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'name'};
    }
    
    public class RecordTypeInfo {
        public Boolean available;
        public Boolean defaultRecordTypeMapping;
        public String name;
        public String recordTypeId;
        private String[] available_type_info = new String[]{'available','urn:tooling.soap.sforce.com',null,'1','1','false'};
        private String[] defaultRecordTypeMapping_type_info = new String[]{'defaultRecordTypeMapping','urn:tooling.soap.sforce.com',null,'1','1','false'};
        private String[] name_type_info = new String[]{'name','urn:tooling.soap.sforce.com',null,'1','1','false'};
        private String[] recordTypeId_type_info = new String[]{'recordTypeId','urn:tooling.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:tooling.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'available','defaultRecordTypeMapping','name','recordTypeId'};
    }

    public class MetadataWarningsHeader_element {
        public Boolean ignoreSaveWarnings;
        private String[] ignoreSaveWarnings_type_info = new String[]{'ignoreSaveWarnings','urn:tooling.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:tooling.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'ignoreSaveWarnings'};
    }

    public class query_element {
        public String queryString;
        private String[] queryString_type_info = new String[]{'queryString','urn:tooling.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:tooling.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'queryString'};
    }


    public class DescribeSObjectResult {
        public BLDR_ToolingService.ActionOverride[] actionOverrides;
        public Boolean activateable;
        public BLDR_ToolingService.ChildRelationship[] childRelationships;
        public Boolean createable;
        public Boolean custom;
        public Boolean customSetting;
        public Boolean deletable;
        public Boolean deprecatedAndHidden;
        public Boolean feedEnabled;
        public BLDR_ToolingService.Field[] fields;
        public String keyPrefix;
        public String label;
        public String labelPlural;
        public Boolean layoutable;
        public Boolean listviewable;
        public Boolean lookupLayoutable;
        public Boolean mergeable;
        public String name;
        public BLDR_ToolingService.NamedLayoutInfo[] namedLayoutInfos;
        public Boolean queryable;
        public BLDR_ToolingService.RecordTypeInfo[] recordTypeInfos;
        public Boolean replicateable;
        public Boolean retrieveable;
        public Boolean searchLayoutable;
        public Boolean searchable;
        public Boolean triggerable;
        public Boolean undeletable;
        public Boolean updateable;
        private String[] actionOverrides_type_info = new String[]{'actionOverrides','urn:tooling.soap.sforce.com',null,'0','-1','false'};
        private String[] activateable_type_info = new String[]{'activateable','urn:tooling.soap.sforce.com',null,'1','1','false'};
        private String[] childRelationships_type_info = new String[]{'childRelationships','urn:tooling.soap.sforce.com',null,'0','-1','false'};
        private String[] createable_type_info = new String[]{'createable','urn:tooling.soap.sforce.com',null,'1','1','false'};
        private String[] custom_type_info = new String[]{'custom','urn:tooling.soap.sforce.com',null,'1','1','false'};
        private String[] customSetting_type_info = new String[]{'customSetting','urn:tooling.soap.sforce.com',null,'1','1','false'};
        private String[] deletable_type_info = new String[]{'deletable','urn:tooling.soap.sforce.com',null,'1','1','false'};
        private String[] deprecatedAndHidden_type_info = new String[]{'deprecatedAndHidden','urn:tooling.soap.sforce.com',null,'1','1','false'};
        private String[] feedEnabled_type_info = new String[]{'feedEnabled','urn:tooling.soap.sforce.com',null,'1','1','false'};
        private String[] fields_type_info = new String[]{'fields','urn:tooling.soap.sforce.com',null,'0','-1','false'};
        private String[] keyPrefix_type_info = new String[]{'keyPrefix','urn:tooling.soap.sforce.com',null,'1','1','false'};
        private String[] label_type_info = new String[]{'label','urn:tooling.soap.sforce.com',null,'1','1','false'};
        private String[] labelPlural_type_info = new String[]{'labelPlural','urn:tooling.soap.sforce.com',null,'1','1','false'};
        private String[] layoutable_type_info = new String[]{'layoutable','urn:tooling.soap.sforce.com',null,'1','1','false'};
        private String[] listviewable_type_info = new String[]{'listviewable','urn:tooling.soap.sforce.com',null,'0','1','false'};
        private String[] lookupLayoutable_type_info = new String[]{'lookupLayoutable','urn:tooling.soap.sforce.com',null,'0','1','false'};
        private String[] mergeable_type_info = new String[]{'mergeable','urn:tooling.soap.sforce.com',null,'1','1','false'};
        private String[] name_type_info = new String[]{'name','urn:tooling.soap.sforce.com',null,'1','1','false'};
        private String[] namedLayoutInfos_type_info = new String[]{'namedLayoutInfos','urn:tooling.soap.sforce.com',null,'0','-1','false'};
        private String[] queryable_type_info = new String[]{'queryable','urn:tooling.soap.sforce.com',null,'1','1','false'};
        private String[] recordTypeInfos_type_info = new String[]{'recordTypeInfos','urn:tooling.soap.sforce.com',null,'0','-1','false'};
        private String[] replicateable_type_info = new String[]{'replicateable','urn:tooling.soap.sforce.com',null,'1','1','false'};
        private String[] retrieveable_type_info = new String[]{'retrieveable','urn:tooling.soap.sforce.com',null,'1','1','false'};
        private String[] searchLayoutable_type_info = new String[]{'searchLayoutable','urn:tooling.soap.sforce.com',null,'0','1','false'};
        private String[] searchable_type_info = new String[]{'searchable','urn:tooling.soap.sforce.com',null,'1','1','false'};
        private String[] triggerable_type_info = new String[]{'triggerable','urn:tooling.soap.sforce.com',null,'0','1','false'};
        private String[] undeletable_type_info = new String[]{'undeletable','urn:tooling.soap.sforce.com',null,'1','1','false'};
        private String[] updateable_type_info = new String[]{'updateable','urn:tooling.soap.sforce.com',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:tooling.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'actionOverrides','activateable','childRelationships','createable','custom','customSetting','deletable','deprecatedAndHidden','feedEnabled','fields','keyPrefix','label','labelPlural','layoutable','listviewable','lookupLayoutable','mergeable','name','namedLayoutInfos','queryable','recordTypeInfos','replicateable','retrieveable','searchLayoutable','searchable','triggerable','undeletable','updateable'};
    }


    public class SforceService {
        public String endpoint_x = URL.getSalesforceBaseUrl().toExternalForm() + '/services/Soap/T/34.0';
        public Map<String,String> inputHttpHeaders_x;
        public Map<String,String> outputHttpHeaders_x;
        public String clientCertName_x;
        public String clientCert_x;
        public String clientCertPasswd_x;
        public Integer timeout_x;
        public BLDR_ToolingService.SessionHeader_element SessionHeader;
        private String SessionHeader_hns = 'SessionHeader=urn:tooling.soap.sforce.com';
        private String[] ns_map_type_info = new String[]{'urn:tooling.soap.sforce.com', 'BLDR_ToolingService', 'urn:metadata.tooling.soap.sforce.com', 'BLDR_ToolingServiceMD'};

        public BLDR_ToolingService.DescribeSObjectResult describeSObject(String type_x) {
            BLDR_ToolingService.describeSObject_element request_x = new BLDR_ToolingService.describeSObject_element();
            request_x.type_x = type_x;
            BLDR_ToolingService.describeSObjectResponse_element response_x;
            Map<String, BLDR_ToolingService.describeSObjectResponse_element> response_map_x = new Map<String, BLDR_ToolingService.describeSObjectResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'urn:tooling.soap.sforce.com',
              'describeSObject',
              'urn:tooling.soap.sforce.com',
              'describeSObjectResponse',
              'BLDR_ToolingService.describeSObjectResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.result;
        }
 
        public BLDR_ToolingService.QueryResult query(String queryString) {
            BLDR_ToolingService.query_element request_x = new BLDR_ToolingService.query_element();
            request_x.queryString = queryString;
            BLDR_ToolingService.queryResponse_element response_x;
            Map<String, BLDR_ToolingService.queryResponse_element> response_map_x = new Map<String, BLDR_ToolingService.queryResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'urn:tooling.soap.sforce.com',
              'query',
              'urn:tooling.soap.sforce.com',
              'queryResponse',
              'BLDR_ToolingService.queryResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.result;
        }


    }
}