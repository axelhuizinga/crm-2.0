package action.async;
import db.DbQuery.DbQueryParam;
import state.UserState;
typedef DBAccessOutcome = 
{
	status:String,
	success:Bool
}

typedef DBAccessProps = DbQueryParam;/*
{
	?action:String,	
	?devIP:String,	
	?classPath:String,
	?filter:Dynamic,
	?dataSource:Map<String,Map<String,Dynamic>>,
	?limit:Int,
	?maxImport:Int,
	?pages:Int,
	?offset:Int,
	?onlyNew:Bool,
	?table:String,
	?totalRecords:Int,
	?userState:UserState
};
/*typedef DbQueryParam = {
	?action:String,	
	?classPath:String,
	?extDB:Bool,
	?relations:Map<String,DbRelation>,
	?devIP:String,	
	?filter:Dynamic,//Map<String,String>,
	?data:Dynamic,	
	?firstBatch:Bool,
	?onlyNew:Bool,
	?limit:Int,
	?maxImport:Int,
//	?pages:Int,
	?resolveMessage:DbQueryResolveMessage,
	?offset:Int,
	?table:String,
	?dbUser:DbUser
};*/