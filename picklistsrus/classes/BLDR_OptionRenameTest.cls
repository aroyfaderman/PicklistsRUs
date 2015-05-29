@IsTest
public class BLDR_OptionRenameTest {
    static BLDR_MetadataServiceMock mock {get; set;}
    
    public static testmethod void testSave() {
        BLDR_OptionRenameController ctrlr = setup();
        ctrlr.option.recordLabel = 'The best option!';
        ctrlr.save();
        System.assert(mock.didUpdate);
    }

    static BLDR_OptionRenameController setup() {
        mock = new BLDR_MetadataServiceMock();
        Test.setMock(WebServiceMock.class, mock);
        PageReference optionRename = Page.BLDR_OptionRename;
        optionRename.getParameters().put('picklistApiName', 
                                         ReusablePicklistTestUtil.getDevNamespaceWithSep() + 'TestPicklistNonAlpha');
        optionRename.getParameters().put('id',
                                        [SELECT Id from ReusablePicklistOption__mdt
                                         WHERE Picklist__c = 'TestPicklistNonAlpha'][0].Id);
        Test.setCurrentPage(optionRename);
        return new BLDR_OptionRenameController();
    }
}