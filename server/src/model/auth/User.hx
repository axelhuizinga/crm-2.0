package model.auth;
import php.Global;
import haxe.Json;
import db.DbUser;
import comments.CommentString.*;
import db.DbQuery;
import db.LoginTask;
import haxe.CallStack;
import shared.DbData;
import haxe.crypto.Sha256;
import haxe.ds.IntMap;
import haxe.ds.Map;
import jwt.JWT;
import jwt.JWT.JWTResult;
import me.cunity.debug.Out;
import model.tools.DB;
import php.Exception;
import php.Lib;
import php.NativeArray;
import php.Syntax;
import php.Web;
import php.db.PDO;
import php.db.PDOStatement;
using  DateTools;
using Util;
/**
 * ...
 * @author axel@bi4.me
 */

 typedef  UserInfo = 
 {
	?id:Int,
	?ip:String,
	?mandator:Int,
	?user_name:String,
	?validUntil:Int
 }

class User extends Model
{
	static var lc:Int = 0;
	static var _me:User;
	var last_login:Date;

	public static function _create(param:Map<String,String>):Void
	{
		trace(param);
		var self:User = new User(param);	
		
		//self.run();
		//trace(action);
		//Reflect.callMethod(self, Reflect.field(self, action),[]);
	}
	
	public function new(?param:Map<String,String>) 
	{
		trace(lc);
		if(lc==1)
		{
			trace(_me.dbData);
			Out.dumpStack(CallStack.callStack());
			S.sendInfo(_me.dbData);
		}
		else{
			_me = this;
		}
		super(param);

		if(lc++ >1)
		{
			trace('too much $lc');
		}
		else 
			run();
	}	
	
	public function edit():Void
	{
		trace(joinSql);
		trace(filterSql);
		S.sendbytes(serializeRows(doSelect()));
	}
	
	public function getExternalUserData():Map<String, Dynamic>
	{
		return null;
	}
	
	static function userEmail(param:Map<String,Dynamic>):String
	{
		var dbData:DbData = new DbData();
		var sql:String = 'SELECT user_name FROM ${S.dbSchema}.users WHERE user_name=:user_name AND mandator=:mandator AND active=TRUE';
		var stmt:PDOStatement = S.dbh.prepare(sql,Syntax.array(null));
		if( !Model.paramExecute(stmt, Lib.associativeArrayOfObject(
			{':user_name': param.get('user').user_name,':mandator':param.get('mandator')}))
		){			
			trace(stmt.errorInfo());
			S.sendErrors(dbData,['${param['action']}' => Std.string(stmt.errorInfo())]);
			return '';
		}
		if(stmt.rowCount()>0)
		{
			//ACTIVE USER EXISTS - CHECK EMAIL
			sql = 'SELECT email, first_name, last_name, last_login, us.id FROM ${S.dbSchema}.users us INNER JOIN contacts cl ON us.contact=cl.id WHERE user_name=:user_name';
			stmt = S.dbh.prepare(sql,Syntax.array(null));
			if( !Model.paramExecute(stmt, Lib.associativeArrayOfObject(
				{':user_name': param.get('user').user_name}
				)))
			{
				S.sendErrors(dbData,['${param['action']}' => stmt.errorInfo()]);
			}
			if (stmt.rowCount()==0)
			{
				S.sendErrors(dbData,['user'=>'user ${param['user_name']} not found!']);
				return '';
			}
			// USER AUTHORIZED
			var assoc:Dynamic = stmt.fetch(PDO.FETCH_ASSOC);
			var res:Map<String,Dynamic> = Lib.hashOfAssociativeArray(assoc);	
			//dbData.dataInfo['id'] = res['id'];
			//dbData.dataInfo['user_data'] = Lib.objectOfAssociativeArray(assoc);		
			dbData.dataInfo = res;		
			//dbData.dataInfo['mandator'] = res['mandator'];
			//dbData.dataInfo['last_login'] = res['last_login'];
			//dbData.dataInfo['loggedIn'] = 'true';
			trace(res['user_name']+':'+res['email']);	
			//S.sendInfo(dbData);
			return res['email'];
		}
		else
		{
			trace(stmt.rowCount+':$sql');
			S.sendErrors(dbData,['${param['action']}'=>'user_name']);
			return '';                          
		}
	}

