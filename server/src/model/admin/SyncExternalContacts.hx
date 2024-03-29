package model.admin;

//import action.async.DBAccessProps;
import php.Exception;
import php.SuperGlobal;
import php.Global;
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

class SyncExternalContacts extends Model 
{
	var keys:Array<String>;	
	var synced:Int;

	public function new(param:Map<String,String>):Void
	{
		super(param);

		tableNames[0] = 'clients';
		totalCount = count();
		trace(totalCount);
		if(param.exists('synced'))
		{
			synced = cast param['synced'];
		}
		else synced = 0;
		keys = S.tableFields('contacts');
        trace('calling ${action}');
		trace(keys.join('|'));
		keys.push('care_of');
		//SWITCH Call either an instance method directly or use the shared Model query execution
		switch(action ){
			case 'importContacts':
				importContacts();			
			case 'dev':
				dev();
			case _:
				run();
		}		
	}

	function dev() {
		Sys.exit(0);
	}

	function getAllExtIds():NativeArray {
		var offset:Int = ( param['offset']>0?param['offset']:0);
		var sql:String = 'SELECT client_id FROM clients ORDER BY client_id';
		var stmt:PDOStatement = S.syncDbh.query(sql);
		if(untyped stmt==false)
		{
			trace(S.syncDbh.errorInfo());
			S.sendErrors(dbData, ['getAllExtIds query:'=>S.syncDbh.errorInfo()]);
		}
		if(stmt.errorCode() !='00000')
		{
			trace(stmt.errorInfo());
		}
		var res:NativeArray = (stmt.execute()?stmt.fetchAll(PDO.FETCH_COLUMN):null);	
		
		trace('all:' + totalCount);
				
		//var cleared:Int = S.dbh.exec('TRUNCATE contact_ids');
		if(S.dbh.errorCode() !='00000')
		{
			trace(S.dbh.errorInfo());
		}	
		return res;	
	}

	function getMissingExtIds(maxID:Int):NativeArray {
		var sql:String = 'SELECT client_id FROM clients WHERE client_id>$maxID ORDER BY client_id';
		trace(sql);
		var stmt:PDOStatement = S.syncDbh.query(sql);
		if(untyped stmt==false)
		{
			trace(S.syncDbh.errorInfo());
			S.sendErrors(dbData, ['getAllExtIds query:'=>S.syncDbh.errorInfo()]);
		}
		if(stmt.errorCode() !='00000')
		{
			trace(stmt.errorInfo());
		}
		var res:NativeArray = (stmt.execute()?stmt.fetchAll(PDO.FETCH_COLUMN):null);	
		
		trace('all:' + totalCount);
				
		//var cleared:Int = S.dbh.exec('TRUNCATE contact_ids');
		if(S.dbh.errorCode() !='00000')
		{
			trace(S.dbh.errorInfo());
		}	
		return res;	
	}

	function  getMissing() {
		var updateExtIds:Bool= param.exists('updateExtIds')? true:false;
		
		var stmt:PDOStatement = S.dbh.query('SELECT MAX(id)ext_max FROM "crm"."contacts";');
		S.checkStmt(S.dbh, stmt, 'get max contacts id query:'+Std.string(S.dbh.errorInfo()));
		
		var maxCid:Int = (stmt.execute()?stmt.fetch(PDO.FETCH_COLUMN):null);	
		//trace(Std.string(res));
		//param['totalRecords'] = untyped res[0];//Syntax.code("count({0})",res);
		trace('ext_max: $maxCid');			

		var cData:NativeArray = getMissingClients('WHERE client_id>${maxCid}');
		trace('got:'+Lib.toHaxeArray(cData).length);
		if(Lib.toHaxeArray(cData).length>0){
			trace(cData[0]);
			var cD:Map<String,Dynamic> = Util.map2fields(cData[0], keys);
			//trace(cD);
			var cNames:Array<String> = [for(k in cD.keys()) k];
			//var haData:Array<NativeArray> = Lib.toHaxeArray(cData);
			var _1st:Bool = true;
			var madded:Int = 0;
			for(row in cData.iterator())
			{			
				var aid:Int = Syntax.code("{0}['id']",row);				
				var stmt:PDOStatement = upsertClient(row, cD, cNames);
				try{
					var res:NativeArray = stmt.fetchAll(PDO.FETCH_ASSOC);		
					if(_1st){
						_1st=false;
						trace(row);
						trace(res);
						//Sys.exit(333);
					}
				}
				catch(e:Dynamic)
				{
					{S.sendErrors(dbData, [
						'dbError'=>S.dbh.errorInfo(),
						'upsertClient'=>S.errorInfo(row),
						'exception'=>e
					]);}		
				}
				madded++;
			}		
			trace('added $madded');	
		}
		
		S.sendInfo(dbData);
		Sys.exit(0);
	}

