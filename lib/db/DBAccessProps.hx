package db;

import shared.DbData;
import db.DbRelation;
import db.DbUser;
import state.UserState;

typedef DBAccessResolveMessage = {
	?success:String,
	?failure:String
}

typedef DBAccessJsonResponse = {
	?data:String,
	?message:DBAccessResolveMessage
}

typedef  DBAccessProps = {	
	?action:String,	
	?classPath:String,
	?componentPath:String,
	?fields:String,
	?id:Int,
	?offset:Int,
	?onlyNew:Bool,
	?limit:Int,	
	?maxImport:Int,
	?totalRecords:Int,
	?relations:Map<String,DbRelation>,
	?dataSource:DataSource,//Map<String,Map<String,Dynamic>>,	
	?dbUser:DbUser,
	?devIP:String,	
	?extDB:Bool,	
	?viciBoxDB:Bool,
	?filter:Dynamic,
	?data:Dynamic,	
	?order:Dynamic,
	?jThen:DBAccessJsonResponse->Void,
	?mandator:Int,
	?page:Int,
	?resolveMessage:DBAccessResolveMessage,
	?table:String,
	?then:DbData->Void,
	?userState:UserState
}