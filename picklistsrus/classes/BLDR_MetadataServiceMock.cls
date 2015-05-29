@IsTest
global class BLDR_MetadataServiceMock implements WebServiceMock {
    
    public static final String[] C_M_FULL_NAMES = new String[] {
    	'ReusablePicklist.' + ReusablePicklistTestUtil.getDevNamespaceWithSep() + 'TestPicklistAlpha',
    	'ReusablePicklist.' + ReusablePicklistTestUtil.getDevNamespaceWithSep() + 'TestPicklistNonAlpha',
    	'ReusablePicklistOption.' + ReusablePicklistTestUtil.getDevNamespaceWithSep() + 'AlphaTestValue1',
        'ReusablePicklistOption.' + ReusablePicklistTestUtil.getDevNamespaceWithSep() + 'AlphaTestValue2',
        'ReusablePicklistOption.' + ReusablePicklistTestUtil.getDevNamespaceWithSep() + 'NonAlphaTestValue1',
        'ReusablePicklistOption.' + ReusablePicklistTestUtil.getDevNamespaceWithSep() + 'NonAlphaTestValue2',
        'PicklistUsage.' + ReusablePicklistTestUtil.getDevNamespaceWithSep() + 'AlphaTestUsage',
        'PicklistUsage.' + ReusablePicklistTestUtil.getDevNamespaceWithSep() + 'NonAlphaTestUsage'
    };
        
    String managedState {get; set;}
    
    public boolean didDelete {public get; set;}
    public boolean didUpdate {public get; set;}
    public boolean didCreate {public get; set;}
    public boolean didRename {public get; set;}
        
    public BLDR_MetadataServiceMock() {
        managedState = 'unmanaged';
    }
    
    public BLDR_MetadataServiceMock managedState(String state) {
        managedState = state;
        return this;
    }
    
    global void doInvoke(Object stub,
                         Object request,
                         Map<String, Object> response,
                         String endpoint,
                         String soapAction,
                         String requestName,
                         String responseNS,
                         String responseName,
                         String responseType) 
    {
		if(responseType == 'BLDR_MetadataService.listMetadataResponse_element'){
            BLDR_MetadataService.listMetadataResponse_element respElt = new BLDR_MetadataService.listMetadataResponse_element();
            respElt.result = new List<BLDR_MetadataService.FileProperties>();
            for (String fullname : C_M_FULL_NAMES) {
                BLDR_MetadataService.FileProperties props = new BLDR_MetadataService.FileProperties();
                props.fullName = fullname;
                props.manageableState = managedState;
                respElt.result.add(props);
            }
        	response.put('response_x', respElt); 
        } else if(responseType == 'BLDR_MetadataService.updateMetadataResponse_element'){
            BLDR_MetadataService.updateMetadataResponse_element respElt = 
                new BLDR_MetadataService.updateMetadataResponse_element();
            respElt.result = new List<BLDR_MetadataService.SaveResult>();
            BLDR_MetadataService.SaveResult sr = new BLDR_MetadataService.SaveResult();
            sr.success = true;
            respElt.result.add(sr);
            response.put('response_x', respElt);
            didUpdate = true;
        } else if (responseType == 'BLDR_MetadataService.createMetadataResponse_element') {
            BLDR_MetadataService.createMetadataResponse_element respElt =
                new BLDR_MetadataService.createMetadataResponse_element();
            respElt.result = new List<BLDR_MetadataService.SaveResult>();
            BLDR_MetadataService.SaveResult sr = new BLDR_MetadataService.SaveResult();
            sr.success = true;
            respElt.result.add(sr);
            response.put('response_x', respElt);
            didCreate = true;
        } else if (responseType == 'BLDR_MetadataService.deleteMetadataResponse_element') {
            BLDR_MetadataService.deleteMetadataResponse_element respElt = 
                new BLDR_MetadataService.deleteMetadataResponse_element();
            respElt.result = new List<BLDR_MetadataService.DeleteResult>();
            BLDR_MetadataService.DeleteResult dr = new BLDR_MetadataService.DeleteResult();
            dr.success = true;
            respElt.result.add(dr);
            response.put('response_x', respElt);
            didDelete = true;
        } else if (responseType == 'BLDR_MetadataService.describeMetadataResponse_element') {
            BLDR_MetadataService.describeMetadataResponse_element respElt =
                new BLDR_MetadataService.describeMetadataResponse_element();
            respElt.result = new BLDR_MetadataService.DescribeMetadataResult();
            String[] rPickSplitName = NamespaceUtil.split(ReusablePicklist__mdt.sObjectType.getDescribe().getName(), true);
            String devOrgNs = (rPickSplitName.size() == 1) ? null : rPickSplitName[0];
            respElt.result.organizationNamespace = devOrgNs;
            response.put('response_x', respElt);
        } else if (responseType == 'BLDR_MetadataService.renameMetadataResponse_element') {
            BLDR_MetadataService.renameMetadataResponse_element respElt =
                new BLDR_MetadataService.renameMetadataResponse_element();
            respElt.result = new BLDR_MetadataService.SaveResult();
            respElt.result.success = true;
            response.put('response_x', respElt);
            didRename = true;
        } else {
            System.assert(false, 'Unexpected response type: ' + responseType);
        }
        
    }
}