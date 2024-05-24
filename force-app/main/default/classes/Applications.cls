public inherited sharing class Applications extends ObjDomain {
    public Applications(Application__c[] sObjectList){
        super(sObjectList);
    }
    public Applications(Application__c[] sObjectList, Map<Id, Application__c> sObjectMap){
        super(sObjectList,sObjectMap);
    }
    
    public void numberOfApplications(){
        //Retrieve the list of positions and predefine a total of zero
        Map<Id,Integer> myMap=new Map<Id,Integer>();
        for(Application__c Application:(Application__c[])Records){
            myMap.put(Application.Position__c,0);
        }
        //Count the children if any
        for(AggregateResult ar:[Select count(Id) sum, Position__c from Application__c where Position__c in:myMap.keySet() group By Position__c]) {
            myMap.put((Id)ar.get('Position__c'),(Integer)ar.get('sum'));
        }
        //Prepare the list of records to update
        Position__c[] Pos=new Position__c[]{};
        for(Id i:myMap.keySet()){
            Pos.add(new Position__c(Id=i,Number_of_Applications__c=myMap.get(i)));
        }
        Update Pos;
    }    
    
}