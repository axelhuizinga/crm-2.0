package action.async;
import state.UserState;

typedef DBAccessProps = 
{
	?action:String,	
	?pages:Int,
	?className:String,
	?filter:String,
	?dataSource:Map<String,Map<String,Dynamic>>,
	?limit:Int,
	?maxImport:Int,
	?totalRecords:Int,
	?offset:Int,
	?table:String,
	?user:UserState
};