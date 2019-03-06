package model;

import react.router.ReactRouter;
import action.AppAction;
import action.LocationAction;
import history.Action;
import history.History;
import history.Location;
import history.TransitionManager;
import reduce.AppStore;
import reduce.LocationStore;
import reduce.StatusBarStore;
//import reduce.UserStore;
import redux.Redux;
import redux.Store;
import redux.StoreBuilder.*;
import redux.thunk.Thunk;
import redux.thunk.ThunkMiddleware;
import model.AppState;

class ApplicationStore
{
	static public function create():Store<AppState>
	{
		// store model, implementing reducer and middleware logic
		var appWare = new AppStore();
		var locationStore = new LocationStore();
		var statusBarStore = new StatusBarStore();
		//var userStore = new UserStore();
		
		// create root reducer normally, excepted you must use 
		// 'StoreBuilder.mapReducer' to wrap the Enum-based reducer
		var rootReducer = Redux.combineReducers(
			{
				appWare: mapReducer(AppAction, appWare),
				locationStore: mapReducer(LocationAction, locationStore),
				statusBar: mapReducer(StatusAction, statusBarStore)
				//userStore: mapReducer(UserAction, userStore)
			}
		);
		
		// create middleware normally, excepted you must use 
		// 'StoreBuilder.mapMiddleware' to wrap the Enum-based middleware
		var middleware = Redux.applyMiddleware(
			mapMiddleware(Thunk, new ThunkMiddleware())
			//mapMiddleware(StatusAction, statusBarStore)
			//mapMiddleware(AppAction, appWare)
			//mapMiddleware(LocationAction, locationStore)
		);
		
		// use 'StoreBuilder.createStore' helper to automatically wire
		// the Redux devtools browser extension:
		// https://github.com/zalmoxisus/redux-devtools-extension
		return createStore(rootReducer, null, middleware);
	}
	
	static public function startHistoryListener(store:Store<model.AppState>, history:History):TUnlisten
	{
		//trace(store);
		store.dispatch(InitHistory(history));
	
		return history.listen( function(location:Location, action:history.Action){
			//trace(action);
			trace(location.pathname);
			
			store.dispatch(LocationChange({
				pathname:location.pathname,
				search: location.search,
				hash: location.hash,
				key:null,
				state:null
			}));
		});
	}
	
}