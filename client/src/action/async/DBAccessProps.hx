package action.async;
import state.UserState;
typedef DBAccessOutcome = 
{
	status:String,
	success:Bool
}

typedef DBAccessProps = 
{
	?action:String,	
	?pages:Int,
	?className:String,
	?filter:Dynamic,
	?dataSource:Map<String,Map<String,Dynamic>>,
	?limit:Int,
	?maxImport:Int,
	?totalRecords:Int,
	?offset:Int,
	?outcome:DBAccessOutcome,
	?table:String,
	?user:UserState
};