public class BLDR_DevNameUtil {
    public static String uniquify(String label, SObject[] existingWithDevNames) {
        return uniquify(label, existingWithDevNames, new Set<String>());
    }
    
    public static String uniquify(String label, SObject[] existingWithDevNames, Set<String> otherNewNames) {
        Set<String> existingNames = new Set<String>();
        for (SObject existing : existingWithDevNames) {
            existingNames.add(((String) existing.get('DeveloperName')).toLowerCase());
        }
        String strippedName = label.replaceAll('\\W+', '_').replaceAll('__+', '_').replaceAll('\\A[^a-zA-Z]+', '').replaceAll('_$', '');
        if (!existingNames.contains(strippedName.toLowerCase()) && 
            !otherNewNames.contains(strippedName.toLowerCase())) {
                
            otherNewNames.add(strippedName.toLowerCase());
            return strippedName;
        } else {
            for (Integer suffix=1; true; suffix++) {
                String proposedName = strippedName + suffix;
                if (!existingNames.contains(proposedName.toLowerCase()) && 
                    !otherNewNames.contains(proposedName.toLowerCase())) {
                        
                    otherNewNames.add(proposedName.toLowerCase());
                    return proposedName;
                }
            }
            //Shouldn't happen, but if it does, user will just have to enter it themselves
            return '';
        }
    }
}