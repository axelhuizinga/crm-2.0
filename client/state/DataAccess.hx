package state;

import action.AppAction.*;
import haxe.Serializer;
import haxe.http.HttpJs;
import model.DataAccessState;

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

class DataAccess
{
	public static function load(props:DataAccessState) 
	{
		return Thunk.Action(function(dispatch:Dispatch, getState:Void->DataAccessState){
			trace(getState());
			if (!props.user.loggedIn)
			{
				return dispatch(LoginError(
				{
					user_name:props.user.user_name,
					loginError:'Du musst dich neu anmelden!',
					id:props.user.id
				}));
			}				
			return null;
			//*****/
			//var spin:Dynamic = dispatch(AppWait);
			//req.send();
			//trace(spin);
			//return spin;			
		});
	}

	public static function updateRequest(props:DataAccessState, ?requests:Array<OneOf<HttpJs, XMLHttpRequest>>) 
	{
		return Thunk.Action(function(dispatch:Dispatch, getState:Void->DataAccessState){
			trace(props);
			//trace(getState());
			if (props.user.pass == '' || props.user.user_name == '') 
				return dispatch(LoginError({user_name:props.user.user_name, loginError:'Passwort und user_name eintragen!'}));
			var spin:Dynamic = dispatch(AppWait);
			trace(spin);
			var bL:XMLHttpRequest = BinaryLoader.create(
			'${App.config.api}', 
			{				
				user_name:props.user.user_name,
				jwt:props.user.jwt,
				className:'auth.User',
				action:'login',
				filter:'user_name|${props.user.user_name}',
				dataSource:Serializer.run([
					"users" => ["alias" => 'us',
						"fields" => 'user_name,last_login'],
					"contacts" => [
						"alias" => 'co',
						"fields" => 'first_name,last_name,email',
						"jCond"=>'contact=co.id']
				]),
				pass:props.user.pass,
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
	}
}