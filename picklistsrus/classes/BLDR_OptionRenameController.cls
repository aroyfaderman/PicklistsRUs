public class BLDR_OptionRenameController {

    public final BLDR_ReusablePicklistOption option {public get; set;}
    final String picklistApiName {get; set;}
    
    public BLDR_OptionRenameController() {
        option = new BLDR_ReusablePicklistOption(ApexPages.currentPage().getParameters().get('id'));
        picklistApiName = ApexPages.currentPage().getParameters().get('picklistApiName');
    }
    
    public PageReference save() {
        BLDR_MetadataService.SaveResult result = BLDR_MetadataUtil.updateMd(option);
        if (BLDR_MetadataUtil.checkResult(result)) {
        	return getDetail();
        }
        return null;
    }
    
    public PageReference cancel() {
        return getDetail();
    }
    
    PageReference getDetail() {
        PageReference detail = Page.BLDR_PicklistDetail;
        detail.getParameters().put('apiName', picklistApiName);
        return detail;
    }
}