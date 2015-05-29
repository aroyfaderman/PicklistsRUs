public class BLDR_PicklistDeleter {
    final BLDR_CustomMetadata[] toDelete {get; set;}
    
    public BLDR_PicklistDeleter(Id picklistId) {
        toDelete = new List<BLDR_CustomMetadata>();
        toDelete.add(new BLDR_ReusablePicklist(picklistId));
        ReusablePicklist__mdt picklist = [SELECT QualifiedApiName, DeveloperName, NamespacePrefix
                                         FROM ReusablePicklist__mdt
                                         WHERE Id = :picklistId];
        
        String picklistName = picklist.QualifiedApiName;
        String picklistNs = picklist.NamespacePrefix;
        ReusablePicklistOption__mdt[] options;
        PicklistUsage__mdt[] usages;
        if (String.isBlank(picklistNs)) {
            options = [SELECT Id
                          FROM ReusablePicklistOption__mdt
                          WHERE Picklist__c = :picklistName
                            AND NamespacePrefix = NULL];
            usages = [SELECT Id
                          FROM PicklistUsage__mdt
                          WHERE Picklist__c = :picklistName
                          AND NamespacePrefix = NULL];
        } else {
            String picklistDevName = picklist.DeveloperName;
            options = new List<ReusablePicklistOption__mdt>();
            options.addAll([SELECT Id
                               FROM ReusablePicklistOption__mdt
                               WHERE Picklist__c = :picklistName]);
            options.addAll([SELECT Id
                               FROM ReusablePicklistOption__mdt
                               WHERE NamespacePrefix = :picklistNs
                               AND Picklist__c = :picklistDevName]);
            usages = new List<PicklistUsage__mdt>();
            usages.addAll([SELECT Id
                               FROM PicklistUsage__mdt
                               WHERE Picklist__c = :picklistDevName]);
            usages.addAll([SELECT Id
                               FROM PicklistUsage__mdt
                               WHERE NamespacePrefix = :picklistNs
                               AND Picklist__c = :picklistDevName]);
        }
        for (ReusablePicklistOption__mdt option : options) {
            toDelete.add(new BLDR_ReusablePicklistOption(option.Id));
        }
        for (PicklistUsage__mdt usage : usages) {
            toDelete.add(new BLDR_PicklistUsage(usage.Id));
        }
    }
    
    public PageReference doDelete() {
        BLDR_MetadataService.DeleteResult[] results = BLDR_MetadataUtil.deleteMd(toDelete);
        if (BLDR_MetadataUtil.checkResult(results)) {
            PageReference tab = Page.BLDR_ReusablePicklistsList;
            tab.setRedirect(true);
            return tab;
        }
		return null;
    }
}