	public static function resetPassword(user:Map<String,Dynamic>):Bool {
		var dbData:DbData = new DbData();
		//TODO: configure valid time span of token
		var d:Float = DateTools.delta(Date.now(), DateTools.minutes(8)).getTime();
		user.set('email',userEmail(user));
		user.set('jwt',JWT.sign({
			user_name:user['user_name'],
			validUntil:d,
			mandator:user['mandator']
		}, S.secret));
		sendMail(user);
		dbData.dataInfo = [
			'email' => user.get('email'),
			'pin'=>'12341',
			'resetPassword' => 'OK'
		];
		S.sendInfo(dbData);
		return true;
	}
	/**
	 * 	
	 * @user user 
	 * @return UserAuth
	 */
	
	static function userIsAuthorized(user:DbUser,?login:Bool):UserAuth
	{
		var dbData:DbData = new DbData();
		var sql:String = 'SELECT user_name FROM ${S.dbSchema}.users WHERE user_name=:user_name AND active=TRUE';
		var stmt:PDOStatement = S.dbh.prepare(sql,Syntax.array(null));
		if( !Model.paramExecute(stmt, Lib.associativeArrayOfObject({':user_name': '${user.user_name}'})))
		{			
			trace(stmt.errorInfo());
			S.sendErrors(dbData,['User.userIsAuthorized' => Std.string(stmt.errorInfo())]);
		}
		if(stmt.rowCount()>0)
		{
			//ACTIVE USER EXISTS
			sql = 'SELECT change_pass_required, first_name, last_name, last_login, us.id, us.mandator FROM ${S.dbSchema}.users us INNER JOIN contacts cl ON us.contact=cl.id WHERE user_name=:user_name AND phash=crypt(:password,phash)';
			trace(sql);
			stmt = S.dbh.prepare(sql,Syntax.array(null));
			if( !Model.paramExecute(stmt, Lib.associativeArrayOfObject({':user_name': '${user.user_name}',':password':'${user.password}'})))
			{
				S.sendErrors(dbData,['User.userIsAuthorized' => stmt.errorInfo()]);
			}
			if (stmt.rowCount()==0)
			{
				S.sendErrors(dbData,['user'=>'user ${user.user_name} forgot password?']);
				return UserAuth.NotOK;
			}
			// USER AUTHORIZED
			var assoc:Dynamic = stmt.fetch(PDO.FETCH_ASSOC);
			var res:Map<String,Dynamic> = Lib.hashOfAssociativeArray(assoc);	
			//dbData.dataInfo['id'] = res['id'];
			//dbData.dataInfo['user_data'] = Lib.objectOfAssociativeArray(assoc);		
			dbData.dataInfo = res;		
			//dbData.dataInfo['mandator'] = res['mandator'];
			//dbData.dataInfo['last_login'] = res['last_login'];
			dbData.dataInfo['loggedIn'] = 'true';
			trace(res['user_name']+':'+res['change_pass_required']);
			trace('change_pass_required'+(res['change_pass_required']==true || res['change_pass_required']=='true'?'Y':'N'));
			if(login){					
				// UPDATE LAST_LOGIN
				var rTime:String = DateTools.format(Date.now(), "'%Y-%m-%d %H:%M:%S'");//,request=?
				var update:PDOStatement = S.dbh.prepare('UPDATE users SET last_login=${rTime} WHERE id=:id',Syntax.array(null));
				var success:Bool = Model.paramExecute(update, Lib.associativeArrayOfObject({':id':res['id']}));
				trace(update.errorCode());
				//trace(update.errorInfo());
				dbData.dataInfo['last_login'] = rTime;
				//UPDATE DONE			
			}
			if (res['change_pass_required']==true || res['change_pass_required']=='true')
				return UserAuth.PassChangeRequired(dbData);
			return UserAuth.AuthOK(dbData);			
		}
		else
		{
			trace(stmt.rowCount+':$sql');
			S.sendErrors(dbData,['User.userIsAuthorized'=>'user ${user.user_name} not found!']);
			return UserAuth.NotOK;
		}
	}
	
