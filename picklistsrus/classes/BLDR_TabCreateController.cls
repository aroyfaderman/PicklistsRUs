public class BLDR_TabCreateController {
    public final EntityDefinition entityDef {public get; set;}
    final String tabUrl {get; set;}
    final String picklistName {get; set;}
    public final BLDR_MetadataService.CustomTab tab {public get; set;}
    public final List<SelectOption> motifs {public get; set;}
    final BLDR_ToolingService.SforceService port = new BLDR_ToolingService.SforceService();
        
    
    public BLDR_TabCreateController() {
        entityDef = [SELECT QualifiedApiName, DeveloperName, Label, PluralLabel
                     FROM EntityDefinition
                     WHERE Id = :ApexPages.currentPage().getParameters().get('entityDefId')];
        tab = new BLDR_MetadataService.CustomTab();
        tab.customObject = false;
        tab.mobileReady = false;
        PageReference tabRef = Page.ReusablePicklistTab;
        tabRef.getParameters().put('type', entityDef.QualifiedApiName);
        tab.url = tabRef.getUrl();
        tab.urlEncodingKey='UTF-8';
        tab.frameHeight=600;
        tab.Label = entityDef.PluralLabel;
        tab.hasSidebar = true;
        tab.fullName = entityDef.QualifiedApiName.replaceAll('__','_').left(25);
        picklistName = ApexPages.currentPage().getParameters().get('picklistName');
        port.sessionHeader = new BLDR_ToolingService.SessionHeader_element();
        port.sessionHeader.sessionId = UserInfo.getSessionId();
        motifs = new List<SelectOption>();
        BLDR_ToolingService.DescribeSObjectResult tabDesc =
            port.describeSObject('CustomTab');
        for (BLDR_ToolingService.Field field : tabDesc.fields) {
            if (field.name.equalsIgnoreCase('MotifName')) {
                motifs.add(new SelectOption('', '-- please select a value --'));
                Set<String> motifLabels = new Set<String>();
                for (BLDR_ToolingService.PicklistEntry motif : field.picklistValues) {
                    if (!motifLabels.contains(motif.label)) {
                    	motifs.add(new SelectOption(motif.value + ': ' + motif.label, motif.label));
                        motifLabels.add(motif.label);
                    }
                }
                break;
            }
        }  
    }
    
    public PageReference checkTabNeeded() {
        BLDR_ToolingService.QueryResult existingTabs = port.query('SELECT Id from CustomTab where Url LIKE \'%' + tab.url + '\' LIMIT 1');
        if (existingTabs.records == null) {
            System.debug('Records is null?');
        }
        if (existingTabs.records != null && ! existingTabs.records.isEmpty()) {
            PageReference detail = Page.BLDR_PicklistDetail;
            detail.getParameters().put('apiName', picklistName);
            return detail;
        }
        
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 
                                                   'Reusable picklists do not display in ordinary object tabs.'));
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,
                                                   'Click "Create Custom Tab" to create a tab for ' +
                                                       entityDef.Label + ' that supports reusable picklists.'));
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,
                                                   'You will still need to make your tab visible for users and/or add it to your applications.'));
        if (BLDR_MetadataUtil.getCurrentOrgNamespace() == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 
                                                      'If you later add a namespace to your organization, you will have to edit the URL of this tab to support your namespace.'));
        }
        return null;
    }
    
    public PageReference createTab() {
        BLDR_MetadataService.SaveResult result = BLDR_MetadataUtil.getPort().createMetadata(new BLDR_MetadataService.CustomTab[] {tab})[0];
        if (BLDR_MetadataUtil.checkResult(result)) {
            PageReference detail = Page.BLDR_PicklistDetail;
            detail.getParameters().put('apiName', picklistName);
            return detail;
        }
        return null;
    }
}