package model.admin;

import sys.FileSystem;
import sys.io.FileOutput;
import shared.DbData;
import haxe.macro.Type.Ref;
import haxe.ds.Map;
import php.db.Mysqli;
import haxe.Http;
import haxe.Json;
import php.db.PDO;
import haxe.ds.StringMap;
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
class SyncExternalClients extends Model 
{
	public static function create(param:StringMap<String>):Void
	{
		var self:SyncExternalClients = new SyncExternalClients(param);	
		//self.table = 'columns';
        trace('calling ${param.get("action")}');
		Reflect.callMethod(self, Reflect.field(self,param.get('action')), [param]);
	}	

    public function importClientDetails(?user:Dynamic):Void
    {
        var info:Map<String,Dynamic>  = getViciDialData();
        trace(info);
        var data:String = Syntax.code("exec({0})", 
            'curl -d "user=${info['admin']}&pass=${info['pass']}" ${info['syncApi']+"/exportClients.php"}');
        /*return;
        var req:Http = new Http(info['syncApi']);
        trace(info['syncApi']);
        req.addParameter('pass', info['pass']);
        req.addParameter('user', info['admin']);
        req.addParameter('action', info['exportClients']);
        req.onData = function(data:String)
        {*/
            //S.saveLog(data);
        trace(data.substr(0,80));
        var out:FileOutput = sys.io.File.write('../.crm/sync.csv');
        trace(out);
        dbData.dataInfo = ['sync.csv'=>FileSystem.stat('../.crm/sync.csv').size];
        S.sendData(dbData, null);
        trace('nono');
        return;
            //var dRows:Array<Map<String, Dynamic>> = cast Json.parse(data).contacts;
            var dRows:Array<Array<Dynamic>> = cast Json.parse(data).contacts;
            //var dRows:Array<Map<String, Dynamic>> = [['test'=>"hallo welt"]];
            trace(dRows.length);
            trace(dRows[0].length);
            dbData.dataRows = [];
            var fNames:Array<String> = cast dRows.shift();
            trace(fNames);
            var i:Int = 100;
            for(r in dRows)
            {
                dbData.dataRows.push(
                    [
                        for(n in fNames)
                        n => r.shift()
                    ]
                );
                if(i--<0)
                {
                    break;
                }
            }
            S.sendData(dbData, null);
        /*};
        req.onError = function (msg:String)
        {
            trace(msg);
        }
        req.onStatus = function (s:Int)
        { trace(s);}
        req.request(true);*/
        trace('done');
    }

    function saveClientDetails():DbData
    {
        var updated:Int = 0;
        //dbData = new DbData();
        var stmt:PDOStatement = null;
        trace(dbData.dataRows[dbData.dataRows.length-2]);
        for(dR in dbData.dataRows)
        {
            var external_text = row2jsonb(Lib.objectOfAssociativeArray(Lib.associativeArrayOfHash(dR)));
            var sql = comment(unindent, format) /*
            UPDATE crm.users SET active='${dR['active']}',edited_by=101, external = jsonb_object('{$external_text}')::jsonb WHERE user_name='${dR['user']}'
            */;
            
            var q:EitherType<PDOStatement,Bool> = S.dbh.query(sql);
            if(!q)
            {
               dbData.dataErrors = ['${param.get('action')}' => S.dbh.errorInfo()];
               return dbData;
            } 
        }        
        dbData.dataInfo = ['saveClientDetails' => 'OK', 'updatedRows' => updated];
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
	}

}