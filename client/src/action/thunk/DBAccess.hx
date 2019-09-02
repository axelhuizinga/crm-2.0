package action.thunk;
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

/**
 * ...
 * @author axel@cunity.me
 */

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

	/*public static function load(props:DBAccessProps) 
	{
		return Thunk.Action(function(dispatch:Dispatch, getState:Void->AppState){
			trace(getState());
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
					filter:'id|${initialState.id}',
					table:props.table,
					devIP:App.devIP
				},
				function(data:DbData)
				{			
					UserAccess.jwtCheck(data);
					trace(data.dataInfo);
					trace(data.dataRows.length);
					if(data.dataRows.length>0) 
					{
						if(!data.dataErrors.keys().hasNext())
						{
							//var sData:IntMap<Map<String,Dynamic>> = App.store.getState().dataStore.contactData;
							actualState = data.dataRows[0].MapToDyn();
							props.parentComponent.props.select(actualState.id,data.dataRows[0],props.match);
							trace(actualState);
							//forceUpdate();
						}
						else 
						{
							//TODO: IMPLEMENT GENERIC FAILURE FEEDBACK
							trace('no matching data found for ${initialState.id}');
							var baseUrl:String = props.match.path.split(':section')[0];
							props.history.push('${baseUrl}List/find');							
						}				
					}
				}
			);			
		});
	}*/

	public static function execute(props:DBAccessProps, ?requests:Array<OneOf<HttpJs, XMLHttpRequest>>) 
	{
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