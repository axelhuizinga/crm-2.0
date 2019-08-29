package shared;

import action.AppAction.StatusAction;
import js.html.Blob;
import state.UserState;
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

//typedef DBAccessProps = Dynamic;
typedef DBAccessProps = 
{
	action:String,
	className:String,
	?dataSource:Map<String,Map<String,Dynamic>>,
	?table:String,
	user:UserState
}

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

	public static function execute(props:DBAccessProps, ?requests:Array<OneOf<HttpJs, XMLHttpRequest>>) 
	{
		return Thunk.Action(function(dispatch:Dispatch, getState:Void->AppState){
			trace(props);
			//trace(getState());
			if (!props.user.loggedIn)
			{
				return dispatch(LoginError(
				{
					id:props.user.id,
					loginError:'Du musst dich neu anmelden!',
					user_name:props.user.user_name
				}));
			}	
			//var spin:Dynamic = dispatch(AppWait);
			//trace(spin);
			var params:Dynamic = {				
				id:props.user.id,
				jwt:props.user.jwt,
				className:props.className,
				action:props.action,
				dataSource:Serializer.run(props.dataSource),
				devIP:App.devIP
			};
			if(props.table != null)
				params.table = props.table;
			var bL:XMLHttpRequest = BinaryLoader.create(
			'${App.config.api}', 
			params,
			function(data:DbData)
			{				
				trace(data);
				var status:String = '';
				if (data.dataErrors.keys().hasNext())
				{
					trace(data.dataErrors);
					if(data.dataErrors.exists('loginError'))
					{
						return dispatch(LoginError({loginError: data.dataErrors.get('loginError')}));
					}
				}else 
				status = switch ('${props.className}.${props.action}')
				{
					case "data.Contacts.update":
						'Kontakt ${props.dataSource["contacts"]["filter"].substr(3)} wurde gespeichert';
					default:
						"Unbekannter Vorgang";

				}
				trace('${props.className}.${props.action} => $status');
				return dispatch(StatusAction.Status(status));
			});
			if (requests != null)
			{
				requests.push(bL);
			}
			return null;
		});
	}

	/*public static function update(props:DBAccessProps, ?requests:Array<OneOf<HttpJs, XMLHttpRequest>>) 
	{
		return Thunk.Action(function(dispatch:Dispatch, getState:Void->AppState){
			trace(props);
			//trace(getState());
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
			var bL:XMLHttpRequest = BinaryLoader.create(
			'${App.config.api}', 
			{				
				id:props.user.id,
				jwt:props.user.jwt,
				className:props.className,
				action:props.action,
				dataSource:Serializer.run(props.dataSource),
				devIP:App.devIP
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
	}*/
}