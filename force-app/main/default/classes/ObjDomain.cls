//Classe de domaine héritant de la visibilité du contexte, donc sans explicitement mettre with ou without sharing
//C'est la classe appelante qui doit explicitement posséder with ou without sharing
public virtual class ObjDomain{
    public SObject[] Records { get; private set;}
    public Map<Id,SObject> existingRecords { get; private set;}
    
    public Schema.DescribeSObjectResult SObjectDescribe {get; private set;}
    
    static{
        //constructeur	
    }
    
    public ObjDomain(SObject[] sObjectList)	{
        Records = sObjectList;
        SObjectDescribe = Records.getSObjectType().getDescribe();
    }
    
    public ObjDomain(SObject[] sObjectList, Map<Id,SObject> sObjectMap)	{
        Records = sObjectList;
        existingRecords = sObjectMap;
        SObjectDescribe = Records.getSObjectType().getDescribe();
    }
    
    /**
* Surcharger pour définir des valeurs par défaut.
* Appelé par la méthode handleBeforeInsert()
**/
    public virtual void onApplyDefaults() { }
    
    /**
* Surcharger pour appliquer des validations générales
* appelé sur création et modification d'enregistrement
**/
    public virtual void onValidate() {	}
    
    /**
* Surcharger pour appliquer des validations générales
* Appelé sur mise à jour (pas sur création) pour comparer les valeurs existantes avec les valeurs nouvelles
**/
    public virtual void onValidateExisting()	{ }
    
    // ==== Insert : debut ====
    // A surcharger
    public virtual void onBeforeInsert() { }
    
    // A surcharger
    public virtual void onAfterInsert() { }
    
    // handler de base du trigger
    public virtual void handleBeforeInsert() {
        if(!SObjectDescribe.isCreateable()){
            for(SObject o:Records)o.addError('Permission de créer un ' + SObjectDescribe.getName() + ' refusée.');
        }else{
            onApplyDefaults();
            onBeforeInsert();
        }
    }
    // handler de base
    public void handleAfterInsert(){
        onValidate();
        onAfterInsert(); 
    }
    // ==== Insert : fin ====
    
    
    // ==== Update : debut ====
    // A surcharger
    public virtual void onBeforeUpdate() { }
    
    // A surcharger
    public virtual void onAfterUpdate() { }
    
    // handler de base
    public void handleBeforeUpdate() {
        if(!SObjectDescribe.isUpdateable()){
            for(SObject o:Records)o.addError('Permission de modifier un ' + SObjectDescribe.getName() + ' refusée.');
        }else onBeforeUpdate();
    }
    
    // handler de base
    public void handleAfterUpdate()     {
        onValidate();
        onValidateExisting();
        onAfterUpdate(); 
    }
    // ==== Update : fin ====
    
    
    // ==== Delete : debut ====
    // à surcharger
    public virtual void onBeforeDelete() { }
    
    // à surcharger
    public virtual void onAfterDelete() { }
    
    // handler de base du trigger
    public void handleBeforeDelete() {
        if(!SObjectDescribe.isDeletable()){
            for(SObject o:Records)o.addError('Permission de supprimer un ' + SObjectDescribe.getName() + ' refusée.');
        }else onBeforeDelete();
    }
    
    // Handler de base du trigger
    public void handleAfterDelete() {
        onAfterDelete();
    }
    // ==== Delete : fin ====
}