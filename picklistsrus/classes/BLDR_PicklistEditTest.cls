@IsTest
public class BLDR_PicklistEditTest {
    static BLDR_MetadataServiceMock mock {get; set;}
    
    public static testmethod void testAlphaToNonAlpha() {
        BLDR_PicklistEditController ctrlr = setup(true);
        ctrlr.picklist.setAlphaSort(false);
        ctrlr.save();
        System.assert(mock.didUpdate);
    }
    
    public static testmethod void testNonAlphaToAlpha() {
        BLDR_PicklistEditController ctrlr = setup(false);
        ctrlr.picklist.setAlphaSort(true);
        ctrlr.save();
        System.assert(mock.didUpdate);
    }
    
    public static testmethod void testRename() {
        BLDR_PicklistEditController ctrlr = setup(true);
        ctrlr.picklist.recordDevName='NewRecordDevName';
        ctrlr.save();
        system.assert(mock.didRename);
        System.assert(mock.didUpdate);
    }
    
    static BLDR_PicklistEditController setup(boolean startWithAlpha) {
        mock = new BLDR_MetadataServiceMock();
        Test.setMock(WebServiceMock.class, mock);
        PageReference pickEdit = Page.BLDR_PicklistEdit;
        String picklistApiName = ReusablePicklistTestUtil.getDevNamespaceWithSep() + 
            (startWithAlpha?'TestPicklistAlpha':'TestPicklistNonAlpha');
        pickEdit.getParameters().put('id',
                                  [SELECT Id FROM ReusablePicklist__mdt
                                   WHERE QualifiedApiName = :picklistApiName].Id);
        pickEdit.getParameters().put('cancelUrl', Page.BLDR_ReusablePicklistsList.getUrl());
        Test.setCurrentPage(pickEdit);
        return new BLDR_PicklistEditController();
    }
}