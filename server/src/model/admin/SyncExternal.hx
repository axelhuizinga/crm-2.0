package model.admin;

import php.NativeAssocArray;
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


class SyncExternal extends Model 
{
	var sEC:SyncExternalContacts;

	public function new(param:Map<String,Dynamic>):Void
	{
		super(param);	
		//self.table = 'columns';
        //trace('calling ${action}');
		trace(action);
		//SWITCH Call either an instance method directly or use the shared Model query execution
		switch(action ){
			case 'checkAll':
				checkAll();			
			case 'syncAll':
				syncAll();
			case _:
				run();
		}		
	}

	function checkAll() {
		trace(param);
		param.set('action','getMissing');
		sEC = new SyncExternalContacts(param);
		S.sendErrors(dbData,['syncAll'=>'OK']);
	}

	/**
	 * Import or Update crm clients, deals + accounts
	 */

	function syncAll() {
		trace(param);
		//param.set('action','getMissing');
		sEC = new SyncExternalContacts(param);
		S.sendErrors(dbData,['syncAll'=>'OK']);
	}

	public function syncBankTransferRequests():Void
    {
		var res:NativeArray = fetchAll('SELECT * FROM `buchungs_anforderungen`',S.syncDbh,'syncBankTransferRequests',PDO.FETCH_NUM);
		trace(res);
		if(res != null)
		{
			//sendRows(res);
			var updated:Int = syncUserIds(res);
			S.sendInfo(dbData,['syncUserDetail'=>'DONE $updated']);
		}
			
		else 
			S.sendInfo(dbData,['syncUserDetail'=>'no results???']);
		trace('done');
    }

    public function syncUserDetails():Void
    {
		var res:NativeArray = fetchAll("SELECT user, full_name, active FROM asterisk.vicidial_users 
		WHERE CAST(user AS UNSIGNED)>0 AND active='Y'",S.syncDbh,'syncUserDetails',PDO.FETCH_BOTH);
		trace(res);
		if(res != null)
		{
			//sendRows(res);
			var updated:Int = syncUserIds(res);
			S.sendInfo(dbData,['updated'=>updated]);
		}			
		else 
			S.sendInfo(dbData,['syncUserDetail'=>'no results???']);
		trace('done');
    }

    function saveUserDetails():DbData
    {
        var updated:Int = 0;
        var stmt:PDOStatement = null;
        trace(dbData.dataRows[dbData.dataRows.length-2]);
        for(dR in dbData.dataRows)
        {
            var external_text = row2jsonb(Lib.objectOfAssociativeArray(Lib.associativeArrayOfHash(dR)));
            var sql = comment(unindent, format) /*
            UPDATE crm.users SET active=${dR['active']='Y'},edited_by=${S.dbQuery.dbUser.id}, external = jsonb_object('{$external_text}')::jsonb WHERE user_name='${dR['user']}'
            */;
            trace(sql);
            var q:EitherType<PDOStatement,Bool> = S.dbh.query(sql);
            if(!q)
            {
               dbData.dataErrors = ['${action}' => Std.string(S.dbh.errorInfo())];
               return dbData;
			} 
			updated++;
        }        
        dbData.dataInfo = dbData.dataInfo.copyStringMap(
			['saveUserDetails' => 'OK', 'updatedRows' => Std.string(updated)]);
        trace(dbData.dataInfo);
		return dbData; 
    }

    /*public function getViciDialData():Map<String,Dynamic> 
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

	function syncUserIds(vdUsers:NativeArray):Int 
	{
		var updated:Int = 0;
		//var nrow:NativeArray;
		for(nrow in vdUsers.iterator())
		//user, full_name, active
		{
			//var name:Array<String> = Syntax.code("{0}['full_name']", row).split(' ');	
			var row:Array<Dynamic> = Lib.toHaxeArray(nrow);
			//trace(row);
			var name:Array<String> = row[1].split(' ');			
			var last_name = (name.length==3?name[1]:name.pop());
			var first_name = (name.length>0?name.shift():'');
			var user = row[0];
			trace(
				comment(unindent,format)/**
				UPDATE users 
				SET active=${nrow[2]=='Y'}
				FROM contacts
				WHERE contact=contacts.id;
			**/
			);
			updated += updateRows(
				comment(unindent,format)/**
				UPDATE users 
				SET active=${nrow[2]=='Y'}
				FROM contacts
				WHERE contact=contacts.id;
			**/,S.dbh);
		}
		return updated;	
	}

	public static function  getMissing(dbData:DbData):String {
		var sql:String = '
		SELECT DISTINCT(cl.client_id) FROM clients cl 
INNER JOIN pay_plan pp 
ON pp.client_id=cl.client_id 
INNER JOIN pay_source ps 
ON ps.client_id = cl.client_id;';
        var stmt:PDOStatement = S.syncDbh.query(sql);
		if(untyped stmt==false)
		{
			trace(S.syncDbh.errorInfo());
			S.sendErrors(dbData, ['getAll query:'=>S.syncDbh.errorInfo()]);
		}
		if(stmt.errorCode() !='00000')
		{
			trace(stmt.errorInfo());
		}
		var res:NativeArray = (stmt.execute()?stmt.fetchAll(PDO.FETCH_NUM):null);	
		
		trace(Syntax.code("count({0})",res));
				
		var cleared:Int = S.dbh.exec('CREATE TEMP TABLE contact_ids(id BIGINT)');
		if(S.dbh.errorCode() !='00000')
		{
			trace(S.dbh.errorInfo());
		}
		else 	
			trace('created temp table contact_ids');
		var cIDs:NativeArray = Syntax.code("array_map(function($r){return $r[0];}, {0})",res);
		trace(Syntax.code("print_r({0}[0],1)", cIDs));
		var ok:Bool = S.dbh.pgsqlCopyFromArray("contact_ids",cIDs);
		if(!ok)
		{
			trace(S.dbh.errorInfo());
		}
		if(S.dbh.errorCode() !='00000')
		{
			trace(S.dbh.errorInfo());
		}
		sql = comment(unindent, format)/* 
		SELECT ARRAY_TO_STRING(array_agg(acid.id),',') from contact_ids acid
		left join 
		(SELECT 1 as gg,id from contacts) c
		ON acid.id=c.id
		where c.id IS NULL
		GROUP BY gg;
		*/;
		stmt = S.dbh.query(sql);
		if(untyped stmt==false)
		{
			trace('$sql ${Std.parseInt(S.dbQuery.dbParams['limit'])}');
			S.sendErrors(dbData, ['getMissingIDs query:'=>S.syncDbh.errorInfo()]);
		}
		if(stmt.errorCode() !='00000')
		{
			trace(stmt.errorInfo());
		}
		var ids:String = (stmt.execute()?stmt.fetch(PDO.FETCH_COLUMN,0):null);
		trace(ids);
		return ids;
	}


}