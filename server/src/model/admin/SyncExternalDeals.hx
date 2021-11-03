package model.admin;
import me.cunity.debug.Out;
import php.Global;
import comments.CommentString.*;
import php.db.PDO;
import php.db.PDOStatement;
import php.Lib;
import php.NativeArray;
import php.Syntax;
import shared.DbData;
using Util;

class SyncExternalDeals extends Model 
{
	static var dKeys:Array<String> =  S.tableFields('deals');
	var keys:Array<String>;	
	var synced:Int;

	public function new(param:Map<String,String>):Void
	{
		super(param);	
		//self.table = 'columns';
		if(param.exists('synced'))
		{
			synced = cast param['synced'];
		}
		else synced = 0;
		keys = S.tableFields('deals');
        trace('calling ${action}');
		trace(action);
		//SWITCH Call either an instance method directly or use the shared Model query execution
		switch(action ){
			case 'importAll':
				importAll();			
			/*case 'syncAll':
				syncAll();
			
			case 'syncImportDeals':
				syncImportDeals();
			case 'mergeContacts':
				mergeContacts();*/
			case _:
				run();
		}		
	}

	function updateExtIds():Array<Int> {
		/*CLEAR fly_crm pay_plan_id's from ext_ids_ table*/
		var action = S.params["classPath"]+'.'+S.params["action"];
		var cleared:Int = S.dbh.exec(
			'DELETE FROM ext_ids_ WHERE auth_user=${S.dbQuery.dbUser.id} AND action=\'${Util.actionPath(this)}\' AND table_name=\'deals\'');
		//trace('DELETE FROM ext_ids_ WHERE auth_user=${S.dbQuery.dbUser.id} AND action=\'${action}\' AND table_name=\'deals\'');
		//S.checkStmt(S.syncDbh, stmt, 'updateExtIds-pay_plan_ids');
		var cids:Array<Int> = untyped Lib.toHaxeArray(getAllExtIds());	
		var start = Sys.time();
		for(cid in cids){
			var sti:PDOStatement = S.dbh.prepare(
				'INSERT INTO ext_ids_ VALUES(?,?,?,?) ON CONFLICT DO NOTHING');			
			if(untyped sti==false)
			{
				trace(S.dbh.errorInfo);
				//trace('INSERT INTO ext_ids_ VALUES(${cid}, ${S.dbQuery.dbUser.id}, \'${Util.actionPath(this)}\',\'deals\')');
				Sys.exit(untyped '666');
			}
			//var args:Array<Dynamic> = [cid[0], S.dbQuery.dbUser.id, action,'deals'];
			if(! sti.execute(
				Syntax.code("array({0},{1},{2},{3})",cid, S.dbQuery.dbUser.id, '${Util.actionPath(this)}','deals'))){
				trace(S.dbh.errorInfo());
				trace(sti.errorInfo());
				Sys.exit(untyped '666');
			}
		}
		trace(cids.length + ' storing took:' + (Sys.time()-start));		
		return cids;
	}

	function getAllExtIds():NativeArray {
		//var offset:Int = ( param['offset']>0?param['offset']:0);
		var sql:String = 'SELECT pay_plan_id FROM pay_plan ORDER BY pay_plan_id';
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
		
		param['totalRecords'] = Syntax.code("count({0})",res);
		trace('all:' + param['totalRecords']);
				
		//var cleared:Int = S.dbh.exec('TRUNCATE contact_ids');
		if(S.dbh.errorCode() !='00000')
		{
			trace(S.dbh.errorInfo());
		}	
		return res;	
	}

	function getMissing():Void {
		var start = Sys.time();
		var stmt:PDOStatement = S.dbh.query('SELECT MAX(id) FROM "crm"."deals";');
		S.checkStmt(S.dbh, stmt, 'get max deals id query:'+Std.string(S.dbh.errorInfo()));
		
		var maxDeal:Int = (stmt.execute()?stmt.fetch(PDO.FETCH_COLUMN):0);
		if(maxDeal==null)
			maxDeal=0;
		trace('maxDeal:$maxDeal');
		importExtDeals('WHERE pay_plan_id>$maxDeal ');
		
		trace('missing deals took:' + (Sys.time()-start));
	}
	
	function getDeals4Client():Void {
		var start = Sys.time();
		var client:String = param['client'];
		var stmt:PDOStatement = S.dbh.query('SELECT MAX(contact) FROM "crm"."deals";');
		S.checkStmt(S.dbh, stmt, 'get max contacts id query:'+Std.string(S.dbh.errorInfo()));
		
		var maxCid:Int = (stmt.execute()?stmt.fetch(PDO.FETCH_COLUMN):null);
		trace('maxCid:$maxCid');
		importExtDeals('WHERE pay_plan.client_id=$client ');
		
		trace('missing deals took:' + (Sys.time()-start));
	}	

	function importAll(){ 

		var start = Sys.time();
		trace('$start $synced ${param['totalRecords']}');
		var ext_ids = getAllExtIds();
		var max_import = param['totalRecords'] != null?param['totalRecords']:Global.max(ext_ids);
		
		while(synced<max_import){
			importExtDeals();
			//trace('offset:'+ offset.int);
			//trace(param);
		}
		trace('done:' + Std.string(Sys.time()-start));
		Sys.exit(S.sendInfo(dbData, ['importContacts'=>'OK'])?1:0);
		
		
	}

