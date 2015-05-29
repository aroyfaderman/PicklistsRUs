//We need SeeAllData to see EntityDefinition and FieldDefinition data
@IsTest(SeeAllData=true)
public class BLDR_UsageCreateTest {
    static BLDR_MetadataServiceMock mock {get; set;}
    
    public static testmethod void testSave() {
        BLDR_UsageCreateController ctrlr = setup();
        ctrlr.usage.setSObjectType('Account');
        ctrlr.usage.setField('Site');
        ctrlr.save();
        System.assert(mock.didCreate);
    }
    
    public static testmethod void testCalcFieldOptions() {
        BLDR_UsageCreateController ctrlr = setup();
        ctrlr.usage.setSObjectType(ReusablePicklistTestUtil.getTestDataObjectName());
        ctrlr.calcFieldOptions();
        SelectOption[] options = ctrlr.fieldOptions;
        //option 0 is just the '--please select--'
        //other fields are already assigned to picklists
        System.assertEquals(2, options.size());
        System.assertEquals('Regular Text Field', options[1].getLabel());
        System.assertEquals(ReusablePicklistTestUtil.getDevNamespaceWithSep() + 'Regular_Text_Field__c',
                    options[1].getValue());
    }
    
    static BLDR_UsageCreateController setup() {
        mock = new BLDR_MetadataServiceMock();
        Test.setMock(WebServiceMock.class, mock);
        PageReference usageCreate = Page.BLDR_UsageCreate;
        usageCreate.getParameters().put('picklistApiName', 
                                         ReusablePicklistTestUtil.getDevNamespaceWithSep() + 'TestPicklistNonAlpha');
        Test.setCurrentPage(usageCreate);
        return new BLDR_UsageCreateController();
    }
}