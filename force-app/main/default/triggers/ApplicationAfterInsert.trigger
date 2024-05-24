trigger ApplicationAfterInsert on Application__c (before insert) {
	new Applications(Trigger.new).handleAfterInsert();
}