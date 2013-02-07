public class SearchController {
    public List<xingUserProfile__c>	xingUserProfiles	{get;set;}
	public List<Account>			accounts			{get;set;}
    public List<Contact>			contacts			{get;set;}
    public List<Lead>				leads				{get;set;}
    
    Public String name {get;set;}

	public SearchController(){
	
		//List<List<SObject>> searchList = [FIND 'zoek*' IN ALL FIELDS RETURNING Account (Id, Name), Contact(Name), Lead];
        List<List<SObject>> searchList = [FIND 'zoek*' IN ALL FIELDS RETURNING xingUserProfile__c (Id, Name,wants__c)];
        
        xingUserProfiles = ((List<xingUserProfile__c>)searchList[0]);
        //contacts = ((List<Contact>)searchList[1]);
        //leads	 = ((List<Lead>)searchList[2]);
        
        
        //name = S.Name;
	}
}