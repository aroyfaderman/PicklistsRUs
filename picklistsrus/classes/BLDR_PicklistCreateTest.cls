@IsTest
public class BLDR_PicklistCreateTest {
    static BLDR_MetadataServiceMock mock {get; set;}
    
    public static testmethod void testDefaultName() {
        BLDR_PicklistCreateController ctrlr = setup();
        ctrlr.picklist.recordLabel = '#1 Awesome Picklist!';
        String expectedStart = 'Awesome_Picklist';
        ctrlr.defaultName();
        System.assert(ctrlr.picklist.recordDevName.startsWith(expectedStart));
        if (expectedStart.length() < ctrlr.picklist.recordDevName.length()) {
            String suffix = ctrlr.picklist.recordDevName.substring(expectedStart.length());
            //Will throw an exception if the remainder isn't numeric
            Integer.valueOf(suffix);
        }
    }
    
    public static testmethod void testSave() {
        BLDR_PicklistCreateController ctrlr = setup();
        ctrlr.picklist.recordLabel='Test Picklist';
        ctrlr.picklist.recordDevName='Test_Picklist';
        ctrlr.picklist.setAlphaSort(false);
        ctrlr.optionsToParse=
            'An Option?\n' +
            'An Option!\n' +
            'Option #3';
        ctrlr.save();
        System.assert(mock.didCreate);
    }
    
    static BLDR_PicklistCreateController setup() {
        mock = new BLDR_MetadataServiceMock();
        Test.setMock(WebServiceMock.class, mock);
        Test.setCurrentPage(Page.BLDR_PicklistCreate);
        return new BLDR_PicklistCreateController();
    }
    
}