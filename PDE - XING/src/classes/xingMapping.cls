public class xingMapping {
	
    //public List<xingUserProfile__c> xingUserProfileList;
    
    public string xingUserField{get;set;}
    public string RDField{get;set;}
    
    public boolean addingFieldMapping{get; set;}
    public integer xumSize{get; set;} 
    public list<xingUserMapping__c> xum {get; set;}
    public map<string, xingUserMapping__c> xumMap;
    
    public xingMapping(){
        xumMap = xingUserMapping__c.getAll().clone();
        xum = xumMap.values();    
    	
    }
    
    public pageReference saveFieldMapping(){
    	//get existing Opp fields
    	set<string> userFields = new set<string>();
    	for (xingUserMapping__c xu : xum){
    		userFields.add(xu.userField__c);
    	} 
    	
    	//if (isValidMapping(RDField, xingUserField) && !userFields.contains(xingUserField)){
        if (true){
    	   string fmName = 'FieldMapping-' + system.now();	
    	   
    	   xingUserMapping__c myUM = new xingUserMapping__c(Name = fmName ,object__c = 'Contact' ,objectField__c = RDField , userField__c = xingUserField); 
    	   insert myUM;
    	   xum.add(myUM);
    	   xumSize = xum.size();
    	   xumMap.put(myUM.Name, myUM);
    	   addingFieldMapping = false;	
    	}    	
    	//add error
    	else{
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.WARNING, 'system.label.RecurringDonationBadFieldMapping');
            ApexPages.addMessage(myMsg);
    	}
        
    	return null;
    }   
    
    public list<SelectOption> availableRDFields{
        get{
            list<SelectOption> fieldlist = new list<SelectOption>();
            map<String, Schema.SObjectField> M = schema.SObjectType.Contact.fields.getMap();            
            for (string s : m.keySet()){
                fieldlist.add(new SelectOption(s,s));
            }
            return sortOptionList(fieldlist);
        }
    }
    
    public List<SelectOption> xingUserFields{
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
    
    //checks the compatibility of a recurring donation and opp field
    private boolean isValidMapping(string RDField, string OppField){
    	boolean isValid = false;
    	
    	Schema.Sobjectfield schemaRDField = schema.SObjectType.Contact.fields.getMap().get(RDField);
        Schema.Sobjectfield schemaOppField = schema.SobjectType.Opportunity.fields.getMap().get(OppField);
    	
    	if (schemaRDField != null && schemaOppField != null){
            Schema.DescribeFieldResult RDF = schemaRDField.getDescribe();
            Schema.DescribeFieldResult ODF = schemaOppField.getDescribe();                        		
    		if  ( RDF.isAccessible() && (ODF.isAccessible() && !ODF.isDeprecatedAndHidden() && ODF.isUpdateable()) && (RDF.getSoapType() == ODF.getSoapType())){
                isValid = true;                    		  
    		}
    	}
    	return isValid;
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
    
    public static void createProfile(xingPersonFullProfile fullProfile){
        List<xingUserProfile__c> xingUserProfileList = new List<xingUserProfile__c>();
        
        for(xingPersonFullProfile.Users user : fullProfile.users){
        	
            xingUserProfile__c xingUserReference = new xingUserProfile__c();
            xingUserReference.id__c = user.id;
            
            // Private Address
            xingUserAddress__c pa = new xingUserAddress__c();
            // Populate the fields
            pa.street__c = user.private_address.street;
            pa.zip_code__c = user.private_address.zip_code;
            pa.city__c = user.private_address.city;
            pa.province__c = user.private_address.province;
            pa.country__c = user.private_address.country;
            pa.type__c = 'private';
            pa.email__c = user.private_address.email;            
            pa.xingUserProfile__r = xingUserReference;
            
            // Business Address
            xingUserAddress__c ba = new xingUserAddress__c();
            // Populate the fields
            ba.street__c = user.business_address.street;
            ba.zip_code__c = user.business_address.zip_code;
            ba.city__c = user.business_address.city;
            ba.province__c = user.business_address.province;
            ba.country__c = user.business_address.country;
            ba.type__c = 'business';
            ba.email__c = user.business_address.email;            
            ba.xingUserProfile__r = xingUserReference;            
            
            // User Profile
            xingUserProfile__c x = new xingUserProfile__c();
        	x.Name = user.display_name;
            x.id__c = user.id;
            x.first_name__c = user.first_name;
            x.gender__c = user.gender;
            x.last_name__c = user.last_name;
            x.display_name__c = user.display_name;
            x.page_name__c = user.page_name;
            x.permalink__c = user.permalink;            
            x.birth_date__c = date.newinstance(user.birth_date.year,user.birth_date.month,user.birth_date.day);
            x.wants__c = user.wants;
            x.haves__c = user.haves;
            x.interests__c = user.interests;
            x.organisation_member__c = user.organisation_member;
            x.active_email__c = user.active_email;            
            
            Database.SaveResult[] results = Database.insert(new SObject[] { x, pa, ba });
            // Check results.
            for (Integer i = 0; i < results.size(); i++) {
                if (results[i].isSuccess()) {
                	System.debug('Successfully created ID: '+ results[i].getId());
                } else {
                	System.debug('Error: could not create sobject '+ 'for array element ' + i + '.');
                	System.debug('   The error reported was: '+ results[i].getErrors()[0].getMessage() + '\n');
                }
            }            
            
            // Get the id of the xingUserProfile
            Id xingUserId = results[0].getId();
            
            // Save all the phone/fax numbers
            List<xingUserPhone__c> xingUserPhoneList = new List<xingUserPhone__c>();
            
            // user.business_address.phone
            xingUserPhone__c bPhone = new xingUserPhone__c();
            bPhone.phoneNumber__c = user.business_address.phone;
            bPhone.phoneType__c = 'phone';
            bPhone.type__c = 'business';
            bPhone.xingUserProfile__c = xingUserId;
            xingUserPhoneList.add(bPhone);
            // user.business_address.mobile_phone
            xingUserPhone__c bmPhone = new xingUserPhone__c();
            bmPhone.phoneNumber__c = user.business_address.mobile_phone;
            bmPhone.phoneType__c = 'mobile';
            bmPhone.type__c = 'business';
            bmPhone.xingUserProfile__c = xingUserId;
            xingUserPhoneList.add(bmPhone);
            // user.business_address.fax
            xingUserPhone__c bFax = new xingUserPhone__c();
            bFax.phoneNumber__c = user.business_address.fax;
            bFax.phoneType__c = 'fax';
            bFax.type__c = 'business';
            bFax.xingUserProfile__c = xingUserId;
            xingUserPhoneList.add(bFax);
            
            // user.private_address.phone
            xingUserPhone__c pPhone = new xingUserPhone__c();
            pPhone.phoneNumber__c = user.private_address.phone;
            pPhone.phoneType__c = 'phone';
            pPhone.type__c = 'private';
            pPhone.xingUserProfile__c = xingUserId;
            xingUserPhoneList.add(pPhone);
            //user.private_address.mobile_phone;
            xingUserPhone__c pmPhone = new xingUserPhone__c();
            pmPhone.phoneNumber__c = user.private_address.mobile_phone;
            pmPhone.phoneType__c = 'mobile';
            pmPhone.type__c = 'private';
            pmPhone.xingUserProfile__c = xingUserId;
            xingUserPhoneList.add(pmPhone);
            //user.private_address.fax;
            xingUserPhone__c pFax = new xingUserPhone__c();
            pFax.phoneNumber__c = user.private_address.fax;
            pFax.phoneType__c = 'fax';
            pFax.type__c = 'private';
            pFax.xingUserProfile__c = xingUserId;
            xingUserPhoneList.add(pFax);
            
            insert xingUserPhoneList;
            
            
            List<xingUserPosition__c> xingUserPositionList = new List<xingUserPosition__c>();            
            // User Positions
            xingUserPosition__c ppc = new xingUserPosition__c();
            ppc.isCurrent__c = true;
            ppc.Name = user.professional_experience.primary_company.name;
            ppc.title__c = user.professional_experience.primary_company.title;
            ppc.companySize__c = user.professional_experience.primary_company.company_size;
            ppc.companyURL__c = user.professional_experience.primary_company.url;
            ppc.careerLevelName__c = user.professional_experience.primary_company.career_level;            
            ppc.startDate__c = StringToDate(user.professional_experience.primary_company.begin_date);
            ppc.description__c = user.professional_experience.primary_company.description;
            if(user.professional_experience.primary_company.end_date != null){
            	ppc.endDate__c = StringToDate(user.professional_experience.primary_company.end_date);
            }
            ppc.companyIndustryName__c = user.professional_experience.primary_company.industry;
            ppc.xingUserProfile__c = xingUserId;
            // Add to Primary company to the list
            xingUserPositionList.add(ppc);
            
            // Loop throw the other companies
            for(xingPersonFullProfile.Non_primary_companies company : user.professional_experience.non_primary_companies){
                xingUserPosition__c pnpc = new xingUserPosition__c();
                pnpc.Name = company.name;
                pnpc.title__c = company.title;
                pnpc.companySize__c = company.company_size;
                pnpc.companyURL__c = company.url;
                pnpc.careerLevelName__c = company.career_level;            
                pnpc.startDate__c = StringToDate(company.begin_date);
                pnpc.description__c = company.description;
                if(company.end_date != null){
                    pnpc.endDate__c = StringToDate(company.end_date);
                }
                pnpc.companyIndustryName__c = company.industry;
                pnpc.xingUserProfile__c = xingUserId;
                
            	xingUserPositionList.add(pnpc);
            }
            
            // Loop through the Education  
            List<xingUserEducation__c> xingUserEducationList = new List<xingUserEducation__c>();
            for(xingPersonFullProfile.Schools school : user.educational_background.schools){
                xingUserEducation__c edu = new xingUserEducation__c();
                
                edu.Name = school.name; 
                edu.degree__c = school.degree;
                edu.endDate__c = StringToDate(school.end_date);
                edu.fieldOfStudy__c = school.subject;
                edu.grade__c = ''; // No data from Xing
                edu.notes__c = school.notes;
                edu.startDate__c = StringToDate(school.begin_date);
                edu.xingUserProfile__c = xingUserId;
                
                xingUserEducationList.add(edu);
            }
            
            // Loop through the language
            List<xingUserLanguage__c> xingUserLanguageList = new List<xingUserLanguage__c>();
            for(xingPersonFullProfile.Language language : user.languages.values){
                xingUserLanguage__c lang = new xingUserLanguage__c();
                lang.Name = language.Name;
                lang.proficiency__c = language.level;
                lang.xingUserProfile__c = xingUserId;
            	xingUserLanguageList.add(lang);
            }
            
            //Skills
            List<xingUserSkill__c> xingUserSkillList = new List<xingUserSkill__c>();
            for(xingPersonFullProfile.Qualification qualification :user.educational_background.qualifications){
            	xingUserSkill__c skill =  new xingUserSkill__c();
                skill.Name = qualification.name;
                skill.xingUserProfile__c = xingUserId;
                xingUserSkillList.add(skill);
            }
            
            // WebProfiles
            List<xingUserWebProfile__c> xingUserWebProfileList = new List<xingUserWebProfile__c>();
            for(xingPersonFullProfile.webProfile wp :user.web_profiles.values ){
                for(xingPersonFullProfile.webURL weburl : wp.webURLs){
                    xingUserWebProfile__c webProfile = new xingUserWebProfile__c();
                    webProfile.Name = wp.name;
                    webProfile.type__c = 'other';                	
                	webProfile.url__c = weburl.url;
                    webProfile.xingUserProfile__c = xingUserId;
                    xingUserWebProfileList.add(webProfile);
                }                
            }
            
            // im Accounts
            for(xingPersonFullProfile.im_account im :user.im_accounts.values ){
                xingUserWebProfile__c webProfile = new xingUserWebProfile__c();
                webProfile.Name = im.label;
                webProfile.link__c = im.name;
                webProfile.type__c = 'im';
                webProfile.xingUserProfile__c = xingUserId;
                xingUserWebProfileList.add(webProfile);
            }
            
            // Awards & Honors
            List<xingUserHonor__c> xingUserHonorList = new List<xingUserHonor__c>();
                for(xingPersonFullProfile.Awards award : user.professional_experience.awards){
                    xingUserHonor__c xingUserHonor = new xingUserHonor__c();
                    xingUserHonor.Name = award.Name;
                    xingUserHonor.date__c = date.newinstance(award.date_awarded,1,1);
                    xingUserHonor.url__c = award.url;
                    xingUserHonor.xingUserProfile__c = xingUserId;
                    xingUserHonorList.add(xingUserHonor);
                }
            
            xingUserProfile__c profile = [SELECT Id FROM xingUserProfile__c WHERE id =:xingUserId];
            
            
            insert xingUserPositionList;
            insert xingUserEducationList;
            insert xingUserLanguageList;
            insert xingUserSkillList;
            insert xingUserWebProfileList;
            insert xingUserHonorList;
        }
        
        
    }
    
    public static date StringToDate(String s){        
        List<String> parts = s.split('-');
        Integer year = integer.valueOf(parts[0]);
        Integer month = integer.valueOf(parts[1]);
        Integer day = 1;
        date d = date.newinstance(year, month, day);
        System.Debug('xxx Date d: '+d);
        return d;
    }
    
    
}