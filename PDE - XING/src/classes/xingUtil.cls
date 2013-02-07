public class xingUtil {
    
    public static Saved_URL__c savedURL	{get;set;}
    
    
    public static String get(String urlName) {
		if(urlName != null && urlName != ''){
            
            savedURL = [SELECT Id, Name, url__c,OAuth_Service__r.Name FROM Saved_URL__c WHERE Name =: urlName];
            System.debug('savedURL: ' + savedURL);
            

	        String endpoint = savedURL.url__c;
            
	        return doGet(endpoint);
        } else {        	
            System.debug('Xing Error: ID cannot be null/empty to make an API Call.');
            throw new xingException('ID cannot be null/empty to make an API Call.');
        }
	}
    
    private static String doGet(String url) {
    	String response;
    	
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        req.setMethod('GET');
        req.setHeader('x-li-format', 'json');
            
        OAuth oa = new OAuth();
        if(!oa.setService(savedURL.OAuth_Service__r.Name)) {
            System.debug('setService: ' +  oa.message);                               
        }
        oa.sign(req);
        System.debug('Sending request...');
        HttpResponse res = h.send(req);
        response = res.getBody();
        
        System.debug('API RESP: '+response);
        
        return response;
    }

}