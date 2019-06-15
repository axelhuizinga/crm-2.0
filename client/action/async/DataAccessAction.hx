package action.async;

import action.AppAction;
import model.AppState;
import model.DataAccessState;

import js.html.XMLHttpRequest;

import redux.Redux.Dispatch;
import redux.thunk.Thunk;
import shared.DbData;

/**
 * ...
 * @author axel@cunity.me
 */

class DataAccessAction 
{
	public static function dataReq(props:DataAccessState) 
	{
		return Thunk.Action(function(dispatch:Dispatch, getState:Void->AppState){
			trace(getState());
			if (!props.user.loggedIn)
			{
				return dispatch(AppAction.LoginError(
				{
					user_name:props.user.user_name,
					loginError:'Du musst dich neu anmelden!',
					id:props.user.id
				}));
			}
				
			
			//*****/
			var spin:Dynamic = dispatch(AppAction.LoginWait);
			req.send();
			trace(spin);
			return spin;			
		});
	}
}