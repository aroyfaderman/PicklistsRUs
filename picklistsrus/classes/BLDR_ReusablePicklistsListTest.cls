@isTest
public class BLDR_ReusablePicklistsListTest {
    
    static BLDR_MetadataServiceMock mock {get; set;}
    
    public static testmethod void testInitialDisplayPropertiesUnmanaged() {
        BLDR_ReusablePicklistsListController cntlr = setup('unmanaged');
        checkInitialDisplayProperties(cntlr, true, true);
    }
    
    public static testmethod void testInitialDisplayPropertiesReleased() {
        BLDR_ReusablePicklistsListController cntlr = setup('released');
        checkInitialDisplayProperties(cntlr, true, false);
    }
    
    public static testmethod void testInitialDisplayPropertiesInstalled() {
        BLDR_ReusablePicklistsListController cntlr = setup('installed');
        checkInitialDisplayProperties(cntlr, false, false);
    }
    
    public static testmethod void testDetail() {
        BLDR_ReusablePicklistsListController cntlr = setup('unmanaged');
        cntlr.selectedApiName = 'TestingName';
        PageReference expected = Page.BLDR_PicklistDetail;
        expected.getParameters().put('apiName', cntlr.selectedApiName);
        System.assertEquals(expected.getUrl(), cntlr.detail().getUrl());
    }
    
    public static testmethod void testEdit() {
        BLDR_ReusablePicklistsListController cntlr = setup('unmanaged');
        setSelectedIdToTestAlpha(cntlr);
        PageReference expected = Page.BLDR_PicklistEdit;
        expected.getParameters().put('id', cntlr.selectedId);
        expected.getParameters().put('cancelUrl', Page.BLDR_ReusablePicklistsList.getUrl());
        System.assertEquals(expected.getUrl(), cntlr.edit().getUrl());
    }
    
    public static testmethod void testDelete() {
        BLDR_ReusablePicklistsListController cntlr = setup('unmanaged');
        setSelectedIdToTestAlpha(cntlr);
        cntlr.deletePicklist();
        System.assert(mock.didDelete);
    }
    
    static void setSelectedIdToTestAlpha(BLDR_ReusablePicklistsListController cntlr) {
        String picklistApiName = ReusablePicklistTestUtil.getDevNamespaceWithSep() + 'TestPicklistAlpha';
        cntlr.selectedId = [SELECT Id FROM ReusablePicklist__mdt WHERE QualifiedApiName = :picklistApiName].Id;
    }
    
    static void checkInitialDisplayProperties(BLDR_ReusablePicklistsListController cntlr, 
                                              boolean shouldBeEditable, 
                                              boolean shouldBeDeletable) 
    {
        System.assertEquals(shouldBeEditable, 
                            cntlr.getIsCmdEditable().get(BLDR_MetadataServiceMock.C_M_FULL_NAMES[0]));
        System.assertEquals(shouldBeDeletable, 
                            cntlr.getIsCmdDeletable().get(BLDR_MetadataServiceMock.C_M_FULL_NAMES[0]));
        
    }
    
    static BLDR_ReusablePicklistsListController setup(String managedState) {
        mock = new BLDR_MetadataServiceMock().managedState(managedState);
        Test.setMock(WebServiceMock.class, mock);
        Test.setCurrentPage(Page.BLDR_ReusablePicklistsList);
        return new BLDR_ReusablePicklistsListController();
    }
}