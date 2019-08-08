package store;

import js.Cookie;
import redux.StoreMethods;
import redux.IMiddleware;
import action.async.DataAction;
import shared.DBAccess;
import state.DataAccessState;
import react.ReactUtil.copy;
import redux.IReducer;
import shared.DbData;

class DataStore
	implements IReducer<DataAction, DataAccessState>
	implements IMiddleware<DataAction, DataAccessState>
{
	public var initState:DataAccessState;
	public var store:StoreMethods<DataAccessState>;	

	public function new() 
	{ 
		initState = {
			dbData:new DbData(),
			user:{
				user_name:(Cookie.get('user.user_name')==null?'':Cookie.get('user.user_name')),
				jwt:(Cookie.get('user.jwt')==null?'':Cookie.get('user.jwt'))
			}
		};
		trace('ok');
	}
	
	public function reduce(state:DataAccessState, action:DataAction):DataAccessState
	{
		trace(state);
		return switch(action)
		{
			case Load(data):
			trace(data.dataParams);
				copy(state, {
					dbData:data,
					//user:initState.user,
					waiting:true
				});
			case Done(data):
				copy(state,
				{
					dbData:data
				}
				);
			default:
				state;
		}
	}
	
	public function middleware(action:DataAction, next:Void -> Dynamic)
	{
		trace(action);
		return switch(action)
		{
			case Update(data):
			store.dispatch(DBAccess.update(data));
				//next();
			default: next();
		}
	}	

}