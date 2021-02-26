package;
import haxe.Exception;
import haxe.CallStack;
import db.DBAccessProps;
import haxe.ds.ReadOnlyArray;
import sys.io.FileOutput;
import sys.FileSystem;
import php.Const;
import php.Global;
import php.SuperGlobal;
import db.DbRelation;
import db.DbUser;
import db.DbQuery;
import haxe.PosInfos;
import haxe.ds.StringMap;

import haxe.io.Bytes;
import me.cunity.debug.Out;
import php.Syntax;
import php.db.PDO;
import php.db.PDOStatement;
import shared.DbData;
import shared.Upload;

import model.data.Accounts;
import model.data.Contacts;
import model.data.Deals;
import model.data.DebitReturnStatements;
import model.admin.CreateHistoryTrigger;
import model.admin.CreateUsers;
import model.data.SyncExternal;
import model.admin.SyncExternalAccounts;
import model.admin.SyncExternalBookings;
import model.admin.SyncExternalContacts;
import model.admin.SyncExternalDeals;
import model.roles.Users;
import model.stats.History;
import model.tools.DB;
import model.tools.Jsonb;
import Model.MData;
import Model.RData;
//import model.QC;
//import model.Select;
import model.auth.User;
import model.view.Forms;
import php.Lib;
import me.cunity.php.Debug;
import php.NativeArray;
//import php.Session;
import php.Web;
//import tjson.TJSON;
import haxe.Json;
import haxe.extern.EitherType;
import hxbit.Serializer;
import sys.io.File;
import comments.CommentString.*;

using Lambda;
using Util;

/**
 * ...
 * @author axel@cunity.me
 */

typedef ColDef =
{
	column_name:String,
	column_default:String
}

typedef Response =
{
	?content:Dynamic,
	?error:Dynamic,
	?data:MData
}

typedef PDOResult = EitherType<Bool,PDOStatement>;

class S 
{
	static inline var debug:Bool = true;
	static var headerSent:Bool = false;
	static var response:Response;
	public static var action:String;
	public static var conf:Map<String,Dynamic>;	
	public static var home:String;
	public static var secret:String;
	public static var dbh:PDO;
	public static var syncDbh:PDO;
	public static var last_request_time:Date;
	public static var host:String;
	public static var request_scheme:String;
	public static var user_id:Int;
	public static var devIP:String;
	public static var db:String;
	public static var dbHost:String;
	public static var dbUser:String;
	public static var dbPass:String;
	public static var dbSchema:String;
	public static var dbViciBoxCRM:String;
	public static var dbViciBoxDB:String;
	public static var dbViciBoxHost:String;
	public static var dbViciBoxUser:String;
	public static var dbViciBoxPass:String;	
	public static var dbQuery:DbQuery;
	public static var params:Map<String,Dynamic>;
	public static var vicidialUser:String;
	public static var viciDial: Map<String, Dynamic>;
	static var ts:Float;
	
