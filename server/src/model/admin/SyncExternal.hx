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
	var sEC:SyncExternalClients;

	public function new(param:Map<String,String>):Void
	{
		super(param);	
		//self.table = 'columns';
        //trace('calling ${action}');
		//trace(action);
		//SWITCH Call either an instance method directly or use the shared Model query execution
		switch(action ){
			case 'syncAll':
				syncAll();
			case _:
				run();
		}		
	}

	/**
	 * Import or Update crm clients, deals + accounts
	 */

	function syncAll() {
		trace(param);
		sEC = new SyncExternalClients(param);
		S.sendErrors(dbData,['syncAll'=>'OK']);
	}

    public function syncUserDetails(?user:Dynamic):Void
    {
		var res:NativeArray = fetchAll('SELECT user, full_name, active FROM asterisk.vicidial_users 
		WHERE CAST(user AS UNSIGNED)>0 AND active="Y"',S.syncDbh,'syncUserDetails',3);
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

    function saveUserDetails():DbData
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
            UPDATE crm.users SET active='${dR['active']}',edited_by=101, external = jsonb_object('{$external_text}')::jsonb WHERE user_name='${dR['user']}'
            */;
            
            var q:EitherType<PDOStatement,Bool> = S.dbh.query(sql);
            if(!q)
            {
               dbData.dataErrors = ['${action}' => Std.string(S.dbh.errorInfo())];
               return dbData;
            } 
        }        
        dbData.dataInfo = dbData.dataInfo.copyStringMap(
			['saveUserDetails' => 'OK', 'updatedRows' => Std.string(updated)]);
        trace(dbData.dataInfo);
		return dbData; 
    }

    public function getViciDialData():Map<String,Dynamic> 
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
	}

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
				SET contact=contacts.id, active=true
				FROM contacts
				WHERE first_name='${first_name}' AND last_name='${last_name}'
				AND "users"."mandator"="contacts"."mandator" and user_name='$user';
			**/
			);
			updated += updateRows(
				comment(unindent,format)/**
				UPDATE users 
				SET contact=contacts.id, active=true
				FROM contacts
				WHERE first_name='${first_name}' AND last_name='${last_name}'
				AND "users"."mandator"="contacts"."mandator" and user_name='$user';
			**/,S.dbh);
		}
		return updated;	
	}

}