package store;
import react.ReactSharedInternals.Update;
import App;
import action.AppAction;
import haxe.Http;
import haxe.Json;
import haxe.ds.StringMap;
import js.Browser;
import js.Cookie;
import js.Promise;
import react.ReactUtil.copy;
import redux.IMiddleware;
import redux.IReducer;
import redux.StoreMethods;
import react.router.ReactRouter;
import history.BrowserHistory;
import history.History;
import state.CState;
import state.AppState;
import state.StatusState;
import Webpack.*;

/**
 * ...
 * @author axel@cunity.me
 */

class AppStore 
	implements IReducer<AppAction, AppState>
	implements IMiddleware<AppAction, AppState>
{
	public var initState:AppState;
		
	public var store:StoreMethods<AppState>;
	
	public function new() 
	{
		initState = {
			app:{},
			config:App.config,
			dataStore: null,
			//firstLoad:true,
			formStates: new Map(),
			//themeColor: 'green',
			//locale: 'de',			
			//routeHistory: new Array(),
			redirectAfterLogin: (Browser.location.pathname=='/'?'DashBoard':Browser.location.pathname), 
			status: {
				text: Browser.location.pathname,
				date:Date.now(),
				user:null
			},
			user:{
				first_name:'',
				last_name:'',
				mandator: 1,
				id:Cookie.get('user.id')==null?0:Std.parseInt(Cookie.get('user.id')),
				email:'',
				pass:'',
				loggedIn:false,
				last_login:null,
				jwt:(Cookie.get('user.jwt')==null?'':Cookie.get('user.jwt')),
				waiting: false
			}
		};

		trace('redirectAfterLogin: ${initState.redirectAfterLogin}');
	}
	
	public function reduce(state:AppState, action:AppAction):AppState
	{
		trace(Reflect.fields(state));
		return switch(action)
		{
			case ApplySubState(subState):
				copy(state,subState);
			/*case FormChange(cfp, fState):
				var formStates = state.formStates;
				if(formStates.exists(cfp))
				{
					formStates.set(cfp, copy(formStates.get(cfp),fState));
				}
				else
				{
					formStates.set(cfp,fState);
				}
				copy(state,{
					formStates:formStates
				});		*/
			default:
				state;
		}
	}
	
	public function middleware(action:AppAction, next:Void -> Dynamic)
	{
		trace(Type.enumConstructor(action)+'.'+Type.enumConstructor(Type.enumParameters(action)[0]));
		return switch(action)
		{			
			/*case GlobalState(key, value):
				trace('eating global $key=>$value');
				next();
			//case DataLoaded(component:String,sData:IntMap<Map<String,Dynamic>>):
			case DataLoaded(component,sData):
				next();
			case Status(status):
				trace(status);
				//Out.dumpStack(CallStack.callStack());ReduxAction
				//store.dispatch(StatusAction.Status(status));
				next();*/
			case Data(action):
				store.dispatch(action);		
			case Status(action):	
				store.dispatch(action);
			case User(action):
				switch (action)
				{
					case LoginError(state):
						//store.dispatch(ApplySubState({user:state}));
						trace(ApplySubState({user:state}));
					
					default:
					//ignore
				}
				store.dispatch(action);
			//default: next();
			default: 
				next();
				//store.dispatch(action);
		}
	}
	
}