@IsTest
public class ReusablePicklistTestUtil {
    public static final String RECORD_NAME_PREF = 'Test Record ';
    
    public static PageReference getTab() {
        PageReference tabPage = Page.ReusablePicklistTab;
        tabPage.getParameters().put('type', getTestDataObjectName());
        return tabPage;
    }
    
    public static PageReference getDetail(Id recordId) {
        PageReference detailPage = Page.ReusablePicklistEngine;
        detailPage.getParameters().put('id', recordId);
        return detailPage;
    }
    
    public static PicklistTestData__c[] createData() {
        PicklistTestData__c[] data = new PicklistTestData__c[2];
        System.debug(PicklistTestData__c.sObjectType.getDescribe());
        System.debug(UserInfo.getUserName()); 
        for (Integer i = 0; i < 2; i++) {           
            PicklistTestData__c record = new PicklistTestData__c();
            record.AlphaTestField__c= 'AlphaTestValue' + (i+1);
            record.NonAlphaTestField__c= 'NonAlphaTestValue' + (i+1);
            record.name = RECORD_NAME_PREF + (i+1);
            data[i] = record;
        }
        insert data;
        return data;
    }
    
    public static void doControllerCommonAsserts(
        ReusablePicklistController controller) {
        
        System.assertEquals(getTestDataObjectName(), controller.typeName);
        doFieldSpecificAsserts(controller, true);
        doFieldSpecificAsserts(controller, false);
    }
    
    static void doFieldSpecificAsserts(ReusablePicklistController controller,
                                       boolean alphaField) {
       String fieldName = getTestFieldName(alphaField);
       System.debug(fieldName);
       System.debug(controller.doesFieldUsePicklist);
       System.assertEquals(true, 
                           controller.doesFieldUsePicklist.get(fieldName));
       String testPicklistName = getDevNamespaceWithSep() + 
           'TestPicklist' + (alphaField ? 'Alpha' : 'NonAlpha');
       System.assertEquals(testPicklistName, 
                           controller.picklistsByField.get(fieldName));
       SelectOption[] picklistOptions = 
           controller.selectOptionsByPicklist.get(testPicklistName);

       // Index 0 is the --select--
       for (Integer i=1; i<3; i++) {
           SelectOption option = picklistOptions[i];
           System.assertEquals(getExpectedOptionLabel(i, alphaField),
                               option.getLabel());
           System.assertEquals(getExpectedOptionName(i, alphaField),
                               option.getValue());
       }
    }
    
    public static String getTestDataObjectName() {
        return PicklistTestData__c.sObjectType.getDescribe().name;
    }
    
    public static String getDevNamespaceWithSep() {
        String[] splitName = NamespaceUtil.split(getTestDataObjectName(), true);
        return splitName.size() ==2 ? (splitName[0] + '__') : '';
    }
    
    static String getTestFieldName(boolean alpha) {
        if (alpha) {
            return PicklistTestData__c.fields.AlphaTestField__c
                .getDescribe().getName();
        } else {
            return PicklistTestData__c.fields.NonAlphaTestField__c
                .getDescribe().getName();
        }
    }
    
    static String getExpectedOptionLabel(Integer index, 
                                           boolean alphaField) {
        if (alphaField) {
            return 'Test Value ' + index;
        } else {
            //65 is ASCII for A
            Integer[] prefix = new Integer[] {65 + 2 - index};
            return String.fromCharArray(prefix) + ' Test Value ' + index;
        }
    }
    
    static String getExpectedOptionName(Integer index, boolean alphaField) {
        String expectedDevName = 
            (alphaField ? 'Alpha' : 'NonAlpha') + 'TestValue' + index;
        return getDevNamespaceWithSep() + expectedDevName;
    }
    
    public static User createTestingEndUser() {
        List<Integer> userNameChars = new List<Integer>();
        // more or less random username (all lowercase, but that's good 
        // enough) because this code will be created multiple times in 
        // multiple versions of "Picklists R Us" in different organizations
        for (Integer i=0; i<16; i++) {
            userNameChars.add(
                Math.mod(Math.abs(System.Crypto.getRandomInteger()),26)+97);
        }
        userNameChars.add('@'.charAt(0));
        for (Integer i=0; i<8; i++) {
            userNameChars.add(
                Math.mod(Math.abs(System.Crypto.getRandomInteger()),26)+97);
        }
        String randomUserName = String.fromCharArray(userNameChars) + '.com';
        
        Profile sysAdmin = [SELECT id, name 
                            FROM Profile 
                            WHERE name = 'System Administrator'];

        User newUser = new User(alias = 'tstusr',
		email=randomUserName,
      	emailencodingkey='UTF-8',
        lastname='Testing', languagelocalekey='en_US',
        localesidkey='en_US',
        profileid = sysadmin.id,
        timezonesidkey='America/Los_Angeles',
        username=randomUserName);
		insert newUser;
        PermissionSet[] pSets = 
            [SELECT Id 
             FROM PermissionSet 
             WHERE Name = 'Reusable_Picklists_End_User'
                OR Name = 'Picklist_Framework_Unit_Testing_Only_Do_Not_Grant'];
        
        PermissionSetAssignment[] psas = new List<PermissionSetAssignment>();
        for (PermissionSet ps : pSets) {
            psas.add(new PermissionSetAssignment(
                AssigneeId = newUser.id,
                PermissionSetId = ps.id
            ));
        }
        insert psas;
        return newUser;
    }
}