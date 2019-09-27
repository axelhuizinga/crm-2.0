package store;

import action.async.UserAccess;
import action.UserAction;
import js.Cookie;
import react.ReactUtil.copy;
import redux.IReducer;
import redux.IMiddleware;
import redux.StoreMethods;
import state.AppState;
import state.UserState;
/**
 * ...
 * @author axel@cunity.me
 */

class UserStore implements IReducer<UserAction, UserState>
	implements IMiddleware<UserAction, AppState>
{
	public var initState:UserState = {
		first_name:'',
		last_name:'',
		mandator: 1,
		id:Cookie.get('user.id')==null?0:Std.parseInt(Cookie.get('user.id')),
		email:'',
		pass:'',				
		change_pass_required:false,
		loggedIn:Cookie.get('user.jwt')!=null,
		last_login:null,
		jwt:(Cookie.get('user.jwt')==null?'':Cookie.get('user.jwt')),
		waiting: false
	};
	
	public var store:StoreMethods<AppState>;
	
	public function new() {}
	
	public function reduce(state:UserState, action:UserAction):UserState
	{
		//trace(action);
		return switch(action)
		{
			case LoginRequired(uState):
					trace(uState);
					copy(state, uState);                             
			case LoginError(err):
					trace(err);
					//if(err.id==state.user.id)
					copy(state, {
						loggedIn:false,
						jwt:'',
						loginError:err.loginError, waiting:false});                       
			case LoginComplete(uState):
					//trace(uState.id + ':' + uState.loggedIn);
					trace(uState);
					copy(state, {		
						change_pass_required:uState.change_pass_required,				
						id:uState.id,
						jwt:uState.jwt,
						loginError: null,
						loggedIn: true,
						pass:uState.pass,
						waiting:false
					});                                             
			case LogOutComplete(uState):
					trace(uState);
					copy(state, {
						change_pass_required:uState.change_pass_required,
						loginError: null,
						loggedIn: false,					
						jwt:'',
						waiting:false
					});   					
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