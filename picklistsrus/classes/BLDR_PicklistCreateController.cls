public class BLDR_PicklistCreateController {
    public final BLDR_ReusablePicklist picklist {public get; set;}
    public String optionsToParse {public get; set;}
    
    public BLDR_PicklistCreateController() {
        picklist = new BLDR_ReusablePicklist();
    }
    
    public PageReference defaultName() {
        if (String.isBlank(picklist.recordDevName) && !String.isBlank(picklist.recordLabel)) {
            picklist.recordDevName = BLDR_DevNameUtil.uniquify(picklist.recordLabel, [SELECT DeveloperName FROM ReusablePicklist__mdt]);
        }
        return null;
    }
    
    public PageReference save() {
        BLDR_CustomMetadata[] toCreate = new List<BLDR_CustomMetadata>();
        toCreate.add(picklist);
        toCreate.addAll(parseOptions());
        BLDR_MetadataService.SaveResult[] results = BLDR_MetadataUtil.create(toCreate);
        if (BLDR_MetadataUtil.checkResult(results)) {
            PageReference detail = Page.BLDR_PicklistDetail;
            detail.getParameters().put(
                'apiName', 
                NamespaceUtil.qualifyIfNeeded(
                    BLDR_MetadataUtil.getCurrentOrgNamespace(), 
                    picklist.recordName, 
                    false));
            detail.setRedirect(true);
            return detail;
        }
        return null;
    }
    
    public PageReference cancel() {
        return Page.BLDR_ReusablePicklistsList;
    }
    
    BLDR_CustomMetadata[] parseOptions() {
        BLDR_CustomMetadata[] parsedOptions = new List<BLDR_CustomMetadata>();
        if (optionsToParse == null) {
            return parsedOptions;
        }
        String[] optionLabelsUntrimmed = optionsToParse.split('(?m)^');
        ReusablePicklistOption__mdt[] existingOptions = [SELECT DeveloperName FROM ReusablePicklistOption__mdt];
        Set<String> optionNameAccumulator = new Set<String>();
        Integer optionOrder = 1;
        for (String optionLabelUntrimmed : optionLabelsUntrimmed) {
            String optionLabel = optionLabelUntrimmed.trim();
            if (!String.isBlank(optionLabel)) {
                BLDR_ReusablePicklistOption option = new BLDR_ReusablePicklistOption();
                option.recordLabel = optionLabel;
                option.recordDevName = BLDR_DevNameUtil.uniquify(optionLabel, existingOptions, optionNameAccumulator);
                option.setPicklist(picklist.recordDevName);
                if (!picklist.getAlphaSort()) {
                    option.setSortOrder(optionOrder++);
                }
                parsedOptions.add(option);
            }  
        }
        return parsedOptions;
    }
}