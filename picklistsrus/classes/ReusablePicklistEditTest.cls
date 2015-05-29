@IsTest
public class ReusablePicklistEditTest {
    
    public static testmethod void testCreateRenderFromTab() {
        System.runAs(ReusablePicklistTestUtil.createTestingEndUser()) {
            PicklistTestData__c firstRecord = 
                ReusablePicklistTestUtil.createData().get(0);
            goToEditPageFromTab(firstRecord.Id);
            ReusablePicklistController ctrlr = new ReusablePicklistController();
            ReusablePicklistTestUtil.doControllerCommonAsserts(ctrlr);
            System.assert(!ctrlr.readOnly, 'Create page was read-only');
            System.assertEquals('Edit Picklist Test Object: ' + firstRecord.Name,
                                ctrlr.getTitle());
        }
    }
    
    public static testmethod void testCreateRenderFromDetail() {
        System.runAs(ReusablePicklistTestUtil.createTestingEndUser()) {
            PicklistTestData__c firstRecord = 
                ReusablePicklistTestUtil.createData().get(0);
            goToEditPageFromDetail(firstRecord.Id);
            ReusablePicklistController ctrlr = new ReusablePicklistController();
            ReusablePicklistTestUtil.doControllerCommonAsserts(ctrlr);
            System.assert(!ctrlr.readOnly, 'Create page was read-only');
            System.assertEquals('Edit Picklist Test Object: ' + firstRecord.Name,
                                ctrlr.getTitle());
        }
    }
    
    public static testmethod void testCancelAfterLoadFromTab() {
        System.runAs(ReusablePicklistTestUtil.createTestingEndUser()) {
            PicklistTestData__c firstRecord = 
                ReusablePicklistTestUtil.createData().get(0);
            goToEditPageFromTab(firstRecord.Id);
            ReusablePicklistController ctrlr = new ReusablePicklistController();
            System.assertEquals(ReusablePicklistTestUtil.getTab().getUrl(),
                                ctrlr.cancel().getUrl());
        }
    }
    
    public static testmethod void testCancelAfterLoadFromDetail() {
        System.runAs(ReusablePicklistTestUtil.createTestingEndUser()) {
            PicklistTestData__c firstRecord = 
                ReusablePicklistTestUtil.createData().get(0);
            goToEditPageFromDetail(firstRecord.Id);
            ReusablePicklistController ctrlr = new ReusablePicklistController();
            System.assertEquals(
                ReusablePicklistTestUtil.getDetail(firstRecord.Id).getUrl(),
                ctrlr.cancel().getUrl());
        }
    }
    
    public static testmethod void testCancelAfterSaveAndNewFromTab() {
        System.runAs(ReusablePicklistTestUtil.createTestingEndUser()) {
        	PicklistTestData__c firstRecord = 
                ReusablePicklistTestUtil.createData().get(0);
            goToEditPageFromTab(firstRecord.Id);
            ReusablePicklistController ctrlr1 = new ReusablePicklistController();
            Test.setCurrentPage(ctrlr1.saveAndNew());
            ReusablePicklistController ctrlr2 = new ReusablePicklistController();
            System.assertEquals(ReusablePicklistTestUtil.getTab().getUrl(),
                                ctrlr2.cancel().getUrl());
        }
    }

    public static testmethod void testCancelAfterSaveAndNewFromDetail() {
        System.runAs(ReusablePicklistTestUtil.createTestingEndUser()) {
        	PicklistTestData__c firstRecord = 
                ReusablePicklistTestUtil.createData().get(0);
            goToEditPageFromDetail(firstRecord.Id);
            ReusablePicklistController ctrlr1 = new ReusablePicklistController();
            Test.setCurrentPage(ctrlr1.saveAndNew());
            ReusablePicklistController ctrlr2 = new ReusablePicklistController();
            System.assertEquals(
                ReusablePicklistTestUtil.getDetail(firstRecord.Id).getUrl(),
                ctrlr2.cancel().getUrl());
        }
    }
    
    static void goToEditPageFromTab(Id toEdit) {
        Test.setCurrentPage(ReusablePicklistTestUtil.getTab());
        ReusablePicklistTabController ctrlr = new ReusablePicklistTabController();
        ctrlr.selected = toEdit;
        Test.setCurrentPage(ctrlr.edit());
    }
    
    static void goToEditPageFromDetail(Id toEdit) {
        Test.setCurrentPage(ReusablePicklistTestUtil.getDetail(toEdit));
        ReusablePicklistController ctrlr = new ReusablePicklistController();
        Test.setCurrentPage(ctrlr.edit());
    }
}