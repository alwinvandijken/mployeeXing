global class xingProfileController {
    
    global String action		{get;set;}
    global String errorMessage	{get;set;}  
    
    // Classes
    global xingPersonFullProfile		fullProfile		{get;set;} 
    
    public void getPersonBasicProfile(){        
        try {
            String urlName = 'usersMe';
            fullProfile = new xingPersonFullProfile(urlName);
            action = 'getFullProfile';
        } catch (Exception e) {
            errorMessage = e.getMessage();
            action = 'error';
        } 
    }
    
    public void createPersonBasicProfile(){
        xingMapping.createProfile(fullProfile); 
    
    }

}