	public static function login(user:DbUser):Bool
	{
		//var me:User = new User(user);
		trace(user);
		switch(userIsAuthorized(user, true))
		{//TODO:CONFIG JWT DURATION
			case uath = UserAuth.AuthOK(dbData)|UserAuth.PassChangeRequired(dbData):
				var d:Float = DateTools.delta(Date.now(), DateTools.hours(11)).getTime();
				trace(d + ':' + Date.fromTime(d));
				var	jwt = JWT.sign({
					id:dbData.dataInfo['id'],
					validUntil:d,
					ip: Web.getClientIP(),
					mandator:dbData.dataInfo['mandator']
				}, S.secret);						
				
				//trace(jwt);
				//trace(JWT.extract(jwt));
				//Web.setCookie('user.id', me.dbData.dataInfo['user_data'].id, Date.fromTime(d + 86400000));
				var expire:Int = Date.fromTime(d + 86400000).getSeconds();
				Global.setcookie('user.jwt',jwt,expire,'/','',true);
				Global.setcookie('user.id', dbData.dataInfo['id'],expire,'/','',true);
				Global.setcookie('user.last_name', dbData.dataInfo['last_name'], expire,'/','',true);
				Global.setcookie('user.first_name', dbData.dataInfo['first_name'], expire,'/','',true);
				//me.dbData.dataInfo['user_data'] = Lib.objectOfAssociativeArray(me.doSelect()[0]);
				trace(Type.enumConstructor(uath));
				dbData.dataInfo['change_pass_required'] = Std.string(Type.enumConstructor(uath) == 'PassChangeRequired');
				//me.dbData.dataInfo['user_data'].id = jwt;
				dbData.dataInfo['jwt'] = jwt;
				//trace(dbData);
				S.sendInfo(dbData);
				return true;
			default:
				return false;
		}
	}
	
	public static function logout(dbQuery:DbQuery):Bool
	{	
		trace(dbQuery.dbUser);
		//var me:User = new User(user);		
		var expiryDate:Int = Date.now().delta(31556926000).getSeconds();//1 year
		Global.setcookie('user.jwt','',expiryDate,'/','',true);
		Global.setcookie('user.id', Std.string(dbQuery.dbUser.id), expiryDate,'/','',true);

		//me.dbData.dataInfo['user_data'].id = jwt;
		//trace(me.dbData);
		S.sendInfo(new DbData(),['logout'=>'Done']);
		return true;
	}

	public function changePassword():Bool
	{
		if (param.get('new_pass') == param.get('pass'))
		{
			dbData.dataErrors['changePassword'] = 'Das Passwort wurde nicht geändert!';
			S.sendInfo(dbData);
		}
		
		var sql = (param.get('user').id!='undefined'&&param.get('user').id!=null?
				'UPDATE ${S.dbSchema}.users SET phash=crypt(:new_password,gen_salt(\'bf\',8)),change_pass_required=false WHERE id=:id':
				'UPDATE ${S.dbSchema}.users SET phash=crypt(:new_password,gen_salt(\'bf\',8)),change_pass_required=false WHERE user_name=:user_name AND mandator=:mandator');
		trace(sql);
		var stmt:PDOStatement = S.dbh.prepare(sql,Syntax.array(null));
		if ( !Model.paramExecute(stmt, Lib.associativeArrayOfObject(
			//(param.get('id')!='undefined'&&param.get('id')!=null?				 
			(param.get('user').id!='undefined'&&param.get('user').id!=null? 				 
				{':id': param.get('user').id,':new_password':param.get('new_pass')}:
				{':new_password':param.get('new_pass'),':user_name': param.get('user').user_name,':mandator': param.get('mandator')}
		))))
		{
			S.sendErrors(dbData,['changePassword' => stmt.errorInfo()]);
		}
		if (stmt.rowCount()==0)
		{
			S.sendErrors(dbData,['changePassword'=>'Benutzer nicht gefunden!']);
		}
		//}		
		var userInfo:UserInfo = JWT.extract(param.get('jwt'));
		trace(userInfo);				
		//dbData.dataInfo['opath'] = userInfo.opath;
		dbData.dataInfo['changePassword'] = 'OK';
		//param.set('pass', param.get('new_pass'));
		var dbQuery = Model.binary();
		//dbQuery.data.set('pass', param.get('new_pass'));
		return login(dbQuery.dbUser);
		S.sendInfo(dbData);
		return true;
	}