	function importExtDeals(where:String='') {
		/*GET DATA FROM fly_crm */
		var sql:String = comment(unindent,format)/*
		SELECT IF(pay_plan_state='active',TRUE,FALSE) active, ${S.dbQuery.dbUser.id} edited_by,1 mandator, pay_plan_id id,pay_plan.client_id contact,pay_plan.creation_date,pay_source_id account,target_id target_account,start_day,start_date,buchungs_tag booking_day,IF(start_day='1','start','middle') booking_run,cycle,amount,IF(product='K',2,3) product ,agent,agency_project project,pay_plan_state,pay_method,end_date,end_reason,repeat_date,cycle_start_date,lead_id from pay_plan 
		LEFT JOIN clients ON clients.client_id=pay_plan.client_id
		${where} 
		ORDER BY pay_plan_id  
		${limit.sql} ${offset.sql}		
		*/;
		trace(sql);
		//Sys.exit(0);
		var stmt = S.syncDbh.query(sql);
		S.checkStmt(S.syncDbh,stmt,'importExtDeals deals');
		var dData:NativeArray = (stmt.execute()?stmt.fetchAll(PDO.FETCH_ASSOC):null);
		var cnt:Int = Global.count(dData);
		trace('all:$cnt::' + Syntax.code('count({0})',dData));
		if(cnt>0){
			var start = Sys.time();
			var cD:Map<String,Dynamic> = Util.map2fields(dData[0], keys);
			//trace(dData);
			//trace(cD);
			var cNames:Array<String> = [for(k in cD.keys()) k];		
			/* STORE fetched data in new crm */
			for(row in dData)
			{
				var stmt:PDOStatement = upsertDeal(row, cD, cNames);
				try{
					var res:NativeArray = stmt.fetchAll(PDO.FETCH_ASSOC);	
					if(!(synced>1)){
						//trace(row);
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
				trace('${offset.int} + ${synced} limit:${limit.int} all:${param['totalRecords']}');
				offset = Util.offset(synced);
				if(offset.int+limit.int>param['totalRecords'])
				{
					limit = Util.limit(param['totalRecords'] - offset.int);
				}			
				//return;
			}

			trace('done took:' + (Sys.time()-start));
			
			//dbData.dataInfo['offset'] = param['offset'] + synced;
			trace(dbData.dataInfo);
		}
		
        //S.sendData(dbData, null);
		//S.sendInfo(dbData,['missing'=> missing, 'got' => got, 'max_client_id' => maxCid]);
		
	}

	public static function importDeals(dbh:PDO, dbData:DbData, deals:NativeArray):Void 
	{
		var dealsRows:Int = Global.count(deals);
		if(dealsRows==0){
			S.sendInfo(dbData,['imported'=>0]);
		}
		//Syntax.code("count({0})",deals);
		trace('dealsRows:$dealsRows');
		//trace(dbData);
		var dD:Map<String,Dynamic> = Util.map2fields(deals[0], dKeys);
        var dNames:Array<String> = [for(k in dD.keys()) k];		
		var dPlaceholders:Array<String> =  [for(k in dNames) k].map(function (k) return ':$k');
		var dSet:String = [
			for(k in dNames.filter(function(k)return k!='id')) k
			].map(function (k) return ' "$k"=:$k').join(',');		
		var sql:String = comment(unindent, format) /*
				INSERT INTO deals (${dNames.join(',')})
				VALUES (${dPlaceholders.join(',')})
				ON CONFLICT (id) DO UPDATE
				SET $dSet returning id;
			*/;
		trace(sql);
		var stmt:PDOStatement = S.dbh.prepare(sql,Syntax.array(null));
		var synced:Int = 0;
		for(row in deals.iterator())
		{
			Util.bindClientData('deals',stmt,row,dbData);
			if(!stmt.execute()){
				trace(row);
				trace(stmt.errorInfo());
				S.sendErrors(dbData, ['execute'=>Lib.hashOfAssociativeArray(stmt.errorInfo()),
				'sql'=>sql,
				'id'=>Std.string(Syntax.code("{0}['id']",row))]);
			}
			//trace(stmt.rowCount());
			synced++;
		}
        trace('done');
		dbData.dataInfo['offset'] = Std.string(Std.parseInt(S.params.get('offset')) + synced);
		trace(dbData.dataInfo);
        //S.sendData(dbData, null);
		S.sendInfo(dbData,['imported'=>'OK:' + stmt.rowCount()]);
	}
	
	function upsertDeal(rD:NativeArray, cD:Map<String,Dynamic>, cNames:Array<String>):PDOStatement
	{
		//var cD:Map<String,Dynamic> = Util.map2fields(rD, keys);
		//trace(cD);
		//var cNames:Array<String> = [for(k in cD.keys()) k];
		//var cVals:String =  [for(v in cD.iterator()) v].map(function (v) return '\'$v\'').join(',');
		var cPlaceholders:Array<String> =  [for(k in cNames) k].map(function (k) return ':$k');
		var cSet:String = [
			for(k in cNames.filter(function(k)return k!='id')) k
			].map(function (k) return ' "$k"=:$k').join(',');
		
		var sql:String = comment(unindent, format) /*
				INSERT INTO deals (${cNames.join(',')})
				VALUES (${cPlaceholders.join(',')})
				ON CONFLICT (id) DO UPDATE
				SET $cSet returning id;
			*/;
		//trace(sql);
		//trace(untyped rD['id'] + ' lead_id:'+ untyped rD['lead_id'] + ' amount:' + untyped rD['amount']);
		//Out.dumpObject(DebugOutput.CONSOLE);
		var stmt:PDOStatement = S.dbh.prepare(sql,Syntax.array(null));
		Util.bindClientData('deals',stmt,rD,dbData);
		if(!stmt.execute()){
			trace(rD);
			trace(stmt.errorInfo());
			S.sendErrors(dbData, ['execute'=>Lib.hashOfAssociativeArray(stmt.errorInfo()),
			'sql'=>sql,
			'id'=>Std.string(Syntax.code("{0}['id']",rD))]);
		}
		synced++;
		
		//trace(rD['']);
		//trace(synced);
		return stmt;
	}	

}