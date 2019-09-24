package action.async;

import action.AppAction;
import action.UserAction;
import haxe.http.HttpJs;
import haxe.Json;
import haxe.Serializer;
import loader.BinaryLoader;
import react.ReactUtil.copy;
import redux.Redux;
import redux.StoreMethods;
import redux.thunk.Thunk;
import js.Cookie;
import js.html.FormData;
import js.html.XMLHttpRequest;

import shared.DbData;
import state.AppState;
import state.UserState;
import view.shared.OneOf;
using DateTools;

class UserAccess {

	public static function changePassword(new_pass:String) 
	{
		return Thunk.Action(function(dispatch:Dispatch, getState:Void->AppState)
		{
			var aState:AppState = getState();
			BinaryLoader.create(
				'${App.config.api}', 
				{				
					id:aState.user.id, 
					jwt:aState.user.jwt,
					className:'auth.User',
					action:'changePassword',
					new_pass:new_pass,
					//pass:aState.values['pass'],
					devIP:App.devIP
				},
				function(data:DbData)
				{
					//UserAccess.jwtCheck(data);
					trace(Reflect.fields(data));
					trace(data);
					if (data.dataErrors.keys().hasNext())
					{
						trace(data.dataErrors.toString());
					}
					if (data.dataInfo['changePassword'] == 'OK')
					{
						trace(aState.user);
						/*setState({
							//viewClassPath:'update',
							fields:dataAccess['update'].view,
							values:props.formApi.createStateValues(App.store.getState().user.dynaMap(), dataAccess['update'].view),
							loading:false});*/
					}
					else trace(data.dataErrors);				
				}
			);	
		});
	}
	public static function jwtCheck(data:DbData) 
	{
		if (data.dataErrors.keys().hasNext())
		{
			return Thunk.Action(function(dispatch:Dispatch, getState:Void->AppState){
				trace(data.dataErrors);
				return dispatch(User(LoginError(
					{id:getState().user.id, loginError:data.dataErrors.iterator().next()})));
			});
		}		
		return null;
	}

	public static function doLogin(props:UserState, ?requests:Array<OneOf<HttpJs, XMLHttpRequest>>) 
	{
		return Thunk.Action(function(dispatch:Dispatch, getState:Void->AppState){
			trace(props);
			//trace(getState());
			if (props.pass == '' || props.user_name == '') 
				return dispatch(User(LoginError({user_name:props.user_name, loginError:'Passwort und user_name eintragen!'})));
			//var spin:Dynamic = dispatch(AppAction.AppWait);
			//trace(spin);
			var bL:XMLHttpRequest = null;
			if(App.maxLoginAttempts-->0)
			bL = BinaryLoader.create(
			'${App.config.api}', 
			{				
				user_name:props.user_name,
				jwt:props.jwt,
				className:'auth.User',
				action:'login',
				filter:'user_name|${props.user_name},us.mandator|1',//TODO. ADD MANDATOR SELECT AT LOGINFORM
				dataSource:Serializer.run([
					"users" => ["alias" => 'us',
						"fields" => 'id,last_login,mandator'],
					"contacts" => [
						"alias" => 'co',
						"fields" => 'first_name,last_name,email',
						"jCond"=>'contact=co.id']
				]),
				pass:props.pass,
				devIP:App.devIP
			},
			function(data:DbData)
			{				
				trace(data);
				if (data.dataErrors.keys().hasNext())
				{
					if(App.maxLoginAttempts-->0)
					return dispatch(User(LoginError({user_name:props.user_name, loginError:data.dataErrors.iterator().next()})));
				}
				var uState:UserState = data.dataInfo['user_data'];
				Cookie.set('user.id', Std.string(uState.id), null, '/');
				Cookie.set('user.jwt',uState.jwt, null, '/');
				trace(Cookie.get('user.jwt'));
				uState.loggedIn = true;
				trace(uState);
				trace(dispatch);
				return dispatch(User(LoginComplete(uState)));
				//return dispatch(AppAction.LoginComplete(
			});
			if (requests != null)
			{
				requests.push(bL);
			}
			return null;
		});
	}

