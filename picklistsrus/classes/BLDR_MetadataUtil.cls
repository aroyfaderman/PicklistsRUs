public class BLDR_MetadataUtil {
    static String currentOrgNamespace;
    static Boolean emptyNamespace = false;
    static BLDR_MetadataService.MetadataPort port;
    //public for testing purposes only;
    public static BLDR_MetadataUtil.Status mdApiStatus = Status.NOT_CHECKED;
    public static Map<String, boolean> isCmdEditable;
    public static Map<String, boolean> isCmdDeletable;
    public static String reusablePicklistPrefix {public get;}
    public static String reusablePicklistOptionPrefix {public get;}
    public static String picklistUsagePrefix {public get;}
    
    //public for testing purposes
    public enum Status {
        NOT_CHECKED,
        AVAILABLE,
        UNAVAILABLE
    }
    
    public static Boolean checkMetadataAPIConnection() {
        if (mdApiStatus == Status.NOT_CHECKED) {
            boolean success = true;
            BLDR_MetadataService.FileProperties[] allCmdProps;
            try {
                BLDR_MetadataService.MetadataPort service = getPort();
                service.SessionHeader = new BLDR_MetadataService.SessionHeader_element();
                service.SessionHeader.sessionId = UserInfo.getSessionId();
                List<BLDR_MetadataService.ListMetadataQuery> queries = new List<BLDR_MetadataService.ListMetadataQuery>();
                BLDR_MetadataService.ListMetadataQuery customMetadata = new BLDR_MetadataService.ListMetadataQuery();
                customMetadata.type_x = 'CustomMetadata';
                queries.add(customMetadata);
                allCmdProps = service.listMetadata(queries, 34);
                mdApiStatus = Status.AVAILABLE;
            } catch (CalloutException e) {
                if (!e.getMessage().contains('Unauthorized endpoint, please check Setup')) {
                    throw e;
                }
                mdApiStatus = Status.UNAVAILABLE;
            }
            if (allCmdProps != null) {
                isCmdEditable = new Map<String, boolean>();
                isCmdDeletable = new Map<String, boolean>();
                for (BLDR_MetadataService.FileProperties cmdProps : allCmdProps) {
                    String fullName = cmdProps.fullName;
                    String[] nameAndType = cmdProps.fullName.split('\\.');
                    fullName = nameAndType[0] + '.' + NamespaceUtil.qualifyIfNeeded(cmdProps.namespacePrefix, nameAndType[1], false);
                    String manageableState = cmdProps.manageableState;
                    System.debug(fullName + ': ' + manageableState);
                    boolean isEditable = manageableState != 'installed' && manageableState != 'deprecated';
                    boolean isDeletable = isEditable && manageableState != 'released';
					isCmdEditable.put(fullName, isEditable);
					isCmdDeletable.put(fullName, isDeletable);                    
                }
                String[] rPickSplitName = NamespaceUtil.split(ReusablePicklist__mdt.sObjectType.getDescribe().getName(), true);
                String devOrgNs = (rPickSplitName.size() == 1) ? null : rPickSplitName[0];
                String nsForPrefixes = (String.isBlank(devOrgNs) || devOrgNs == getCurrentOrgNamespace()) ?
                    '' : (devOrgNs + '__');
                reusablePicklistPrefix = nsForPrefixes + 'ReusablePicklist.';
                reusablePicklistOptionPrefix = nsForPrefixes + 'ReusablePicklistOption.';
                picklistUsagePrefix = nsForPrefixes + 'PicklistUsage.';
                
            }
        }
        return mdApiStatus == Status.AVAILABLE;
    }
    
    public static String getCurrentOrgNamespace() {
        if (emptyNamespace) {
            return null;
        }
        if (String.isBlank(currentOrgNamespace)) {
            currentOrgNamespace = getPort().describeMetadata(Double.valueOf(34.0)).organizationNamespace;
            if (String.isBlank(currentOrgNamespace)) {
                emptyNamespace = true;
            }
        }
        return currentOrgNamespace;
    }
    
    public static BLDR_MetadataService.MetadataPort getPort() {
        if (port == null) {
            port = new BLDR_MetadataService.MetadataPort();
            port.sessionHeader = new BLDR_MetadataService.SessionHeader_element();
            port.sessionHeader.sessionId = UserInfo.getSessionId();
        }
        return port;
    }
    
    static BLDR_MetadataService.CustomMetadata[] convertForMdApi(BLDR_CustomMetadata[] writeableMetadata) {
        BLDR_MetadataService.CustomMetadata[] converted = new List<BLDR_MetadataService.CustomMetadata>();
        for (BLDR_CustomMetadata md : writeableMetadata) {
            converted.add(md.buildMetadata());
        }
        return converted;
    }
    
    public static BLDR_MetadataService.SaveResult create(BLDR_CustomMetadata newMetadata) {
        return create(new BLDR_CustomMetadata[] {newMetadata})[0];
    }
    
    public static BLDR_MetadataService.SaveResult[] create(BLDR_CustomMetadata[] newMetadata) {
        return getPort().createMetadata(convertForMdApi(newMetadata));
    }
    
    public static BLDR_MetadataService.SaveResult updateMd(BLDR_CustomMetadata mdToUpdate) {
        return updateMd(new BLDR_CustomMetadata[] {mdToUpdate})[0];
    }
    
    public static BLDR_MetadataService.SaveResult[] updateMd(BLDR_CustomMetadata[] mdToUpdate) {
        return getPort().updateMetadata(convertForMdApi(mdToUpdate));
    }
    
    public static BLDR_MetadataService.SaveResult rename(BLDR_CustomMetadata toRename) {
        return getPort().renameMetadata('CustomMetadata',
                                        toRename.getOldFullNameForRenameOrDelete(),
                                        toRename.getNewFullNameForRename());
    }
    
    public static BLDR_MetadataService.DeleteResult deleteMd(BLDR_CustomMetadata toDelete) {
        return deleteMd(new Bldr_CustomMetadata[] {toDelete})[0];
    }
    
    public static BLDR_MetadataService.DeleteResult[] deleteMd(BLDR_CustomMetadata[] toDelete) {
        String[] fullNames = new List<String>();
        for (BLDR_CustomMetadata record : toDelete) {
            fullNames.add(record.getOldFullNameForRenameOrDelete());
        }
        return getPort().deleteMetadata('CustomMetadata',
                                       fullNames);
    }
    
    public static Boolean checkResult(BLDR_MetadataService.SaveResult[] results) {
        boolean overallSuccess = true;
        for (BLDR_MetadataService.SaveResult result : results) {
            if (!result.success) {
                overallSuccess = false;
                for (BLDR_MetadataService.Error mdError : result.errors) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, mdError.message));
                }
            }
        }
        return overallSuccess;
    }
    
    public static Boolean checkResult(BLDR_MetadataService.SaveResult result) {
        return checkResult(new BLDR_MetadataService.SaveResult[] {result});
    }
    
    public static Boolean checkResult(BLDR_MetadataService.DeleteResult[] results) {
        boolean overallSuccess = true;
        for (BLDR_MetadataService.DeleteResult result : results) {
            if (!result.success) {
                overallSuccess = false;
                for (BLDR_MetadataService.Error mdError : result.errors) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, mdError.message));
                }
            }
        }
        return overallSuccess;
    }
    
    public static Boolean checkResult(BLDR_MetadataService.DeleteResult result) {
        return checkResult(new BLDR_MetadataService.DeleteResult[] {result});
    }
    
}
