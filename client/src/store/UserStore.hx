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
		waiting: false	
	};
	
	public var store:StoreMethods<state.AppState>;
	
	public function new() {}
	
	public function reduce(state:UserState, action:UserAction):UserState
	{
		trace(state);
		return switch(action)
		{
			case LoginError(err):
				if(err.id==state.id)
					copy(state, err);
				else
					state;				
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