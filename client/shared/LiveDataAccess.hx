package shared;

import react.router.RouterMatch;
import js.html.Blob;
import state.UserState;
import state.AppState;
import action.AppAction;
import action.async.DataAction;
import haxe.Serializer;
import haxe.http.HttpJs;
import state.DataAccessState;

import js.html.XMLHttpRequest;

import redux.Redux.Dispatch;
import redux.thunk.Thunk;
import shared.DbData;
import loader.BinaryLoader;
import view.shared.OneOf;
import view.shared.io.FormApi;

using shared.Utils;

/**
 * ...
 * @author axel@cunity.me
 */

//typedef DBAccessProps = Dynamic;
typedef LiveDataProps = 
{
	id:Dynamic,
	data:Map<String,Dynamic>,
	match:RouterMatch
}

class LiveDataAccess
{
	public static function create() {
		
	}

	public static function delete() {
		
	}

	public static function select(props:LiveDataProps) 
	{
		return Thunk.Action(function(dispatch:Dispatch, getState:Void->AppState){
			var aState:AppState = getState();
			trace(aState.dataStore.selectedData);
			var sData = aState.dataStore.selectedData;
			sData.set(props.id,props.data);
			var baseUrl:String = props.match.path.split(':section')[0];
			baseUrl = '${baseUrl}${props.match.params.section}/${props.match.params.action}';	
			aState.appWare.history.push('${baseUrl}/${FormApi.params(sData.keys().keysList())}');
			dispatch(DataAction.Select(props.id,props.data));
			/**
			 * 				var state = store.getState();
				var sData = state.dataStore.selectedData;
				var baseUrl:String = match.path.split(':section')[0];
				baseUrl = '${baseUrl}${match.params.section}/${match.params.action}';	
				state.appWare.history.push('${baseUrl}/${FormApi.params(sData.keys().keysList())}');
			 */
			return null;		
		});
	}

	/*public static function update(props:LiveDataProps, ?requests:Array<OneOf<HttpJs, XMLHttpRequest>>) 
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
			//var hS:hxbit.Serializer = new hxbit.Serializer();
			//trace(hS.serialize(props.dataSource));
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