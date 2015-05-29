public class BLDR_ReusablePicklistsListController {
    public final List<ReusablePicklist__mdt> picklists {public get; set;}
    public String selectedApiName {get; public set;}
    public Id selectedId {get; public set;}
    public final String picklistPrefix {public get; set;}
    
    public BLDR_ReusablePicklistsListController() {
        picklists = [SELECT Id, QualifiedApiName, NamespacePrefix, DeveloperName, Label 
                     from ReusablePicklist__mdt 
                     ORDER BY QualifiedApiName];
        BLDR_MetadataUtil.checkMetadataAPIConnection();
        picklistPrefix = BLDR_MetadataUtil.reusablePicklistPrefix;
    }
    
    public Map<String, Boolean> getIsCmdEditable() {
        return BLDR_MetadataUtil.isCmdEditable;
    }
    
    public Map<String, Boolean> getIsCmdDeletable() {
        return BLDR_MetadataUtil.isCmdDeletable;
    }
    
    public PageReference detail() {
        PageReference detailPage = Page.BLDR_PicklistDetail;
        detailPage.getParameters().put('apiName', selectedApiName);
        return detailPage;
    }
    
    public PageReference edit() {
        PageReference editPage = Page.BLDR_PicklistEdit;
        editPage.getParameters().put('id', selectedId);
        editPage.getParameters().put('cancelUrl', ApexPages.currentPage().getUrl());
        return editPage;
    }
    
    public PageReference deletePicklist() {
        return new BLDR_PicklistDeleter(selectedId).doDelete();
    }
}