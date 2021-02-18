package store;
import me.cunity.debug.Out;
import action.StatusAction;
import action.async.UserAccess;
import state.UserState;
import action.DataAction;
import react.ReactSharedInternals.Update;
import App;
import action.AppAction;
import haxe.Http;
import haxe.Json;
import haxe.Constraints.Function;
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
using StringTools;
using shared.Utils;
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
	
	public function new(uStore:UserStore) 
	{
		//var user = new UserStore();
		initState = {
			//app:{},
			//config:App.config,
			//dataStore: {},
			//firstLoad:true,
			//formStates: new Map(),
			//themeColor: 'green',
			//locale: 'de',			
			//routeHistory: new Array(),
			
			//redirectAfterLogin: (Browser.location.pathname=='/'?'/DashBoard':Browser.location.pathname), 
			 
			status: {
				date:Date.now(),
				path: Browser.location.pathname,
				text: '',
				userState:null
			},
			userState:null//uStore.store.getState()
			/*{
				first_name:'',
				last_name:'',
				mandator: 1,
				id:Cookie.get('userState.dbUser.id')==null?0:Std.parseInt(Cookie.get('userState.dbUser.id')),
				email:'',
				pass:'',				
				change_pass_required:false,
				online:false,//Cookie.get('userState.dbUser.jwt')!=null && UserAccess.verify(),
				loginTask: (Browser.location.pathname.startsWith('/ResetPassword')?LoginTask.ResetPassword:LoginTask.Login),
				last_login:null,
				jwt:(Cookie.get('userState.dbUser.jwt')==null?'':Cookie.get('userState.dbUser.jwt')),
				waiting: true
			}*/
		};
		trace(store);
	}
	
	public function reduce(state:AppState, action:AppAction):AppState
	{
		trace(Reflect.fields(state));
		trace(action);
		return switch(action)
		{
			case ApplySubState(subState):
				copy(state,subState);
			case Data(dataAction):
				trace(dataAction);
				switch (dataAction)
				{
					case ContactsLoaded(data):
					trace(data.dataRows);
					copy(state,
						{dataStore:{contactsDbData:data}});

					default:
						state;
				}
			/*case Status(action):
				copy(state,
					{status:{text:'666'}});				
			case FormChange(cfp, fState):
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
		//trace(Type.enumConstructor(action)+'.'+Type.enumConstructor(Type.enumParameters(action)[0]));
		//Out.dumpObject(Type.enumParameters(action));
		/*Type.enumParameters(action).map(function (p) {
			trace(p);
			return p;
		});*/
		return switch(action)
		{			
			/*case GlobalState(key, value):
				trace('eating global $key=>$value');
				next();
			//case DataLoaded(component:String,sData:IntMap<Map<String,Dynamic>>):
			case DataLoaded(component,sData):
				next();
			*/	
			case Status(action):
				
				//store.dispatch(StatusAction.Update(copy(Type.enumParameters(action)[0])));
				store.dispatch(action);
			/*	next();
				
			case Status(status):
				trace(status);
				//Out.dumpStack(CallStack.callStack());ReduxAction
				//store.dispatch(StatusAction.Status(status));
				next();
			case Data(action):
				//store.dispatch(action);		
				next();
			//case Thunk.Action(f):
				//store.dispatch(action);
			case Status(action):	
				store.dispatch(action);*/
			case Location(action):
				store.dispatch(action);
			case User(action):
				store.dispatch(action);
				//next();
			//default: next();
			default: 
				//store.dispatch(action);
				next();
				//store.dispatch(action);
		}
	}
	
}