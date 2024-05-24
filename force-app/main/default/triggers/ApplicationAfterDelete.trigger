trigger ApplicationAfterDelete on Application__c (before insert) {
	new Applications(Trigger.old).handleAfterDelete();
}