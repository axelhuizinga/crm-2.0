package store;

import action.async.LivePBXSync;
import haxe.ds.IntMap;
import state.AppState;
import js.Cookie;
import redux.StoreMethods;
import redux.IMiddleware;
import action.DataAction;
import action.async.DBAccess;
import action.async.LiveDataAccess;
import state.DataAccessState;
import react.ReactUtil.copy;
import redux.IReducer;
import shared.DbData;
import view.shared.io.FormApi;
using shared.Utils;

class DataStore
	implements IReducer<DataAction, DataAccessState>
	implements IMiddleware<DataAction, AppState>
{
	public var initState:DataAccessState;
	public var store:StoreMethods<AppState>;	

	public function new() 
	{ 
		initState = {
			//dbData:new DbData(),			
			contactData: new IntMap(),
			dealData: new IntMap(),
			accountData: new IntMap()
		};
		trace('ok');
	}
	
	public function reduce(state:DataAccessState, action:DataAction):DataAccessState
	{
		//trace(state);
		trace(Reflect.fields(state));
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
				});
			case SelectAccounts(sData):
				trace(sData.keys().keysList());
				copy(state,{
					contactData:sData
				});
			case SelectActContacts(sData):
				trace(sData.keys().keysList());
				copy(state,{
					contactActData:sData
				});				
			case SelectContacts(sData):
				trace(sData.keys().keysList());
				copy(state,{
					contactData:sData
				});
			case SelectDeals(sData):
				trace(sData.keys().keysList());
				copy(state,{
					contactData:sData
				});
			default:
				state;
		}
	}
	
	public function middleware(action:DataAction, next:Void -> Dynamic)
	{
		trace(Type.enumConstructor(action));
		return switch(action)
		{
			/*case CreateSelect(id, data, match):
				//next();
				store.dispatch(LiveDataAccess.select({id:id,data:data,match:match}));
				//next();*/
			case Execute(data):
				store.dispatch(DBAccess.execute(data));
				//next();
			case Sync(data):
				store.dispatch(LivePBXSync.syncAll(data));
			default: next();
		}
	}	

}