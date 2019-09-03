package store;

import action.UserAction;
import js.Cookie;
import react.ReactUtil.copy;
import redux.IReducer;
import redux.IMiddleware;
import redux.StoreMethods;
import state.UserState;

/**
 * ...
 * @author axel@cunity.me
 */

class UserStore implements IReducer<UserAction, UserState>
	//implements IMiddleware<UserAction, state.AppState>
{
	public var initState:UserState = {
		first_name:'',
		last_name:'',
		mandator: 1,
		id:Cookie.get('user.id')==null?0:Std.parseInt(Cookie.get('user.id')),
		email:'',
		pass:'',
		loggedIn:false,
		last_login:null,
		jwt:(Cookie.get('user.jwt')==null?'':Cookie.get('user.jwt')),
		waiting: true	
	};
	
	public var store:StoreMethods<state.AppState>;
	
	public function new() {}
	
	public function reduce(state:UserState, action:UserAction):UserState
	{
		trace(state);
		return switch(action)
		{
			case LoginRequired(uState):
					trace(uState);
					copy(state, uState);                             
			case LoginError(err):
					trace(err);
					//if(err.id==state.user.id)
					copy(state, {loginError:err.loginError, waiting:false});                       
			case LoginComplete(uState):
					//trace(uState.id + ':' + uState.loggedIn);
					trace(uState);
					uState.loginError = null;
					uState.loggedIn = true;
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
		trace(action);
		return switch(action)
		{		
			default: next();
		}
	}	
}