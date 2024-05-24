trigger AccountBeforeInsert on Account (before insert) {
    if(Trigger.New.size()>1){
        System.debug('creating multiple accounts');
    }else{
        System.debug('creating one account');
    }
}