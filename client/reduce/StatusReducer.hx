package reduce;
import action.AppAction;
import action.StatusAction;
import js.Browser;
import react.ReactUtil.copy;
import state.StatusBarState;

class StatusReducer 
{
	public static var initState:StatusBarState = {
			status:Browser.location.pathname,// '',
			date:Date.now(),
			user:null
		}
	public static function reduce(state:StatusBarState, action:StatusAction):StatusBarState
	{
		trace(state);
		return switch(action)
		{
			case Tick(date):
			trace(date);
				copy(state, {
					date:date
				});
			case Status(status):
				trace(status);
				copy(state, {
					status:status
				});
			default:
				state;
		}
	}
	
}