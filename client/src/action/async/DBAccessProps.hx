package action.async;
import state.UserState;

typedef DBAccessProps = 
{
	action:String,	
	?batchCount:Int,
	?batchSize:Int,
	?offset:Int,
	className:String,
	?filter:String,
	?dataSource:Map<String,Map<String,Dynamic>>,
	?limit:Int,
	?totalRecords:Int,
	?synced:Int,
	?table:String,
	user:UserState
}