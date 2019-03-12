package reduce;
import react.ReactSharedInternals.Update;
import App;
import action.AppAction;
import haxe.Http;
import haxe.Json;
import haxe.ds.StringMap;
import js.Browser;
import js.Cookie;
import js.Promise;
import view.shared.io.User;
import react.ReactUtil.copy;
import redux.IMiddleware;
import redux.IReducer;
import redux.StoreMethods;
import react.router.ReactRouter;
import history.BrowserHistory;
import history.History;
import model.CState;
import model.AppState;
import model.GlobalAppState;
import Webpack.*;

/**
 * ...
 * @author axel@cunity.me
 */

class AppStore 
	implements IReducer<AppAction, GlobalAppState>
	implements IMiddleware<AppAction, AppState>
{

	public var initState:GlobalAppState = {
		config:App.config,
		firstLoad:true,
		history:BrowserHistory.create({basename:"/", getUserConfirmation:CState.confirmTransition}),
		themeColor: 'green',
		locale: 'de',
		redirectAfterLogin: Browser.location.pathname, 
		routeHistory: new Array(),
		userList:[],
		user:{
			first_name:'',
			last_name:'',
			user_name:(Cookie.get('user.user_name')==null?'':Cookie.get('user.user_name')),
			email:'',
			pass:'',
			loggedIn:false,
			last_login:null,
			jwt:(Cookie.get('user.jwt')==null?'':Cookie.get('user.jwt')),
			waiting: false
		}
	};
		
	public var store:StoreMethods<model.AppState>;
	
	public function new() 
	{
		//trace('OK');
		//initState.config = Reflect.field(appCconf, 'default');		
		//initState.config = appCconf;		
		//trace(initState.config);
	}
	
	public function reduce(state:GlobalAppState, action:AppAction):GlobalAppState
	{
		//trace(action);
		//trace(state.compState.get('dashboard'));
		return switch(action)
		{
			case Load:
				copy(state, {
					loading:true
				});
			
			case LoginChange(uState):
				copy(state, {
					user:{user_name:uState.user_name, pass:uState.pass}
				});
			case LoginRequired(uState):
				trace(uState);
				copy(state, {
					user:uState
				});
				
			case LoginError(err):
				trace(err);
				//if(err.user_name==state.user.user_name)
				copy(state, {user:{loginError:err.loginError, waiting:false}});
				//else
					///state;
					
			case LoginWait:
				copy(state, {waiting:true});
				
			case LoginComplete(uState):
				trace(uState.user_name + ':' + uState.loggedIn);
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
				else state;

			case User(uState):
			trace(state.user);
				copy(state, {
					user:copy(state.user,{first_name:uState.first_name, last_name:uState.last_name, email:uState.email, 
					last_login:uState.last_login, pass:uState.pass, new_pass:uState.new_pass, new_pass_confirm:uState.new_pass_confirm, waiting:uState.waiting})
				});	
			default:
				state;
		}
	}
	
	public function middleware(action:AppAction, next:Void -> Dynamic)
	{
		trace(action);
		/*var n = next();
		trace(n);
		return n;*/
		return switch(action)
		{			
			/*case LoginReq(uState):
				//store.getState().userStore.
				var n:Dynamic = next();
				trace(n);
				n;*/
			case LoginComplete(state):
				//App.firstLoad = false;	
				next();		
			case LoginError(err):
				trace(err);
				store.dispatch(AppAction.LoginRequired(store.getState().appWare.user));
			default: next();
		}
	}
	
}