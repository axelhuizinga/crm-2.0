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
		if(param['batchSize']==null)
			param['batchSize'] = '1000';
		importCrmData();
		S.sendErrors(dbData,['syncAll'=>'OK']);
	}

    public function importCrmData():Void
    {
        var cData:NativeArray = getCrmData();
        trace(cData[0]);        
		//var rows:KeyValueIterator<Int,NativeAssocArray<Dynamic>> = result.keyValueIterator();
		for(row in cData.iterator())
		{
			/*if (! cast stmt:PDOStatement = upsertClient(row))
			{S.sendErrors(dbData, ['upsertClient'=>S.errorInfo(row)]);}		
			trace(stmt.fetchAll())*/
			trace(upsertClient(row));
		}		
        S.sendData(dbData, null);
        trace('done');
    }
    
    inline function testValue(v:Dynamic):Bool return cast v;
    //inline function testValue(v:Dynamic):Bool return cast v != null && v != false;

    function upsertClient(rD:NativeArray):PDOStatement
    {
		var cD:Map<String,Dynamic> = clientRowData(rD);
        var cNames:String = [for(k in cD.keys()) k].join(',');
		var cVals:String =  [for(v in cD.iterator()) v].map(function (v) return '\'$v\'').join(',');

        var sql:String = comment(unindent, format) /*
			WITH new_contact AS (
				INSERT INTO crm.contacts ($cNames)
				VALUES ($cVals)
				ON CONFLICT (id) DO UPDATE
				SET returning id)
				select id from new_contact;
			*/;
		trace(sql);
		return S.dbh.query(sql, PDO.FETCH_ASSOC);
    }/**
    client_id,creation_date,state,use_email,register_on,register_off,register_off_to,teilnahme_beginn,title,anrede,namenszusatz,co_field,storno_grund,birth_date,old_active
	##
	'${cD["client_id"]}',1,'${cD["creation_date"]}', ,'${cD["state"]}'
                ,'${cD["use_email"]}','${cD["phone_code"]}','${cD["phone_number"]}'
                ,'${cD["creation_date"]}','${cD["creation_date"]}','${cD["creation_date"]}'
                ,'${cD["creation_date"]}','${cD["creation_date"]}','${cD["creation_date"]}'
    **/
	function clientRowData(row:NativeArray):Map<String,Dynamic> {
		var keys:Array<String> = S.tableFields('contacts');
		keys.filter(function (k) return row[k]!=null);
		return[
			for(k in keys)
				k => row[k]
		];
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

    public function getCrmData():NativeArray
	{		        
        var sql = comment(unindent,format)/*
		SELECT cl.client_id id,cl.lead_id,cl.creation_date,cl.state,cl.use_email,cl.register_on,cl.register_off,cl.register_off_to,cl.teilnahme_beginn,cl.title,cl.anrede,cl.namenszusatz,cl.co_field,cl.storno_grund,cl.birth_date date_of_birth,IF(cl.old_active=1,'true','false')old_active,
pp.pay_plan_id,pp.creation_date,pp.pay_source_id,pp.target_id,pp.start_day,pp.start_date,pp.buchungs_tag,pp.cycle,pp.amount,IF(pp.product='K',2,3) product ,pp.agent,pp.agency_project project,pp.pay_plan_state,pp.pay_method,pp.end_date,pp.end_reason,pp.repeat_date,
 ps.pay_source_id,ps.debtor,ps.bank_name,ps.account,ps.blz,ps.iban,ps.sign_date,ps.pay_source_state,ps.creation_date account_creation_date,
vl.entry_date,vl.modify_date,vl.status,vl.user,vl.source_id,vl.list_id,vl.phone_code,vl.phone_number,vl.first_name,vl.last_name,vl.address1,vl.address2,vl.city,vl.postal_code,vl.country_code,vl.gender,
IF( vl.alt_phone LIKE '1%',vl.alt_phone,'')mobil,vl.email,vl.comments,vl.last_local_call_time,vl.owner,vl.entry_list_id, 1 mandator, 100 edited_by, '' company_name
FROM clients cl
INNER JOIN pay_plan pp
ON pp.client_id=cl.client_id
INNER JOIN pay_source ps
ON ps.client_id=cl.client_id
INNER JOIN asterisk.vicidial_list vl
ON vl.vendor_lead_code=cl.client_id
ORDER BY cl.client_id 
LIMIT
*/;

        var stmt:PDOStatement = S.syncDbh.query('$sql ${param['batchSize']}');
		return (stmt.execute()?stmt.fetchAll(PDO.FETCH_ASSOC):null);
	}

}