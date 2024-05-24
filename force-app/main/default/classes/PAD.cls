public class PAD{
    @TestVisible
    private static final String BP_ALL_TRG_DNAME = 'bpAllTRG';
    @TestVisible
    private static final String BP_DNAME_PATTERN = 'bp%';
    private static final Set<String> requiredOnce=new Set<String>{'bpAP123','bpAP432'};//List of Apex codes that should run only once. Add any code to the list
    @TestVisible
    private static Set<String> hasRun=new Set<String>();//List of Apex code that has already been run. Keep this list empty.
    public static String PAD_BypassTrigger{get; private set;}//List of triggers that can be bypassed
    public static Set<String> ApexForcedBypass=new Set<String>();//ex: 'bpAP123','bpAP432'//List of Apex codes that need to be bypassed, dynamically and temporaryly managed by Apex Code

    public static Boolean bypassAll=false;//Can be set by Apex Code to avoid running any logic
    static{
        //Retrieve custom permissions assigned to a user, no matter within which PermissionSet
        //the DeveloperName of the custom permission must begin with 'bp'. Example bpOwnerAlert. permission sets can have any naming convention
        String strTmp='';
        for(CustomPermission cp:[SELECT DeveloperName,(SELECT Id FROM Setupentityaccessitems WHERE SetupEntityType='CustomPermission' AND ParentId IN(SELECT PermissionSetId FROM PermissionSetAssignment WHERE AssigneeId= :UserInfo.getUserId()) limit 1)
FROM CustomPermission where DeveloperName like :BP_DNAME_PATTERN])if(cp.SetupEntityAccessItems!=null && cp.SetupEntityAccessItems.size()>0)strTmp+=cp.DeveloperName+';';
        PAD_BypassTrigger=';'+strTmp;
    }
    /**
     *  @return Boolean : True si le traitement doit avoir lieu (= apexName non trouvé/pas de bypass all) ; False sinon
     */
    public static Boolean canTrigger(String apexName){//If no bypass
        if(requiredOnce.contains(apexName)){//If it should run Once
            if(hasRun.contains(apexName))return false;//Already run, should not run
            hasRun.add(apexName);//Never run, can run only if not bypassed
        }
        return(PAD_BypassTrigger.indexOf(';'+apexName+';')==-1 && !ApexForcedBypass.contains(apexName) && !bypassAll && PAD_BypassTrigger.indexOf(';'+BP_ALL_TRG_DNAME+';')==-1);
    }
}