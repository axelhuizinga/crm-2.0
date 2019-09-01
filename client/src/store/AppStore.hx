package store;
import react.ReactSharedInternals.Update;
import App;
import action.AppAction;
import action.ReduxAction;
import haxe.Http;
import haxe.Json;
import haxe.ds.StringMap;
import js.Browser;
import js.Cookie;
import js.Promise;
//import view.shared.io.User;
import react.ReactUtil.copy;
import redux.IMiddleware;
import redux.IReducer;
import redux.StoreMethods;
import react.router.ReactRouter;
import history.BrowserHistory;
import history.History;
import state.CState;
import state.AppState;
//import state.GlobalAppState;
import state.StatusState;
import Webpack.*;

/**
 * ...
 * @author axel@cunity.me
 */

class AppStore 
	implements IReducer<AppAction, AppState>
	implements IMiddleware<ReduxAction, AppState>
{
	public var initState:AppState;
		
	public var store:StoreMethods<AppState>;
	
	public function new() 
	{
		//trace('OK');
		initState = {
			config:App.config,
			history:BrowserHistory.create({basename:"/", getUserConfirmation:CState.confirmTransition}),
			/*firstLoad:true,
			formStates: new Map(),
			themeColor: 'green',
			locale: 'de',
			
			routeHistory: new Array(),*/
			redirectAfterLogin: (Browser.location.pathname=='/'?'DashBoard':Browser.location.pathname), 
			statusBar: {
				status: Browser.location.pathname,
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
		//initState.config = Reflect.field(appCconf, 'default');		
		//initState.config = appCconf;		
		//trace(initState.config);
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
				});			
			case LoginChange(uState):
				copy(state, {
					user:{id:uState.id, pass:uState.pass}
				});
			case LoginRequired(uState):
				trace(uState);
				copy(state, {
					user:uState
				});				
			case LoginError(err):
				trace(err);
				//if(err.id==state.user.id)
				copy(state, {user:{loginError:err.loginError, waiting:false}});
			case AppWait:
				copy(state, {waiting:true});				
			case LoginComplete(uState):
				//trace(uState.id + ':' + uState.loggedIn);
				trace(uState);
				uState.loginError = null;
				uState.loggedIn = true;
				copy(state, //uState.change_pass_required?:
				{
					user:copy(state.user,uState)
				});						
			case LogOut(uState):
				trace(uState);
				copy(state, {user:uState});				
			case SetLocale(locale):
				if (locale != state.locale)
				{
					copy(state, {
						locale:locale
					});
				}
				else state;	
			
			case SetTheme(color):
				if (color != state.themeColor)
				{
					copy(state, {
						themeColor:color
					});
				}
				else state;*/	
			/*case StatusBarStatus(status):
				trace(status);
				copy(state, {
					statusBar:{status:status}
				});		
			case User(uState):
			trace(state.user);
				copy(state, {
					user:copy(state.user,{first_name:uState.first_name, last_name:uState.last_name, email:uState.email, 
					last_login:uState.last_login, pass:uState.pass, new_pass:uState.new_pass, new_pass_confirm:uState.new_pass_confirm, waiting:uState.waiting})
				});	*/	
			default:
				state;
		}
	}
	
	public function middleware(action:ReduxAction, next:Void -> Dynamic)
	{
		trace(action);
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
	
			default: next();
		}
	}
	
}