//SeeAllData needed to see EntityDefinitions
@IsTest(SeeAllData = true)
public class BLDR_TabCreateTest {
    static BLDR_ToolingOrMdServiceMock toolingMock {get; set;}
    
    public static testmethod void testInitialSetup() {
        BLDR_TabCreateController ctrlr  = setup(false);
        PageReference expected = Page.ReusablePicklistTab;
        expected.getParameters().put('type', ReusablePicklistTestUtil.getTestDataObjectName());
        System.assertEquals(expected.getUrl(), ctrlr.tab.url);
        //+1 for the "--select--" entry
        System.assertEquals(toolingMock.motifs.size() + 1, ctrlr.motifs.size());
    }
    
    public static testmethod void testCheckTabIsNeeded() {
        BLDR_TabCreateController ctrlr = setup(false);
        System.assertEquals(null, ctrlr.checkTabNeeded());
    }
    
    public static testmethod void testCheckTabIsntNeeded() {
        BLDR_TabCreateController ctrlr = setup(true);
        PageReference expected = Page.BLDR_PicklistDetail;
        expected.getParameters().put('apiName', 
                                     ReusablePicklistTestUtil.getDevNamespaceWithSep() + 'TestPicklistNonAlpha');
    	System.assertEquals(expected.getUrl(), ctrlr.checkTabNeeded().getUrl());
    }
    
    public static testmethod void testCreate() {
        BLDR_TabCreateController ctrlr = setup(false);
        ctrlr.createTab();
        System.assert(toolingMock.delegate.didCreate);
    }
    
    static BLDR_TabCreateController setup(boolean findTab) {
        toolingMock = new BLDR_ToolingOrMdServiceMock(findTab);
        Test.setMock(WebServiceMock.class, toolingMock);
        Id entityId = [SELECT Id 
                       FROM EntityDefinition 
                       WHERE QualifiedApiName=:ReusablePicklistTestUtil.getTestDataObjectName()].Id;
        PageReference createTab = Page.BLDR_TabCreate;
        createTab.getParameters().put('entityDefId', entityId);
        
        createTab.getParameters().put('picklistName', 
                                         ReusablePicklistTestUtil.getDevNamespaceWithSep() + 'TestPicklistNonAlpha');
        Test.setCurrentPage(createTab);
        return new BLDR_TabCreateController();
    }
}