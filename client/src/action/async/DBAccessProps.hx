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