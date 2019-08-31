package reduce;
import action.AppAction;
import action.ConfigAction;
import js.Browser;
import react.ReactUtil.copy;
import state.ConfigState;

class ConfigReducer 
{
	public static var initState:ConfigState = {
			params:null
		}
	public static function reduce(state:ConfigState, action:ConfigAction):ConfigState
	{
		trace(state);
		trace(action);
		return switch(action)
		{
			case Loaded(p):
				trace(p);
				copy(initState, {
					params:p
				});
			default:
				state;
		}
	}
	
}