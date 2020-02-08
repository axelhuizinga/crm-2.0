package store;

import history.Location;
import history.History;
import js.Browser;
import js.html.BroadcastChannel;
import action.LocationAction;
import react.ReactUtil.copy;
import state.LocationState;
import redux.IReducer;
import redux.StoreMethods;

class LocationStore implements IReducer<LocationAction,LocationState> 
{
	public var initState:LocationState;

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
		if(state.location !=null)
		trace(state.location.pathname);
		return switch(action)
		{
			case InitHistory(history, location):
				trace(state);
				copy(state, {
					history:history,
					location:location
				});
			case LocationChange(location):
				trace(location.pathname);
				copy(state, location);				
			default:
				state;
		}
	}

	public function middleware(store:StoreMethods<LocationState>, action:LocationAction, next:Void -> Dynamic):Dynamic
	{
		trace(action);
		var history = store.getState().history;//App._app.state.locationState.history;
		return switch(action)
		{
			case LocationChange(location):
				trace(location.pathname);
				history.push(location.pathname);
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
				{};
			default:
				next();
		}
	}
	
}