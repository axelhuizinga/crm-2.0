package action.async;

import me.cunity.debug.Out;
import js.lib.Promise;
import db.DbRelation;
import db.DbUser;
import js.html.svg.Point;
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
using Lambda;

class UserAccess {

	public static function changePassword(userState:UserState) 
	{
		trace(userState);
		return Thunk.Action(function(dispatch:Dispatch, getState:Void->AppState)
		{
			if (userState.dbUser.jwt == '' || userState.new_pass == '' || userState.dbUser.user_name == '') 
				return dispatch(
					User(LoginError({dbUser:userState.dbUser, lastError:'Neues Passwort eingeben!'})));
			
			var aState:AppState = getState();
			trace('aState.locationStore.redirectAfterLogin:${aState.locationStore.redirectAfterLogin}');
			BinaryLoader.create(
				'${App.config.api}', 
				{				
					id:userState.dbUser.id, 
					jwt:userState.dbUser.jwt,
					classPath:'auth.User',
					action:'changePassword',
					new_pass:userState.dbUser.new_pass,
					original_path:aState.locationStore.redirectAfterLogin,
					password:userState.dbUser.password,
					user_name:userState.dbUser.user_name,
					devIP:App.devIP
				},
				function(data:DbData)
				{
					//UserAccess.jwtCheck(data);
					trace(Reflect.fields(data));
					//trace(data);
					if (data.dataErrors.keys().hasNext())
					{
						trace(data.dataErrors.toString());
						userState.lastError = data.dataErrors.iterator().next();
						return dispatch(User(LoginError(userState)));
					}
					if (data.dataInfo['jwtExpired'])
					{
						userState.lastError = data.dataInfo['jwtExpired'];
						return dispatch(User(LoginExpired(userState)));
					}
					if (data.dataInfo['online'])
					{
						//trace(aState.userState);			
						aState.userState.new_pass = '';
						//aState.userState.dbUser.loginTask = Login;
						aState.userState.dbUser.first_name = data.dataInfo['first_name'];
						aState.userState.dbUser.last_name = data.dataInfo['last_name'];
						aState.userState.dbUser.last_login = data.dataInfo['last_login'];
						aState.userState.dbUser.id = data.dataInfo['id'];
						aState.userState.dbUser.jwt = data.dataInfo['jwt'];
						aState.userState.dbUser.password = '';
						aState.userState.dbUser.change_pass_required = false;						
						//return dispatch(LocationAccess.redirect([], aState.app.redirectAfterLogin));
						//Cookie.set('SameSite', 'Strict', null, '/');
						//Cookie.set('userState.dbUser.id', Std.string(aState.userState.dbUser.id), null, '/');
						//Cookie.set('userState.dbUser.jwt',aState.userState.dbUser.jwt, null, '/');						
						return dispatch(User(LoginComplete(aState.userState)));
					}
					else trace(data.dataErrors);		
					return null;		
				}
			);	
			return null;
		});
	}