	public static function sendMail(param:Map<String,Dynamic>) {
		var address = userEmail(param);
		trace(address);
		var jwt:String = param.get('jwt');		
		var original_path:String = param.get('original_path');
		var user_name:String = param.get('user').user_name;
		var host:String = Syntax.code("$_SERVER['SERVER_NAME']");
		if(param.get('dev'))
		{
			host = '192.168.178.20:9000';			
		}
		var header = comment(unindent, format) /*
Content-type: text/html; charset=utf-8
From: SCHUTZENGELWERK crm-2.0 <admin@pitverwaltung.de>
X-Mailer: HaxeMail
*/;
		var content:String = comment(unindent, format) /*
<!DOCTYPE html>
<html><head>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">

<title>Neues Passwort</title>

<style>
html,body{
	height:100%;
	width:100%;
	display:flex;
	margin:0px;
	padding:0px;
}
	div{
		text-align:center;
		width:60%;
		height:40%;
		margin:auto;		
	}
	.center{
	        display: flex;
        align-items: center;
        justify-content: center;
        flex-direction: column;
        text-align: center;
        min-height: 200px;
        background-color: rgba(33, 33, 33, .3);
        align-items: center;
	}
    </style>
</head>
<body>
	<div class="center">
		<a href="https://$host/ChangePassword/$jwt/$user_name$original_path">Passwort Ändern</span>
	</div>
</body>
</html>
*/;		

		if(php.Syntax.code("mail({0},{1},{2},{3})",
		address,'Passwort Reset',content,header))
		{
			trace('Email sent to ${address}');
		}
		else
		{
			trace('Error sending Email to ${address}');
		}
	}
	
	public function save():Bool
	{
		var res = update();
		trace(res);
		S.sendbytes(serializeRows(doSelect()));
		//S.send('OK');
		return true;
	}
	
	static function saveRequest(id:Int, dbQuery:DbQuery):Bool
	{
		//trace(new hxbit.Serializer().serialize(dbQuery));
		//trace(S.dbQuery);
		trace(Json.stringify(dbQuery));
		//var request:String = Json.stringify(new hxbit.Dump(new hxbit.Serializer().serialize(dbQuery)).dumpObj());
		var request:String = Web.getPostData();
		trace( request.length + ' == ' +  Syntax.code('strlen(@iconv("UTF-8", "UTF-8//IGNORE",{0}))',request));
		//trace(request);
		var rTime:String = DateTools.format(S.last_request_time, "'%Y-%m-%d %H:%M:%S'");//,request=?
		var stmt:PDOStatement = S.dbh.prepare('UPDATE activity SET "request"=:request FROM users WHERE users.id=:id AND users.id=activity.user' ,Syntax.array(null));
		//trace('UPDATE users SET last_request_time=${rTime},request=\'$request\' WHERE id=\'$id\'');
		var success:Bool = Model.paramExecute(stmt, //null
			Lib.associativeArrayOfObject({':id': id, ':request': request})
		);
		if(Std.parseInt(stmt.errorCode())>0)
			trace(stmt.errorInfo());
		return success;
	}

	public static function getViciDialPassword(jwt:String, user:String,?params:Map<String,String>):String
	{
		return '';
	}
	