	public static function loginReq(props:UserState, ?requests:Array<OneOf<HttpJs, XMLHttpRequest>>) 
	{
		return Thunk.Action(function(dispatch:Dispatch, getState:Void->AppState){
			trace(props);
			trace(getState().user);
			if (props.loginError != null) 
				return dispatch(User(LoginRequired(props)));
			//var spin:Dynamic = dispatch(AppAction.AppWait);
			//trace(spin);
			return null;
		});
	}
	/**
	 * 
	 */
	public static function logOut() 
	{
		return Thunk.Action(function(dispatch:Dispatch, getState:Void->AppState){
			trace(getState().user);
			var props:UserState = getState().user;
			if (props.id == null) 
				return dispatch(User(LoginError({id:props.id, loginError:'UserId fehlt!',mandator:props.mandator})));
			var bL:XMLHttpRequest = null;
			bL = BinaryLoader.create(
			'${App.config.api}', 
			{				
				id:props.id,
				jwt:props.jwt,
				className:'auth.User',
				action:'logout',
				devIP:App.devIP
			},
			function(data:DbData)
			{
				 if (data.dataErrors.keys().hasNext()){
					 // OK
					trace(data.dataErrors);
					//Cookie.set('user.id', Std.string(props.id));
					return null;
				} else {
					//var d:Date = Date.now().delta(31556926000);//ADD one year				
					Cookie.set('user.jwt', '', 31556926);
					trace(Cookie.get('user.jwt'));
					return dispatch(User(LogOutComplete({id:props.id, jwt:'', loggedIn:false, waiting: false})));
				}
			});
			return null;
		});
		
	}

	public static function logOff() 
	{
		return Thunk.Action(function(dispatch:Dispatch, getState:Void->AppState){
			trace(getState().user);
			var props:UserState = getState().user;
			if (props.id == null) 
				return dispatch(User(LoginError({id:props.id, loginError:'UserId fehlt!',mandator:props.mandator})));
			var fD:FormData = new FormData();
			fD.append('action', 'logOff');
			fD.append('className', 'auth.User');
			fD.append('id', Std.string(props.id));
			var req:XMLHttpRequest = new XMLHttpRequest();
			req.open('POST', '${App.config.api}');
			req.onload = function()
			{
				 if (req.status == 200) {
					 // OK
					var jRes:UserState = Json.parse( req.response);
					trace(jRes.jwt);
					//Cookie.set('user.id', Std.string(props.id));
					Cookie.set('user.jwt', jRes.jwt);
					trace(Cookie.get('user.jwt'));
					return dispatch(User(LoginComplete({id:props.id, jwt:jRes.jwt, loggedIn:false})));
				} else {
					  // Otherwise reject with the status text
					  // which will hopefully be a meaningful error
					return dispatch(User(LoginError({id:props.id, loginError:req.statusText})));
				}
			};
			req.send(fD);
			return null;
			/*var spin:Dynamic = dispatch(AppWait);
			
			trace(spin);
			return spin;	*/		
		});
	}	

	/*public static function logOut() {
		return Thunk.Action(function(dispatch:Dispatch, getState:Void->AppState){
			trace('logout');		
			return dispatch(User(LogOut({jwt:'', id: getState().user.id })));
		});
	}*/

	public static function verify() {
		//CHECK IF WE HAVE A VALID SESSION
		return Thunk.Action(function(dispatch:Dispatch, getState:Void->AppState){
			//trace('clientVerify');
			var state:AppState = getState();
			trace(state.user);
			var bL:XMLHttpRequest = BinaryLoader.create(
			'${App.config.api}', 
			{				
				id:state.user.id,
				jwt:state.user.jwt,
				className:'auth.User', 
				action:'clientVerify',
				filter:'us.id|${state.user.id}',//LOGIN NAME
				dataSource:Serializer.run([
					"users" => ["alias" => 'us',
						"fields" => 'id,last_login,mandator'],
					"contacts" => [
						"alias" => 'co',
						"fields" => 'first_name,last_name,email',
						"jCond"=>'contact=co.id'] 
				]),
				devIP:App.devIP
			},			
			function(data:DbData)
			{
				if (data.dataErrors.keys().hasNext())
				{
					trace(data.dataErrors);
					
					return dispatch(User(LoginError(
						{
							id:state.user.id, 
							jwt:'',
							loginError:data.dataErrors.iterator().next(),
							waiting: false
						})));
				}	
				var uState:UserState = data.dataInfo['user_data'];
				trace(uState);
				uState.waiting = false;
				return dispatch(User(LoginComplete(copy(state,{user:uState}))));			
			});
		});	
	}
/**
 * 
 */
	
}