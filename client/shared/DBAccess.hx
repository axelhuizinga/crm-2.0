package shared;

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
		return Thunk.Action(function(dispatch:Dispatch, getState:Void->DataAccessState){
			trace(getState());
			if (!props.user.loggedIn)
			{
				return dispatch(LoginError(
				{
					user_name:props.user.user_name,
					loginError:'Du musst dich neu anmelden!',
					id:props.user.id
				}));
			}				
			return null;		
		});
	}

	public static function update(props:DBAccessProps, ?requests:Array<OneOf<HttpJs, XMLHttpRequest>>) 
	{
		return Thunk.Action(function(dispatch:Dispatch, getState:Void->DataAccessState){
			trace(props);
			trace(getState());
			if (!props.user.loggedIn)
			{
				return dispatch(LoginError(
				{
					user_name:props.user.user_name,
					loginError:'Du musst dich neu anmelden!',
					id:props.user.id
				}));
			}	
			var spin:Dynamic = dispatch(AppWait);
			trace(spin);
			var hS:hxbit.Serializer = new hxbit.Serializer();
			var bL:XMLHttpRequest = BinaryLoader.create(
			'${App.config.api}', 
			{				
				user_name:props.user.user_name,
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