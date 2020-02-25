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
			text:Browser.location.pathname,// '',
			date:Date.now(),
			userState:null
		}
	}
	public function reduce(state:StatusState, action:StatusAction):StatusState
	{
		trace(state);
		return switch(action)
		{
			case Update(status):
				trace(status);
				copy(state, status);
			default:
				state;
		}
	}
	
}