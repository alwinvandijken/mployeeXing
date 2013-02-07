public class mappingSettingsController {

    public boolean 							addingFieldMapping		{get;set;}   
    
    public String							fromObject				{get;set;}
    public String							fromObjectField			{get;set;}
    public String							toObject				{get;set;}
    public String							toObjectField			{get;set;}
    public List<objectMapping__c>			objectMappingList		{get;set;}
    public Map<String, objectMapping__c>	objectMappingMap;
    public integer 							objectMappingListSize	{get;set;}
    public string 							fieldMappingName		{get;set;}
    
     public PageReference getSettingsFirstTime() {
		fromObject = 'Lead';
        toObject = 'Contact';
        
        objectMappingMap = objectMapping__c.getAll().clone();
        objectMappingList = objectMappingMap.values();

        return null;
    }
    
    public list<SelectOption> customObjectsFrom{
        get{
            list<SelectOption> objectlist = new list<SelectOption>();
            List<Schema.SObjectType> gd = Schema.getGlobalDescribe().Values();
            for(Schema.SObjectType f : gd){
            	objectlist.add(new SelectOption(f.getDescribe().getName(),f.getDescribe().getName()));
            }
        	return sortOptionList(objectlist);
        }
    }
    
    public list<SelectOption> customObjectsTo{
        get{
            list<SelectOption> objectlist = new list<SelectOption>();
            List<Schema.SObjectType> gd = Schema.getGlobalDescribe().Values();
            for(Schema.SObjectType f : gd){
            	objectlist.add(new SelectOption(f.getDescribe().getName(),f.getDescribe().getName()));
            }
        	return sortOptionList(objectlist);
        }
    }
    
    public list<SelectOption> customObjectFromFields{
        get{
            list<SelectOption> fieldlist = new list<SelectOption>();
            
            Map<String,Schema.SObjectType> gd = Schema.getGlobalDescribe();
            Schema.SObjectType sobjType = gd.get(fromObject);
            Schema.DescribeSObjectResult r = sobjType.getDescribe();
            Map<String,Schema.SObjectField> M = r.fields.getMap();
            
            for (string s : m.keySet()){
                fieldlist.add(new SelectOption(s,s));
            }
            return sortOptionList(fieldlist);
        }
    }
    
    public list<SelectOption> customObjectToFields{
        get{
            list<SelectOption> fieldlist = new list<SelectOption>();
            
            Map<String,Schema.SObjectType> gd = Schema.getGlobalDescribe();
            Schema.SObjectType sobjType = gd.get(toObject);
            Schema.DescribeSObjectResult r = sobjType.getDescribe();
            Map<String,Schema.SObjectField> M = r.fields.getMap();
            
            for (string s : m.keySet()){
                fieldlist.add(new SelectOption(s,s));
            }
            return sortOptionList(fieldlist);
        }
    }
    
    public pageReference saveFieldMapping(){
        return null;
    }
    
    public pagereference addFieldMapping(){
    	addingFieldMapping = true;    	
    	return null;
    }
    
    public pagereference cancel(){
        addingFieldMapping = false;
        return null;
    }
    
    public pageReference deleteFieldMapping(){
    	if (fieldMappingName != null){
    		delete [select id from xingUserMapping__c where Name = :fieldMappingName];
    		objectMappingMap.remove(fieldMappingName);
    		objectMappingList = objectMappingMap.values();
    		objectMappingListSize = objectMappingList.size();
    	}    	    	
    	return null;
    }
    
    //http://improveit360.blogspot.com/2010/09/implementing-quicksort-to-sort-list-of.html
    private list<SelectOption> sortOptionList(list<SelectOption> ListToSort)
    {
        if(ListToSort == null || ListToSort.size() <= 1)
            return ListToSort;
            
        List<SelectOption> Less = new List<SelectOption>();
        List<SelectOption> Greater = new List<SelectOption>();
        integer pivot = ListToSort.size() / 2;
          
        // save the pivot and remove it from the list
        SelectOption pivotValue = ListToSort[pivot];
        ListToSort.remove(pivot);
        
        for(SelectOption x : ListToSort)
        {
            if(x.getLabel() <= pivotValue.getLabel())
                Less.add(x);
            else if(x.getLabel() > pivotValue.getLabel()) Greater.add(x);   
        }
        List<SelectOption> returnList = new List<SelectOption> ();
        returnList.addAll(SortOptionList(Less));
        returnList.add(pivotValue);
        returnList.addAll(SortOptionList(Greater));
        return returnList;   
    }
}