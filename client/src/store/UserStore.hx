package store;

import db.DbUser;
import js.Browser;
import action.async.UserAccess;
import action.UserAction;
import js.Cookie;
import react.ReactUtil.copy;
import redux.IReducer;
import redux.IMiddleware;
import redux.StoreMethods;
import state.AppState;
import state.UserState;
using StringTools;
using shared.Utils;
/**
 * ...
 * @author axel@cunity.me
 */

class UserStore implements IReducer<UserAction, UserState>
	implements IMiddleware<UserAction, UserState>
{
	public var initState:UserState;
	
	public var store:StoreMethods<UserState>;
	
	public function new() {
		/*if(Browser.location.pathname.startsWith('/ChangePassword')){
			var param:Map<String,Dynamic> = Browser.location.pathname.argList(
					['action','jwt','user_name','opath']
				);
			initState = {
				loginTask:LoginTask.ChangePassword,
				?new_pass_confirm:String,
				?waiting:Bool   				
				dbUser: new DbUser({
					first_name:Cookie.get('user.first_name')==null?'':Cookie.get('user.first_name'),
					//id:Cookie.get('user.id')==null?0:Std.parseInt(Cookie.get('user.id')),
					last_name:Cookie.get('user.last_name')==null?'':Cookie.get('user.last_name'),
					mandator: Cookie.get('user.mandator')==null?1:Std.parseInt(Cookie.get('user.mandator')),
					user_name:param.get('user_name'),
					email:Cookie.get('user.email')==null?'':Cookie.get('user.email'),
					password:'',				
					change_pass_required:false,
					online:false,//Cookie.get('user.jwt')!=null,
					//loginTask: LoginTask.ChangePassword,
					//last_login:null,
					jwt:param.get('jwt'),
					waiting: false
				})
			}
		}
		else	*/	
		initState =  {
			loginTask:null,
			waiting:true,   				
			dbUser: new DbUser({
				first_name:Cookie.get('user.first_name')==null?'':Cookie.get('user.first_name'),
				id:Cookie.get('user.id')==null?0:Std.parseInt(Cookie.get('user.id')),
				last_name:Cookie.get('user.last_name')==null?'':Cookie.get('user.last_name'),
				mandator: Cookie.get('user.mandator')==null?1:Std.parseInt(Cookie.get('user.mandator')),
				user_name:Cookie.get('user.user_name')==null?'':Cookie.get('user.user_name'),
				email:Cookie.get('user.email')==null?'':Cookie.get('user.email'),
				password:'',				
				change_pass_required:false,
				online:false,//Cookie.get('user.jwt')!=null,
				last_login:null,
				jwt:(Cookie.get('user.jwt')==null?'':Cookie.get('user.jwt'))
			})
		};
		trace(initState);
		trace(store);
	}
	
	public function reduce(state:UserState, action:UserAction):UserState
	{
		//trace(action);
		return switch(action)
		{
			case LoginChange(uState)|LoginRequired(uState):
				trace(uState);
				copy(state, uState);                             					
			case LoginError(err):
				trace(err);
				//if(err.id==state.user.id)
				copy(state, {lastError:err});   
			case LoginExpired(uState):
				copy(state, uState);  
	                    
			case LoginComplete(uState):
					//trace(uState.id + ':' + uState.online);
					trace(uState);
					copy(state, uState);                                             
			case LogOutComplete(uState):
					trace(uState);
					copy(state, uState);   					
			case LogOut(uState):
					trace(uState);
					copy(state, uState);      		
			default:
				state;
		}
	}

	public function middleware(action:UserAction, next:Void -> Dynamic)
	{
		//trace(store);
		return switch(action)
		{		
			//case LoginError(state):
				//store.dispatch(UserAccess.loginReq(state));
			//store.dispatch(UserAction.LoginRequired(state));
			//next();
			//
			default: 
			next();
		}
	}	
}