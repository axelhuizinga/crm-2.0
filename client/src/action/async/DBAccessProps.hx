package action.async;
import state.UserState;

typedef DBAccessProps = 
{
	action:String,
	className:String,
	?filter:String,
	?dataSource:Map<String,Map<String,Dynamic>>,
	?table:String,
	user:UserState
}