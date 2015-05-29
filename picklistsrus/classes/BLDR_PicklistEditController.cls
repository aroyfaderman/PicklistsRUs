public class BLDR_PicklistEditController {
    public final BLDR_ReusablePicklist picklist {public get; set;}
    public final ReusablePicklist__mdt originalPicklist {public get; set;}
    public final String cancelUrl {public get; set;}
    
    public BLDR_PicklistEditController() {
        Id picklistId = ApexPages.currentPage().getParameters().get('id');
        picklist = new BLDR_ReusablePicklist(picklistId);
        originalPicklist = [SELECT QualifiedApiName, DeveloperName, NamespacePrefix, AlphaSort__c
                           FROM ReusablePicklist__mdt
                           WHERE Id = :picklistId];
        cancelUrl = EncodingUtil.urlDecode(ApexPages.currentPage().getParameters().get('cancelUrl'), 'UTF-8');
        BLDR_MetadataUtil.checkMetadataAPIConnection();
    }
    
    public PageReference save() {
        BLDR_CustomMetadata[] toUpdate = new List<BLDR_CustomMetadata>();
        Boolean updateNames = picklist.recordDevName != originalPicklist.DeveloperName;
        if (updateNames && picklist.recordDevName != BLDR_DevNameUtil.uniquify(
            picklist.recordDevName, [SELECT DeveloperName from ReusablePicklist__mdt])) {
            // We want to catch this early, before we try to update anything.
            ApexPages.addMessage(
                new ApexPages.Message(ApexPages.Severity.ERROR,
                                      'The Name field can only contain underscores and alphanumeric ' +
                                      'characters. It must be unique, begin with a letter, not ' + 
                                      'include spaces, not end with an underscore, and not contain ' +
                                      'two consecutive underscores.', '', 'DeveloperName')
            );
            return null;
        }
        toUpdate.add(picklist);
        String picklistNs = originalPicklist.NamespacePrefix;
        String oldPicklistName = originalPicklist.QualifiedApiName;
        String oldPicklistDevName = originalPicklist.DeveloperName;
        if (updateNames || picklist.getAlphaSort() != originalPicklist.AlphaSort__c) {
            ReusablePicklistOption__mdt[] options = new List<ReusablePicklistOption__mdt>();
            String selectAndFrom = 'SELECT Id, Label FROM ReusablePicklistOption__mdt ';
            Boolean addSortOrder = ! picklist.getAlphaSort() && originalPicklist.AlphaSort__c;
            String orderBy = addSortOrder ? 'ORDER BY Label' : '';
            
           
            if (String.isBlank(picklistNs)) {
                options = Database.query(
                    selectAndFrom + 
                    'WHERE NamespacePrefix=null AND Picklist__c = :oldPicklistName ' +
                    orderBy);
            } else {
                //Namespace for Picklist__c specified in the option
                ReusablePicklistOption__mdt[] optionsSpecNamespace =
                    Database.query(selectAndFrom +
                                   'WHERE Picklist__c = :oldPicklistName ' +
                                   orderBy);
                
                //Also options where no ns is specified for Picklist__c but that are in
                //picklist ns.
                ReusablePicklistOption__mdt[] optionsDefaultedNamespace = 
                    Database.query(selectAndFrom + 
                                   'WHERE NamespacePrefix = :picklistNs ' +
                                   '  AND Picklist__c = :oldPicklistDevName ' +
                                   orderBy);
                
                options = new List<ReusablePicklistOption__mdt>();
                if (addSortOrder) {
                    Integer specIndex=0;
                    Integer defaultedIndex=0;
                    // Merge the sorted lists
                    while (specIndex < optionsSpecNamespace.size()) {
                        ReusablePicklistOption__mdt nsSpecOption = optionsSpecNamespace[specIndex];
                        if (defaultedIndex < optionsDefaultedNamespace.size()) {
                            ReusablePicklistOption__mdt nsDefOption = 
                                optionsDefaultedNamespace[defaultedIndex];
                            if (nsSpecOption.Label < nsDefOption.Label) {
                                options.add(nsSpecOption);
                                specIndex++;
                            } else {
                                options.add(nsDefOption);
                                defaultedIndex++;
                            }
                        } else {
                            options.add(nsSpecOption);
                            specIndex++;
                        }
                	}
                    // Add any remaining namespace-defaulted options to the list to complete
                    // the merge.
                    while (defaultedIndex < optionsDefaultedNamespace.size()) {
                        options.add(optionsDefaultedNamespace[defaultedIndex++]);
                    }
                } else {
                    options.addAll(optionsSpecNamespace);
                    options.addAll(optionsDefaultedNamespace);
                }
            }
            Integer sortOrder = 1;
            for (ReusablePicklistOption__mdt option : options) {
                BLDR_ReusablePicklistOption toChange = new BLDR_ReusablePicklistOption(option.Id);
                if (addSortOrder) {
                    toChange.setSortOrder(sortOrder ++);
                } else if (picklist.getAlphaSort() && !originalPicklist.AlphaSort__c) {
                    toChange.setSortOrder(null);
                }
                if (updateNames) {
                    toChange.setPicklist(NamespaceUtil.qualifyIfNeeded(picklistNs, picklist.recordDevName, false));
                }
                toUpdate.add(toChange);
            }
        }
        if (updateNames) {
            PicklistUsage__mdt[] usages;
            if (String.isBlank(picklistNs)) {
                usages = [SELECT Id
                          FROM PicklistUsage__mdt
                          WHERE Picklist__c = :oldPicklistName];
            } else {
                usages = new List<PicklistUsage__mdt>();
                usages.addAll([SELECT Id
                               FROM PicklistUsage__mdt
                               WHERE Picklist__c = :oldPicklistName]);
                usages.addAll([SELECT Id
                               FROM PicklistUsage__mdt
                               WHERE NamespacePrefix = :picklistNs
                               AND Picklist__c = :oldPicklistDevName]);
            }
            for (PicklistUsage__mdt usage : usages) {
                BLDR_PicklistUsage toChange = new BLDR_PicklistUsage(usage.Id);
                toChange.setPicklist(NamespaceUtil.qualifyIfNeeded(picklistNs, picklist.recordDevName, false));
                toUpdate.add(toChange);
            }
            
        }
        BLDR_MetadataService.SaveResult[] results = BLDR_MetadataUtil.updateMd(toUpdate);
        if (BLDR_MetadataUtil.checkResult(results)) {

            if (updateNames) {
                BLDR_MetadataUtil.rename(picklist);
            }
            PageReference detail = Page.BLDR_PicklistDetail;
            detail.getParameters().put('apiName', NamespaceUtil.qualifyIfNeeded(picklistNs, picklist.recordDevName, false));
            detail.setRedirect(true);
            return detail;
        }
        return null;
    }
    
    public PageReference cancel() {
        return new PageReference(cancelUrl);
    }
}