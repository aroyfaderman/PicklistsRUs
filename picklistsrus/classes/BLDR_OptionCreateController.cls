public class BLDR_OptionCreateController {
    public final BLDR_ReusablePicklistOption option {public get; set;}
    public final ReusablePicklist__mdt picklist {public get; set;}
    
    public BLDR_OptionCreateController() {
        String picklistApiName = ApexPages.currentPage().getParameters().get('picklistApiName');
        picklist = [SELECT QualifiedApiName, DeveloperName, NamespacePrefix, Label, AlphaSort__c 
                    FROM ReusablePicklist__mdt 
                    WHERE qualifiedApiName = :picklistApiName];
        option = new BLDR_ReusablePicklistOption();
        option.setPicklist(picklistApiName);
    }
    
    public PageReference save() {
        option.recordDevName = BLDR_DevNameUtil.uniquify(option.recordLabel,
                                                         [SELECT DeveloperName
                                                          FROM ReusablePicklistOption__mdt]);
        if (!picklist.AlphaSort__c) {
        	ReusablePicklistOption__mdt[] existing;
            if (String.isBlank(picklist.NamespacePrefix)) {
                existing = [SELECT SortOrder__c 
                            FROM ReusablePicklistOption__mdt
                            WHERE NamespacePrefix = NULL AND Picklist__c = :picklist.DeveloperName];
            } else {
                existing = new List<ReusablePicklistOption__mdt>();
                existing.addAll([SELECT SortOrder__c
                                 FROM ReusablePicklistOption__mdt
                                 WHERE Picklist__c = :picklist.QualifiedApiName]);
                existing.addAll([SELECT SortOrder__c
                                 FROM ReusablePicklistOption__mdt
                                 WHERE NamespacePrefix = :picklist.NamespacePrefix
                                   AND Picklist__c = :picklist.DeveloperName]);
            }
            Integer nextSlot = 1;
            for (ReusablePicklistOption__mdt otherOption : existing) {
                nextSlot = Math.max(nextSlot, Integer.valueOf(otherOption.SortOrder__c) + 1);
            }
            option.setSortOrder(nextSlot);
        }
        BLDR_MetadataService.SaveResult result = BLDR_MetadataUtil.create(option);
        if (BLDR_MetadataUtil.checkResult(result)) {
            return getDetail();
        }
        return null;
    }
    
    public PageReference cancel() {
        return getDetail();
    }
    
    PageReference getDetail() {
        PageReference retVal = Page.BLDR_PicklistDetail;
        retVal.getParameters().put('apiName', picklist.QualifiedApiName);
        retVal.setRedirect(true);
        return retVal;
    }
}