	function  getMissing1() {
		var updateExtIds:Bool= param.exists('updateExtIds')? true:false;
		var cIDs:Array<Dynamic> = null;
		if(updateExtIds){
			cIDs = Lib.toHaxeArray(getAllExtIds());			
			trace('got:' +cIDs.length + ' client_ids');
			//trace('got:' + Syntax.code("count({0})",cIDs) +' client_ids');		
			var clearExtIds:Bool= param.exists('clearExtIds')? true:false;
			if(clearExtIds){
				var cleared:Int = S.dbh.exec('DELETE FROM ext_ids_ WHERE auth_user=${S.dbQuery.dbUser.id} AND table_name=\'contacts\' AND action=${Util.actionPath(this)}');
				if(S.dbh.errorCode() !='00000')
				{
					trace(S.dbh.errorInfo());var madded:Int = 0;
				}
				else 	
					trace('cleared all contacts IDs from ext_ids_');				
			}

			var cidsStored:Int = 0;
			for(cid in cIDs){
				var sql = 'INSERT INTO ext_ids VALUES($cid)';// ON CONFLICT DO NOTHING
				var stored:Int = S.dbh.exec(sql);
				cidsStored += stored;
				if(stored==0){
					trace('$sql not inserted');
					S.errorInfo({oops:333});
				}
			}
			if(S.dbh.errorCode() !='00000')
			{
				trace(S.dbh.errorInfo());
			}
			else 	
				trace('stored $cidsStored client_ids to ext_ids_');
		}
		else{
			var stmt:PDOStatement = S.dbh.query('SELECT MAX(ext_id)ext_max FROM "crm"."ext_ids";');
			S.checkStmt(S.dbh, stmt, 'getAllExtIds query:'+Std.string(S.dbh.errorInfo()));
			
			var ext_max:Int = (stmt.execute()?stmt.fetch(PDO.FETCH_COLUMN):null);	
			//trace(Std.string(res));
			//param['totalRecords'] = untyped res[0];//Syntax.code("count({0})",res);
			trace('ext_max: $ext_max');			
			cIDs = Lib.toHaxeArray(getMissingExtIds(ext_max));
			trace('missing:${cIDs.count()}');
			var cData:NativeArray = getMissingClients('WHERE client_id>${ext_max}');
			trace('got:'+Lib.toHaxeArray(cData).length);
			var cD:Map<String,Dynamic> = Util.map2fields(cData[0], keys);
			//trace(cD);
			var cNames:Array<String> = [for(k in cD.keys()) k];
			//var haData:Array<NativeArray> = Lib.toHaxeArray(cData);
			var _1st:Bool = true;
			var madded:Int = 0;
			for(row in cData.iterator())
			{			
				var aid:Int = Syntax.code("{0}['id']",row);				
				var stmt:PDOStatement = upsertClient(row, cD, cNames);
				try{
					var res:NativeArray = stmt.fetchAll(PDO.FETCH_ASSOC);		
					if(_1st){
						_1st=false;
						trace(row);
						trace(res);
						//Sys.exit(333);
					}
				}
				catch(e:Dynamic)
				{
					{S.sendErrors(dbData, [
						'dbError'=>S.dbh.errorInfo(),
						'upsertClient'=>S.errorInfo(row),
						'exception'=>e
					]);}		
				}
				madded++;
			}		
			trace('added $madded');
			S.sendInfo(dbData);
		}

		Sys.exit(0);
	}

