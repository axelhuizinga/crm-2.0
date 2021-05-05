package store;
import redux.IReducer;
import action.AppAction;
import action.StatusAction;
import js.Browser;
import react.ReactUtil.copy;
import state.StatusState;

class StatusStore 
	implements IReducer<StatusAction, StatusState>
{
	public var initState:StatusState;
	
	public function new() {
		initState = {
			path:Browser.location.pathname,
			text: '',
			date:Date.now(),
			userState:null
		}
		trace(initState);
	}
	public function reduce(state:StatusState, action:StatusAction):StatusState
	{		
		//trace(action);
		trace(state);
		return switch(action)
		{
			case Update(status):
				//trace(status);
				copy(state,status);
			default:
				initState;
		}
	}
	
}