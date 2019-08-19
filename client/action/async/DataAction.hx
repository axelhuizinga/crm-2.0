package action.async;

import haxe.ds.IntMap;
import react.router.RouterMatch;
import redux.Redux.Dispatch;
import redux.thunk.Thunk;
import shared.DbData;
import state.DataAccessState;

/**
 * ...
 * @author axel@cunity.me
 */
import shared.DBAccess;

enum  DataAction
{
	Execute(dataAccess:DBAccessProps);
	//Delete(data:DbData);
	Done(data:DbData);
	Error(data:DbData);
	Load(data:DbData);
	CreateSelect(id:Int,data:Map<String,Dynamic>,match:RouterMatch);
	Select(id:Int,data:Map<String,Dynamic>);

	//Update(data:DBAccessProps);
}
