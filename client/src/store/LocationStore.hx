package store;

import history.Location;
import history.History;
import js.Browser;
import js.html.BroadcastChannel;
import action.LocationAction;
import react.ReactUtil.copy;
import redux.IReducer;
import redux.IMiddleware;
import redux.StoreMethods;
import state.AppState;
import state.LocationState;

class LocationStore implements IReducer<LocationAction,LocationState> 
	implements IMiddleware<LocationAction,AppState> 
{
	public var initState:LocationState;
	public var store:StoreMethods<AppState>;

	public function new(history:History) 
	{
		initState = {
			history:history,
			location:null,
			lastModified:Date.now(),
			redirectAfterLogin: '/'//App.store.getState().redirectAfterLogin
			// (Browser.location.pathname=='/'?'/DashBoard':Browser.location.pathname)
		};	
	}

	public function reduce(state:LocationState, action:LocationAction):LocationState
	{
		trace(state.history.location);
		trace(state.location);
		if(store != null)
		trace(Reflect.fields(store));
		return switch(action)
		{
			case InitHistory(history):
				trace(state);
				copy(state, {
					history:history
				});
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
		trace(Reflect.fields(store.getState()));
		
		var history = store.getState().locationStore.history;//App._app.state.locationState.history;
		//var history = App._app.state.locationStore.history;
		return switch(action)
		{
			/*case LocationChange(location):
				trace(location.pathname);
				history.push(location.pathname);
				{};
			case Pop(url, state):
				history.push(url, state);
				{};				
			case Push(url, state):
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