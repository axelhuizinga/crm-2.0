package loader;

import haxe.Json;
import js.html.XMLHttpRequest;
import shared.DbDataTools;
import shared.DbData;
import action.AppAction.*;
import action.UserAction.*;
import js.lib.Promise;
import db.DBAccessProps;
import data.DataState;
import action.async.LoadAction;
import redux.Redux.Dispatch;
import redux.thunk.Thunk;
import react.router.Route.RouteRenderProps;
import react.router.ReactRouter.matchPath;
import state.AppState;

class ListLoader 
{
	public static function load(param:Dynamic) 
	{

		return Thunk.Action(function (dispatch:Dispatch, getState:Void->DataState)
		{
			if(param.page==null)
				param.page=0;
			trace('Loading ${param.page+1}');
			
			trace(Type.typeof(param.dataSource));
			trace(param.dataSource);
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
							//trace(param);
							dispatch(Status(Update(
							{
								className: 'warn',
								text: 'Keine Daten für ${Json.stringify(param.filter)} gefunden'
							}))); 
						}
					}
				);
			});
		});
	}
		
}