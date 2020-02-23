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
	?className:String,
	?filter:Dynamic,
	?dataSource:Map<String,Map<String,Dynamic>>,
	?limit:Int,
	?maxImport:Int,
	?pages:Int,
	?offset:Int,
	//?outcome:DBAccessOutcome,
	?table:String,
	?totalRecords:Int,
	?userState:UserState
};