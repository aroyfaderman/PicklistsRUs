@IsTest
public class BLDR_ReusablePicklistsTabTest {
    public static testmethod void testCheckMdApiSucceeds() {
        BLDR_ReusablePicklistsTabController cntlr = setup();
        PageReference result = cntlr.checkMdApi();
        System.assertEquals(Page.BLDR_ReusablePicklistsList.getUrl(), result.getUrl());
    }
    
    public static testmethod void testCheckMdApiFails() {
        BLDR_ReusablePicklistsTabController cntlr = setup();
        ApexPages.currentPage().getHeaders().put('Host', 'na1.salesforce.com');
        BLDR_MetadataUtil.mdApiStatus = BLDR_MetadataUtil.Status.UNAVAILABLE;
        try {
            PageReference result = cntlr.checkMdApi();
            System.assertEquals(result, null);
            System.assertEquals('na1', cntlr.prefixOrLocal);
        } finally {
            BLDR_MetadataUtil.mdApiStatus = BLDR_MetadataUtil.Status.NOT_CHECKED;
        }
    }
    
    public static testmethod void testDisplayMetadataResponse() {
        BLDR_ReusablePicklistsTabController cntlr = setup();
        cntlr.metadataResponse = '';
        cntlr.displayMetadataResponse();
        System.assert(!cntlr.metadataConnectionWarning);
        cntlr.metadataResponse = 'Danger, Will Robinson!';
        cntlr.displayMetadataResponse();
        System.assert(cntlr.metadataConnectionWarning);
    }
    
    static BLDR_ReusablePicklistsTabController setup() {
        Test.setMock(WebServiceMock.class, new BLDR_MetadataServiceMock());
        Test.setCurrentPage(Page.BLDR_ReusablePicklistsTab);
        return new BLDR_ReusablePicklistsTabController();
    }
}