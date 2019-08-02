package store;

import action.async.DataAction;
import model.DataAccess;
import model.DataAccessState;
import react.ReactUtil.copy;
import redux.IReducer;
import shared.DbData;

class DataStore
	implements IReducer<DataAction, DataAccessState>
	//implements IMiddleware<DataAction, DataAccessState>
{
	public var initState:DataAccessState;
	public function new() 
	{ 
		initState = {
			dbData:new DbData(),
			user:App._app.state.appWare.user,
			waiting:false
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
					dbData:data
				});
			default:
				state;
		}
	}
	
	public function middleware(action:DataAction, next:Void -> Dynamic)
	{
		trace(action);
		return switch(action)
		{
			default: next();
		}
	}	

}