	static function main() 
	{		
		/*var _server:NativeArray = SuperGlobal._SERVER;
		var m:String = '';//'${_server.length} ${Const.PHP_EOL}${Global.implode(Const.PHP_EOL, Lib.toPhpArray(_server))}${Const.PHP_EOL}';
		for(k=>v in _server){
			m += '${k}=>${v}' + Const.PHP_EOL;
		}
		Syntax.code("error_log({0})",m);*/
		//Syntax.code("error_log({0} {1} {2})",_server.length, Const.PHP_EOL, Global.implode(Const.PHP_EOL, Lib.toPhpArray(_server)));
		
		init();
		//trace(conf.get('ini'));
		//var ini:NativeArray = S.conf.get('ini');
		//var vD:NativeArray = ini['vicidial'];
		//trace(ini);
		ts = Sys.time();
		last_request_time = Date.fromTime(ts/1000);
		var now:String = DateTools.format(Date.now(), "%d.%m.%y %H:%M:%S");		
		//trace(last_request_time.toString() + ' == $now' );		
		trace(DateTools.format(last_request_time, "%d.%m.%y %H:%M:%S") + ' == $now' );		
		//trace(vD['syncApi']);
		//var viciDial = Lib.hashOfAssociativeArray(vD);
		//trace(viciDial['url']);
		//trace(viciDial['admin']);
		if(Syntax.code("isset($_SERVER['VERIFIED'])"))
		{trace(Syntax.code("$_SERVER['VERIFIED']"));}
		//var pd:Dynamic = Web.getPostData();
		trace(Lib.isCli()?'cli':'web');
		//devIP = SuperGlobal._POST['devIP'];
		response = {content:'',error:''};
		if(Lib.isCli()){
			safeLog(Sys.args());
			params = Cli.parse();
			action = params.get('action');		
			trace(params);
			var dbUser:DbUser = new DbUser(				
				{jwt:'jwt',id:100,online:true, password:'password', user_name:'sysadmin'});
				//{jwt:params['jwt'],id:params['id'],online:true, password:params['password'], user_name:params['user_name']});
			var dbAccProps:DBAccessProps = {action:action, data:{REMOTE_ADDR:params['REMOTE_ADDR']}, dbUser: dbUser};
			for(k=>v in params.keyValueIterator())
			{
				Reflect.setField(dbAccProps, k, v);
			}
			dbQuery = new DbQuery(dbAccProps);
			//trace(dbQuery);
		}
		else{
			if(Lib.toHaxeArray(SuperGlobal._FILES).length>0)
			{				
				dbh = new PDO('pgsql:dbname=$db;client_encoding=UTF8',dbUser,dbPass,
				Syntax.array([PDO.ATTR_PERSISTENT,true]));
			
				//trace(dbh);
				params = Lib.hashOfAssociativeArray(SuperGlobal._POST);
				action = params.get('action');		
				if(params.get('extDB'))
				{
					//CONNECT DIALER DB	
					trace('mysql:host=$dbViciBoxHost;dbname=$dbViciBoxCRM');
					syncDbh = new PDO('mysql:host=$dbViciBoxHost;dbname=$dbViciBoxCRM',
						dbViciBoxUser,dbViciBoxPass,Syntax.array([PDO.ATTR_PERSISTENT,true]));
					//trace(syncDbh.getAttribute(PDO.ATTR_PERSISTENT)); 
				}
				#if debug
				dbh.setAttribute(PDO.ATTR_ERRMODE, PDO.ERRMODE_EXCEPTION);	
				if(params.get('extDB'))
					syncDbh.setAttribute(PDO.ATTR_ERRMODE, PDO.ERRMODE_EXCEPTION);
				#end	
				devIP = params.get('devIP');		
				Upload.go();
			}
			//trace(Web.getPostData());
			dbQuery = Model.binary();			
			//(dbQuery);
			if(dbQuery==null)
				send("dev end");
			//Model.binary(params.get('dbData'));
			params = dbQuery.dbParams;
			params.set('mandator',dbQuery.dbUser.mandator);
			user_id = dbQuery.dbUser.id;
			trace(params);
			safeLog(dbQuery);
			//devIP = params.get('devIP');
			//trace(params);

		}
		action = params.get('action');
		devIP = params.get('devIP');
		if (params.get('action') == null || params.get('classPath') == null)
		{
			exit( { error:"required params action and/or classPath missing" } );
		}
			//host=$dbHost;
		dbh = new PDO('pgsql:dbname=$db;client_encoding=UTF8',dbUser,dbPass,
			Syntax.array([PDO.ATTR_PERSISTENT,true]));
		
		//trace(dbh);
		trace('$devIP connect2syncDB:'+ (params.get('extDB')!=null||params.get('action').indexOf('sync')==0?'Y':'N'));
		if(params.get('extDB')||params.get('action').indexOf('sync')==0)
		{
			//CONNECT DIALER DB	
			trace('mysql:host=$dbViciBoxHost;dbname=$dbViciBoxCRM');
			syncDbh = new PDO('mysql:host=$dbViciBoxHost;dbname=$dbViciBoxCRM',
				dbViciBoxUser,dbViciBoxPass,Syntax.array([PDO.ATTR_PERSISTENT,true]));
			trace(syncDbh.getAttribute(PDO.ATTR_PERSISTENT)); 
		}
		#if debug
		dbh.setAttribute(PDO.ATTR_ERRMODE, PDO.ERRMODE_EXCEPTION);
		if(params.get('extDB'))
			syncDbh.setAttribute(PDO.ATTR_ERRMODE, PDO.ERRMODE_EXCEPTION);
		saveRequest(dbQuery,false);
		#else 
		saveRequest(dbQuery,(params.exist('saveReq')?false:true));
		#end

		if(action == 'resetPassword')
		{
			User.resetPassword(params);
			exit(response);
		}

		var jwt:String = (dbQuery.dbUser!=null?dbQuery.dbUser.jwt:'');
		//var id:String = params.get('id');
		if(jwt != null)
		trace('jwt.length:' +jwt.length);
		if (jwt.length > 0)
		{
			if(Lib.isCli() || User.verify(dbQuery))
			{
				if(action=='returnDebitFile')
				{
					Upload.go();
					exit({'Error':'Upload.go()$action did not send anything'});
				}
				Model.dispatch(dbQuery);		
				exit({'Error':'Model.dispatch ${params.get('classPath')}.$action did not send anything'});
			}

		}	
		User.login(dbQuery.dbUser);		
		exit(response);
	}
	
