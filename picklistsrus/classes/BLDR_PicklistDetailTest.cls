//We need SeeAllData to see EntityDefinition and FieldDefinition data
@IsTest(SeeAllData = true)
public class BLDR_PicklistDetailTest {
	static BLDR_MetadataServiceMock mock {get; set;}
    
    public static testmethod void testOptionsNonAlphaPickUnmanaged() {
        BLDR_PicklistDetailController ctrlr = setup('unmanaged', false);
        System.assertEquals(2, ctrlr.pickOptions.size());
        assertMoveDownMoveUpOptions(ctrlr, true);
    }
    
    public static testmethod void testOptionsNonAlphaPickInstalled() {
        BLDR_PicklistDetailController ctrlr = setup('installed', false);
        assertMoveDownMoveUpOptions(ctrlr, false);
    }
    
    public static testmethod void testOptionsAlphaPick() {
        BLDR_PicklistDetailController ctrlr = setup('unmanaged', true);
        System.assertEquals(2, ctrlr.pickOptions.size());
        assertMoveDownMoveUpOptions(ctrlr, false);
    }
    
    public static testmethod void testMoveDown() {
        BLDR_PicklistDetailController ctrlr = setup('unmanaged', false);
        ctrlr.selected = ctrlr.pickOptions[0].id;
        ctrlr.moveDown();
        System.assert(mock.didUpdate);
    }
    
    public static testmethod void testMoveUp() {
        BLDR_PicklistDetailController ctrlr = setup('unmanaged', false);
        ctrlr.selected = ctrlr.pickOptions[1].id;
        ctrlr.moveUp();
        System.assert(mock.didUpdate);
    }
    
    public static testmethod void testCreateOption() {
        BLDR_PicklistDetailController ctrlr = setup('installed', true);
        PageReference expected = Page.BLDR_OptionCreate;
        expected.getParameters().put('picklistApiName', ctrlr.picklist.QualifiedApiName);
        System.assertEquals(expected.getUrl(), ctrlr.createOption().getUrl());
    }
    
    public static testmethod void testCreateUsage() {
        BLDR_PicklistDetailController ctrlr = setup('installed', true);
        PageReference expected = Page.BLDR_UsageCreate;
        expected.getParameters().put('picklistApiName', ctrlr.picklist.QualifiedApiName);
        System.assertEquals(expected.getUrl(), ctrlr.createUsage().getUrl());
    }
    
    public static testmethod void testRenameOption() {
        BLDR_PicklistDetailController ctrlr = setup('installed', true);
        ctrlr.selected = ctrlr.pickOptions[0].id;
        PageReference expected = Page.BLDR_OptionRename;
        expected.getParameters().put('id', ctrlr.selected);
        expected.getParameters().put('picklistApiName', ctrlr.picklist.QualifiedApiName);
        System.assertEquals(expected.getUrl(), ctrlr.renameOption().getUrl());
    }
    
    public static testmethod void testDeleteOption() {
        BLDR_PicklistDetailController ctrlr = setup('unmanaged', true);
        ctrlr.selected = ctrlr.pickOptions[0].id;
        ctrlr.deleteOption();
        System.assert(mock.didDelete);
    }
    
    public static testmethod void testDeleteUsage() {
        BLDR_PicklistDetailController ctrlr = setup('unmanaged', true);
        ctrlr.selected = ctrlr.pickUsages[0].id;
        ctrlr.deleteUsage();
        System.assert(mock.didDelete);
    }
    
    public static testmethod void testEdit() {
        BLDR_PicklistDetailController ctrlr = setup('unmanaged', true);
        PageReference expected = Page.BLDR_PicklistEdit;
        expected.getParameters().put('id', ctrlr.picklist.Id);
        expected.getParameters().put('cancelUrl', ApexPages.currentPage().getUrl());
        System.assertEquals(expected.getUrl(), ctrlr.edit().getUrl());
    }
    
    public static testmethod void testDeletePicklist() {
        BLDR_PicklistDetailController ctrlr = setup('unmanaged', true);
        ctrlr.deletePicklist();
        System.assert(mock.didDelete);
    }
    
    public static testmethod void testBackToList() {
        BLDR_PicklistDetailController ctrlr = setup('unmanaged', true);
        System.assertEquals(Page.BLDR_ReusablePicklistsList.getUrl(), ctrlr.backToList().getUrl());
    }
    
    public static testmethod void testIsDeletableUnmanaged() {
        BLDR_PicklistDetailController ctrlr = setup('unmanaged', true);
        System.assert(ctrlr.getIsCmdDeletable().get(BLDR_MetadataServiceMock.C_M_FULL_NAMES[0]));
    }
    
    public static testmethod void testIsDeletableReleased() {
        BLDR_PicklistDetailController ctrlr = setup('released', true);
        System.assert(!ctrlr.getIsCmdDeletable().get(BLDR_MetadataServiceMock.C_M_FULL_NAMES[0]));
    }
    
    public static testmethod void testGetNewUsageLabel() {
        BLDR_PicklistDetailController ctrlr = setup('unmanaged', true);
        System.assertEquals('Use for Another Field', ctrlr.getNewUsageLabel());
    }
    
    static void assertMoveDownMoveUpOptions(BLDR_PicklistDetailController ctrlr, Boolean canMoveAny) {
        System.assert(!ctrlr.optionCanBeMovedDown.get(ctrlr.pickOptions[1].Id));
        System.assert(!ctrlr.optionCanBeMovedUp.get(ctrlr.pickOptions[0].Id));
        System.assertEquals(canMoveAny, ctrlr.optionCanBeMovedDown.get(ctrlr.pickOptions[0].Id));
        System.assertEquals(canMoveAny, ctrlr.optionCanBeMovedUp.get(ctrlr.pickOptions[1].Id));
    }
    
    static BLDR_PicklistDetailController setup(String managedState, boolean alphaPick) {
        mock = new BLDR_MetadataServiceMock().managedState(managedState);
        Test.setMock(WebServiceMock.class, mock);
        PageReference detail = Page.BLDR_PicklistDetail;
        String picklistApiName = ReusablePicklistTestUtil.getDevNamespaceWithSep() + 
            (alphaPick?'TestPicklistAlpha':'TestPicklistNonAlpha');
        detail.getParameters().put('apiName', picklistApiName);
        Test.setCurrentPage(detail);
        return new BLDR_PicklistDetailController();
    }
}