	function importContacts() 
	{
		//createOrUpdateAction();
		//var allCids = getAllExtIds();
		
		if(offset.int+limit.int>totalCount)
		{
			limit = Util.limit(totalCount - offset.int);
		}
		trace(param);
		if(Lib.isCli()){
			while(synced<totalCount){
				importCrmContacts();
				trace('offset:'+ offset.int);
				trace(param);
			}
			trace('done');
			Sys.exit(S.sendInfo(dbData, ['importContacts'=>'OK'])?1:0);
		}
		else{
			param['user_name'] = S.dbQuery.dbUser.user_name;			
			param['id'] = S.dbQuery.dbUser.id;			
			param['REMOTE_ADDR'] = SuperGlobal._SERVER['REMOTE_ADDR'];			
			param['jwt'] = S.dbQuery.dbUser.jwt;
			param['password'] = S.dbQuery.dbUser.password;
			var cliArg:String = Util.cliArgs(param);
			trace(cliArg);
			var com:String = 'php ${S.home + "/server.php " + cliArg}';
			trace(com);			
			Syntax.code("`{0} &`", com );
			//Sys.sleep(10);
			S.sendInfo(dbData, ['importContacts'=>'OK']);
		}
		
		S.sendErrors(dbData,['importContacts'=>'NOTOK']);
	}

