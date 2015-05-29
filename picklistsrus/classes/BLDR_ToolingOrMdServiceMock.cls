@IsTest
global class BLDR_ToolingOrMdServiceMock implements WebServiceMock {
    public final BLDR_ToolingService.PicklistEntry[] motifs {public get; set;}
    public final BLDR_MetadataServiceMock delegate {public get; set;}
    final boolean findTab;
    
    public BLDR_ToolingOrMdServiceMock(boolean findTab) {
        BLDR_ToolingService.PicklistEntry motif1 = new BLDR_ToolingService.PicklistEntry();
        motif1.value = 'motif1';
        motif1.label = 'Motif 1';
        BLDR_ToolingService.PicklistEntry motif2 = new BLDR_ToolingService.PicklistEntry();
        motif2.value = 'motif2';
        motif2.label = 'Motif 2';
        motifs = new BLDR_ToolingService.PicklistEntry[] {motif1, motif2};
        this.findTab = findTab;
        this.delegate = new BLDR_MetadataServiceMock();
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
        if (responseType == 'BLDR_ToolingService.describeSObjectResponse_element') {
            BLDR_ToolingService.describeSObjectResponse_element respElt =
                new BLDR_ToolingService.describeSObjectResponse_element();
            respElt.result = new BLDR_ToolingService.DescribeSObjectResult();
            BLDR_ToolingService.Field motifField = new BLDR_ToolingService.Field();
            motifField.name='MotifName';
            motifField.picklistValues = motifs;
            respElt.result.fields = new BLDR_ToolingService.Field[] {motifField};
            response.put('response_x', respElt);
            
        } else if (responseType == 'BLDR_ToolingService.queryResponse_element') {
            BLDR_ToolingService.queryResponse_element respElt =
                new BLDR_ToolingService.queryResponse_element();
            respElt.result = new BLDR_ToolingService.QueryResult();
            if (findTab) {
                BLDR_ToolingService.sObject_x record = new BLDR_ToolingService.sObject_x();
                respElt.result.records = 
                    new BLDR_ToolingService.sObject_x[] {record};
                respElt.result.size = 1;
            } else {
                respElt.result.records = new BLDR_ToolingService.sObject_x[0];
                respElt.result.size = 0;
            }
            response.put('response_x', respElt);
        } else {
            //Maybe it's an MD API call
            delegate.doInvoke(stub,
                         request,
                         response,
                         endpoint,
                         soapAction,
                         requestName,
                         responseNS,
                         responseName,
                         responseType);
        }
    }
}