package action.async;

//import buddy.internal.sys.Js;

import haxe.Json;
import haxe.Serializer;
import haxe.http.HttpJs;
import haxe.io.Bytes;
import js.Cookie;
import js.Syntax;
import js.html.FormData;
import me.cunity.debug.Out;
import state.AppState;

import js.html.XMLHttpRequest;

import redux.Redux.Dispatch;
import redux.thunk.Thunk;
import shared.DbData;
import view.LoginForm.LoginState;
import view.shared.FormState;
import view.shared.OneOf;
import loader.BinaryLoader;
import state.UserState;

typedef UserProps = UserState;
/**
 * ...
 * @author axel@cunity.me
 */

class UserAction 
{
	public static function loginReq(props:LoginState, ?requests:Array<OneOf<HttpJs, XMLHttpRequest>>) 
	{
		return Thunk.Action(function(dispatch:Dispatch, getState:Void->AppState){
			trace(props);
			//trace(getState());
			if (props.pass == '' || props.user_name == '') 
				return dispatch(AppAction.LoginError({user_name:props.user_name, loginError:'Passwort und user_name eintragen!'}));
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
					return dispatch(AppAction.LoginError({user_name:props.user_name, loginError:data.dataErrors.iterator().next()}));
				}
				var uState:UserProps = data.dataInfo['user_data'];
				Cookie.set('user.id', Std.string(uState.id), null, '/');
				Cookie.set('user.jwt',uState.jwt, null, '/');
				trace(Cookie.get('user.jwt'));
				uState.loggedIn = true;
				return dispatch(AppAction.LoginComplete(uState));
				//return dispatch(AppAction.LoginComplete(
			});
			if (requests != null)
			{
				requests.push(bL);
			}
			return null;
		});
	}

	public static function logOff(props:LoginState) 
	{
		return Thunk.Action(function(dispatch:Dispatch, getState:Void->AppState){
			trace(getState());
			if (props.id == null) 
				return dispatch(AppAction.LoginError({id:props.id, loginError:'UserId fehlt!',mandator:props.mandator}));
			var fD:FormData = new FormData();
			fD.append('action', 'logOff');
			fD.append('className', 'auth.User');
			fD.append('id', Std.string(props.id));
			var req:XMLHttpRequest = new XMLHttpRequest();
			req.open('POST', '${props.api}');
			req.onload = function()
			{
				 if (req.status == 200) {
					 // OK
					var jRes:LoginState = Json.parse( req.response);
					trace(jRes.jwt);
					//Cookie.set('user.id', Std.string(props.id));
					Cookie.set('user.jwt', jRes.jwt);
					trace(Cookie.get('user.jwt'));
					return dispatch(AppAction.LoginComplete({id:props.id, jwt:jRes.jwt, loggedIn:false}));
				} else {
					  // Otherwise reject with the status text
					  // which will hopefully be a meaningful error
					return dispatch(AppAction.LoginError({id:props.id, loginError:req.statusText}));
				}
			};
			var spin:Dynamic = dispatch(AppAction.AppWait);
			req.send(fD);
			trace(spin);
			return spin;			
		});
	}	
}