public class xingSettingsController {
    
    public boolean 							addingFieldMapping		{get;set;}   
    
    public String							xingUserField			{get;set;}
    public String							customObject			{get;set;}
    public String							customObjectField		{get;set;}
    public List<xingUserMapping__c>			xingUserMappingList		{get;set;}
    public Map<String, xingUserMapping__c>	xingUserMappingMap;
    public integer 							xingUserMappingListSize	{get;set;}
    public string 							fieldMappingName		{get;set;}
    
    
    
    public PageReference getSettingsFirstTime() {
		customObject = 'Lead';
        xingUserMappingMap = xingUserMapping__c.getAll().clone();
        xingUserMappingList = xingUserMappingMap.values();

        return null;
    }
    
    public pageReference saveFieldMapping(){
        //get existing Opp fields
    	set<string> userFields = new set<string>();
    	for (xingUserMapping__c userField : xingUserMappingList){
    		userFields.add(userField.userField__c);
    	}    	
    	if (isValidMapping(xingUserField, customObjectField) && !userFields.contains(xingUserField)){        
    	   xingUserMapping__c xingUserMapping = new xingUserMapping__c(); 
           xingUserMapping.Name = 'FieldMapping-' + system.now();
           xingUserMapping.object__c = customObject;
           xingUserMapping.objectField__c = customObjectField;
           xingUserMapping.userField__c = xingUserField;
            
    	   insert xingUserMapping;
    	   xingUserMappingList.add(xingUserMapping);
    	   xingUserMappingListSize = xingUserMappingList.size();
    	   xingUserMappingMap.put(xingUserMapping.Name, xingUserMapping);
    	   addingFieldMapping = true;	
    	}    	
    	//add error
    	else{
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.WARNING, 'system.label.RecurringDonationBadFieldMapping');
            ApexPages.addMessage(myMsg);
    	}
        return null;
    }
    
    //checks the compatibility of a recurring donation and opp field
    private boolean isValidMapping(string xingUserField, string customObjectField){
    	boolean isValid = false;
    	
    	Schema.Sobjectfield schemaXingUserField		= schema.SObjectType.xingUserProfile__c.fields.getMap().get(xingUserField);
        //Schema.Sobjectfield schemacustomObjectField = schema.SobjectType.Contact.fields.getMap().get(customObjectField);
        Map<String, Schema.SObjectType> m  = Schema.getGlobalDescribe() ;
        Schema.SObjectType s = m.get(customObject) ;
        Schema.DescribeSObjectResult r = s.getDescribe() ;
        Schema.Sobjectfield schemaCustomObjectField = r.fields.getMap().get(customObjectField) ;
    	
    	if (schemaXingUserField != null && schemaCustomObjectField != null){
            Schema.DescribeFieldResult XUF = schemaxingUserField.getDescribe();
            Schema.DescribeFieldResult COF = schemacustomObjectField.getDescribe();                        		
    		if(XUF.isAccessible() && (COF.isAccessible() && !XUF.isDeprecatedAndHidden() && COF.isUpdateable()) && (XUF.getSoapType() == COF.getSoapType())){
                isValid = true;                    		  
    		}
    	}
    	return isValid;
    }
    
    public list<SelectOption> customObjects{
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
            //map<String, Schema.SObjectField> M = schema.SObjectType.Contact.fields.getMap();  
            Map<String,Schema.SObjectType> gd = Schema.getGlobalDescribe();
            Schema.SObjectType sobjType = gd.get(customObject);
            Schema.DescribeSObjectResult r = sobjType.getDescribe();
            Map<String,Schema.SObjectField> M = r.fields.getMap();
            
            for (string s : m.keySet()){
                fieldlist.add(new SelectOption(s,s));
            }
            return sortOptionList(fieldlist);
        }
    }
    
    public list<SelectOption> xingUserFields{
        get{
            list<SelectOption> fieldlist = new list<SelectOption>();
            map<String, Schema.SObjectField> M = schema.SObjectType.xingUserProfile__c.fields.getMap();            
            for (string s : m.keySet()){
                fieldlist.add(new SelectOption(s,s));
            }
            return sortOptionList(fieldlist);
        }
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
    		xingUserMappingMap.remove(fieldMappingName);
    		xingUserMappingList = xingUserMappingMap.values();
    		xingUserMappingListSize = xingUserMappingList.size();
    	}    	    	
    	return null;
    }
    
    public List<SelectOption> xingUserFieldsXXX{
    	get{
            list<SelectOption> fieldlist = new list<SelectOption>();
            fieldlist.add(new SelectOption('id','id'));
            fieldlist.add(new SelectOption('first_name','first_name'));
            fieldlist.add(new SelectOption('last_name','last_name'));
            fieldlist.add(new SelectOption('display_name','display_name'));
            fieldlist.add(new SelectOption('page_name','page_name'));
            fieldlist.add(new SelectOption('permalink','permalink'));
            fieldlist.add(new SelectOption('gender','gender'));
            fieldlist.add(new SelectOption('birth_date','birth_date'));
            fieldlist.add(new SelectOption('active_email','active_email'));
            fieldlist.add(new SelectOption('time_zone','time_zone'));
            fieldlist.add(new SelectOption('street','street'));
            fieldlist.add(new SelectOption('zip_code','zip_code'));
            fieldlist.add(new SelectOption('city','city'));
            fieldlist.add(new SelectOption('province','province'));
            fieldlist.add(new SelectOption('country','country'));
            fieldlist.add(new SelectOption('email','email'));
            fieldlist.add(new SelectOption('phone','phone'));
            fieldlist.add(new SelectOption('mobile_phone','mobile_phone'));
            fieldlist.add(new SelectOption('fax','fax'));
            
            return sortOptionList(fieldlist);
        }
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