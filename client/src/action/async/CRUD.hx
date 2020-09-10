package action.async;
import db.DbQuery.DbQueryParam;
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
import loader.BinaryLoader;
import shared.DbData;
import shared.DbDataTools;
import view.shared.OneOf;
import action.async.DBAccessProps;
using shared.Utils;
/**
 * ...
 * @author axel@cunity.me
 */


class CRUD
{
	public static function create() {
		
	}

	public static function delete() {
		
	}

	public static function read(param:DbQueryParam) 
	{
		return Thunk.Action(function(dispatch:Dispatch, getState:Void->AppState){
			//trace(getState());
			trace(param);
			return new Promise(function(resolve, reject){
				if (!param.dbUser.online)
				{
					dispatch(User(LoginError(
					{
						dbUser:param.dbUser,
						lastError:'Du musst dich neu anmelden!'
					})));
					trace('LoginError');
					var dbData:DbData = DbDataTools.create(['LoginError'=>'Du musst dich neu anmelden!']);
					resolve(dbData);
				}
				var bl:XMLHttpRequest = BinaryLoader.dbQuery(
					'${App.config.api}', 
					param,
					function(data:DbData)
					{			
						trace(data.dataInfo);
						trace(data.dataRows.length);
						if(data.dataRows.length>0) 
						{
							if(!data.dataErrors.keys().hasNext())
							{
								trace(data.dataRows[0]);
								resolve(data);
							}
							else 
							{
								//TODO: IMPLEMENT GENERIC FAILURE FEEDBACK
								dispatch(Status(Update(
									{
										cssClass:'error',
										text:'${data.dataErrors.get(param.action)}',
									})));
								resolve(data);
							}				
						}
						else
							dispatch(Status(Update(
							{
								cssClass: 'warn',
								text: 'Keine Daten für ${param.filter.toString()} gefunden'
							})));
					}
				);
			});
		});
	}
	//public static function update(props:DBAccessProps) 
	public static function update(props:DbQueryParam) 
	{	trace(props.action);
		return Thunk.Action(function(dispatch:Dispatch, getState:Void->AppState):Promise<Dynamic>{
			trace(props);
			//if(props.dataSource != null)
				//trace(props.dataSource.get('contacts').get('data'));
			
			var dbData:DbData = DbDataTools.create();
			//trace(getState());
			return new Promise(function(resolve, reject){
				if (!props.dbUser.online)
				{
					dispatch(User(LoginError(
					{
						dbUser:props.dbUser,
						lastError:'Du musst dich neu anmelden!'
					})));
					trace('LoginError');
					resolve(null);
				}	
				var params:Dynamic = {			
					dbUser:props.dbUser,
					filter:props.filter,	
					table:props.table,
					//id:props.userState.dbUser.id,
					//jwt:props.userState.dbUser.jwt,
					classPath:props.classPath,
					action: props.action,
					devIP:App.devIP
				};
				//if(props.dataSource != null)
					//params.dataSource = props.dataSource;
				if(props.table != null)
					params.table = props.table;
				trace(params);
				var bL:XMLHttpRequest = BinaryLoader.dbQuery(
					'${App.config.api}', 
					props,
					function(data:DbData)
					{				
						trace(data);
						if(data.dataErrors != null)
							trace(data.dataErrors);
						if(data.dataInfo != null && data.dataInfo.exists('dataSource'))
							trace(new Unserializer(data.dataInfo.get('dataSource')).unserialize());

						if(data.dataErrors.exists('lastError'))
						{
							dispatch(User(LoginError({lastError: data.dataErrors.get('lastError')})));
							resolve(null);
						}
						else{

							dispatch(Status(Update( 
								{	cssClass:'',
									text:switch ('${props.classPath}.${props.action}')
									{
										case "data.Contacts.edit":
											'Kontakt ${props.filter.id} geladen';
										case "data.Contacts.update":
											'Kontakt ${props.filter.id} wurde gespeichert';
										default:
											"Unbekannter Vorgang";

									}
								}
							)));
							resolve(data);
						}
					}
				);
				trace(bL);
			});	
		});
			
	}

}