	public static function add2Response(ob:Response, doExit:Bool = false)
	{
		if (ob.content != null)
			response.content += ob.content;
		if (ob.error != null)
			response.error += ob.error;
		if (doExit || ob.data != null)
		{
			response.data = ob.data;
			exit(response);
		}
	}
	
	public static function exit(r:Dynamic):Void
	{
		if(!Lib.isCli()){
			if (!headerSent)
			{
				setHeader('application/json');
			}			
			//var exitValue =  
			//trace( Syntax.code("json_encode({0})",r.data));
			trace(Json.stringify(r));
			//trace( Syntax.code("json_encode({0})",r));
			//Sys.print(Syntax.code("json_encode({0})",r));
			Sys.print(Json.stringify(r));			
		}
		trace('done at ${Sys.time()-ts} ms');
		trace(r);
		Out.dumpStack(CallStack.callStack());
		Sys.exit(untyped Std.string(r));		
	}
	
	public static function send(r:String, ?json:Bool = false)
	{
		if (!headerSent && !Lib.isCli())
		{
			//setHeader((json?'application/json':'text/plain'));		
			//Web.setHeader('Content-Type', cType);
			Web.setHeader("Access-Control-Allow-Headers", "access-control-allow-headers, access-control-allow-methods, access-control-allow-origin");
			Web.setHeader("Access-Control-Allow-Credentials", "true");
			if(S.devIP!=null&&S.devIP!=''){
				Web.setHeader("Access-Control-Allow-Origin", 'https://${S.devIP}:9000');	
				trace('https://${S.devIP}:9000');
			}
			else {
				trace('no devIP? ${S.devIP}<<<');
			}	
		}			
		Sys.print(r);
		trace('client req from ${params.get('devIP')} done at ${Sys.time()-ts} ms');
		Sys.exit(0);
	}
	
	public static function sendData(dbData:DbData, data:RData):Bool
	{
		var s:Serializer = new Serializer();
		//trace(data.info);
		if(data != null){
			dbData.dataInfo = dbData.dataInfo.copyStringMap(data.info);
			if(data.rows!=null)
				for(row in data.rows.iterator())
					dbData.dataRows.push(Lib.hashOfAssociativeArray(row));		
		}
		
		//trace(Std.string(dbData).substr(0,250));
		if(dbData.dataRows.length>0){
			try{
				trace(dbData.dataRows[0]);

			}
			catch(ex:Exception){
				//trace(ex);
				trace(CallStack.callStack());
			}
		}
		if(Lib.isCli()){
			trace(dbData.dataRows.length);
			return true;			 
		 }		
		return sendbytes(s.serialize(dbData));
	}

	public static function checkStmt(dbConn:PDO, stmt:PDOStatement, err:String, ?pos:PosInfos):Bool
	{
		if(untyped stmt==false)
		{
			trace('${pos.fileName}::${pos.lineNumber}' + dbConn.errorInfo());
			S.sendErrors(null, ['${pos.fileName}::${pos.lineNumber}'=>dbConn.errorInfo()]);
		}
		if(stmt.errorCode() !='00000')
		{
			trace('${pos.fileName}::${pos.lineNumber}' + stmt.errorInfo());
			S.sendErrors(null, ['${pos.fileName}::${pos.lineNumber}'=>stmt.errorInfo()]);
		}		
		return true;
	}

