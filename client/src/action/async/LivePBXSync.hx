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
		return Thunk.Action(function(dispatch:Dispatch, getState:Void->AppState){
			var aState:AppState = getState();
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
			var bl:XMLHttpRequest = BinaryLoader.create(
				'${App.config.api}', 
				{
					id:props.user.id,
					jwt:props.user.jwt,
					className:props.className,
					action:props.action,
					batchSize:props.batchSize,
					filter:props.filter,
					devIP:App.devIP
				},
				function(data:DbData)
				{			
					trace(data.dataInfo);
					trace(data.dataRows.length);
					var status:String = '';
		
					if(data.dataErrors.keys().hasNext())
					{
						return dispatch(Status(Update(
								'${data.dataErrors.iterator().next()}'.errorStatus())));
					}
					trace(data.dataInfo);
					props.batchCount += data.dataInfo['count'];
					dispatch(Status(Update('Kontakte Aktualisiert:${props.batchCount}')));
					if(data.dataInfo['done'])
					{
						return dispatch(Status(Update('Alle Kontakte Aktualisiert:${props.batchCount}')));
					}
					if(props.limit==null || props.limit < props.batchCount)
						return dispatch(syncAll(props));
					return null;
				}
			);
			return null;
		});
	}
}