	public function importCrmContacts():Void
	{
		var cData:NativeArray = getCrmClients();
		if(Syntax.code("count({0})",cData)==0){
			Sys.exit(0);
		}
		//trace(cData[0]);
		var cD:Map<String,Dynamic> = Util.map2fields(cData[0], keys);
		//trace(cD);
		var cNames:Array<String> = [for(k in cD.keys()) k];
		//var rows:KeyValueIterator<Int,NativeAssocArray<Dynamic>> = result.keyValueIterator();
		for(row in cData)
		{			
			var stmt:PDOStatement = upsertClient(row, cD, cNames);
			try{
				var res:NativeArray = stmt.fetchAll(PDO.FETCH_ASSOC);	
				if(!(offset.int>0)){
					trace(res);
				}
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
		if(Lib.isCli()){
			trace('${offset.int} + ${synced}');
			offset = Util.offset(synced);
			if(offset.int+limit.int>totalCount)
			{
				limit = Util.limit(totalCount - offset.int);
			}			
			return;
		}
		trace('done');
		dbData.dataInfo['offset'] = Std.string(offset.int);
		trace(dbData.dataInfo);
		S.sendData(dbData, null);
	}

    public function importCrmData():Void
    {
		var cData:NativeArray = getCrmClients();
		var cD:Map<String,Dynamic> = Util.map2fields(cData[0], keys);
		//trace(cD);
		var cNames:Array<String> = [for(k in cD.keys()) k];			
        //trace(cData[0]);        
		//var rows:KeyValueIterator<Int,NativeAssocArray<Dynamic>> = result.keyValueIterator();
		for(row in cData.iterator())
		{			
			//trace(row);
			//S.sendErrors(dbData,['importContacts'=>'NOTOK']);
			var stmt:PDOStatement = upsertClient(row, cD, cNames);
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
		if(Lib.isCli()){
			offset = Util.offset(synced);
			return;
		}
        trace('done');
		dbData.dataInfo['offset'] = param['offset'] + synced;
		trace(dbData.dataInfo);
        S.sendData(dbData, null);
    }
    
    function upsertClient(rD:NativeArray, cD:Map<String,Dynamic>, cNames:Array<String>):PDOStatement
    {		
		//trace(rD);
		//trace(cNames);Sys.exit(0);
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
		if(id< untyped 11000100){
			trace(sql);
			trace(Std.string(Syntax.code("{0}['id']",rD)));			
		}			
		var stmt:PDOStatement = S.dbh.prepare(sql,Syntax.array(null));
		Util.bindClientData('contacts',stmt,rD,dbData);
		try{
			if(!stmt.execute()){
				trace(rD);
				trace(stmt.errorInfo());
				S.sendErrors(dbData, ['execute'=>Lib.hashOfAssociativeArray(stmt.errorInfo()),
				'sql'=>sql,
				'id'=>Std.string(Syntax.code("{0}['id']",rD))]);
			}
		}
		catch(ex:Exception){
			trace(ex);
			trace(sql);
			trace(rD);
			Sys.exit(666);
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
            UPDATE crm.users SET active='${dR['active']}',edited_by=${S.dbQuery.dbUser.id}, external = jsonb_object('{$external_text}')::jsonb WHERE user_name='${dR['user']}'
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
	
	public function importContact():Void
	{
		var cData:NativeArray = getCrmClient(param.get('id'));
		if(Syntax.code("count({0})",cData)==0){
			Sys.exit(0);
		}
		var cD:Map<String,Dynamic> = Util.map2fields(cData[0], keys);
		trace(cD);
		var cNames:Array<String> = [for(k in cD.keys()) k];
		//var rows:KeyValueIterator<Int,NativeAssocArray<Dynamic>> = result.keyValueIterator();
		for(row in cData)
		{			
			trace(row);
			var stmt:PDOStatement = upsertClient(row, cD, cNames);
			try{
				var res:NativeArray = stmt.fetchAll(PDO.FETCH_ASSOC);	
				if(!(offset.int>0)){
					trace(res);
				}
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
		//dbData.dataInfo['offset'] = Std.string(offset.int);
		trace(dbData.dataInfo);
		S.sendData(dbData, null);
	}

	
	public function getCrmClient(id:Int):NativeArray
	{		        
		var min_age:Int = ( param['min_age']>0?param['min_age']:18);
		var sql = comment(unindent,format)/*
SELECT cl.client_id id,cl.lead_id,cl.creation_date,cl.state,cl.use_email,cl.register_on,cl.register_off,cl.register_off_to,cl.teilnahme_beginn,cl.title title_pro,cl.anrede title,cl.namenszusatz,cl.co_field care_of,cl.storno_grund,IF(YEAR(FROM_DAYS(DATEDIFF(CURDATE(),cl.birth_date)))>$min_age ,cl.birth_date,null) date_of_birth,IF(cl.old_active=1,'true','false')old_active,1 mandator,vl.modify_date,cl.state 'status',vl.user,vl.source_id,vl.list_id,vl.phone_code,vl.phone_number,'' fax,vl.first_name,vl.last_name,vl.address1 address1,vl.address2 address2,vl.city,vl.postal_code,vl.country_code,IF(vl.gender='U','',vl.gender) gender,
IF( vl.alt_phone LIKE '1%',vl.alt_phone,'')mobile,vl.email,vl.comments,vl.last_local_call_time,vl.owner
FROM fly_crm.clients cl 
INNER JOIN asterisk.vicidial_list vl
ON vl.lead_id=cl.lead_id WHERE client_id = $id
*/;
		trace(sql); 
		var stmt:PDOStatement = S.syncDbh.query(sql);
		trace('loading ${limit} ${offset}');
		S.checkStmt(S.syncDbh, stmt,'getCrmClients query:');
		var res:NativeArray = (stmt.execute()?stmt.fetchAll(PDO.FETCH_ASSOC):null);
		trace('fetched:' + Syntax.code("count({0})",res));
		offset = Util.offset(offset.int + Syntax.code("count({0})",res));
		return res;
	}
		
	public function getCrmClients():NativeArray
	{		        
		var min_age:Int = ( param['min_age']>0?param['min_age']:18);
		var sql = comment(unindent,format)/*
SELECT cl.client_id id, cl.*,1 mandator,vl.modify_date,cl.state status,vl.user,vl.source_id,vl.list_id,vl.phone_code,vl.phone_number,'' fax,vl.first_name,vl.last_name,vl.address1 address,vl.address2 address_2,vl.city,vl.postal_code,vl.country_code,IF(vl.gender='U','',vl.gender) gender,
IF( vl.alt_phone LIKE '1%',vl.alt_phone,'')mobile,vl.email,vl.comments,vl.last_local_call_time,vl.owner
FROM fly_crm.clients cl 
INNER JOIN asterisk.vicidial_list vl
ON vl.lead_id=cl.lead_id
ORDER BY client_id
${limit.sql} ${offset.sql}
*/;
		sql = comment(unindent,format)/*
SELECT cl.client_id id,cl.lead_id,cl.creation_date,cl.state,cl.use_email,cl.register_on,cl.register_off,cl.register_off_to,cl.teilnahme_beginn,cl.title title_pro,cl.anrede title,cl.namenszusatz,cl.co_field care_of,cl.storno_grund,IF(YEAR(FROM_DAYS(DATEDIFF(CURDATE(),cl.birth_date)))>$min_age ,cl.birth_date,null) date_of_birth,IF(cl.old_active=1,'true','false')old_active,1 mandator,vl.modify_date,cl.state 'status',vl.user,vl.source_id,vl.list_id,vl.phone_code,vl.phone_number,'' fax,vl.first_name,vl.last_name,vl.address1 address1,vl.address2 address2,vl.city,vl.postal_code,vl.country_code,IF(vl.gender='U','',vl.gender) gender,
IF( vl.alt_phone LIKE '1%',vl.alt_phone,'')mobile,vl.email,vl.comments,vl.last_local_call_time,vl.owner
FROM fly_crm.clients cl 
INNER JOIN asterisk.vicidial_list vl
ON vl.lead_id=cl.lead_id
 
ORDER BY client_id	
${limit.sql} ${offset.sql}
*/;
		trace(sql);//${where}
		var stmt:PDOStatement = S.syncDbh.query(sql);
		trace('loading ${limit} ${offset}');
		S.checkStmt(S.syncDbh, stmt,'getCrmClients query:');
		var res:NativeArray = (stmt.execute()?stmt.fetchAll(PDO.FETCH_ASSOC):null);
		trace('fetched:' + Syntax.code("count({0})",res));
		offset = Util.offset(offset.int + Syntax.code("count({0})",res));
		return res;
	}

	public function getMissingClients(where:String):NativeArray
	{		        
		var min_age:Int = ( param['min_age']>0?param['min_age']:18);
		var sql = comment(unindent,format)/*
	SELECT cl.client_id id, cl.*,1 mandator,vl.modify_date,cl.state status,vl.user,vl.source_id,vl.list_id,vl.phone_code,vl.phone_number,'' fax,vl.first_name,vl.last_name,vl.address1 address,vl.address2 address_2,vl.city,vl.postal_code,vl.country_code,IF(vl.gender='U','',vl.gender) gender,
	IF( vl.alt_phone LIKE '1%',vl.alt_phone,'')mobile,vl.email,vl.comments,vl.last_local_call_time,vl.owner
	FROM fly_crm.clients cl 
	INNER JOIN asterisk.vicidial_list vl
	ON vl.lead_id=cl.lead_id
	${where} 
	ORDER BY client_id	
	*/;
	sql = comment(unindent,format)/*
	SELECT cl.client_id id,cl.lead_id,cl.creation_date,cl.state,cl.use_email,cl.register_on,cl.register_off,cl.register_off_to,cl.teilnahme_beginn,cl.title title_pro,cl.anrede title,cl.namenszusatz,cl.co_field care_of,cl.storno_grund,IF(YEAR(FROM_DAYS(DATEDIFF(CURDATE(),cl.birth_date)))>$min_age ,cl.birth_date,null) date_of_birth,IF(cl.old_active=1,'true','false')old_active,1 mandator,vl.modify_date,cl.state status,vl.user,vl.source_id,vl.list_id,vl.phone_code,vl.phone_number,'' fax,vl.first_name,vl.last_name,vl.address1 address,vl.address2 address_2,vl.city,vl.postal_code,vl.country_code,IF(vl.gender='U','',vl.gender) gender,
	IF( vl.alt_phone LIKE '1%',vl.alt_phone,'')mobile,vl.email,vl.comments,vl.last_local_call_time,vl.owner
	FROM fly_crm.clients cl 
	INNER JOIN asterisk.vicidial_list vl
	ON vl.lead_id=cl.lead_id
	${where} 
	ORDER BY client_id	
	*/;
		trace(sql);
		var stmt:PDOStatement = S.syncDbh.query(sql);
		S.checkStmt(S.syncDbh, stmt,'getCrmClients query:');
		var res:NativeArray = (stmt.execute()?stmt.fetchAll(PDO.FETCH_ASSOC):null);
		//trace(res);
		return res;
	}	
	

    public function getCrmData2(?min_id=9999999):NativeArray
	{		        
		trace(min_id);
		//S.sendErrors(null,['devbreak'=>min_id]);
		var min_age:Int = ( param['min_age']>0?param['min_age']:18);
        var sql:String = comment(unindent,format)/*
		SELECT cl.client_id id,cl.lead_id,cl.creation_date,cl.state,cl.use_email,cl.register_on,cl.register_off,cl.register_off_to,cl.teilnahme_beginn,cl.title title_pro,cl.anrede title,cl.namenszusatz,cl.co_field care_of,cl.storno_grund,IF(YEAR(FROM_DAYS(DATEDIFF(CURDATE(),cl.birth_date)))>$min_age ,cl.birth_date,null) date_of_birth,IF(cl.old_active=1,'true','false')old_active,
pp.pay_plan_id,pp.creation_date,pp.pay_source_id,pp.target_id,pp.start_day,pp.start_date,pp.buchungs_tag,pp.cycle,pp.amount,IF(pp.product='K',2,3) product ,pp.agent,pp.agency_project project,pp.pay_plan_state,pp.pay_method,pp.end_date,pp.end_reason,pp.repeat_date,pp.cycle_start_date,
 ps.pay_source_id,ps.debtor,ps.bank_name,ps.account,ps.blz,ps.iban,ps.sign_date,ps.pay_source_state,ps.creation_date account_creation_date,
vl.entry_date,vl.modify_date,vl.status,vl.user,vl.source_id,vl.list_id,vl.phone_code,vl.phone_number,'' fax,vl.first_name,vl.last_name,vl.address1 address,vl.address2 address_2,vl.city,vl.postal_code,vl.country_code,IF(vl.gender='U','',vl.gender) gender,
IF( vl.alt_phone LIKE '1%',vl.alt_phone,'')mobile,vl.email,vl.comments,vl.last_local_call_time,vl.owner,vl.entry_list_id, ${S.dbQuery.dbUser.id} edited_by, '' company_name
, cl.client_id contact,target_id target_account
FROM clients cl
INNER JOIN pay_plan pp
ON pp.client_id=cl.client_id
INNER JOIN pay_source ps
ON ps.client_id=cl.client_id
INNER JOIN asterisk.vicidial_list vl
ON vl.vendor_lead_code=cl.client_id
WHERE cl.client_id>${min_id}
*/;
		trace('$sql');
        var stmt:PDOStatement = S.syncDbh.query(
			'$sql ORDER BY cl.client_id ${Util.limit()} ${Util.offset()}');
		trace('loading ${Util.limit()} ${Util.offset()}');
		if(untyped stmt==false)
		{
			trace('$sql ORDER BY cl.client_id ${Util.limit()} ${Util.offset()}');
			S.sendErrors(dbData, ['getCrmData query:'=>S.syncDbh.errorInfo()]);
		}
		if(stmt.errorCode() !='00000')
		{
			trace(stmt.errorInfo());
		}
		var res:NativeArray = (stmt.execute()?stmt.fetchAll(PDO.FETCH_ASSOC):null);
		if(!(offset.int>0))
		{
			dbData.dataInfo['totalRecords'] = Std.string(count());
		}
		return res;
	}

	override function count():Int {
		var stmt:PDOStatement = S.syncDbh.query('SELECT COUNT(*) FROM clients');
		return Std.parseInt(stmt.fetchColumn());
	}

}