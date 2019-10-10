package store;

import history.Location;
import history.History;
import js.Browser;
import js.html.BroadcastChannel;
import action.LocationAction;
import react.ReactUtil.copy;
import redux.IReducer;
import state.LocationState;

class LocationStore implements IReducer<LocationAction,LocationState> 
{
	public var initState:LocationState;

	public function new(history:History) 
	{
		initState = {
			history:history,
			location:null,
			lastModified:Date.now(),
			redirectAfterLogin: (Browser.location.pathname=='/'?'DashBoard':Browser.location.pathname)
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
			default:
				state;
		}
	}
	
}