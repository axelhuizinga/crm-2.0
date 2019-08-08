package action.async;


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
	Create(data:DbData);
	Delete(data:DbData);
	Done(data:DbData);
	Error(data:DbData);
	Load(data:DbData);
	Update(data:DBAccessProps);
}