	public static function sendErrors(dbData:DbData = null, ?err:Map<String,Dynamic>, ?pos:PosInfos):Bool
	{
		 trace('${pos.fileName}::${pos.lineNumber}');
		 if(Lib.isCli()){
			trace(err);
			Sys.exit(666);
			return false;			 
		 }
		if(dbData==null)
			dbData = new DbData();
		//trace(dbData);
		var s:Serializer = new Serializer();
		if (err != null)
		{
			for (k in err.keys())
			{
				dbData.dataErrors[k] = err[k];
			}
		}
		trace(dbData.dataErrors);
		return sendbytes(s.serialize(dbData));
	}
	
	public static function sendInfo(dbData:DbData, ?info:Map<String,Dynamic>):Bool
	{
		var s:Serializer = new Serializer();
		if (info != null)
		{
			for (k in info.keys())
			{
				dbData.dataInfo[k] = info[k];
			}
		}
		//trace('done at ${Sys.time()-ts} ms');
		//trace(dbData.dataErrors);
		//trace(dbData);
		return sendbytes(s.serialize(dbData));
	}
	
	public static function sendbytes(b:Bytes, ?loop:Bool):Bool
	{		
		trace('OK ${b.length}');
		if(Lib.isCli())
			return false;		
		setHeader('application/octet-stream');		
		var out = File.write("php://output", true);
		out.bigEndian = true;
		out.write(b);
		trace('done at ${Sys.time()-ts} ms');
		Sys.exit(0);
		return true;
	}
	
	public static function setHeader(cType:String) 
	{
		if(Lib.isCli())
			return;
		Web.setHeader('Content-Type', cType);
		Web.setHeader("Access-Control-Allow-Headers", "access-control-allow-headers, access-control-allow-methods, access-control-allow-origin");
		Web.setHeader("Access-Control-Allow-Credentials", "true");
		if(S.devIP!=null&&S.devIP!=''){
			Web.setHeader("Access-Control-Allow-Origin", 'https://${S.devIP}:9000');	
			trace('https://${S.devIP}:9000');
		}
		else {
			Web.setHeader("Access-Control-Allow-Origin", '*');
			trace('no devIP? ${S.devIP}<<<');
		}
		headerSent = true;	
	}

	public static function dump(d:Dynamic):Void
	{
		if (!headerSent)
		{
			setHeader('application/json');
		}
		
		Lib.println(Json.stringify(d));
	}
	
	public static function edump(d:Dynamic):Void
	{
		Syntax.code("edump({0})", d);
	}
	
	public static function newMemberID():Int {
		var stmt:PDOStatement = S.dbh.query(
			'SELECT  MAX(CAST(vendor_lead_code AS UNSIGNED)) FROM vicidial_list WHERE list_id=10000'
			);
		return (stmt.rowCount()==0 ? 1: stmt.fetch(PDO.FETCH_COLUMN)+1);
	}
	
	public static function tables(db:String = 'crm'): Array<String>
	{
		var sql:String = comment(unindent, format) /*
			SELECT string_agg(TABLE_NAME,',') FROM information_schema.tables WHERE table_schema = '$db'
			*/;
		trace(sql);
		var stmt:PDOStatement = S.dbh.query(
			sql
		);
		/*if (stmt == false)
		{
			exit({error:S.dbh.errorInfo()});
		}*/
		if (S.dbh.errorCode() != '00000')
		{
			trace(S.dbh.errorCode());
			trace(S.dbh.errorInfo());
			Sys.exit(0);
		}
		if (stmt.rowCount() == 1)
		{
			return stmt.fetchColumn().split(',');
		}
		return null;
	}

	public static function dumpNativeArray(a:NativeArray, ?i:PosInfos):String
	{
		var d:String = '';
		trace(Reflect.fields(a),i);
		trace(Type.getClass(a),i);
		return d;
	}

	public static function errorInfo(m:Dynamic,?pos:PosInfos):String
	{
		if(pos==null)
			return m;
		return '${pos.fileName}::${pos.lineNumber}::$m';
	}

