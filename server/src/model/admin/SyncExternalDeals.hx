package model.admin;
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

	public function new(param:Map<String,Dynamic>):Void
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

	function importAll(){

		var min_id:Int = S.params.get('offset');
		var got:Int = 0;
		var stmt:PDOStatement = S.dbh.query('SELECT MAX(id)max_deal, COUNT(*)previous_count FROM deals');
		var rO = stmt.fetch(PDO.FETCH_OBJ);
		var onlyNew = '';		
		if(S.params.get('onlyNew')=='true' && rO.max_deal>min_id)
		{
			onlyNew = 'AND d.id IS NULL ';
			min_id = rO.max_deal;
		}
		
		trace('max_deal:${rO.max_deal}');
		dbData.dataInfo.copy2map(rO);

		/*CLEAR fly_crm client_id's from ext_ids table*/
		var action = S.params["classPath"]+'.'+S.params["action"];
		var cleared:Int = S.dbh.exec(
			'DELETE FROM ext_ids WHERE auth_user=${S.dbQuery.dbUser.id} AND action=\'${action}\' AND table_name=\'deals\'');
		//trace('DELETE FROM ext_ids WHERE auth_user=${S.dbQuery.dbUser.id} AND action=\'${action}\' AND table_name=\'deals\'');

		/*GET NEXT  ${Util.limit()} pay_plan_id's from fly_crm*/			
		var sql:String = '
		(SELECT pay_plan_id FROM pay_plan 
		WHERE pay_plan_id>${min_id} LIMIT  ${Util.limit()})
		UNION
		(SELECT MAX(pay_plan_id) FROM pay_plan)';
		//trace(sql);
		var start = Sys.time();
        stmt = S.syncDbh.query(sql);
		// DIE ON ERROR
		S.checkStmt(S.syncDbh, stmt, 'getMissing-pay_plan_ids');
				
		var cids:Array<Dynamic> = Lib.toHaxeArray(stmt.execute()?stmt.fetchAll(PDO.FETCH_NUM):null);	
		if(cids!=null)
			trace(cids.length);
		var maxCid = (cids.length==1? cids[0][0] : cids.pop()[0]);
		
		trace(maxCid + ' took:' + (Sys.time()-start));
		start = Sys.time();
		for(cid in cids){
			//var sti:PDOStatement = S.dbh.query('INSERT IGNORE INTO ext_ids VALUES(${cid[0]}, ${S.dbQuery.dbUser.id}, \'${action}\',\'deals\')');
			var sti:PDOStatement = S.dbh.prepare('INSERT INTO ext_ids VALUES(?,?,?,?) ON CONFLICT DO NOTHING');			
			if(untyped sti==false)
			{
				trace(S.dbh.errorInfo);
				trace('INSERT INTO ext_ids VALUES(${cid[0]}, ${S.dbQuery.dbUser.id}, \'${action}\',\'deals\')');
				S.exit({oops:666});
			}
			//var args:Array<Dynamic> = [cid[0], S.dbQuery.dbUser.id, action,'deals'];
			if(! sti.execute(
				//args.toPhpArray())){
				Syntax.code("array({0},{1},{2},{3})",cid[0], S.dbQuery.dbUser.id, action,'deals'))){
				trace(S.dbh.errorInfo());
				trace(sti.errorInfo());
				S.exit({oops:666});
			}
		}
		trace(cids.length + ' storing took:' + (Sys.time()-start));
		start = Sys.time();
		sql = comment(unindent, format)/* 
		SELECT ARRAY_TO_STRING(array_agg(eid.ext_id),',') from ext_ids eid
		left join 
		(SELECT 1 as gg,id from deals) d
		ON eid.ext_id=d.id
		WHERE eid.table_name='deals'
		${onlyNew}
		AND eid.action='${S.params["classPath"]}.${S.params["action"]}'		
		GROUP BY gg;
		*/;
		stmt = S.dbh.query(sql);
		trace(sql);
		S.checkStmt(S.dbh,stmt,'getMissingIDs ');
		
		var ids:String = (stmt.execute()?stmt.fetch(PDO.FETCH_COLUMN,0):null);
		
		trace(ids.substr(0, 24) + 'took:' + (Sys.time()-start));
		start = Sys.time();
		
		/*GET DATA FROM fly_crm */
		sql = comment(unindent,format)/*
		SELECT pay_plan_id id,pay_plan.client_id contact,pay_plan.creation_date,pay_source_id,target_id,start_day,start_date,buchungs_tag,cycle,amount,IF(product='K',2,3) product ,agent,agency_project project,pay_plan_state,pay_method,end_date,end_reason,repeat_date,cycle_start_date, cl.old_active from pay_plan 
		INNER JOIN clients cl
		ON cl.client_id=pay_plan.client_id 
		WHERE pay_plan_id IN($ids)
		ORDER BY pay_plan_id  
*/;

        stmt = S.syncDbh.query(sql);
		if(untyped stmt==false)
		{
			trace(sql.substr(0, 1100));
			S.sendErrors(dbData, ['getMissingCrmData deals:'=>S.syncDbh.errorInfo()]);
		}
		if(stmt.errorCode() !='00000')
		{
			S.sendErrors(dbData,['getMissingCrmData deals'=>stmt.errorInfo()]);
		}
		var res = (stmt.execute()?stmt.fetchAll(PDO.FETCH_ASSOC):null);
		var missing:Int = (res!=null?Global.count(res):0);
		if(missing==0){
			S.sendInfo(dbData,['OK? found 0 missing deals '=> sql.substr(0,1100)]);
		}
		trace(missing + ' took:' + (Sys.time()-start));
		var last_import_cid = Syntax.code("{0}[{1}]['id']",res,missing-1);
		dbData.dataInfo.set('last_import_cid', last_import_cid);
		start = Sys.time();
		
		/* STORE fetched data in new crm */
		for(row in res.iterator())
		{			
			//trace(row);
			//S.sendErrors(dbData,['syncAll'=>'NOTOK']);
			var stmt:PDOStatement = upsertDeal(row);
			try{
				//trace(Global.count(res));
				var res:NativeArray = stmt.fetch(PDO.FETCH_NUM);		
				got++;
				if(got<3)
				trace('got $got missing :)' + res);
				//var res:NativeArray = stmt.fetchAll(PDO.FETCH_ASSOC);		
			}
			catch(e:Dynamic)
			{
				{S.sendErrors(dbData, [
					'dbError'=>S.dbh.errorInfo(),
					'upsertDeal'=>S.errorInfo(row),
					'exception'=>e
				]);}		
			}
		}		
		trace('done took:' + (Sys.time()-start));
		
		//dbData.dataInfo['offset'] = param['offset'] + synced;
		trace(dbData.dataInfo);
        //S.sendData(dbData, null);
		S.sendInfo(dbData,['missing'=> missing, 'got' => got, 'max_client_id' => maxCid]);
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
		dbData.dataInfo['offset'] = Std.parseInt(S.params.get('offset')) + synced;
		trace(dbData.dataInfo);
        //S.sendData(dbData, null);
		S.sendInfo(dbData,['imported'=>'OK:' + stmt.rowCount()]);
	}
	
	function upsertDeal(rD:NativeArray):PDOStatement
	{
		var cD:Map<String,Dynamic> = Util.map2fields(rD, keys);
		var cNames:Array<String> = [for(k in cD.keys()) k];
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
		return stmt;
	}	

}