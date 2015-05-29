/** 
 * Utility to help deal with the fact that metadata can change its API name
 * when a namespace is added to an organization.
 */
public class NamespaceUtil {
    static final String SEP = '__';
    
    /**
     * Divides a name into a namespace and local part.
     * Specify isObjectOrField = true for SObject types or fields.
     */
    public static String[] split(String qualifiedApiName, 
                                 boolean isObjectOrField) {
        String[] sepSplit = qualifiedApiName.split(SEP);
        if (isObjectOrField) {
            if (sepSplit.size() == 1 || sepSplit.size() == 2) {
                //Standard object/field or custom object/field; no namespace
                return new String[] {qualifiedApiName};
            } else {
                System.assert(sepSplit.size() == 3);
                //Custom object/field with namespace
                return new String[] {
                    sepSplit[0], 
                    sepSplit[1] + SEP + sepSplit[2]
                };
            }
        } else {
            return sepSplit;
        }
    }
    
    /**
     * Adds a namespace to an API name if, and only if
     *   -possiblyUnqualifiedName is not alredy namespaced
     *   -namespace is not empty or null
     * Specify isObjectOrField = true for SObject types or fields.
     */
    public static String qualifyIfNeeded(String namespace,
                                         String possiblyUnqualified,
                                         boolean isObjectOrField) {
        boolean isStandardObjectOrField = isObjectOrField && 
            !possiblyUnqualified.contains(SEP);
        if (
            String.isBlank(namespace) || 
            split(possiblyUnqualified, isObjectOrField).size() > 1 || 
            isStandardObjectOrField
        ) {
            return possiblyUnqualified;
        } else {
            return namespace + SEP + possiblyUnqualified;
        }
    }
}