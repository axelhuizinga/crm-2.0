package;
import haxe.Unserializer;
import hxbit.Serializer;
import shared.Utils;
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

import model.admin.CreateHistoryTrigger;
import model.admin.CreateUsers;
import model.data.Accounts;
import model.data.Booking;
import model.data.Contacts;
import model.data.Deals;
import model.data.DebitReturnStatements;
import model.data.DirectDebits;
import model.data.SyncExternal;
import model.admin.SyncExternalAccounts;
import model.admin.SyncExternalBookings;
import model.admin.SyncExternalContacts;
import model.admin.SyncExternalDeals;
import model.admin.SyncExternalDebitReturnBookings;
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
import sys.io.File;

//import json2object.JsonParser;
//import json2object.JsonWriter;
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
	public static var viciBoxDbh:PDO;
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
	public static var _SERVER:Map<String,Dynamic>;
	public static var vicidialUser:String;
	public static var viciDial: Map<String, Dynamic>;
	static var ts:Float;
	
	static function main() 
	{		
		init();
		ts = Sys.time();
		last_request_time = Date.fromTime(ts/1000);
		var now:String = DateTools.format(Date.now(), "%d.%m.%y %H:%M:%S - %s");		
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
		//trace(SuperGlobal._SERVER['REQUEST_METHOD']);
		//devIP = SuperGlobal._POST['devIP'];//Syntax.code("$sysadmin")
		response = {content:'',error:''};
		if(Lib.isCli()){
			trace(Sys.args());
			params = Cli.parse();
			action = params.get('action');		
			trace(params);
			//var dbUser:DbUser = new DbUser(				
				var dbUser = untyped  {dummy:1};			
				//var dbUser:DbUser = null;			
			//	{jwt:'jwt',id:100,online:true, password:'sysadmin', user_name:'sysadmin'});
				//{jwt:params['jwt'],id:params['id'],online:true, password:params['password'], user_name:params['user_name']});
			//trace('dbUser');
			//Sys.exit(0);
			var dbAccProps:DBAccessProps = {action:action, data:{REMOTE_ADDR:params['REMOTE_ADDR']}, dbUser: dbUser};
			for(k=>v in params.keyValueIterator())
			{
				Reflect.setField(dbAccProps, k, v);
			}
			dbQuery = new DbQuery(dbAccProps);
			trace(dbQuery.dbUser);
		}
		else{
			dbQuery = Model.binary();
			params = dbQuery.dbParams;
			trace(dbQuery.dbParams.get('classPath'));
			trace(params);
			if(params['dataSource']!=null){
				trace(Type.typeof(params['dataSource']));
			}
			//trace(dbQuery.dbRelations);
			trace(Util.rels2string(dbQuery.dbRelations));
			S.devIP = params['devIP'];
			//if(dbQuery!=null)trace(dbQuery.dbUser);
			var ipost = Lib.hashOfAssociativeArray(SuperGlobal._POST);
			//trace(ipost.get('id') +':'+ipost.get('jwt'));
			//trace(ipost.keys());
			//trace(Global.print_r(SuperGlobal._POST,true));
			if(Lib.toHaxeArray(SuperGlobal._FILES).length>0&&Global.isset(SuperGlobal._POST['id'])&&
				User.verify(SuperGlobal._POST['jwt'], Std.parseInt(SuperGlobal._POST['id'])))
			{
				dbh = new PDO('pgsql:dbname=$db;client_encoding=UTF8',dbUser,dbPass,
				Syntax.array([PDO.ATTR_PERSISTENT,true]));
			
				//trace(dbh);
				//params = Lib.hashOfAssociativeArray(SuperGlobal._POST);
				//trace(params);
				action = params.get('action');		
				if(params.get('extDB'))
				{
					//CONNECT DIALER CRM DB	
					//trace('mysql:host=$dbViciBoxHost;dbname=$dbViciBoxCRM');
					syncDbh = new PDO('mysql:host=$dbViciBoxHost;dbname=$dbViciBoxCRM',
						dbViciBoxUser,dbViciBoxPass,Syntax.array([PDO.ATTR_PERSISTENT,true]));
					//trace(syncDbh.getAttribute(PDO.ATTR_PERSISTENT)); 
				}

				#if debug
				dbh.setAttribute(PDO.ATTR_ERRMODE, PDO.ERRMODE_EXCEPTION);	
				params.set('debug',true);
				if(params.get('extDB'))
					syncDbh.setAttribute(PDO.ATTR_ERRMODE, PDO.ERRMODE_EXCEPTION);
				#end	
				devIP = params.get('devIP');	
				//trace(S.devIP + ':' + devIP);
				Upload.go();
			}

			if(dbQuery==null)
				send("dev end");
			devIP = params.get('devIP');
			//trace([for(k in params.keys())k].map(function (v) return '\'$v\'').join('|'));
			if(params==null)
				params = dbQuery.dbParams;
			params.set('mandator',dbQuery.dbUser.mandator);
			user_id = dbQuery.dbUser.id;
			trace(params.get('classPath') + ':' + params.get('action'));
			if(Lib.isCli())
				safeLog(params);
			/*else 
				safeLog(dbQuery);*/
			//devIP = params.get('devIP');
			//trace(params);
		}
		action = params.get('action');

		devIP = params.get('devIP');
		if (params.get('action') == null || params.get('classPath') == null)
		{
			try{
				trace(params);
			}
			catch(ex:Exception){
				trace(ex.message);
				trace(Type.typeof(params));
			}
			
			exit( { error:"required params action and/or classPath missing" } );
		}
			//host=$dbHost;
		dbh = new PDO('pgsql:dbname=$db;client_encoding=UTF8',dbUser,dbPass,
			Syntax.array([PDO.ATTR_PERSISTENT,true]));			
		
		if(params.get('viciBoxDB')){
			//CONNECT DIALER DB	
			//trace('$dbViciBoxUser mysql:host=$dbViciBoxHost;dbname=$dbViciBoxDB');					
			viciBoxDbh = new PDO('mysql:host=$dbViciBoxHost;dbname=$dbViciBoxDB',
				dbViciBoxUser,dbViciBoxPass,Syntax.array([PDO.ATTR_PERSISTENT,true]));
			//trace(viciBoxDbh.getAttribute(PDO.ATTR_PERSISTENT));
		}		
		//trace(dbh);!=null
		//trace('$devIP connect2syncDB:'+ (params.get('extDB')||params.get('action').indexOf('sync')==0?'Y':'N'));
		//trace('$devIP connect2viciBoxDB:'+ (params.get('viciBoxDB')?'Y':'N'));
		if(params.get('extDB')||params.get('action').indexOf('sync')==0)
		{
			//CONNECT dialer crm DB	
			//trace('mysql:host=$dbViciBoxHost;dbname=$dbViciBoxCRM');
			syncDbh = new PDO('mysql:host=$dbViciBoxHost;dbname=$dbViciBoxCRM',
				dbViciBoxUser,dbViciBoxPass,Syntax.array([PDO.ATTR_PERSISTENT,true]));
			trace(syncDbh.getAttribute(PDO.ATTR_PERSISTENT)); 
		}
		
		if(action=='login'){
			params.set('user_name', dbQuery.dbUser.user_name);
			saveRequest(params,true);
		}
		else{		
			#if debug
			dbh.setAttribute(PDO.ATTR_ERRMODE, PDO.ERRMODE_EXCEPTION);
			if(params.get('extDB'))
				syncDbh.setAttribute(PDO.ATTR_ERRMODE, PDO.ERRMODE_EXCEPTION);
			saveRequest(dbQuery,Lib.isCli());
			#else 
			saveRequest(dbQuery,(params.exist('saveReq')?false:Lib.isCli()));
			#end
		}
		if(Lib.isCli()){
			Model.dispatch(dbQuery);
		}
		if(action == 'resetPassword')
		{
			User.resetPassword(params);
			exit(response);
		}

		var jwt:String = (dbQuery.dbUser!=null?dbQuery.dbUser.jwt:'');
		var id:Int = params.get('id');
		if(dbQuery.dbUser!=null){
			jwt = dbQuery.dbUser.jwt;
			id = dbQuery.dbUser.id;
		}
		else {
			jwt = params.get('jwt');
			id = params.get('id');
		}
	
		if(jwt != null)
			trace('$action::jwt.length:' +jwt.length);
		if (jwt.length > 0)
		{
			if(User.verify(jwt, id))
			{
				// DISPATCH
				if(action=='returnDebitFile')
				{
					Upload.go();
					exit({'Error':'Upload.go()$action did not send anything'});
				}
				/*if(action=='verify'){
					User.verify();
				}*/
				if(params['classPath'] == 'data.Deals'){
					new Deals(cast dbQuery.dbParams).go();
				}
				else {
					Model.dispatch(dbQuery);		

				}
				exit({'Error':'Model.dispatch ${params.get('classPath')}.$action did not send anything'});
			}

		}	
		if(dbQuery.dbUser!=null)
		User.login(dbQuery.dbUser);		
		//trace(response);
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
			//trace(Json.stringify(r));
			//trace( Syntax.code("json_encode({0})",r));
			//Sys.print(Syntax.code("json_encode({0})",r));
			Sys.print(Json.stringify(r));			
		}
		trace('req ${params.get('classPath')}.${params.get('action')} done at ${Sys.time()-ts} ms');
		trace(r);
		Out.dumpStack(CallStack.callStack());
		Sys.exit(untyped Std.string(r));		
	}
	
	public static function send(r:String, ?json:Bool = false):Bool
	{
		if (!headerSent && !Lib.isCli())
		{
			Web.setHeader('Content-Type', (json?'application/json':'text/plain'));		
			//Web.setHeader('Content-Type', cType);
			Web.setHeader("Access-Control-Allow-Headers", "access-control-allow-headers, access-control-allow-methods, access-control-allow-origin");
			Web.setHeader("Access-Control-Allow-Credentials", "true");
			if(S.devIP!=null&&S.devIP!=''){
				Web.setHeader("Access-Control-Allow-Origin", 'https://${S.devIP}:9000');	
				trace('Access-Control-Allow-Origin => https://${S.devIP}:9000');
			}
			else {
				//trace('no devIP? ${S.devIP}<<<');
			}	
		}			
		Sys.print(r);
		trace('client req ${params.get('classPath')}.${params.get('action')} from ${params.get('devIP')} done at ${Sys.time()-ts} ms');
		Sys.exit(0);
		return true;
	}
	
	public static function sendData(dbData:DbData, ?data:RData):Bool
	{
		//var w = new JsonWriter<DbData>();//hxbit.Serializer
		var s:Serializer = new Serializer();
		//trace(data.info);
		if(data != null){
			dbData.dataInfo = dbData.dataInfo.copyStringMap(data.info);
			if(data.rows!=null)
				for(row in data.rows.iterator())
					dbData.dataRows.push(Lib.hashOfAssociativeArray(row));		
		}
		
		trace(dbData.dataInfo.toString());
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
		//var s:Serializer = new Serializer();
		//var writer = new json2object.JsonWriter<DbData>();
		if (err != null)
		{
			for (k in err.keys())
			{
				dbData.dataErrors[k] = err[k];
			}
		}
		trace(dbData.dataErrors);
		var s:Serializer = new Serializer();
		return sendbytes(s.serialize(dbData));
		//return send(Serializer.run(dbData));
		//return send(writer.write(dbData));
	}
	
	public static function sendInfo(dbData:DbData, ?info:Map<String,Dynamic>):Bool
	{
		var s:Serializer = new Serializer();
		//var writer = new json2object.JsonWriter<DbData>();
		if (info != null)
		{
			for (k => v in info)
			{
				dbData.dataInfo[k] = v;
			}
		}
		//trace('done at ${Sys.time()-ts} ms');
		//trace(dbData.dataInfo);
		trace(dbData);
		//trace(dbData.dataErrors);
		return sendbytes(s.serialize(dbData));
		//return send(writer.write(dbData));
		//return send(Serializer.run(dbData));
	}
	
	public static function sendbytes(b:Bytes, ?loop:Bool):Bool
	{		
		trace('OK ${b.length}');
		//trace(new Serializer().unserialize(b, DbData));
		if(Lib.isCli())
			return false;		
		
		setHeader('application/octet-stream');		

		var out = File.write("php://output", true);
		out.bigEndian = true;
		out.write(b);
		trace('req ${params.get('classPath')}.${params.get('action')} done at ${Sys.time()-ts} ms');
		Sys.exit(0);
		return true;
	}
	
	public static function setHeader(cType:String) 
	{
		if(Lib.isCli())
			return;
		Web.setHeader('Content-Type', cType);

		if(S.devIP!=null&&S.devIP!=''){
		Web.setHeader("Access-Control-Allow-Headers", "access-control-allow-headers, access-control-allow-methods, access-control-allow-origin");
		Web.setHeader("Access-Control-Allow-Credentials", "true");			
		Web.setHeader("Access-Control-Allow-Origin", 'https://${S.devIP}:9000');	
			trace('https://${S.devIP}:9000');
		}
		else {
			//Web.setHeader("Access-Control-Allow-Origin", '*');
			//Out.dumpStack(CallStack.callStack());
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
		// TODO: ADD Const.FILE_APPEND  2 haxe.git
		//trace(pos);
		Util.safeLog(what,false,pos);
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
		//trace(Json.stringify(req));
		trace(logOnly);
		if(logOnly){
			Util.safeLog(Json.stringify(req));
			return true;			
		}

		var stmt:PDOStatement = dbh.prepare(
			'INSERT INTO activity(action,request,"user") VALUES(:action,:request,:user)' ,Syntax.array(null));

		var success:Bool = Model.paramExecute(stmt, 
			Lib.associativeArrayOfObject(
				{':action':params.get('classPath') + '.' + params.get('action'),
				':user': (Lib.isCli()?'100':req.dbUser.id), ':request': Json.stringify(req, function(key:Dynamic, value:Dynamic) {
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
	
	static function init() {		
		var branch:String = #if dev 'dev' #else 'crm' #end;
		_SERVER = Lib.hashOfAssociativeArray(SuperGlobal._SERVER);
		//Lib.print(home+"\r\n");
		home = haxe.io.Path.directory(_SERVER['SCRIPT_FILENAME']);
		//home = Syntax.code("dirname($_SERVER['SCRIPT_FILENAME'])");
		Global.require_once('$home/../.crm/functions.php');
		Global.require_once('$home/../.crm/db.php');	
		Syntax.code("error_log({0})","appLog:" + Syntax.code("$appLog"));
		Debug.logFile = Syntax.code("$appLog");
		//trace('appLog:${Debug.logFile}');
		haxe.Log.trace = Debug._trace;		
		if(Lib.isCli()){
			//Cli.process(Sys.args(), new CliService()).handle(Cli.exit);
			trace('helloworld :)');
			Lib.print(Syntax.code("$appLog")  + "\r\n");//();
			trace(Global.ini_get('error_log'));
			trace(Sys.args());
		}		
		else{
			//haxe.Log.trace = Debug._trace;
			Out.skipFields = ['admin','keyPhrase','pass','password'];			
		}
		trace('Loaded config@${home}');
		//Syntax.code("file_put_contents($appLog,'.', FILE_APPEND)");
		//Syntax.code('require_once({0})', 'inc/PhpRbac/Rbac.php');

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
		trace('run on branch:$branch @ $db Debug.logFile:${Debug.logFile}');
		secret = Syntax.code("$secret");
		//edump(Syntax.code("$conf"));
		conf =  Config.load('$home/appData.js');
		var ini:NativeArray = Syntax.code("$ini");		
		//trace(ini);	
		var hIni:Map<String,Dynamic> = Lib.hashOfAssociativeArray(ini);
		//trace(conf);	
		conf.set('ini', ini);	
		trace(Type.typeof(conf.get('ini')) + ':' + conf.exists('ini') + ':' + Reflect.fields(conf.get('ini')));	
		safeLog({vicidial:hIni.get('vicidial')});
		//
		new DbData();
		new DbUser(null);
		new DbRelation({});
		new DbQuery();
	}
}