	public static function safeLog(what:Dynamic,?pos:PosInfos):Void
	{		
		// TODO: ADD Const.FILE_APPEND
		var fields:Array<String> = Reflect.fields(what);
		for (f in fields)
		{
			if(f.indexOf('pass') > -1 || f.indexOf('__hx')>-1)
			{
				continue;
			}
			var cName:String = Type.getClassName(Type.getClass(Reflect.field(what,f)));
			Util.safeLog(cName, pos);
			if(cName=='Array'){
				return Util.safeLog(cast(Reflect.field(what,f),Array<Dynamic>).filter(function (f:Dynamic) {
					return cast(f, String).indexOf('pass') == -1;
				}).join(','), pos);
			}
			if(cName.indexOf('.')>-1)
			{
				Util.safeLog('recurse4 $cName', pos);
				return Util.safeLog(Reflect.field(what,f), pos);
			}
			Util.safeLog(Reflect.field(what,f), pos);
		}
		//trace(what);
		return;
		dumpNativeArray(what, pos);
	}

	public static function columnDefaults(table:String, schema:String = 'crm'):Array<ColDef>
	{
		var sql = comment(unindent, format) /*
		SELECT column_name, column_default
		FROM information_schema.columns
		WHERE (table_schema, table_name) = ('${quoteIdent(schema)}', '${quoteIdent(table)}')
		ORDER BY ordinal_position;
		*/;
		var stmt:PDOStatement = S.dbh.query(sql);
		if (S.dbh.errorCode() != '00000')
		{
			trace(S.dbh.errorCode());
			trace(S.dbh.errorInfo());
			Sys.exit(0);
		}		
		var res:Array<ColDef> = new Array();
		var data:Dynamic =  stmt.fetch(PDO.FETCH_OBJ);
	 	while (data)
		{
			//trace(data);
			if(data.column_name!='id')
			{
				var value:String = data.column_default == null? null: data.column_default.split('::')[0];			
				var defaultValue:String = switch (value)
				{
					/*case b if (b=="true"|b=="false"):
						b;
					case null|"''":
						null;*/
					default:
						value;
				}
				//res.push({column_name:quoteIdent(data.column_name), column_default:defaultValue});				
				res.push({column_name:data.column_name, column_default:defaultValue});				
			}

			data = stmt.fetch(PDO.FETCH_OBJ);
		}
		return res;
	}

	public static function quoteIdent(f : String):String 
	{
		if ( ~/^([a-zA-Z_])[a-zA-Z0-9_]+$/.match(f))
		{
			return f;
		}		
		return '"$f"';
	}
	
	public static function tableFields(table:String, db:String = 'crm'): Array<String>
	{
		var sql:String = comment(unindent, format) /*
			SELECT string_agg(COLUMN_NAME,',') FROM information_schema.columns WHERE table_schema = '$db' AND table_name = '$table'
			*/;

		var stmt:PDOStatement = S.dbh.query(sql);
		if (S.dbh.errorCode() != '00000')
		{
			trace(S.dbh.errorCode());
			trace(S.dbh.errorInfo());
			Sys.exit(0);
		}		
		if (stmt.rowCount() == 1)
		{
			return stmt.fetchColumn().split(',');
		}
		return null;
	}
	
	
	public static function syncTableFields(table:String, db:String = 'fly_crm'): Array<String>
	{
		var sql:String = comment(unindent, format) /*
			SELECT GROUP_CONCAT(COLUMN_NAME) FROM information_schema.columns WHERE table_schema = '$db' AND table_name = '$table'
			*/;
		var stmt:PDOStatement = syncDbh.query(sql);
		if (S.dbh.errorCode() != '00000')
		{
			trace(syncDbh.errorCode());
			trace(syncDbh.errorInfo());
			Sys.exit(0);
		}		
		if (stmt.rowCount() == 1)
		{
			return stmt.fetchColumn().split(',');
		}
		return null;
	}
		
	/**
	 * [Returns a map of metadatas for the columns of a given table]
	 * @param table 
	 * @param db 
	 * @return Map<String,NativeArray>
	 */

	public static function columnsMeta(table:String, db:String = 'crm'): Map<String,NativeArray>
	{
		var sql:String = comment(unindent,format) /*
		select * 
		from $table limit 1;
		*/;
		var stmt:PDOStatement = S.dbh.query(sql);
		if (S.dbh.errorCode() != '00000')
		{
			trace(S.dbh.errorCode());
			trace(S.dbh.errorInfo());
			Sys.exit(0);
		}		
		if (true || stmt.rowCount() == 1)
		{
			var colNames:Array<String> = tableFields(table, db);
			var i = 0;
			return [
				for(c in colNames)			
					c => stmt.getColumnMeta(i++)
			];
		}
		trace(sql);
		return null;
	}

