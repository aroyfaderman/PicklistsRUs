/**
 * Lets us exercise NamespaceUtil using both namespaced and 
 * non-namespaced objects.
 */
@IsTest
public class NamespaceUtilUnitTest {
    public static testmethod void testSplit() {
        doTestSplit(true, 'Account', null);
        doTestSplit(true, 'CustomObject__c', null);
        doTestSplit(true, 'OtherCustomObject__c', 'somens');
        doTestSplit(false, 'CustomMetadataRecord', null);
        doTestSplit(false, 'OtherCustomMetadataRecord', 'somens');
    }
    
    public static testmethod void testQualifyIfNeeded() {
        doTestQualifyIfNeeded(true, true, 'Name', null, '');
        doTestQualifyIfNeeded(true, true, 'Name', null, 'somens');
        doTestQualifyIfNeeded(true, false, 'CustomField__c', null, '');
        doTestQualifyIfNeeded(true, false, 'CustomField__c', 'somens', '');
        doTestQualifyIfNeeded(true, false, 'CustomField__c', null, 'otherns');
        doTestQualifyIfNeeded(true, false, 'CustomField__c', 'somens', 'otherns');
        doTestQualifyIfNeeded(false, false, 'CustomMetadataRecord', null, '');
        doTestQualifyIfNeeded(false, false, 'CustomMetadataRecord', 'somens', '');
        doTestQualifyIfNeeded(false, false, 'CustomMetadataRecord', null, 
                              'otherns');
        doTestQualifyIfNeeded(false, false, 'CustomMetadataRecord', 'somens',
                              'otherns');
    }
    
    static void doTestSplit(boolean isObject, String unqualName, String nsIfAny) {
        String qualName = (nsIfAny == null) ?
            unqualName 
            : nsIfAny + '__' + unqualName;
        String[] result = NamespaceUtil.split(qualName, isObject);
        if (nsIfAny == null) {
            System.assertEquals(1, result.size());
            System.assertEquals(unqualName, result.get(0));
        } else {
            System.assertEquals(2, result.size());
            System.assertEquals(nsIfAny, result.get(0));
            System.assertEquals(unqualName, result.get(1));
        }
    }
    
    static void doTestQualifyIfNeeded(boolean isObjectOrField, boolean isStandard,
                                      String unqualName, String nsIfQual,
                                      String providedNs) {
        String possiblyUnqualified = (nsIfQual == null) ? 
            unqualName : 
            nsIfQual + '__' + unqualName;
        String expectedResult;
        if (nsIfQual == null && !isStandard) {
            expectedResult = String.isBlank(providedNs) ?
                unqualName :
                providedNs + '__' + unqualName;
        } else {
            expectedResult = possiblyUnqualified;
        }
        System.assertEquals(expectedResult,
                            NamespaceUtil.qualifyIfNeeded(providedNs, 
                                                          possiblyUnqualified,
                                                          isObjectOrField));
    }
}