package model.data;

import shared.DbData;
import haxe.macro.Type.Ref;
import haxe.ds.Map;
import php.db.Mysqli;
import haxe.Http;
import haxe.Json;
import php.db.PDO;

import haxe.extern.EitherType;
import php.Lib;
import php.NativeArray;
import me.cunity.php.db.*;
import php.Syntax;
import php.db.PDOStatement;
import sys.db.*;
import comments.CommentString.*;
using Lambda;
using Util;

/**
 * ...
 * @author axel@bi4.me
 */

@:keep
class SyncExternal extends Model 
{
	public static function _create(param:Map<String,String>):Void
	{
		var self:SyncExternal = new SyncExternal(param);	
		//self.table = 'columns';
        trace('calling ${param.get("action")}');
		Reflect.callMethod(self, Reflect.field(self,param.get("action")), [param]);
	}	

	public function accountsCount() {
		var stmt:PDOStatement = S.syncDbh.query('SELECT COUNT(*) FROM pay_source');
		S.checkStmt(S.syncDbh, stmt, 'pay_sourceCount query:'+Std.string(S.syncDbh.errorInfo()));			
		dbData.dataInfo.set('pay_sourceCount',(stmt.execute()?stmt.fetch(PDO.FETCH_COLUMN):null));
		stmt = S.dbh.query('SELECT COUNT(*) FROM accounts');
		S.checkStmt(S.dbh, stmt, 'get accounts count query:'+Std.string(S.dbh.errorInfo()));
		dbData.dataInfo.set('accountsCount',(stmt.execute()?stmt.fetch(PDO.FETCH_COLUMN):null));
		S.sendInfo(dbData);	
	}

	public function bookingRequestsCount() {
		var stmt:PDOStatement = S.syncDbh.query('SELECT COUNT(*) FROM buchungs_anforderungen');
		S.checkStmt(S.syncDbh, stmt, 'buchungsAnforderungenCount:'+Std.string(S.syncDbh.errorInfo()));
		dbData.dataInfo.set('buchungsAnforderungenCount',(stmt.execute()?stmt.fetch(PDO.FETCH_COLUMN):null));
		stmt = S.dbh.query('SELECT COUNT(*) FROM booking_requests');
		S.checkStmt(S.dbh, stmt, 'booking_requests count:'+Std.string(S.dbh.errorInfo()));
		dbData.dataInfo.set('bookingRequestsCount',(stmt.execute()?stmt.fetch(PDO.FETCH_COLUMN):null));
		S.sendInfo(dbData);			
	}

	public function clientsCount() {
		var stmt:PDOStatement = S.syncDbh.query('SELECT COUNT(*) FROM clients');
		S.checkStmt(S.syncDbh, stmt, 'clientsCount query:'+Std.string(S.syncDbh.errorInfo()));			
		dbData.dataInfo.set('clientsCount',(stmt.execute()?stmt.fetch(PDO.FETCH_COLUMN):null));
		stmt = S.dbh.query('SELECT COUNT(*) FROM contacts WHERE id>9999999');
		S.checkStmt(S.dbh, stmt, 'get contacts count query:'+Std.string(S.dbh.errorInfo()));
		dbData.dataInfo.set('contactsCount',(stmt.execute()?stmt.fetch(PDO.FETCH_COLUMN):null));
		S.sendInfo(dbData);	
	}

