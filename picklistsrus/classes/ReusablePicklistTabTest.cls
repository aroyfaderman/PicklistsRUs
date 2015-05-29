@IsTest
public class ReusablePicklistTabTest {
    
    public static final String RECORD_NAME_PREF = 'Test Record ';
        
    public static testmethod void testInitialRenderExistingRecords() {
        System.runAs(ReusablePicklistTestUtil.createTestingEndUser()) {
            ReusablePicklistTestUtil.createData();
            Test.setCurrentPage(ReusablePicklistTestUtil.getTab());
            ReusablePicklistTabController ctrlr = 
                new ReusablePicklistTabController();
            Set<String> nameSet = new Set<String>();
            for (Integer i=0; i<2; i++) {
                nameSet.add(ReusablePicklistTestUtil.RECORD_NAME_PREF + (i+1));
            }
            for (SObject record : ctrlr.records) {
                System.assert(nameSet.remove((String) record.get('Name')),
                              'Found spurious record: ' + record.get('Name'));
            }
            System.assert(nameSet.isEmpty(),
                          'Failed to find records: ' + nameSet);
        }
    }
    
    public static testmethod void testInitialRenderNoExistingRecords() {
        System.runAs(ReusablePicklistTestUtil.createTestingEndUser()) {
            Test.setCurrentPage(ReusablePicklistTestUtil.getTab());
            ReusablePicklistTabController ctrlr = 
                new ReusablePicklistTabController();
            System.assert(ctrlr.records.isEmpty(),
                          'Records list should have been empty.');
        }
    }
    
    public static testmethod void testCreateButton() {
        System.runAs(ReusablePicklistTestUtil.createTestingEndUser()) {
            Test.setCurrentPage(ReusablePicklistTestUtil.getTab());
            PageReference expected = Page.ReusablePicklistEngine;
            Map<String, String> params = expected.getParameters();
            params.put('type', ReusablePicklistTestUtil.getTestDataObjectName());
            params.put('retUrl', 
                       ReusablePicklistTestUtil.getTab().getUrl());
            ReusablePicklistTabController ctrlr = 
                new ReusablePicklistTabController();
            PageReference create = ctrlr.create();
            System.assertEquals(expected.getUrl(),
                                create.getUrl());
        }
    }
    
    public static testmethod void testDetailLink() {
        System.runAs(ReusablePicklistTestUtil.createTestingEndUser()) {
            Id firstId = ReusablePicklistTestUtil.createData().get(0).Id;
            Test.setCurrentPage(ReusablePicklistTestUtil.getTab());
            PageReference expected = ReusablePicklistTestUtil.getDetail(firstId);
            ReusablePicklistTabController ctrlr = 
                new ReusablePicklistTabController();
            ctrlr.selected = firstId;
            PageReference detail = ctrlr.detail();
            System.assertEquals(expected.getUrl(), detail.getUrl());
        }
    }
    
    public static testmethod void testEditLink() {
        System.runAs(ReusablePicklistTestUtil.createTestingEndUser()) {
            Id firstId = ReusablePicklistTestUtil.createData().get(0).Id;
            Test.setCurrentPage(ReusablePicklistTestUtil.getTab());
            PageReference expected = Page.ReusablePicklistEngine;
            Map<String, String> params = expected.getParameters();
            params.put('id', firstId);
            params.put('e', '');
            params.put('retUrl', 
                       ReusablePicklistTestUtil.getTab().getUrl());
            ReusablePicklistTabController ctrlr = 
                new ReusablePicklistTabController();
            ctrlr.selected = firstId;
            PageReference edit = ctrlr.edit();
            System.assertEquals(expected.getUrl(), edit.getUrl());
        }
    }
    
    public static testmethod void testDeleteLink() {
        System.runAs(ReusablePicklistTestUtil.createTestingEndUser()) {
            PicklistTestData__c[] data = ReusablePicklistTestUtil.createData();
            PicklistTestData__c expectedRemaining = data.get(1);
            Test.setCurrentPage(ReusablePicklistTestUtil.getTab());
            ReusablePicklistTabController ctrlr = 
                new ReusablePicklistTabController();
            ctrlr.selected = data.get(0).Id;
            ctrlr.remove();
            PicklistTestData__c[] dataNow = [SELECT Id, Name 
                                             FROM PicklistTestData__c];
            System.assertEquals(1, dataNow.size(), 
                                'Expected one row remaining in DB, was ' + dataNow.size());
            System.assertEquals(expectedRemaining.Id, dataNow.get(0).Id);
            System.assertEquals(1, ctrlr.records.size(), 
                                'Expected one row remaining in controller list, was '
                                  + ctrlr.records.size());
            System.assertEquals(expectedRemaining.get('Name'), 
                                ctrlr.records.get(0).get('Name'));
        }
    }    
}