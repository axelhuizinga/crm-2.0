package shared;

import state.AppState;
import action.AppAction.*;
import haxe.Serializer;
import haxe.http.HttpJs;
import state.DataAccessState;

import js.html.XMLHttpRequest;

import redux.Redux.Dispatch;
import redux.thunk.Thunk;
import shared.DbData;
import loader.BinaryLoader;
import view.shared.OneOf;

/**
 * ...
 * @author axel@cunity.me
 */

typedef DBAccessProps = Dynamic;

class DBAccess
{
	public static function create() {
		
	}

	public static function delete() {
		
	}

	public static function load(props:DBAccessProps) 
	{
		return Thunk.Action(function(dispatch:Dispatch, getState:Void->AppState){
			trace(getState().dataStore);
			if (!props.user.loggedIn)
			{
				return dispatch(LoginError(
				{
					id:props.user.id,
					loginError:'Du musst dich neu anmelden!',
					user_name:props.user.user_name
				}));
			}				
			return null;		
		});
	}

	public static function update(props:DBAccessProps, ?requests:Array<OneOf<HttpJs, XMLHttpRequest>>) 
	{
		return Thunk.Action(function(dispatch:Dispatch, getState:Void->AppState){
			trace(props);
			trace(getState());
			if (!props.user.loggedIn)
			{
				return dispatch(LoginError(
				{
					id:props.user.id,
					loginError:'Du musst dich neu anmelden!',
					user_name:props.user.user_name
				}));
			}	
			var spin:Dynamic = dispatch(AppWait);
			trace(spin);
			var hS:hxbit.Serializer = new hxbit.Serializer();
			var bL:XMLHttpRequest = BinaryLoader.create(
			'${App.config.api}', 
			{				
				id:props.user.id,
				jwt:props.user.jwt,
				className:props.className,
				action:props.action,
				dbData:hS.serialize(props.dataSource)
			},
			function(data:DbData)
			{				
				trace(data);
				if (data.dataErrors.keys().hasNext())
				{
					trace(data.dataErrors);
				}
				return null;

			});
			if (requests != null)
			{
				requests.push(bL);
			}
			return null;
		});
	}
}