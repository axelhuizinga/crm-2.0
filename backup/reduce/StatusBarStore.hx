package reduce;
import action.AppAction;
import haxe.Http;
import haxe.Json;
import js.Browser;
import js.Promise;
import view.shared.io.User;
import react.ReactUtil.copy;
import redux.IMiddleware;
import redux.IReducer;
import redux.StoreMethods;


typedef StatusBarState =
{
	pathname: String,
	date:Date,
	?hasError:Bool
}


/**
 * ...
 * @author axel@cunity.me
 */

class StatusBarStore implements IReducer<StatusAction, StatusBarState>
//	implements IMiddleware<StatusAction, AppState>
{
	public var initState:StatusBarState = {
		pathname: Browser.location.pathname,// '',
		date:Date.now()
	};
	public var store:StoreMethods<model.AppState>;

	var ID = 0;
	var loadPending:Promise<Bool>;
	
	public function new() 
	{ 
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