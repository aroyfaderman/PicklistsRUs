@IsTest
public class ReusablePicklistDetailTest {
    public static testmethod void testDetailRender() {
        System.runAs(ReusablePicklistTestUtil.createTestingEndUser()) {
            PicklistTestData__c firstRecord = 
                ReusablePicklistTestUtil.createData().get(0);
            Test.setCurrentPage(
                ReusablePicklistTestUtil.getDetail(firstRecord.id));
            ReusablePicklistController ctrlr = new ReusablePicklistController();
            ReusablePicklistTestUtil.doControllerCommonAsserts(ctrlr);
            System.assert(ctrlr.readOnly, 'Detail page not read-only');
            System.assertEquals(
                'Picklist Test Object: ' + firstRecord.Name,
                ctrlr.getTitle());
    	}
    }
    
    public static testmethod void testEditButton() {
        System.runAs(ReusablePicklistTestUtil.createTestingEndUser()) {
            PicklistTestData__c firstRecord = 
                ReusablePicklistTestUtil.createData().get(0);
            Test.setCurrentPage(
                ReusablePicklistTestUtil.getDetail(firstRecord.id));
            ReusablePicklistController ctrlr = new ReusablePicklistController();
            PageReference expected = Page.ReusablePicklistEngine;
            Map<String, String> params = expected.getParameters();
            params.put('id', firstRecord.id);
            params.put('e', '');
            params.put('retUrl', ApexPages.currentPage().getUrl());
            System.assertEquals(expected.getUrl(), ctrlr.edit().getUrl());
        }
    }
    
    public static testmethod void testDeleteButton() {
        PicklistTestData__c[] records = ReusablePicklistTestUtil.createData();
        Test.setCurrentPage(
            ReusablePicklistTestUtil.getDetail(records.get(0).id));
        ReusablePicklistController ctrlr = new ReusablePicklistController();
        PageReference result = ctrlr.remove();
        System.assertEquals(ReusablePicklistTestUtil.getTab().getUrl(), 
                            result.getUrl());
        PicklistTestData__c[] dataNow = [SELECT Id, Name
                                         FROM PicklistTestData__c];
        System.assertEquals(1, dataNow.size(), 
                            'Expected one row remaining in DB, was '
                                + dataNow.size());
        System.assertEquals(records.get(1).Id, dataNow.get(0).Id);
    }
}