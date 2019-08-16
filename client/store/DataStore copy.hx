package store;

import haxe.ds.IntMap;
import state.AppState;
import js.Cookie;
import redux.StoreMethods;
import redux.IMiddleware;
import action.async.DataAction;
import shared.DBAccess;
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
			dbData:new DbData(),
			selectedData: new IntMap()
			//user:store.getState().appWare.user 
			/*user:{
				mandator: 1,
				id:Cookie.get('user.id')==null?0:Std.parseInt(Cookie.get('user.id')),
				jwt:(Cookie.get('user.jwt')==null?'':Cookie.get('user.jwt')),
				waiting: false
			}*/
		};
		trace('ok');
	}
	
	public function reduce(state:AppState, action:DataAction):AppState
	{
		trace(state);
		return switch(action)
		{
			case Load(data):
			trace(data.dataParams);
				copy(state, {
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
			case Select(id, data, match):
				var sData = state.selectedData;
				sData.set(id,data);
				var baseUrl:String = match.path.split(':section')[0];
				baseUrl = '${baseUrl}${match.params.section}/${match.params.action}';	
				App.store.getState().appWare.history.push('${baseUrl}/${FormApi.params(sData.keys().keysList())}');					
				copy(state,{
					selectedData:sData
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
			case Update(data):
			store.dispatch(DBAccess.update(data));
				//next();
			default: next();
		}
	}	

}