package store;
import action.AppAction;
import action.LocationAction;
import haxe.Http;
import haxe.Json;
import history.History;
import history.Location;
import js.Browser;
import js.Promise;
import react.ReactUtil;
import redux.Redux;
import redux.Redux.Dispatch;
import view.shared.io.User;
import react.ReactUtil.copy;
import redux.IMiddleware;
import redux.IReducer;
import redux.StoreMethods;
import state.AppState;
import state.LocationState;


/**
 * ...
 * @author axel@cunity.me
 */

class LocationStore implements IReducer<LocationAction, LocationState>
	implements IMiddleware<LocationAction, AppState>
{
	public var initState:LocationState = {
		history:null,
		location:null
	}
	
	public var store:StoreMethods<AppState>;
	
	public function new() 
	{ 
		trace('ok');
	}	
	
	public function reduce(state:LocationState, action:LocationAction):LocationState
	{
		//trace(action);
		return switch(action)
		{
			case InitHistory(history):
				copy(state, history);
				
			case LocationChange(location):
				trace(location.pathname);
				copy(state, location);
			default:
				state;
		}
	}
	
	public function middleware(action:LocationAction, next:Void -> Dynamic):Dynamic
	{
		trace(action);
		return switch(action)
		{
			/*case Push(url, state):
				history.push(url, state);
				{};
			case Replace(url, state):
				history.replace(url, state);
				{}
			case Go(to):
				history.go(to);
				{}
			case Back:
				history.goBack();
				{};
			case Forward:
				history.goForward();
				{};*/
			default:
				next();
		}
	}	
}