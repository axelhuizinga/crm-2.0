package action.async;
import js.lib.Promise;
import haxe.Unserializer;
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
import DBAccessProps;
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

	public static function read(props:DBAccessProps) 
	{
		return Thunk.Action(function(dispatch:Dispatch, getState:Void->AppState){
			//trace(getState());
			trace(props);
			return new Promise(function(resolve, reject){
				if (!props.user.loggedIn)
				{
					dispatch(User(LoginError(
					{
						id:props.user.id,
						loginError:'Du musst dich neu anmelden!',
						user_name:props.user.user_name
					})));
					trace('LoginError');
					resolve(false);
				}
				var bl:XMLHttpRequest = BinaryLoader.create(
					'${App.config.api}', 
					{
						id:props.user.id,
						jwt:props.user.jwt,
						className:props.className,
						action:props.action,
						filter:props.filter,
						dataSource:Serializer.run(props.dataSource),
						table:props.table,
						devIP:App.devIP
					},
					function(data:DbData)
					{			
						trace(data.dataInfo);
						trace(data.dataRows.length);
						if(data.dataRows.length>0) 
						{
							if(!data.dataErrors.keys().hasNext())
							{
								trace(data.dataRows);
								/*dispatch(AppAction.Data(SelectContacts([
									for(row in data.dataRows)
										Std.parseInt(row['id']) => row
								])));//.then(function()trace('yeah'));*/
								dispatch(Status(Update({text:switch ('${props.className}.${props.action}')
								{
									case "data.Contacts.get":
										resolve(true);
										'Kontakt ${props.filter.substr(3)} geladen';
									case "data.Contacts.update":
										resolve(true);
										'Kontakt ${props.filter.substr(3)} wurde gespeichert';
									default:
										resolve(false);
										"Unbekannter Vorgang";

								}})));
							}
							else 
							{
								//TODO: IMPLEMENT GENERIC FAILURE FEEDBACK
								dispatch(Status(Update(
									{
										className:'error',
										text:'${data.dataErrors.get(props.action)}',
									})));
									resolve(false);
							}				
						}
						else
							dispatch(Status(Update(
							{
								className: 'warn',
								text: 'Keine Daten für ${props.filter.substr(3)} gefunden'
							})));
					}
				);
			});
		});
	}

	public static function update(props:DBAccessProps) 
	{	//trace(props);
		return Thunk.Action(function(dispatch:Dispatch, getState:Void->AppState):Promise<Dynamic>{
			trace(props);
			//trace(getState());
			return new Promise(function(resolve, reject){
				if (!props.user.loggedIn)
				{
					dispatch(User(LoginError(
					{
						id:props.user.id,
						loginError:'Du musst dich neu anmelden!',
						user_name:props.user.user_name
					})));
					trace('LoginError');
					resolve(false);
				}	
				var params:Dynamic = {				
					id:props.user.id,
					jwt:props.user.jwt,
					className:props.className,
					action:props.action,
					devIP:App.devIP
				};
				if(props.dataSource != null)
					params.dataSource = props.dataSource;
				if(props.table != null)
					params.table = props.table;
				var bL:XMLHttpRequest = BinaryLoader.create(
					'${App.config.api}', 
					params,
					function(data:DbData)
					{				
						//trace(data);
						if(data.dataErrors != null)
							trace(data.dataErrors);
						if(data.dataInfo != null && data.dataInfo.exists('dataSource'))
							trace(new Unserializer(data.dataInfo.get('dataSource')).unserialize());

						if(data.dataErrors.exists('loginError'))
						{
							dispatch(User(LoginError({loginError: data.dataErrors.get('loginError')})));
							resolve(false);
						}
						else{

							dispatch(Status(Update(
								{text:switch ('${props.className}.${props.action}')
									{
										case "data.Contacts.edit":
											'Kontakt ${props.dataSource["contacts"]["filter"].substr(3)} geladen';
										case "data.Contacts.update":
											'Kontakt ${props.dataSource["contacts"]["filter"].substr(3)} wurde gespeichert';
										default:
											"Unbekannter Vorgang";

									}
								}
							)));
							resolve(true);
						}
					}
				);
				//resolve(true);
			});	
		});
			
	}

}