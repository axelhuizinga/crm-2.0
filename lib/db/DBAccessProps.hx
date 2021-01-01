package db;

import db.DbRelation;
import db.DbUser;
import state.UserState;

typedef DBAccessAction = {
	action:String,
	?classPath:String,
	?action_id:Int,
	?offset:Int,
	?onlyNew:Bool,
	?limit:Int,	
	?maxImport:Int,
	?totalRecords:Int
}

typedef DBAccessResolveMessage = {
	?success:String,
	?failure:String
}

typedef DBAccessProps = {	
	>DBAccessAction,	
	?relations:Map<String,DbRelation>,
	?dataSource:Map<String,Map<String,Dynamic>>,	
	?dbUser:DbUser,
	?devIP:String,	
	?extDB:Bool,	
	//?firstBatch:Bool,
	?filter:Dynamic,
	?data:Dynamic,	
	?mandator:Int,
	?pages:Int,
	?resolveMessage:DBAccessResolveMessage,
	?table:String,
	?userState:UserState
}