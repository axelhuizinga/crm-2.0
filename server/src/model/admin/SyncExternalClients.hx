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
	var keys:Array<String>;	

	public function new(param:Map<String,String>):Void
	{
		super(param);	
		//self.table = 'columns';
		keys = S.tableFields('contacts');
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
        //trace(cData[0]);        
		//var rows:KeyValueIterator<Int,NativeAssocArray<Dynamic>> = result.keyValueIterator();
		for(row in cData.iterator())
		{			
			var stmt:PDOStatement = upsertClient(row);
			try{
				var res:NativeArray = stmt.fetchAll(PDO.FETCH_ASSOC);		
				//trace(res);
			}
			catch(e:Dynamic)
			{
				{S.sendErrors(dbData, [
					'dbError'=>S.dbh.errorInfo(),
					'upsertClient'=>S.errorInfo(row),
					'exception'=>e
				]);}		
			}
		}		
        trace('done');
        S.sendData(dbData, null);
    }
    
    inline function testValue(v:Dynamic):Bool return cast v;
    //inline function testValue(v:Dynamic):Bool return cast v != null && v != false;

    function upsertClient(rD:NativeArray):PDOStatement
    {
		var cD:Map<String,Dynamic> = clientRowData(rD);
        var cNames:Array<String> = [for(k in cD.keys()) k].filter(function(k)return k!='id');
		//var cVals:String =  [for(v in cD.iterator()) v].map(function (v) return '\'$v\'').join(',');
		var cPlaceholders:Array<String> =  [for(k in cNames) k].map(function (k) return ':$k');
		var cSet:String = [
			for(k in cNames) k
			].map(function (k) return ' "$k"=:$k').join(',');
		
        var sql:String = comment(unindent, format) /*
				INSERT INTO contacts (${cNames.join(',')})
				VALUES (${cPlaceholders.join(',')})
				ON CONFLICT (id) DO UPDATE
				SET $cSet returning id;
			*/;
		//trace(sql);
		var stmt:PDOStatement = S.dbh.prepare(sql,Syntax.array(null));
		bindClientData(stmt,rD);
		if(!stmt.execute()){
			S.sendErrors(dbData, ['execute'=>Lib.hashOfAssociativeArray(stmt.errorInfo())]);
		}
		//trace(stmt.columnCount());
		dbData.dataInfo['synced'] = ++synced;
		return stmt;
		//return S.dbh.query(sql, PDO.FETCH_ASSOC);
    }
	
	function bindClientData(stmt:PDOStatement, row:NativeArray)
	{
		var meta:Map<String, NativeArray> = S.columnsMeta('contacts');
		for(k => v in meta.keyValueIterator())
		{
			if(k=='id')
				continue;
			
			var pdoType:Int = v['pdo_type'];
			if(row[k]==null||row[k].indexOf('0000-00-00')==0)
			{
				switch (v['native_type'])
				{
					case 'date'|'datetime'|'timestamp':
					pdoType = PDO.PARAM_NULL;
					case 'text'|'varchar':
					row[k] = '';
				}
			}
			//trace('$k => $pdoType:${row[k]}');
			if(!stmt.bindValue(':$k',row[k], pdoType))//row[k]==null?1:
			{
				//trace('$k => $v');
				S.sendErrors(dbData,['bindValue'=>'${row[k]}:$pdoType']);
			}		
		}
	}

	function clientRowData(row:NativeArray):Map<String,Dynamic> {
		//trace(keys);
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
		var firstBatch:Bool = param.exists('firstBatch') && param['firstBatch'];
		var selectTotalCount:String = '';
		if(firstBatch)
		{
			selectTotalCount = 'SQL_CALC_FOUND_ROWS';
		}
        var sql = comment(unindent,format)/*
		SELECT $firstBatch cl.client_id id,cl.lead_id,cl.creation_date,cl.state,cl.use_email,cl.register_on,cl.register_off,cl.register_off_to,cl.teilnahme_beginn,cl.title title_pro,cl.anrede title,cl.namenszusatz,cl.co_field,cl.storno_grund,cl.birth_date date_of_birth,IF(cl.old_active=1,'true','false')old_active,
pp.pay_plan_id,pp.creation_date,pp.pay_source_id,pp.target_id,pp.start_day,pp.start_date,pp.buchungs_tag,pp.cycle,pp.amount,IF(pp.product='K',2,3) product ,pp.agent,pp.agency_project project,pp.pay_plan_state,pp.pay_method,pp.end_date,pp.end_reason,pp.repeat_date,
 ps.pay_source_id,ps.debtor,ps.bank_name,ps.account,ps.blz,ps.iban,ps.sign_date,ps.pay_source_state,ps.creation_date account_creation_date,
vl.entry_date,vl.modify_date,vl.status,vl.user,vl.source_id,vl.list_id,vl.phone_code,vl.phone_number,'' fax,vl.first_name,vl.last_name,vl.address1 address,vl.address2 address_2,vl.city,vl.postal_code,vl.country_code,IF(vl.gender='U','',vl.gender) gender,
IF( vl.alt_phone LIKE '1%',vl.alt_phone,'')mobile,vl.email,vl.comments,vl.last_local_call_time,vl.owner,vl.entry_list_id, 1 mandator, 100 edited_by, '' company_name
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
		if(stmt.errorCode() !='00000')
		{
			trace(stmt.errorInfo());
		}
		var res:NativeArray = (stmt.execute()?stmt.fetchAll(PDO.FETCH_ASSOC):null);
		if(firstBatch)
		{
			stmt:PDOStatement = S.syncDbh.query('SELECT FOUND_ROWS()');
			var totalRes:NativeArray = 
			dbData.dataInfo['totalRecords'] =  (stmt.execute()?stmt.fetch(PDO.FETCH_COLUMN,0):null);
		}
		return res;
	}

}