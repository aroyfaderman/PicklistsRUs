@IsTest
public class ReusablePicklistCreateTest {
    public static testmethod void testCreateRender() {
        System.runAs(ReusablePicklistTestUtil.createTestingEndUser()) {
            goToCreatePage();
            ReusablePicklistController ctrlr = new ReusablePicklistController();
            ReusablePicklistTestUtil.doControllerCommonAsserts(ctrlr);
            System.assert(!ctrlr.readOnly, 'Create page was read-only');
            System.assertEquals('New Picklist Test Object', ctrlr.getTitle());
        }
    }
    
    public static testMethod void testCancelButton() {
        System.runAs(ReusablePicklistTestUtil.createTestingEndUser()) {
            goToCreatePage();
            ReusablePicklistController ctrlr = new ReusablePicklistController();
            System.assertEquals(ReusablePicklistTestUtil.getTab().getUrl(),
                                ctrlr.cancel().getUrl());
        }
    }
    
    public static testMethod void testSave() {
        System.runAs(ReusablePicklistTestUtil.createTestingEndUser()) {
            goToCreatePage();
            ReusablePicklistController ctrlr = new ReusablePicklistController();
            PicklistTestData__c record = (PicklistTestData__c) ctrlr.record;
            setupRecordData(record);
            PageReference result = ctrlr.save();
            System.assertEquals(ReusablePicklistTestUtil.getDetail(record.Id)
                                .getUrl(), result.getUrl());
            assertRecordSaved(record);
        }
        
    }
    
    public static testmethod void testSaveAndNew() {
        System.runAs(ReusablePicklistTestUtil.createTestingEndUser()) {
            goToCreatePage();
            PageReference createPageRef = ApexPages.currentPage();
            ReusablePicklistController ctrlr = new ReusablePicklistController();
            PicklistTestData__c record = (PicklistTestData__c) ctrlr.record;
            setupRecordData(record);
            PageReference result = ctrlr.saveAndNew();
            System.assertEquals(createPageRef.getUrl(), result.getUrl());
            
            assertRecordSaved(record);
        }
    }
    
    static void goToCreatePage() {
        Test.setCurrentPage(ReusablePicklistTestUtil.getTab());
        ReusablePicklistTabController ctrlr = new ReusablePicklistTabController();
        Test.setCurrentPage(ctrlr.create());
    }
        
    static void setupRecordData(PicklistTestData__c record) {
        record.Name = 'Testing Testing';
        record.AlphaTestField__c = 'AlphaTestValue1';
        record.NonAlphaTestField__c = 'NonAlphaTestValue1';
    }
    
    static void assertRecordSaved(PicklistTestData__c record) {
        PicklistTestData__c asSaved = [SELECT Name, AlphaTestField__c,
                                              NonAlphaTestField__c
                                        FROM PicklistTestData__c
                                        WHERE Id = :record.Id];
        System.assertEquals(record.Name, asSaved.Name);
        System.assertEquals(record.AlphaTestField__c, asSaved.AlphaTestField__c);
        System.assertEquals(record.NonAlphaTestField__c,
                            asSaved.NonAlphaTestField__c);
    }
}