	public static function resetPassword(userState:UserState) 
	{
		return Thunk.Action(function(dispatch:Dispatch, getState:Void->AppState)
		{
			if (userState.dbUser.user_name == ''|| userState.dbUser.mandator==null) 
				return dispatch(
					User(LoginError({dbUser:userState.dbUser, lastError:'Benutzername eingeben!'})));
			var appState:AppState = getState();
			trace(Reflect.fields(appState));
			trace('${appState.locationStore.redirectAfterLogin}');
			BinaryLoader.create(
				'${App.config.api}', 
				{				
					user_name:userState.dbUser.user_name, 
					mandator:userState.dbUser.mandator,
					classPath:'auth.User',
					action:'resetPassword',
					original_path:appState.locationStore.redirectAfterLogin,
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
						return dispatch(User(LoginError({lastError: data.dataErrors.iterator().next()})));
					}
					if (data.dataInfo['resetPassword'] == 'OK')
					{
						trace(appState.userState.dbUser);						
						appState.userState.dbUser.email = data.dataInfo['email'];
						//appState.userState.dbUser.new_pass_confirm = data.dataInfo['pin'];
						appState.userState.loginTask = CheckEmail;
						return dispatch(User(LoginRequired(appState.userState)));
					}
					else trace(data.dataErrors);		
					return null;		
				}
			);	
			return null;
		});
	}

	public static function jwtCheck(data:DbData) 
	{
		if (data.dataErrors.keys().hasNext())
		{
			return Thunk.Action(function(dispatch:Dispatch, getState:Void->AppState){
				trace(data.dataErrors);
				return dispatch(User(LoginError(
					{dbUser:getState().userState.dbUser, lastError:data.dataErrors.iterator().next()})));
			});
		}		
		return null;
	}

	public static function  doLogin(userState:UserState, ?requests:Array<OneOf<HttpJs, XMLHttpRequest>>) 
	{
		return Thunk.Action(function(dispatch:Dispatch, getState:Void->AppState){
			if(userState.dbUser.mandator==null)
				userState.dbUser.mandator=1;
			//Out.dumpObject(userState);
			//trace(getState());
			if (userState.dbUser.password == '' && userState.dbUser.new_pass == '' || userState.dbUser.user_name == '') 
				return dispatch(User(LoginError({dbUser:userState.dbUser, lastError:'Passwort und user_name eintragen!'})));
			//var spin:Dynamic = dispatch(AppAction.AppWait);
			trace('App.maxLoginAttempts:'+App.maxLoginAttempts);
			var bL:XMLHttpRequest = null; 
			userState.dbUser.jwt = '';
			if(App.maxLoginAttempts-->0)
			bL = BinaryLoader.dbQuery( 
			'${App.config.api}',
			{				
				dbUser:userState.dbUser,
				classPath:'auth.User',
				action: (userState.dbUser.new_pass != null?'changePassword':'login'),
				relations:[
					"users" => new DbRelation({
						alias:'us',
						fields: ['id','last_login','mandator'],
						filter: {mandator:1}
					}),
					"contacts" => new DbRelation({
						alias: 'co',
						fields: ['first_name','last_name','email'],
						jCond: 'contact=co.id'
					}) 
				],
				devIP:App.devIP
			},
			function(data:DbData)
			{				
				if (data.dataInfo.exists('loggedIn'))
					trace('loggedIn:${data.dataInfo.get("loggedIn")}');
				//trace(data);
				if (data.dataErrors.keys().hasNext())
				{					
					trace('App.maxLoginAttempts:'+App.maxLoginAttempts);
					if(App.maxLoginAttempts>0)
						return dispatch(User(LoginError({dbUser:userState.dbUser, lastError:data.dataErrors.iterator().next()})));
				}
				//trace(DbUser);
				var userFields:Array<String> = Type.getInstanceFields(DbUser);
				//var uProps:UserState = {};

				for(k=>v in data.dataInfo.keyValueIterator())
				{
					//trace('$k => $v');
					switch (k)
					{
						case 'online'|'change_pass_required':
							Reflect.setField(userState.dbUser, k, v=='true');
						case _:
							(userFields.has(k)?
							Reflect.setField(userState.dbUser, k, v):
							Reflect.setField(userState, k, v));
					}								
				}
				//var uProps:UserState = data.dataInfo['user_data'];
				userState.loginTask = null;
				Cookie.set('SameSite', 'Strict', null, '/');
				Cookie.set('userState.dbUser.id', Std.string(userState.dbUser.id), null, '/');
				Cookie.set('userState.dbUser.first_name',userState.dbUser.first_name, null, '/');
				Cookie.set('userState.dbUser.last_name',userState.dbUser.last_name, null, '/');
				Cookie.set('userState.dbUser.jwt',userState.dbUser.jwt, null, '/');

				trace(Cookie.get('userState.dbUserState.dbUser.jwt'));
				userState.dbUser.online = true;
				//if(uState.dbUser.change_pass_required)
				//	uState.pass = userState.dbUser.pass;
				//Out.dumpObject(userState);
				//trace(dispatch);
				return dispatch(User(LoginComplete(userState)));
				//return dispatch(AppAction.LoginComplete(
			});
			if (requests != null)
			{
				requests.push(bL);
			}
			return null;
		});
	}

	public static function loginReq(userState:UserState, ?requests:Array<OneOf<HttpJs, XMLHttpRequest>>) 
	{
		return Thunk.Action(function(dispatch:Dispatch, getState:Void->AppState){
			trace(Reflect.fields(userState));
			//trace(getState().userState.dbUser);
			if (userState.lastError != null) 
				return dispatch(User(LoginRequired(userState)));
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
			trace(getState().userState);
			var userState:UserState = getState().userState;
			if (userState.dbUser.id == null) 
				return dispatch(User(LoginError({dbUser:userState.dbUser, lastError:'UserId fehlt!'})));
			var bL:XMLHttpRequest = null;
			bL = BinaryLoader.dbQuery(
			'${App.config.api}', 
			{				
				classPath:'auth.User',
				action:'logout',
				dbUser: userState.dbUser,
				relations: ["users" => new DbRelation({
					filter:{id:userState.dbUser.id}
					}),
				],
				devIP:App.devIP
			},
			function(data:DbData)
			{
				 if (data.dataErrors.keys().hasNext()){
					 // OK
					trace(data.dataErrors);
					//Cookie.set('userState.dbUser.id', Std.string(userState.dbUser.id));
					return null;
				} else {
					userState.dbUser.online = false;
					//var d:Date = Date.now().delta(31556926000);//ADD one year				
					//Cookie.set('userState.dbUser.jwt', '', 31556926);
					Cookie.set('userState.dbUser.id', null, null, '/');					
					trace(Cookie.get('userState.dbUserState.dbUser.jwt'));
					return dispatch(User(LogOutComplete({dbUser: userState.dbUser, waiting: false})));
				}
			});
			return null;
		});		
	}

	public static function verify() {
		//CHECK IF WE HAVE A VALID SESSION
		return Thunk.Action(function(dispatch:Dispatch, getState:Void->AppState){
			//trace('clientVerify');
			return new Promise(function(resolve, reject){
				var state:AppState = getState();
				trace(state.userState.dbUser);
				//trace(Type.getClass(state.userState.dbUser));
				var bL:XMLHttpRequest = BinaryLoader.dbQuery(
				'${App.config.api}', 
				{				
					dbUser:state.userState.dbUser,
					classPath:'auth.User', 
					action:'verify',								
					relations:[
						"users" => new DbRelation({
							alias:  'us',
							fields: ['last_login','mandator'],
							filter:{id:state.userState.dbUser.id}
						}),
						"contacts" => new DbRelation({
							alias: 'co',
							fields: ['first_name','last_name','email'],
							jCond: 'contact=co.id'
						}) 
					],
					devIP:App.devIP
				},			
				function(data:DbData)
				{
					trace(data);
					if(data.dataInfo.exists('verify') && data.dataInfo.get('verify')=='OK'){
						return resolve(data);
					}
					trace(data.dataErrors.empty());
					if (!data.dataErrors.empty())
					{
						trace(data.dataErrors);
						return resolve(data);
						/*return dispatch(User(LoginError(
						{
							//dbUser:state.userState.dbUser, 
							lastError:data.dataErrors.iterator().next(),
							loginTask: data.dataInfo['loginTask'],
							waiting: false
						})));*/
					}	
					var uData = data.dataRows[0];
					//var uProps:Dynamic = {};
					trace(data.dataInfo);
					for(k=>v in uData.keyValueIterator())
					{
						if(Reflect.hasField(state.userState.dbUser, k))
						switch (k)
						{
							case 'change_pass_required'|'online':
								Reflect.setField(state.userState.dbUser, k, v=='true');
								//trace('$k: ${v=='true'?'Y':'N'} =>  ${v?'Y':'N'}');
							default:
								Reflect.setField(state.userState.dbUser, k, v);

						}						
					}
					state.userState.waiting = false;
					trace(state.userState.dbUser.jwt);
					dispatch(User(LoginComplete(state.userState)));
					return resolve(data);
				});
			});
		});	
	}
/**
 * 
 */
	
}