package model.admin;

import sys.io.File;
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
        //trace(info);
        var data:String = Syntax.code("exec({0})", 
            'curl -X POST -o "../.crm/sync.csv" -d "user=${info['admin']}&pass=${info['pass']}" ${info['syncApi']+"/exportClients.php"}');
        
        dbData.dataInfo = ['sync.csv.size'=>FileSystem.stat('../.crm/sync.csv').size];
        if(data.indexOf('Error') == 0)
        {
            dbData.dataErrors['importClientDetails.import'] = data;
        }
        else 
        {
            if(processImport('../.crm/sync.csv'))
            {
                dbData.dataInfo['sync.csv.complete'] = true;
            };
        }
        S.sendData(dbData, null);
        trace('nono');
        return;
            //var dRows:Array<Map<String, Dynamic>> = cast Json.parse(data).contacts;
            var dRows:Array<Array<Dynamic>> = cast Json.parse(data).contacts;
            //var dRows:Array<Map<String, Dynamic>> = [['test'=>"hallo welt"]];
            trace(dRows.length);
            trace(dRows[0].length);
            dbData.dataRows = [];
            
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
	
    public function processImport(path:String):Bool
	{
		var fh:Dynamic = Syntax.code("fopen({0}, 'r')",path);
        var fInfo:String = Syntax.code("exec({0})", 'wc -L ${path}');
        var len:Int = Std.parseInt(fInfo.split(' ')[0]);
        if(!fh)
        {
            dbData.dataErrors['processImport.fopen'] = 'Datei ${path} konnte nicht geöffnet werden';
            return false;
        }
        var data:Dynamic = null;
        var row:NativeArray = null;
        var index:Int = 1;
        var fNames:Array<String> = null;
        while((row = Syntax.code("fgetcsv({0},{1},';')", fh, len)) != null)
        {
            data = Lib.toHaxeArray(row);
            trace(Type.typeof(data));
            if(fNames==null)
            {
                fNames = data;
                trace(Std.string(fNames));
                continue;
            }
            if(!processImportRow(fNames,data))
            {
                dbData.dataErrors['processImportRow.zeile'] = S.errorInfo(Std.string(index));
                break;
            }
            index++;
        }
        return true;
		//setState({dataTable:data.dataRows});
	}    

    function processImportRow(fNames:Array<String>,row:Array<Dynamic>):Bool
    {
        //trace(fNames.length + ':' + row.length);
        if(fNames.length != row.length)
        {
            dbData.dataErrors['processImportRow.fieldCount'] = S.errorInfo('Zeile hat '+ row.length + ' Werte:${Std.string(row)}');
            return false;
        }
        var dMap:StringMap<Dynamic> = [
            for(n in fNames)
            n => row.shift()
        ];

        return true;
    }

    function updateClient(cData:StringMap<Dynamic>):Bool
    {
        var cNames:String<Dynamic> = 'id,creation_date,state,use_email,
                phone_code,phone_number,first_name,last_name,edited_by'.split(',');
        var sql:String = comment(unindent, format) /*
			WITH new_contact AS (
				INSERT INTO crm.contacts (id,mandator,creation_date,state,use_email,
                phone_code,phone_number,first_name,last_name,edited_by)
				VALUES (1, '${contact.phone_number}', '${name[0]}', '${name[1]}', 100)
				ON CONFLICT (id) DO UPDATE
SET
				returning id)
				select id from new_contact;
			*/;
		trace(sql);
        return true;
    }/**
    client_id,lead_id,creation_date,state,use_email,register_on,register_off,register_off_to,teilnahme_beginn,title,anrede,namenszusatz,co_field,storno_grund,birth_date,old_active
    **/

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
               dbData.dataErrors['${param.get('action')}'] = S.dbh.errorInfo();
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