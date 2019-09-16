package model.admin;

import php.NativeAssocArray;
import haxe.macro.Expr.Catch;
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

class SyncExternalClients extends Model 
{
	public function new(param:Map<String,String>):Void
	{
		super(param);	
		//self.table = 'columns';
        trace('calling ${action}');
		trace(action);
		//SWITCH Call either an instance method directly or use the shared Model query execution
		switch(action ){
			case 'syncAll':
				syncAll();
			case _:
				run();
		}		
	}

	function syncAll() {
		trace(param);
		getCrmData();
		S.sendErrors(dbData,['syncAll'=>'OK']);
	}

    public function importClientDetails(?user:Dynamic):Void
    {
        var info:Map<String,Dynamic>  = getCrmData();
        trace(info);        
        S.sendData(dbData, null);
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
        var foo:Dynamic = null;
        while(/*{
            foo = (row = Syntax.code("fgetcsv({0},{1},';')", fh, len));
            foo != null && foo != false;
        }*/
        testValue(row = Syntax.code("fgetcsv({0},{1},';')", fh, len)))
        {
            try {
                data = Lib.toHaxeArray(row);
            }
            catch(ex:Dynamic)
            {
                trace(row == null?'true':'false');
                //trace(ex);
            }
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
        var dMap:Map<String,Dynamic> = [
            for(n in fNames)
            n => row.shift()
        ];

        return updateClient(dMap);
    }
    
    inline function testValue(v:Dynamic):Bool return cast v;
    //inline function testValue(v:Dynamic):Bool return cast v != null && v != false;

    function updateClient(cD:Map<String,Dynamic>):Bool
    {
        var cNames:Array<String> = S.tableFields('contacts');
        trace(cNames.join(','));
        var sql:String = comment(unindent, format) /*
			WITH new_contact AS (
				INSERT INTO crm.contacts (id,mandator,creation_date,state,use_email,
                phone_code,phone_number,first_name,last_name,edited_by)
				VALUES ('${cD["client_id"]}',1,'${cD["creation_date"]}', ,'${cD["state"]}'
                ,'${cD["use_email"]}','${cD["phone_code"]}','${cD["phone_number"]}'
                ,'${cD["creation_date"]}','${cD["creation_date"]}','${cD["creation_date"]}'
                ,'${cD["creation_date"]}','${cD["creation_date"]}','${cD["creation_date"]}'
                )
				ON CONFLICT (id) DO UPDATE
				SET returning id)
				select id from new_contact;
			*/;
		trace(sql);
        return true;
    }/**
    client_id,creation_date,state,use_email,register_on,register_off,register_off_to,teilnahme_beginn,title,anrede,namenszusatz,co_field,storno_grund,birth_date,old_active
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
            */;//TODO: ADD MANDATOR
            
            var q:EitherType<PDOStatement,Bool> = S.dbh.query(sql);
            if(!q)
            {
               dbData.dataErrors['${action}'] = S.dbh.errorInfo();
               return dbData;
            } 
        }        
        dbData.dataInfo = ['saveClientDetails' => 'OK', 'updatedRows' => updated];
        trace(dbData.dataInfo);
		return dbData; 
    }

    public function getCrmData():Map<String,Dynamic> 
	{		        
        var sql = comment(unindent,format)/*
		SELECT cl.client_id,cl.lead_id,cl.creation_date,cl.state,cl.use_email,cl.register_on,cl.register_off,cl.register_off_to,cl.teilnahme_beginn,cl.title,cl.anrede,cl.namenszusatz,cl.co_field,cl.storno_grund,cl.birth_date,cl.old_active,
pp.pay_plan_id,pp.client_id,pp.creation_date,pp.pay_source_id,pp.target_id,pp.start_day,pp.start_date,pp.buchungs_tag,pp.cycle,pp.amount,pp.product,pp.agent,pp.agency_project,pp.pay_plan_state,pp.pay_method,pp.end_date,pp.end_reason,pp.repeat_date,
 ps.pay_source_id,ps.client_id,ps.lead_id,ps.debtor,ps.bank_name,ps.account,ps.blz,ps.iban,ps.sign_date,ps.pay_source_state,ps.creation_date,
vl.lead_id,vl.entry_date,vl.modify_date,vl.status,vl.user,vl.source_id,vl.list_id,vl.called_since_last_reset,vl.phone_code,vl.phone_number,vl.title,vl.first_name,vl.middle_initial,vl.last_name,vl.address1,vl.address2,vl.city,vl.state,vl.province,vl.postal_code,vl.country_code,vl.gender,vl.date_of_birth,vl.alt_phone,vl.email,vl.security_phrase,vl.comments,vl.called_count,vl.last_local_call_time,vl.owner,vl.entry_list_id
FROM clients cl
INNER JOIN pay_plan pp
ON pp.client_id=cl.client_id
INNER JOIN pay_source ps
ON ps.client_id=cl.client_id
INNER JOIN asterisk.vicidial_list vl
ON vl.vendor_lead_code=cl.client_id
LIMIT 100
*/;

        var stmt:PDOStatement = S.syncDbh.query(sql);
		var result:NativeArray = (stmt.execute()?stmt.fetchAll(PDO.FETCH_ASSOC):null);
		trace(result);
		//var rows:KeyValueIterator<Int,NativeAssocArray<Dynamic>> = result.keyValueIterator();
		for(k=>v in result.keyValueIterator())
		{
			trace('$k => $v');
			//var result:NativeAssocArray<Dynamic>
		}
		var ini:NativeArray = null;

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