	public function dealsCount() {
		var stmt:PDOStatement = S.syncDbh.query('SELECT COUNT(*) FROM pay_plan');
		S.checkStmt(S.syncDbh, stmt, 'getExtIds count query:'+Std.string(S.syncDbh.errorInfo()));			
		dbData.dataInfo.set('pay_planCount',(stmt.execute()?stmt.fetch(PDO.FETCH_COLUMN):null));
		stmt = S.dbh.query('SELECT COUNT(*) FROM deals');
		S.checkStmt(S.dbh, stmt, 'get deals count query:'+Std.string(S.dbh.errorInfo()));
		dbData.dataInfo.set('dealsCount',(stmt.execute()?stmt.fetch(PDO.FETCH_COLUMN):null));
		S.sendInfo(dbData);	
	}
    /*public function syncContactDetails(?contact:Dynamic):Void
    {
        var info:Map<String,Dynamic>  = getViciDialData();
        //var req:Http = new Http(info['syncApi']);
        //var req:Http = new Http('https://pitverwaltung.de/test/php/test.php');
        trace(info['syncApi']);
        //trace(info);
        var user:String = info['admin'];
        var pass:String = info['pass'];
        var url:String = info['syncApi']+'/syncContacts.php';
        var data:String = Syntax.code("exec({0})", 'curl -d "user=${user}&pass=${pass}" ${url}');
        //var data:String = untyped __call__('exec','curl -d "user=${user}&pass=${pass}" ${url}');
        trace(data);
            //S.saveLog(data);
            var dRows:Array<Dynamic> = Json.parse(data);
            trace(dRows.length);
            //trace(dRows[dRows.length-2]);
            trace(data.indexOf('phone_data'));
            //dbData.dataRows = [['length'=>dRows.length]];
            dbData.dataRows = [];
            var fNames:Array<String> = Reflect.fields(dRows[0]);
            if(!fNames.has('phone_data'))
                fNames.push('phone_data');
            trace(fNames.has('phone_data'));
            for(r in dRows)
            {
                dbData.dataRows.push(
                    [
                        for(n in fNames)
                        n => Reflect.field(r,n)
                    ]
                );
            }
            S.sendData(saveContactDetails(), null);
      };
        req.onError = function (msg:String)
        {
            trace(msg);
        }
        req.onStatus = function (s:Int)
        { trace(s);}
        req.request(true);
        trace('done');
    }*/

    function saveContactDetails():DbData
    {
        var updated:Int = 0;
        //dbData = new DbData();
        var stmt:PDOStatement = null;
        trace(dbData.dataRows[dbData.dataRows.length-2]);
        for(dR in dbData.dataRows)
        {
           /* var sql:String = 'SELECT external FROM users WHERE user_name = \'${dR['user']}\'';
            var q:EitherType<PDOStatement,Bool> = S.dbh.query(sql);
            if(!q)
            {
                dbData.dataErrors = ['${action}' => S.dbh.errorInfo()];
                return dbData;
            }
            var eStmt:PDOStatement = cast(q, PDOStatement);

            var external:NativeArray = eStmt.fetch();
            trace(sql);
            //trace(Type.typeof(external));

            if(1 == updated++)
            trace(external);*/
            var external_text = row2jsonb(Lib.objectOfAssociativeArray(Lib.associativeArrayOfHash(dR)));
            var sql = comment(unindent, format) /*
            UPDATE crm.users SET active='${dR['active']}',edited_by=${S.dbQuery.dbUser.id}, external = jsonb_object('{$external_text}')::jsonb WHERE user_name='${dR['user']}'
            */;
            
            var q:EitherType<PDOStatement,Bool> = S.dbh.query(sql);
            if(!q)
            {
               dbData.dataErrors = ['${action}' => Std.string(S.dbh.errorInfo())];
               return dbData;
            } 
        }        
        dbData.dataInfo = ['saveContactDetails' => 'OK', 'updatedRows' => updated];
        trace(dbData.dataInfo);
		return dbData; 
    }

/*    public function getViciDialData():Map<String,Dynamic> 
	{		        
        S.saveLog(S.conf.get('ini'));
        var ini:NativeArray = S.conf.get('ini');
        ini = ini['vicidial'];
        var fields:Array<String> = Reflect.fields(Lib.objectOfAssociativeArray(ini));
        var info:Map<String,Dynamic> = [
            for(f in fields)
            f => ini[f]
        ];
        //S.saveLog(info);
        return info;
		S.sendInfo(dbData, info);
	}*/

}