	public static function verify(dbQuery:DbQuery):Bool
	{
		var jwt:String = dbQuery.dbUser.jwt;
		var id:Int = dbQuery.dbUser.id;	
		var now:Float = Date.now().getTime();	
		var dbData:DbData = new DbData();
		//trace('$now:$jwt');
		//trace(dbQuery);
		try{
			var userInfo:UserInfo = JWT.extract(jwt);
			//trace(userInfo);			
			if(userInfo.id==null && userInfo.id ==dbQuery.dbUser.id && (userInfo.validUntil - Date.now().getTime()) > 0)
			{
				var jRes:JWTResult<Dynamic> = JWT.verify(jwt, S.secret);
				trace(jRes);
				return switch(jRes)				
				{
					case Invalid(payload):
						trace(payload);
						// JWT INVALID
						//saveRequest(id, dbQuery);
						dbData.dataErrors = ['jwtError'=>'Invalid'];
						S.sendInfo(dbData, ['loginTask'=>Login]);
						false;
					case Valid(payload):
						// JWT VALID AND NOT OLDER THAN...
						if(dbQuery.dbUser.mandator == null)
							dbQuery.dbUser.mandator = userInfo.mandator;
						//params.set('mandator',userInfo.mandator);
						//saveRequest(id, dbQuery);	
						if(S.action=='verify')
							S.sendInfo(dbData, ['verify'=>'OK']);
						true;
					default:
						dbData.dataErrors = ['jwtError'=>'${DateTools.format(Date.fromTime(userInfo.validUntil), "%d.%m.%y %H:%M:%S")}<${DateTools.format(Date.fromTime(now),"%d.%m.%y %H:%M:%S")}'];
						S.sendInfo(dbData, ['loginTask'=>Login]);
						false;
				}

			}
			//trace('$id==${userInfo.id}::${userInfo.ip}::${Web.getClientIP()}:' + Date.fromTime(userInfo.validUntil) + ':${userInfo.validUntil} - $now:' + cast( userInfo.validUntil - now) + (userInfo.validUntil - Date.now().getTime()) > 0?'Y':'N');
			
			//trace(':'+(id == userInfo.id));
			//trace(':'+(userInfo.ip == Web.getClientIP()));
			//trace(':'+((userInfo.validUntil - Date.now().getTime()) > 0));
			if (id == userInfo.id && userInfo.ip == Web.getClientIP() && (userInfo.validUntil - Date.now().getTime()) > 0)
			{
				trace('calling JWT.verify now...');
				//trace(JWT.verify(jwt, S.secret));
				var jRes:JWTResult<Dynamic> = JWT.verify(jwt, S.secret);
				//trace(jRes);
				return switch(jRes)				
				{
					case Invalid(payload):
						trace(payload);
						// JWT INVALID
						//saveRequest(id, dbQuery);
						dbData.dataErrors = ['jwtError'=>'Invalid'];
						S.sendInfo(dbData, ['loginTask'=>'Login']);
						//S.sendErrors(new DbData(), ['jwtError'=>payload]);
						false;
					case Valid(payload):
						// JWT VALID AND NOT OLDER THAN 11 h
						//trace(dbQuery);
						//saveRequest(id, dbQuery);		
						if(S.action=='verify')
							S.sendInfo(dbData, ['verify'=>'OK','validUntil'=>DateTools.format(Date.fromTime(userInfo.validUntil), "%d.%m.%y %H:%M:%S")]);				
						true;
					default:
						S.sendErrors(new DbData(), ['jwtError'=>jRes]);
						false;
				}
			}
			else{
				// expired - TODO: configure error messages
				dbData.dataErrors = ['jwtError'=>'${DateTools.format(Date.fromTime(userInfo.validUntil), "%d.%m.%y %H:%M:%S")}<${DateTools.format(Date.fromTime(now),"%d.%m.%y %H:%M:%S")}'];
				S.sendInfo(dbData, ['loginTask'=>Login]);
				//S.sendInfo(new DbData(), ['jwtExpired'=>'Das Login war nur bis ${DateTools.format(Date.fromTime(userInfo.validUntil), "%d.%m.%y %H:%M:%S")} gültig - bitte neu anmelden!']);		
				return false;
			}
		}
		catch (ex:Dynamic)
		{
			trace(ex);
			S.exit({error:Std.string(ex)});
			return false;
		}
		
	}
	
}

enum UserAuth{
	AuthOK(dbData:DbData);
	AuthNoEmail;
	PassChangeRequired(dbData:DbData);
	NotOK;
}