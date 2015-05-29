@IsTest
public class BLDR_OptionCreateTest {
    static BLDR_MetadataServiceMock mock {get; set;}
    
    public static testmethod void testSave() {
        BLDR_OptionCreateController ctrlr = setup();
        ctrlr.option.recordLabel = 'The best option!';
        ctrlr.save();
        System.assert(mock.didCreate);
    }

    static BLDR_OptionCreateController setup() {
        mock = new BLDR_MetadataServiceMock();
        Test.setMock(WebServiceMock.class, mock);
        PageReference optionCreate = Page.BLDR_OptionCreate;
        optionCreate.getParameters().put('picklistApiName', 
                                         ReusablePicklistTestUtil.getDevNamespaceWithSep() + 'TestPicklistNonAlpha');
        Test.setCurrentPage(optionCreate);
        return new BLDR_OptionCreateController();
    }
}