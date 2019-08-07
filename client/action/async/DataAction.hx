package action.async;


import redux.Redux.Dispatch;
import redux.thunk.Thunk;
import shared.DbData;
import state.DataAccessState;

/**
 * ...
 * @author axel@cunity.me
 */

enum  DataAction
{
	Create(data:DbData);
	Delete(data:DbData);
	Error(data:DbData);
	Load(data:DbData);
	Update(data:DbData);
}
