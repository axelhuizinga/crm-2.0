package action.async;

import haxe.ds.IntMap;
import state.UserState;
import state.AppState;
import action.AppAction;
import action.DataAction;
import haxe.ds.Either;
import haxe.Serializer;
import state.DataAccessState;

import js.html.XMLHttpRequest;

import redux.Redux.Dispatch;
import redux.thunk.Thunk;
import shared.DbData;
import loader.BinaryLoader;

using shared.Utils;

/**
 * ...
 * @author axel@cunity.me
 */

class LivePBXSync
{
	public static function create() {
		
	}

	public static function delete() {
		
	}

	public static function syncAll(props:DBAccessProps) 
	{
		trace('${props.batchSize} ${props.batchCount} ${props.synced}');
		return Thunk.Action(function(dispatch:Dispatch, getState:Void->AppState){
			var aState:AppState = getState();
			trace(props.synced);
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
			var bl:XMLHttpRequest = BinaryLoader.create(
				'${App.config.api}', 
				{
					id:props.user.id,
					jwt:props.user.jwt,
					className:props.className,
					action:props.action,
					batchSize:props.batchSize,
					offset:props.offset,
					filter:props.filter,
					firstBatch:props.synced==0, 
					devIP:App.devIP
				},
				function(data:DbData)
				{			
					trace(data.dataInfo);
					trace(data.dataRows.length);
					if(data.dataErrors.keys().hasNext())
					{
						return dispatch(Status(Update(
							{
								className:'error',
								text:data.dataErrors.iterator().next()
							}							
						)));
					} 
					trace(data.dataInfo);
					if(data.dataInfo['synced']==null)
					{
						return dispatch(Status(Update(
							{text:'Fehler 0 Kontakte Aktualisiert'})));
					}
					props.batchCount += data.dataInfo['synced'];
					if(data.dataInfo['synced']!=null)
					{
						return dispatch(Status(Update(
							{text:'${data.dataInfo['synced']} Kontakte von ${props.batchCount} aktualisiert'})));
					}
					if(props.limit==null || props.limit < props.batchCount){
						//LOOP UNTIL LIMIT
						return dispatch(syncAll(props));
					}
						
					return null;
				}
			);
			return null;
		});
	}
}