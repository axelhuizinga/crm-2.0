package action.async;
import haxe.Exception;
import me.cunity.debug.Out;
import haxe.Json;
import db.DBAccessProps;
import js.lib.Promise;
import haxe.Unserializer;
import action.AppAction;
//import action.StatusAction;
import js.html.Blob;
import state.UserState;
import state.AppState;

import haxe.http.HttpJs;
import state.DataAccessState;

import js.html.XMLHttpRequest;

import redux.Redux.Dispatch;
import redux.thunk.Thunk;
import loader.BinaryLoader;
import shared.DbData;
import shared.DbDataTools;
import view.shared.OneOf;
import db.DBAccessProps;
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

	public static function read(param:DBAccessProps) 
	{
		return Thunk.Action(function(dispatch:Dispatch, getState:Void->AppState){
			//trace(getState());
			//trace(param.offset);
			//trace(param.page);
			//Out.dumpObject(param);
			//trace(param.filter);
			trace(param);
			//trace(param.classPath);
			//trace(Reflect.fields(param).join('|'));
			return new Promise(function(resolve, reject){
				if (!param.dbUser.online)
				{
					trace('LoginError');
					param.dbUser.last_error = 'Du musst dich neu anmelden!';
					dispatch(User(LoginError(
					{
						dbUser:param.dbUser,
						lastError:'Du musst dich neu anmelden!'
					})));
					var dbData:DbData = DbDataTools.create(['LoginError'=>'Du musst dich neu anmelden!']);
					reject(dbData);
				}
				var bl:XMLHttpRequest = BinaryLoader.dbQuery(
					'${App.config.api}', 
					param,
					function(data:DbData)
					{			
						//trace(data.dataInfo);
						trace(data.dataRows.length);
						if(data.dataRows.length>0) 
						{
							if(!data.dataErrors.keys().hasNext())
							{
								//trace(data.dataRows[0]);
								dispatch(Status(Update( 
									{	className:'',
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
										className:'error',
										text:Json.stringify(data.dataErrors),
									})));
								reject(data);
							}				
						}
						else{
							//NO ROWS FOUND
							trace(data);
							dispatch(Status(Update(
							{
								className: param.resolveMessage!=null && param.resolveMessage.failureClass != null?param.resolveMessage.failureClass:'warn',
								text: param.resolveMessage==null?'Keine Daten für ${Json.stringify(param.filter)} gefunden':param.resolveMessage.failure
							}))); 
							resolve(data);
						}
					}
				);
			});
		});
	}

	
	/**
	 * 
	 * @param dbh:PDO DB handle
	 * @param table:DB table name
	 * @param sql:String query to get option label=>value map
	 * 
	 */
	 public static function initOptions(param:DBAccessProps) 
	{
		return Thunk.Action(function(dispatch:Dispatch, getState:Void->AppState){
			//dbh:PDO, table:String, sql:String) {
			return new Promise(function(resolve, reject){
				if (!param.dbUser.online)
				{
					trace('LoginError');
					param.dbUser.last_error = 'Du musst dich neu anmelden!';
					dispatch(User(LoginError(
					{
						dbUser:param.dbUser,
						lastError:'Du musst dich neu anmelden!'
					})));
					var dbData:DbData = DbDataTools.create(['LoginError'=>'Du musst dich neu anmelden!']);
					reject(dbData);
				}
				var bl:XMLHttpRequest = BinaryLoader.dbQuery(
					'${App.config.api}', 
					param,
					function(data:DbData)
					{			
						//trace(data.dataInfo);
						trace(data.dataRows.length);
						if(data.dataRows.length>0) 
						{
							if(!data.dataErrors.keys().hasNext())
							{
								//trace(data.dataRows[0]);
								dispatch(Status(Update( 
									{	className:'',
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
										className:'error',
										text:Json.stringify(data.dataErrors),
									})));
								reject(data);
							}				
						}
						else{
							//NO ROWS FOUND
							trace(data);
							dispatch(Status(Update(
							{
								className: param.resolveMessage!=null && param.resolveMessage.failureClass != null?param.resolveMessage.failureClass:'warn',
								text: param.resolveMessage==null?'Keine Daten für ${Json.stringify(param.filter)} gefunden':param.resolveMessage.failure
							}))); 
							resolve(data);
						}
					}
				);
			});
		});
	}
	
	public static function update(param:DBAccessProps) 
	{	
		//Out.dumpObjectRSafe(param);
		return Thunk.Action(function(dispatch:Dispatch, getState:Void->AppState):Promise<Dynamic>{
			//trace(param);
			//if(param.dataSource != null)
				//trace(param.dataSource.get('contacts').get('data'));
				var dbData:DbData = DbDataTools.create();
				
			//trace(getState());
			return new Promise<Dynamic>(function(resolve, reject){
				try{
				if (!param.dbUser.online)
				{
					dispatch(User(LoginError(
					{
						dbUser:param.dbUser,
						lastError:'Du musst dich neu anmelden!'
					})));
					trace('LoginError');
					reject('Du musst dich neu anmelden!');
				}	
				//trace(param.data);
				var bL:XMLHttpRequest = BinaryLoader.dbQuery(
					'${App.config.api}', 
					param,					
					function(data:DbData)
					//function(sData:Dynamic)
					{				
						trace(data);
						if(data.dataErrors != null && data.dataErrors.keys().hasNext())
							trace(data.dataErrors);
						if(data.dataInfo != null && data.dataInfo.exists('dataSource'))							
							trace(data.dataInfo.get('dataSource'));
							//trace(new Unserializer(data.dataInfo.get('dataSource')).unserialize());
						if(data.dataErrors.exists('lastError'))
						{
							dispatch(User(LoginError({lastError: data.dataErrors.get('lastError')})));
							reject(data.dataErrors.get('lastError'));
						}
						if(data.dataErrors.toString() != '{}')
						{
							dispatch(Status(Update( 
								{	className:'error',						
									//text:(param.resolveMessage==null?'':param.resolveMessage.failure)
									text:(param.resolveMessage==null?data.dataErrors.toString():param.resolveMessage.failure)
								}
							)));							
							reject(param.resolveMessage==null?param.resolveMessage.failure:data.dataErrors.toString());
						}
						else{

							dispatch(Status(Update( 
								{	className:'',
									text:(param.resolveMessage==null?'':param.resolveMessage.success)		
								}
							)));
							resolve(data);
						}
					}
				);
				trace(bL);
				}
				catch(ex:Exception){
					trace(ex.stack);
				}
			});	
		});
			
	}

}