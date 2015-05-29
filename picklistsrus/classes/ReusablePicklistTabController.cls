public class ReusablePicklistTabController {

    public final String pageTitle {public get; set;}
    public final SObject[] records {public get; set;}
    public final String typeName {public get; set;}
    public Id selected {public get; public set;}
    
    public ReusablePicklistTabController() {
        typeName = ApexPages.currentPage().getParameters().
            get('type');
        Schema.DescribeSObjectResult describe = 
            Schema.describeSObjects(new String[] {typeName})[0];
        pageTitle = describe.labelPlural;
        records = Database.query('SELECT Id, Name FROM '
                                 + typeName
                                 + ' ORDER BY LastModifiedDate DESC');
    }
    
    public PageReference create() {
        PageReference toReturn = Page.ReusablePicklistEngine;
        toReturn.getParameters().put('type', typeName);
        toReturn.getParameters().put('retUrl', ApexPages.currentPage().getUrl());
        return toReturn;
    }
    
    public PageReference edit() {
        PageReference toReturn = Page.ReusablePicklistEngine;
        toReturn.getParameters().put('id', selected);
        toReturn.getParameters().put('e', '');
        toReturn.getParameters().put('retUrl', ApexPages.currentPage().getUrl());
        return toReturn;
    }
    
    public PageReference detail() {
        PageReference toReturn = Page.ReusablePicklistEngine;
        toReturn.getParameters().put('id', selected);
        return toReturn;
    }
    
    public PageReference remove() {
        Integer recordIndex = 0;
        SObject toDelete = null;
        for (SObject record : records) {
            if (record.Id == selected) {
                toDelete = record;
                break;
            }
            recordIndex ++;
        }
        delete toDelete;
        records.remove(recordIndex);
        return null;
    }
}