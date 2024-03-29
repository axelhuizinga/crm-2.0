package db;

import shared.DbData;
import db.DbRelation;
import db.DbUser;
import state.UserState;

typedef DBAccessResolveMessage = {
	?success:String,
	?failure:String,
	?failureClass:String
}

typedef DBAccessJsonResponse = {
	?data:String,
	?message:DBAccessResolveMessage
}

typedef DBAccessProps = {	
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
	?dbRelations:Array<DbRelationProps>,
	?dbUser:DbUser,
	?dbJoinParams:DataSource,//Map<String,Map<String,Dynamic>>,	
	?dbQuery:DbQuery,
	?dataSource:DataSource,
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