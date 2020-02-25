package store;
import haxe.CallStack;
import me.cunity.debug.Out;
import action.AppAction;
import action.StatusAction;
import haxe.Http;
import haxe.Json;
import js.Browser;
import js.lib.Promise;
import view.shared.io.User;
import react.ReactUtil.copy;
import redux.IMiddleware;
import redux.IReducer;
import redux.StoreMethods;
import state.AppState;
import state.StatusBarState;

/**
 * ...
 * @author axel@cunity.me
 */

class StatusBarStore implements IReducer<StatusAction, StatusBarState>
	//implements IMiddleware<StatusAction, AppState>
{
	public var initState:StatusBarState;
	public var store:StoreMethods<AppState>;
	
	var loadPending:Promise<Bool>;
	
	public function new() 
	{ 
		initState = {
			status: Browser.location.pathname,// '',
			date:Date.now(),
			userState:null
		};
		trace('ok');
	}
	
	public function reduce(state:StatusBarState, action:StatusAction):StatusBarState
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
	
	public function middleware(action:StatusAction, next:Void -> Dynamic)
	{
		trace(action);
		return switch(action)
		{
			default: next();
		}
	}	
}