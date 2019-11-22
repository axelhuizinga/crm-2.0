package model.auth;
import haxe.CallStack;
import shared.DbData;
import haxe.Serializer;
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
	
	public function clientVerify():Void
	{
		if (verify(param))
		{			
			dbData.dataInfo['verified'] = 'true';
			
			//dbData.dataInfo['user_data'] = Lib.objectOfAssociativeArray(doSelect()[0]);
			dbData.dataInfo.copyStringMap(Lib.hashOfAssociativeArray(doSelect()[0]));
			//dbData.dataInfo['user_data'] = param['jwt'];
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
	
	static function userEmail(param:Map<String,Dynamic>):String
	{
		var dbData:DbData = new DbData();
		var sql:String = 'SELECT user_name FROM ${S.db}.users WHERE user_name=:user_name AND active=TRUE';
		var stmt:PDOStatement = S.dbh.prepare(sql,Syntax.array(null));
		if( !Model.paramExecute(stmt, Lib.associativeArrayOfObject({':user_name': '${param.get('user_name')}'})))
		{			
			trace(stmt.errorInfo());
			S.sendErrors(dbData,['${param['action']}' => Std.string(stmt.errorInfo())]);
			return '';
		}
		if(stmt.rowCount()>0)
		{
			//ACTIVE USER EXISTS - CHECK EMAIL
			sql = 'SELECT email, first_name, last_name, last_login, us.id FROM ${S.db}.users us INNER JOIN contacts cl ON us.contact=cl.id WHERE user_name=:user_name';
			stmt = S.dbh.prepare(sql,Syntax.array(null));
			if( !Model.paramExecute(stmt, Lib.associativeArrayOfObject(
				{':user_name': param.get('user_name')}
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
	
	static function userIsAuthorized(param:Map<String,Dynamic>):UserAuth
	{
		var dbData:DbData = new DbData();
		var sql:String = 'SELECT user_name FROM ${S.db}.users WHERE user_name=:user_name AND active=TRUE';
		var stmt:PDOStatement = S.dbh.prepare(sql,Syntax.array(null));
		if( !Model.paramExecute(stmt, Lib.associativeArrayOfObject({':user_name': '${param.get('user_name')}'})))
		{			
			trace(stmt.errorInfo());
			S.sendErrors(dbData,['${param['action']}' => Std.string(stmt.errorInfo())]);
		}
		if(stmt.rowCount()>0)
		{
			//ACTIVE USER EXISTS
			trace('SELECT change_pass_required, first_name, last_name, last_login, us.id, us.mandator FROM ${S.db}.users us INNER JOIN contacts cl ON us.contact=cl.id WHERE user_name=:user_name AND phash=crypt (:password,phash)');
			stmt = S.dbh.prepare(
				'SELECT change_pass_required, first_name, last_name, last_login, us.id, us.mandator FROM ${S.db}.users us INNER JOIN contacts cl ON us.contact=cl.id WHERE user_name=:user_name AND phash=crypt(:password,phash)',Syntax.array(null));
			if( !Model.paramExecute(stmt, Lib.associativeArrayOfObject({':user_name': '${param.get('user_name')}',':password':'${param.get('pass')}'})))
			{
				S.sendErrors(dbData,['${param['action']}' => stmt.errorInfo()]);
			}
			if (stmt.rowCount()==0)
			{
				S.sendErrors(dbData,['user'=>'user ${param['user_name']} not found!']);
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
			// UPDATE LAST_LOGIN
			var rTime:String = DateTools.format(Date.now(), "'%Y-%m-%d %H:%M:%S'");//,request=?
			var update:PDOStatement = S.dbh.prepare('UPDATE users SET last_login=${rTime} WHERE id=:id',Syntax.array(null));
			var success:Bool = Model.paramExecute(update, Lib.associativeArrayOfObject({':id':res['id']}));
			trace(update.errorCode());
			trace(update.errorInfo());
			//UPDATE DONE			
			if (res['change_pass_required']==true || res['change_pass_required']=='true')
				return UserAuth.PassChangeRequired(dbData);
			return UserAuth.AuthOK(dbData);			
		}
		else
		{
			trace(stmt.rowCount+':$sql');
			S.sendErrors(dbData,['${param['action']}'=>'user_name']);
			return UserAuth.NotOK;
		}
	}
	
	public static function login(params:Map<String,Dynamic>):Bool
	{
		//var me:User = new User(params);
		//trace(me);
		switch(userIsAuthorized(params))
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
				Web.setCookie('user.jwt', jwt, Date.fromTime(d + 86400000));
				Web.setCookie('user.id', dbData.dataInfo['id'], Date.fromTime(d + 86400000));
				Web.setCookie('user.last_name', dbData.dataInfo['last_name'], Date.fromTime(d + 86400000));
				Web.setCookie('user.first_name', dbData.dataInfo['first_name'], Date.fromTime(d + 86400000));
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
	
	public static function logout(params:Map<String,Dynamic>):Bool
	{	
		trace(params);
		//var me:User = new User(params);		
		trace(params['id']);	
		var expiryDate = Date.now().delta(31556926000);//1 year
		Web.setCookie('user.jwt', '', expiryDate);
		Web.setCookie('user.id', params['id'], expiryDate);

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
		
		if (verify(param))
		{
			trace('UPDATE ${S.db}.users SET phash=crypt(:new_password,gen_salt(\'bf\',8)),change_pass_required=false WHERE id=:id ');
			var stmt:PDOStatement = S.dbh.prepare(
				'UPDATE ${S.db}.users SET phash=crypt(:new_password,gen_salt(\'bf\',8)),change_pass_required=false WHERE id=:id ',Syntax.array(null));
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

	public static function resetPassword(param:Map<String,Dynamic>) {
		var address = userEmail(param);
		final email = {
			subject: 'Subject',
			from: {address: 'admin@pitverwaltung.de', displayName: "crm-2.0 SCHUTZENGELWERK"},
			to: [address],
			content: {
				text: 'hello',
				html: '<font color="orange">hello</font>'
			},
			//attachments: ['image.png']
		}
		smtpmailer.SmtpMailer.connect({
			host: 'pitverwaltung.de',
			port: 587,
			auth: {
				username: 'admin',
				password: 'XbkvugE'
			}
		}).next(mailer ->
		mailer.send(email).next(
			_ -> mailer.close()
		)
		).handle(function(res) {
			switch res {
				case Success(_):
					trace('Email sent!');
				case Failure(e): {
					trace('Something went wrong: '+e);
				}
			}
		});		
	}
	
	public function save():Bool
	{
		var res = update();
		trace(res);
		S.sendbytes(serializeRows(doSelect()));
		//S.send('OK');
		return true;
	}
	
	static function saveRequest(id:Int, params:Map<String,Dynamic>):Bool
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

	public static function getViciDialPassword(jwt:String, user:String,?params:Map<String,String>):String
	{
		return '';
	}
	
	public static function verify(?params:Map<String,Dynamic>):Bool
	{
		var jwt:String = params.get('jwt');
		var id:Int = Std.parseInt(params.get('id'));		
		trace(jwt);
		try{
			var userInfo:UserInfo = JWT.extract(jwt);
			var now:Float = Date.now().getTime();
			//trace('$id==${userInfo.id}::${userInfo.ip}::${Web.getClientIP()}:' + Date.fromTime(userInfo.validUntil) + ':${userInfo.validUntil} - $now:' + cast( userInfo.validUntil - now) + (userInfo.validUntil - Date.now().getTime()) > 0?'Y':'N');
			
			//trace(':'+(id == userInfo.id));
			//trace(':'+(userInfo.ip == Web.getClientIP()));
			//trace(':'+((userInfo.validUntil - Date.now().getTime()) > 0));
			if (id == userInfo.id && userInfo.ip == Web.getClientIP() && (userInfo.validUntil - Date.now().getTime()) > 0)
			{
				//trace('calling JWT.verify now...');
				//trace(JWT.verify(jwt, S.secret));
				var jRes:JWTResult<Dynamic> = JWT.verify(jwt, S.secret);
				return switch(jRes)				
				{
					case Invalid(payload):
						trace(payload);
						// JWT VALID AND NOT OLDER THAN 11 h
						saveRequest(id, params);
						S.sendErrors(new DbData(), ['jwtError'=>jRes]);
						false;
					case Valid(payload):
						// JWT VALID AND NOT OLDER THAN 11 h
						saveRequest(id, params);						
						true;
					default:
						S.sendErrors(new DbData(), ['jwtError'=>jRes]);
						false;
				}
			}
			S.sendErrors(new DbData(), ['jwtError'=>'JWT invalid!']);		
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
	AuthOK(dbData:DbData);
	AuthNoEmail;
	PassChangeRequired(dbData:DbData);
	NotOK;
}