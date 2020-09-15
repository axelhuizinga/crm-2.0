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
								dispatch(Status(Update( 
									{	cssClass:'',
										text:(param.resolveMessage==null?'':param.resolveMessage.success)
									}
								)));								
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
	
	public static function update(param:DbQueryParam) 
	{	trace(param.action);
		return Thunk.Action(function(dispatch:Dispatch, getState:Void->AppState):Promise<Dynamic>{
			trace(param);
			//if(param.dataSource != null)
				//trace(param.dataSource.get('contacts').get('data'));
			
			var dbData:DbData = DbDataTools.create();
			//trace(getState());
			return new Promise(function(resolve, reject){
				if (!param.dbUser.online)
				{
					dispatch(User(LoginError(
					{
						dbUser:param.dbUser,
						lastError:'Du musst dich neu anmelden!'
					})));
					trace('LoginError');
					resolve(null);
				}	
				var params:Dynamic = {			
					dbUser:param.dbUser,
					filter:param.filter,	
					table:param.table,
					//id:param.userState.dbUser.id,
					//jwt:param.userState.dbUser.jwt,
					classPath:param.classPath,
					action: param.action,
					devIP:App.devIP
				};
				//if(param.dataSource != null)
					//params.dataSource = param.dataSource;
				if(param.table != null)
					params.table = param.table;
				trace(params);
				var bL:XMLHttpRequest = BinaryLoader.dbQuery(
					'${App.config.api}', 
					param,
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
									text:(param.resolveMessage==null?'':param.resolveMessage.success)
									/*switch ('${param.classPath}.${param.action}')
									{
										case "data.Contacts.edit":
											'Kontakt ${param.filter.id} geladen';
										case "data.Contacts.update":
											'Kontakt ${param.filter.id} wurde gespeichert';
										default:
											"Unbekannter Vorgang";

									}*/
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