	public static function columnsMeta1(table:String, db:String = 'crm'): Map<String,NativeArray>
	{
		var sql:String = comment(unindent,format) /*
		select * 
		from $table limit 1;
		*/;
		var stmt:PDOStatement = S.dbh.query(sql);
		if (S.dbh.errorCode() != '00000')
		{
			trace(S.dbh.errorCode());
			trace(S.dbh.errorInfo());
			Sys.exit(0);
		}		
		if (stmt.rowCount() == 1)
		{
			var colNames:Array<String> = tableFields(table, db);
			var i = 0;
			return [
				for(c in colNames)			
					c => stmt.getColumnMeta(i++)
			];
		}
		trace(sql);
		return null;
	}

	public static function getViciDialData():Map<String,Dynamic> 
	{		        
		Util.safeLog(S.conf.get('ini'));
		var ini:NativeArray = S.conf.get('ini');
		ini = ini['vicidial'];
		var fields:Array<String> = Reflect.fields(Lib.objectOfAssociativeArray(ini));
		var info:Map<String,Dynamic> = [
			for(f in fields)
			f => ini[f]
		];
		return info;
	}

	static function saveRequest(req:Dynamic, ?logOnly:Bool=true):Bool
	{
		//trace(Json.stringify(dbQuery));
		if(logOnly){
			Util.safeLog(req);
			return true;			
		}

		var stmt:PDOStatement = dbh.prepare(
			'INSERT INTO activity(action,request,"user") VALUES(:action,:request,:user)' ,Syntax.array(null));

		var success:Bool = Model.paramExecute(stmt, 
			Lib.associativeArrayOfObject(
				{':action':params.get('classPath') + '.' + params.get('action'),
				':user': req.dbUser.id, ':request': Json.stringify(req, function(key:Dynamic, value:Dynamic) {
					return switch(key){
						case 'password'|'new_pass':
							'XXX';
						default:
							value;
					} 	
				})})			
		);
		if(Std.parseInt(stmt.errorCode())>0)
			trace(stmt.errorInfo());
		return success;
	}	
	//static function __init__() {
	static function init() {
		
		var branch:String = #if dev 'dev' #else 'crm' #end;
		home = Syntax.code("dirname($_SERVER['SCRIPT_FILENAME'])");
		///opt/src/crm-2.0/server/src/S.hx
		if(Lib.isCli()){
			//Cli.process(Sys.args(), new CliService()).handle(Cli.exit);
			trace(Sys.args());
		}		
		Syntax.code('require_once({0})', '$home/../.crm/functions.php');
		Syntax.code('require_once({0})', '$home/../.crm/db.php');
		//Syntax.code("file_put_contents($appLog,'.', FILE_APPEND)");
		//Syntax.code('require_once({0})', 'inc/PhpRbac/Rbac.php');
		Debug.logFile = Syntax.code("$appLog");
		haxe.Log.trace = Debug._trace;
		Out.skipFields = ['admin','keyPhrase','pass','password'];
		//edump(Debug.logFile);
		
		db = Syntax.code("$DB");
		dbSchema = Syntax.code("$DB_schema");
		dbHost = Syntax.code("$DB_server");
		dbUser = Syntax.code("$DB_user");
		dbPass = Syntax.code("$DB_pass");		
		dbViciBoxUser = Syntax.code("$DB_vicibox_user");
		dbViciBoxCRM = Syntax.code("$DB_vicibox_crm");
		dbViciBoxDB = Syntax.code("$DB_vicibox_db");
		dbViciBoxHost = Syntax.code("$DB_vicibox_server");
		dbViciBoxPass = Syntax.code("$DB_vicibox_pass");
		host = Global.gethostname();
		//request_scheme = Syntax.code("$_SERVER['REQUEST_SCHEME']");
		trace('run on branch:$branch @ $db');
		secret = Syntax.code("$secret");
		//edump(Syntax.code("$conf"));
		conf =  Config.load('$home/appData.js');
		var ini:NativeArray = Syntax.code("$ini");
		conf.set('ini', ini);		
		safeLog(conf.get('ini'));
		new DbData();
		new DbUser(null);
		new DbRelation(null);
		new DbQuery();
	}
}