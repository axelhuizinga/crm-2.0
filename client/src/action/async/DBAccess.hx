package action.async;
import action.AppAction;
import action.StatusAction;
import js.html.Blob;
import state.UserState;
import state.AppState;
import haxe.Serializer;
import haxe.http.HttpJs;
import state.DataAccessState;

import js.html.XMLHttpRequest;

import redux.Redux.Dispatch;
import redux.thunk.Thunk;
import shared.DbData;
import loader.BinaryLoader;
import view.shared.OneOf;
using action.async.DBAccessProps;
using shared.Utils;
/**
 * ...
 * @author axel@cunity.me
 */


class DBAccess
{
	public static function create() {
		
	}

	public static function delete() {
		
	}

	public static function get(props:DBAccessProps) 
	{
		return Thunk.Action(function(dispatch:Dispatch, getState:Void->AppState){
			//trace(getState());
			trace(props);
			if (!props.user.loggedIn)
			{
				return dispatch(User(LoginError(
				{
					id:props.user.id,
					loginError:'Du musst dich neu anmelden!',
					user_name:props.user.user_name
				})));
			}				
			trace('creating BinaryLoader ${App.config.api}');
			//return;
			var bl:XMLHttpRequest = BinaryLoader.create(
				'${App.config.api}', 
				{
					id:props.user.id,
					jwt:props.user.jwt,
					className:props.className,
					action:props.action,
					filter:props.filter,
					//dataSource:Serializer.run(props.dataSource),
					table:props.table,
					devIP:App.devIP
				},
				function(data:DbData)
				{			
					trace(data.dataInfo);
					trace(data.dataRows.length);
					var status:String = '';
					if(data.dataRows.length>0) 
					{
						if(!data.dataErrors.keys().hasNext())
						{
							trace(data.dataRows);
							dispatch(AppAction.Data(SelectContacts([
								for(row in data.dataRows)
									Std.parseInt(row['id']) => row
							])));//.then(function()trace('yeah'));
							return dispatch(Status(Update(switch ('${props.className}.${props.action}')
							{
								case "data.Contacts.get":
									'Kontakt ${props.filter.substr(3)} geladen';
								case "data.Contacts.update":
									'Kontakt ${props.filter.substr(3)} wurde gespeichert';
								default:
									"Unbekannter Vorgang";
							})));
						}
						else 
						{
							//TODO: IMPLEMENT GENERIC FAILURE FEEDBACK
							return dispatch(Status(Update(
								'${data.dataErrors.get(props.action)}'.errorStatus())));
						
						}				
					}
					else
						return dispatch(Status(Update(
							status = 'Keine Daten für ${props.filter.substr(3)} gefunden')));
				}
			);
			return null;
		});
	}

	public static function execute(props:DBAccessProps, ?requests:Array<OneOf<HttpJs, XMLHttpRequest>>) 
	{trace(props);
		return Thunk.Action(function(dispatch:Dispatch, getState:Void->AppState){
			trace(props);
			//trace(getState());
			if (!props.user.loggedIn)
			{
				return dispatch(User(LoginError(
				{
					id:props.user.id,
					loginError:'Du musst dich neu anmelden!',
					user_name:props.user.user_name
				})));
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
						return dispatch(User(LoginError({loginError: data.dataErrors.get('loginError')})));
					}
				}else 
				status = switch ('${props.className}.${props.action}')
				{
					case "data.Contacts.edit":
						'Kontakt ${props.dataSource["contacts"]["filter"].substr(3)} geladen';
					case "data.Contacts.update":
						'Kontakt ${props.dataSource["contacts"]["filter"].substr(3)} wurde gespeichert';
					default:
						"Unbekannter Vorgang";

				}
				trace('${props.className}.${props.action} => $status');
				//return null;
				return dispatch(Status(Update(status)));
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