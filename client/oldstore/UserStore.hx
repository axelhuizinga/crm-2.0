package store;

import react.ReactUtil.copy;
import redux.IReducer;
import redux.IMiddleware;
import redux.StoreMethods;

/**
 * ...
 * @author axel@cunity.me
 */


/*
enum UserAction
{
	AppWait;

	LoginError(state:UserProps);
	LogOut(state:UserProps);	
}

class UserStore implements IReducer<UserAction, UserProps>
	implements IMiddleware<UserAction, state.AppState>
{
	public var initState:UserProps = {
		id:'',
		pass:'',
		waiting:false,
		jwt:''			
	};
	
	public var store:StoreMethods<state.AppState>;
	
	public function new() {}
	
	public function reduce(state:UserProps, action:UserAction):UserProps
	{
		trace(state);
		return switch(action)
		{
			case LoginError(err):
				if(err.id==state.id)
					copy(state, err);
				else
					state;
					
			case AppWait:
				copy(state, {waiting:true});
				
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
}*/	