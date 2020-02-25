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
		trace('${props.table} ${props.maxImport} ${props.limit} ${props.offset}');
		return Thunk.Action(function(dispatch:Dispatch, getState:Void->AppState){
			var aState:AppState = getState();
			trace(props.offset);
			if (!props.userState.dbUser.online)
			{
				return dispatch(User(LoginError(
				{
					dbUser:props.userState.dbUser,
					lastError:'Du musst dich neu anmelden!'
				})));
			}				
			trace('creating BinaryLoader ${App.config.api}');
			var bl:XMLHttpRequest = BinaryLoader.create(
				'${App.config.api}', 
				{
					id:props.userState.dbUser.id,
					jwt:props.userState.dbUser.jwt,
					className:props.className,
					action:props.action,
					limit:props.limit,
					offset:props.offset,
					table:props.table,
					filter:props.filter,
					firstBatch:props.offset==0, 
					maxImport:props.maxImport==null?1000:props.maxImport,
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
					if(data.dataInfo['offset']==null)
					{
						return dispatch(Status(Update(
							{
								className:'error',
								text:'Fehler 0 ${props.className} Aktualisiert'})));
					}
					//props.batchCount += data.dataInfo['offset'];
					if(data.dataInfo['offset']!=null)
					{
						props.offset = Std.parseInt(data.dataInfo['offset']);
						dispatch(Status(Update(
							{
								className:'',
								text:'${props.offset} ${props.className} von ${props.maxImport} aktualisiert'})));
					}
					trace('${props.offset} < ${props.maxImport}');
					if(props.offset < props.maxImport){
						//LOOP UNTIL LIMIT
						trace('next loop:${props}');
						return dispatch(syncAll(props));
					}
						
					return null;
				}
			);
			return null;
		});
	}

	public static function importBookingRequests(props:DBAccessProps) 
	{
		return Thunk.Action(function(dispatch:Dispatch, getState:Void->AppState){
			var aState:AppState = getState();
			trace(props.offset);
			if (!props.userState.dbUser.online)
			{
				return dispatch(User(LoginError(
				{
					dbUser:props.userState.dbUser,
					lastError:'Du musst dich neu anmelden!'
				})));
			}				
			trace('creating BinaryLoader ${App.config.api}');
			var bl:XMLHttpRequest = BinaryLoader.create(
				'${App.config.api}', 
				{
					id:props.userState.dbUser.id,
					jwt:props.userState.dbUser.jwt,
					className:props.className,
					action:props.action,
					limit:props.limit,
					offset:props.offset,
					filter:props.filter,
					firstBatch:props.offset==0, 
					maxImport:props.maxImport==null?1000:props.maxImport,
					devIP:App.devIP
				},
				function(data:DbData)
				{			
					trace(data);
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
					if(data.dataInfo['offset']==null)
					{
						return dispatch(Status(Update(
							{
								className:'error',
								text:'Fehler 0 Buchungsanforderungen Aktualisiert'})));
					}
					//props.batchCount += data.dataInfo['offset'];
					if(data.dataInfo['offset']!=null)
					{
						props.offset = Std.parseInt(data.dataInfo['offset']);
						dispatch(Status(Update(
							{
								className:'',
								text:'${props.offset} Kontakte von ${props.maxImport} aktualisiert'})));
					}
					trace('${props.offset} < ${props.maxImport}');
					if(props.offset < props.maxImport){
						//LOOP UNTIL LIMIT
						trace('next loop:${props}');
						return dispatch(syncAll(props));
					}
						
					return null;
				}
			);
			return null;
		});

	}

	public static function mergeContacts(props:DBAccessProps) 
	{
		trace('${props.maxImport} ${props.limit} ${props.offset}');
		return Thunk.Action(function(dispatch:Dispatch, getState:Void->AppState){
			var aState:AppState = getState();
			trace(props.offset);
			if (!props.userState.dbUser.online)
			{
				return dispatch(User(LoginError(
				{
					dbUser:props.userState.dbUser,
					lastError:'Du musst dich neu anmelden!'					
				})));
			}				
			trace('creating BinaryLoader ${App.config.api}');
			var bl:XMLHttpRequest = BinaryLoader.create(
				'${App.config.api}', 
				{
					id:props.userState.dbUser.id,
					jwt:props.userState.dbUser.jwt,
					className:props.className,
					action:props.action,
					limit:props.limit,
					offset:props.offset,
					filter:props.filter,
					firstBatch:props.offset==0, 
					maxImport:props.maxImport==null?1000:props.maxImport,
					devIP:App.devIP
				},
				function(data:DbData)
				{			
					trace(data);
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
					if(data.dataInfo['offset']==null)
					{
						return dispatch(Status(Update(
							{
								className:'error',
								text:'Fehler 0 Kontakte Aktualisiert'})));
					}
					//props.batchCount += data.dataInfo['offset'];
					if(data.dataInfo['offset']!=null)
					{
						props.offset = Std.parseInt(data.dataInfo['offset']);
						dispatch(Status(Update(
							{
								className:'',
								text:'${props.offset} Kontakte von ${props.maxImport} aktualisiert'})));
					}
					trace('${props.offset} < ${props.maxImport}');
					if(props.offset < props.maxImport){
						//LOOP UNTIL LIMIT
						trace('next loop:${props}');
						return dispatch(syncAll(props));
					}
						
					return null;
				}
			);
			return null;
		});
	}	
}