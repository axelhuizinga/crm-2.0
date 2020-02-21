package model.admin;

import action.async.DBAccessProps;
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
	var synced:Int;
	public function new(param:Map<String,Dynamic>):Void
	{
		super(param);	
		//self.table = 'columns';
		if(param.exists('synced'))
		{
			synced = cast param['synced'];
		}
		else synced = 0;
		keys = S.tableFields('contacts');
        trace('calling ${action}');
		trace(action);
		//SWITCH Call either an instance method directly or use the shared Model query execution
		switch(action ){
			case 'syncAll':
				syncAll();
			
			case 'syncImportDeals':
				syncImportDeals();
			case 'mergeContacts':
				mergeContacts();
			case _:
				run();
		}		
	}

	function  getMissing() {
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
				
		var cleared:Int = S.dbh.exec('TRUNCATE contact_ids');
		if(S.dbh.errorCode() !='00000')
		{
			trace(S.dbh.errorInfo());
		}
		else 	
			trace('cleared all IDs from contact_ids');
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
			trace('$sql ${Std.parseInt(param['limit'])}');
			S.sendErrors(dbData, ['getMissingIDs query:'=>S.syncDbh.errorInfo()]);
		}
		if(stmt.errorCode() !='00000')
		{
			trace(stmt.errorInfo());
		}
		var ids:String = (stmt.execute()?stmt.fetch(PDO.FETCH_COLUMN,0):null);
		trace(ids);
		sql = comment(unindent,format)/*
		SELECT cl.client_id id,cl.lead_id,cl.creation_date,cl.state,cl.use_email,cl.register_on,cl.register_off,cl.register_off_to,cl.teilnahme_beginn,cl.title title_pro,cl.anrede title,cl.namenszusatz,cl.co_field,cl.storno_grund,IF(TO_DAYS(STR_TO_DATE(cl.birth_date, '%Y-%m-%d'))>500000 ,cl.birth_date,null) date_of_birth,IF(cl.old_active=1,'true','false')old_active,
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
ON (vl.lead_id=cl.lead_id )
WHERE cl.client_id IN($ids)
ORDER BY cl.client_id  
*/;

        stmt = S.syncDbh.query(sql);
		if(untyped stmt==false)
		{
			trace(sql);
			S.sendErrors(dbData, ['getMissingCrmData query:'=>S.syncDbh.errorInfo()]);
		}
		if(stmt.errorCode() !='00000')
		{
			S.sendErrors(dbData,['getMissingCrmData'=>stmt.errorInfo()]);
		}
		res = (stmt.execute()?stmt.fetchAll(PDO.FETCH_ASSOC):null);
		var missing:Int = Syntax.code("count({0})",res);
		trace(missing);
		for(row in res.iterator())
		{			
			//trace(row);
			//S.sendErrors(dbData,['syncAll'=>'NOTOK']);
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
		//dbData.dataInfo['offset'] = param['offset'] + synced;
		trace(dbData.dataInfo);
        //S.sendData(dbData, null);
		S.sendInfo(dbData,['gotMissing'=>'OK:$missing']);
	}

	function syncImportDeals() {
		SyncExternalDeals.importDeals(S.dbh, dbData, getCrmData());
	}

	function mergeContacts() {
		var sql:String = "SELECT array_to_string(array(SELECT unnest(merged) from contacts group by merged), ',')";
		var stmt:PDOStatement = S.dbh.query(sql);
		if(untyped stmt==false)
		{
			trace('$sql ${Std.parseInt(param['limit'])}');
			S.sendErrors(dbData, ['getMergedIDs query:'=>S.dbh.errorInfo()]);
		}
		if(stmt.errorCode() !='00000')
		{
			trace(stmt.errorInfo());
		}
		var merged_ids:String = (stmt.execute()?stmt.fetch(PDO.FETCH_COLUMN,0):null);
		trace(merged_ids.substr(0, 40) + '...');		
		sql = comment(unindent,format)/*
			UPDATE contacts SET state='merged' WHERE id IN($merged_ids)
		*/;
		stmt = S.dbh.query(sql);
		if(untyped stmt==false)
		{
			trace('$sql');
			S.sendErrors(dbData, ['updateMergedIDs query:'=>S.dbh.errorInfo()]);
		}		
		if(stmt.errorCode() !='00000')
		{
			trace(stmt.errorInfo());
		}
		var updated_ids:Bool = stmt.execute();
		trace(updated_ids ? 'OK:' + stmt.rowCount() :'$sql');
		//S.sendInfo(dbData,['updated_ids'=>'$updated_ids']);
		sql = "SELECT id, merged from contacts WHERE merged IS NOT NULL";
		stmt = S.dbh.query(sql);
		if(untyped stmt==false)
		{
			trace('$sql ${Std.parseInt(param['limit'])}');
			S.sendErrors(dbData, ['getMergedIDs query:'=>S.dbh.errorInfo()]);
		}
		if(stmt.errorCode() !='00000')
		{
			trace(stmt.errorInfo());
			S.sendErrors(dbData, ['getMergedIDs query:'=>stmt.errorInfo()]);
		}
		var res:NativeArray = (stmt.execute()?stmt.fetchAll(PDO.FETCH_ASSOC):null);
		trace(Lib.toHaxeArray(res)[0]);
		S.sendInfo(dbData,['OK'=> stmt.rowCount()]);
	}

	function syncAll() {
		trace(param);
		getMissing();
		//dbAccessProps = initDbAccessProps();
		if(param['offset']==null)
			param['offset'] = '0';
		if(param['limit']==null)			
			param['limit'] = '1000';
		if(Std.parseInt(param['offset'])+Std.parseInt(param['limit'])>Std.parseInt(param['maxImport']))
		{
			param['limit'] = Std.string(Std.parseInt(param['maxImport']) - Std.parseInt(param['offset']));
		}
		trace(param);
		importCrmData();
		S.sendErrors(dbData,['syncAll'=>'NOTOK']);
	}

    public function importCrmData():Void
    {
        var cData:NativeArray = getCrmData();
        //trace(cData[0]);        
		//var rows:KeyValueIterator<Int,NativeAssocArray<Dynamic>> = result.keyValueIterator();
		for(row in cData.iterator())
		{			
			//trace(row);
			//S.sendErrors(dbData,['syncAll'=>'NOTOK']);
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
		dbData.dataInfo['offset'] = param['offset'] + synced;
		trace(dbData.dataInfo);
        S.sendData(dbData, null);
    }

    public function importDealData():Void
    {
        var cData:NativeArray = getCrmData();
        //trace(cData[0]);        
		//var rows:KeyValueIterator<Int,NativeAssocArray<Dynamic>> = result.keyValueIterator();
		for(row in cData.iterator())
		{			
			//trace(row);
			//S.sendErrors(dbData,['syncAll'=>'NOTOK']);
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
		dbData.dataInfo['offset'] = param['offset'] + synced;
		trace(dbData.dataInfo);
        S.sendData(dbData, null);
    }	
    
    inline function testValue(v:Dynamic):Bool return cast v;
    //inline function testValue(v:Dynamic):Bool return cast v != null && v != false;

    function upsertClient(rD:NativeArray):PDOStatement
    {
		var cD:Map<String,Dynamic> = Util.map2fields(rD, keys);
        var cNames:Array<String> = [for(k in cD.keys()) k];
		//var cVals:String =  [for(v in cD.iterator()) v].map(function (v) return '\'$v\'').join(',');
		var cPlaceholders:Array<String> =  [for(k in cNames) k].map(function (k) return ':$k');
		var cSet:String = [
			for(k in cNames.filter(function(k)return k!='id')) k
			].map(function (k) return ' "$k"=:$k').join(',');
		
        var sql:String = comment(unindent, format) /*
				INSERT INTO contacts (${cNames.join(',')})
				VALUES (${cPlaceholders.join(',')})
				ON CONFLICT (id) DO UPDATE
				SET $cSet returning id;
			*/;
		//trace(sql);
		var stmt:PDOStatement = S.dbh.prepare(sql,Syntax.array(null));
		Util.bindClientData('contacts',stmt,rD,dbData);
		if(!stmt.execute()){
			trace(rD);
			trace(stmt.errorInfo());
			S.sendErrors(dbData, ['execute'=>Lib.hashOfAssociativeArray(stmt.errorInfo()),
			'sql'=>sql,
			'id'=>Std.string(Syntax.code("{0}['id']",rD))]);
		}
		//trace(stmt.columnCount());
		//dbData.dataInfo['synced'] = ++synced;
		synced++;
		return stmt;
		//return S.dbh.query(sql, PDO.FETCH_ASSOC);
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
               dbData.dataErrors['${action}'] = Std.string(S.dbh.errorInfo());
               return dbData;
            } 
        }        
        dbData.dataInfo = ['saveClientDetails' => 'OK', 'updatedRows' => Std.string(updated)];
        trace(dbData.dataInfo);
		return dbData; 
    }

    public function getCrmData():NativeArray
	{		        
		var firstBatch:Bool = (param['offset']=='0');
		var selectTotalCount:String = '';
		if(Std.parseInt(param['limit'])>10000)
		{
			Syntax.code("ini_set('max_execution_time',3600)");
			Syntax.code("ini_set('memory_limit','1G')");			
			trace(Syntax.code("ini_get('memory_limit')"));
		}
		trace('offset:${param['offset']} firstBatch:$firstBatch ');
		if(firstBatch)
		{
			selectTotalCount = 'SQL_CALC_FOUND_ROWS';
		}
        var sql = comment(unindent,format)/*
		SELECT $selectTotalCount cl.client_id id,cl.lead_id,cl.creation_date,cl.state,cl.use_email,cl.register_on,cl.register_off,cl.register_off_to,cl.teilnahme_beginn,cl.title title_pro,cl.anrede title,cl.namenszusatz,cl.co_field,cl.storno_grund,IF(TO_DAYS(STR_TO_DATE(cl.birth_date, '%Y-%m-%d'))>500000 ,cl.birth_date,null) date_of_birth,IF(cl.old_active=1,'true','false')old_active,
pp.pay_plan_id,pp.creation_date,pp.pay_source_id,pp.target_id,pp.start_day,pp.start_date,pp.buchungs_tag,pp.cycle,pp.amount,IF(pp.product='K',2,3) product ,pp.agent,pp.agency_project project,pp.pay_plan_state,pp.pay_method,pp.end_date,pp.end_reason,pp.repeat_date,pp.cycle_start_date,
 ps.pay_source_id,ps.debtor,ps.bank_name,ps.account,ps.blz,ps.iban,ps.sign_date,ps.pay_source_state,ps.creation_date account_creation_date,
vl.entry_date,vl.modify_date,vl.status,vl.user,vl.source_id,vl.list_id,vl.phone_code,vl.phone_number,'' fax,vl.first_name,vl.last_name,vl.address1 address,vl.address2 address_2,vl.city,vl.postal_code,vl.country_code,IF(vl.gender='U','',vl.gender) gender,
IF( vl.alt_phone LIKE '1%',vl.alt_phone,'')mobile,vl.email,vl.comments,vl.last_local_call_time,vl.owner,vl.entry_list_id, 1 mandator, 100 edited_by, '' company_name
, cl.client_id contact,target_id target_account
FROM clients cl
INNER JOIN pay_plan pp
ON pp.client_id=cl.client_id
INNER JOIN pay_source ps
ON ps.client_id=cl.client_id
INNER JOIN asterisk.vicidial_list vl
ON vl.vendor_lead_code=cl.client_id
WHERE cl.client_id>9999999
ORDER BY cl.client_id 
LIMIT 
*/;
//WHERE cl.client_id>11019219
        var stmt:PDOStatement = S.syncDbh.query('$sql ${Std.parseInt(param['limit'])} OFFSET ${Std.parseInt(param['offset'])}');
		trace('loading  ${Std.parseInt(param['limit'])} OFFSET ${Std.parseInt(param['offset'])}');
		if(untyped stmt==false)
		{
			trace('$sql ${Std.parseInt(param['limit'])}');
			S.sendErrors(dbData, ['getCrmData query:'=>S.syncDbh.errorInfo()]);
		}
		if(stmt.errorCode() !='00000')
		{
			trace(stmt.errorInfo());
		}
		var res:NativeArray = (stmt.execute()?stmt.fetchAll(PDO.FETCH_ASSOC):null);
		//trace(res);
		if(firstBatch)
		{
			stmt = S.syncDbh.query('SELECT FOUND_ROWS()');
			var totalRes = stmt.fetchColumn();
			trace(totalRes);
			dbData.dataInfo['totalRecords'] = totalRes;
		}
		return res;
	}

}