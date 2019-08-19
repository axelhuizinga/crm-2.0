package model.auth;
import shared.DbData;
import haxe.Serializer;
import haxe.crypto.Sha256;
import haxe.ds.IntMap;
import haxe.ds.Map;
import haxe.ds.StringMap;
import jwt.JWT;
import me.cunity.debug.Out;
import model.tools.DB;
import php.Exception;
import php.Lib;
import php.NativeArray;
import php.Syntax;
import php.Web;
import php.db.PDO;
import php.db.PDOStatement;

/**
 * ...
 * @author axel@bi4.me
 */

 typedef  UserInfo = 
 {
	?id:Int,
	?ip:String,
	?mandator:Int,
	?validUntil:Int
 }

class User extends Model
{
	public static function _create(param:StringMap<String>):Void
	{
		var self:User = new User(param);	
		trace(param.get('action'));
		Reflect.callMethod(self, Reflect.field(self, param.get('action')),[]);
	}
	
	public function clientVerify():Void
	{
		if (verify(param))
		{			
			dbData.dataInfo['verified'] = true;
			dbData.dataInfo['user_data'] = Lib.objectOfAssociativeArray(doSelect()[0]);
			S.sendInfo(dbData);
		}
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
	
	public function userIsAuthorized():UserAuth
	{
		var sql:String = 'SELECT user_name FROM ${S.db}.users WHERE user_name=:user_name AND active=TRUE';
		var stmt:PDOStatement = S.dbh.prepare(sql,Syntax.array(null));
		if( !Model.paramExecute(stmt, Lib.associativeArrayOfObject({':user_name': '${param.get('user_name')}'})))
		{
			S.sendErrors(dbData,['${param.get('action')}' => stmt.errorInfo()]);
		}
		if(stmt.rowCount()>0)
		{
			//ACTIVE USER EXISTS
			stmt = S.dbh.prepare(
				'SELECT change_pass_required, first_name, last_name, last_login, us.id, us.mandator FROM ${S.db}.users us
				INNER JOIN contacts cl ON us.contact=cl.id 
				WHERE user_name=:user_name AND password=crypt(:password,password)',Syntax.array(null));
			if( !Model.paramExecute(stmt, Lib.associativeArrayOfObject({':user_name': '${param.get('user_name')}',':password':'${param.get('pass')}'})))
			{
				S.sendErrors(dbData,['${param.get('action')}' => stmt.errorInfo()]);
			}
			if (stmt.rowCount()==0)
			{
				S.sendErrors(dbData,['${param.get('action')}'=>'pass']);
			}
			// USER AUTHORIZED
			var assoc:Dynamic = stmt.fetch(PDO.FETCH_ASSOC);
			var res:Map<String,Dynamic> = Lib.hashOfAssociativeArray(assoc);	
			dbData.dataInfo['user_data'] = Lib.objectOfAssociativeArray(assoc);		
			dbData.dataInfo['id'] = res['id'];
			dbData.dataInfo['mandator'] = res['mandator'];
			dbData.dataInfo['last_login'] = res['last_login'];
			dbData.dataInfo['loggedIn'] = true;
			trace(res['user_name']);
			trace('change_pass_required'+(res['change_pass_required']==1 || res['change_pass_required']==true?'Y':'N'));
			// UPDATE LAST_LOGIN
			var rTime:String = DateTools.format(Date.now(), "'%Y-%m-%d %H:%M:%S'");//,request=?
			var update:PDOStatement = S.dbh.prepare('UPDATE users SET last_login=${rTime} WHERE id=:id',Syntax.array(null));
			var success:Bool = Model.paramExecute(update, Lib.associativeArrayOfObject({':id':dbData.dataInfo['user_data'].id}));
			trace(update.errorCode());
			trace(update.errorInfo());
			//UPDATE DONE			
			if (res['change_pass_required']==1 || res['change_pass_required']==true)
				return UserAuth.PassChangeRequired;
			return UserAuth.AuthOK;			
		}
		else
		{
			trace(stmt.rowCount+':$sql');
			S.sendErrors(dbData,['${param.get('action')}'=>'user_name']);
			return UserAuth.NotOK;
		}
	}
	
	public static function login(params:StringMap<String>, secret:String):Bool
	{
		var me:User = new User(params);
		//trace(me);
		switch(me.userIsAuthorized())
		{//TODO:CONFIG JWT DURATION
			case uath = UserAuth.AuthOK|UserAuth.PassChangeRequired:
				var d:Float = DateTools.delta(Date.now(), DateTools.hours(11)).getTime();
				trace(d + ':' + Date.fromTime(d));
				var	jwt = JWT.sign({
						id:me.dbData.dataInfo['user_data'].id,
						validUntil:d,
						ip: Web.getClientIP(),
						mandator:me.dbData.dataInfo['user_data'].mandator
					}, secret);						
				
				trace(jwt);
				trace(JWT.extract(jwt));
				Web.setCookie('user.jwt', jwt, Date.fromTime(d + 86400000));
				Web.setCookie('user.id', me.dbData.dataInfo['user_data'].id, Date.fromTime(d + 86400000));
				//me.dbData.dataInfo['user_data'] = Lib.objectOfAssociativeArray(me.doSelect()[0]);
				if (uath == UserAuth.PassChangeRequired)
				me.dbData.dataInfo['change_pass_required'] = true;
				//me.dbData.dataInfo['user_data'].id = jwt;
				me.dbData.dataInfo['user_data'].jwt = jwt;
				//trace(me.dbData);
				S.sendInfo(me.dbData);
				return true;
			default:
				return false;
		}
	}
	
	public function changePassword():Bool
	{
		if (param.get('new_pass') == param.get('pass'))
		{
			dbData.dataErrors['changePassword'] = 'Das Passwort wurde nicht geändert!';
			S.sendInfo(dbData);
		}
		
		if (verify())
		{
			trace('UPDATE ${S.db}.users SET password=crypt(:new_password,gen_salt(\'bf\',8)),change_pass_required=false WHERE id=:id ');
			var stmt:PDOStatement = S.dbh.prepare(
				'UPDATE ${S.db}.users SET password=crypt(:new_password,gen_salt(\'bf\',8)),change_pass_required=false WHERE id=:id ',Syntax.array(null));
			if ( !Model.paramExecute(stmt, Lib.associativeArrayOfObject(
				{':id': '${param.get('id')}',':new_password':'${param.get('new_pass')}'})))
			{
				S.sendErrors(dbData,['changePassword' => stmt.errorInfo()]);
			}
			if (stmt.rowCount()==0)
			{
				S.sendErrors(dbData,['changePassword'=>'Benutzer nicht gefunden!']);
			}
		}		
		dbData.dataInfo['changePassword'] = 'OK';
		S.sendInfo(dbData);
		return true;
	}
	
	public function save():Bool
	{
		var res = update();
		trace(res);
		S.sendbytes(serializeRows(doSelect()));
		//S.send('OK');
		return true;
	}
	
	static function saveRequest(id:Int, params:StringMap<String>):Bool
	{
		var request:String = Serializer.run(params);
		var rTime:String = DateTools.format(S.last_request_time, "'%Y-%m-%d %H:%M:%S'");//,request=?
		var stmt:PDOStatement = S.dbh.prepare('UPDATE users SET online=TRUE,last_request_time=${rTime},"request"=:request WHERE id=:id',Syntax.array(null));
		//trace('UPDATE users SET last_request_time=${rTime},request=\'$request\' WHERE id=\'$id\'');
		var success:Bool = Model.paramExecute(stmt, //null
			Lib.associativeArrayOfObject({':id': id, ':request': '$request'})
		);
		if(Std.parseInt(stmt.errorCode())>0)
			trace(stmt.errorInfo());
		return success;
	}

	public static function getViciDialPassword(jwt:String, user:String,?params:StringMap<String>):String
	{
		return '';
	}
	
	public static function verify(?params:StringMap<String>):Bool
	{
		var jwt:String = params.get('jwt');
		var id:Int = Std.parseInt(params.get('id'));		
		trace(jwt);
		try{
			var userInfo:UserInfo = JWT.extract(jwt);
			var now:Float = Date.now().getTime();
			trace('$id==${userInfo.id}::${userInfo.ip}::${Web.getClientIP()}:' + Date.fromTime(userInfo.validUntil) + 
			':${userInfo.validUntil} - $now:' + cast( userInfo.validUntil - now) + 
			(userInfo.validUntil - Date.now().getTime()) > 0?'Y':'N');
			
			trace(':'+(id == userInfo.id));
			trace(':'+(userInfo.ip == Web.getClientIP()));
			trace(':'+((userInfo.validUntil - Date.now().getTime()) > 0));
			if (id == userInfo.id && userInfo.ip == Web.getClientIP() && (userInfo.validUntil - Date.now().getTime()) > 0)
			{
				trace('calling JWT.verify now...');
				trace(JWT.verify(jwt, S.secret));
				return switch(JWT.verify(jwt, S.secret))				
				{
					case Valid(payload):
						// JWT VALID AND NOT OLDER THAN 11 h
						saveRequest(id, params);
						true;
					default:
						S.sendErrors(new DbData(), ['loginError'=>'JWT invalid!']);
						false;
				}
			}
			S.sendErrors(new DbData(), ['loginError'=>'JWT invalid!']);		
			return false;
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
	AuthOK;
	PassChangeRequired;
	NotOK;
}