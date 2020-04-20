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


class SyncExternalAccounts extends Model 
{
	static var keys:Array<String> = S.tableFields('accounts');	
	var synced:Int;

	public function new(param:Map<String,Dynamic>):Void
	{
		super(param);	
		if(param.exists('synced'))
		{
			synced = cast param['synced'];
		}
		else synced = 0;
		//trace(action);
		//SWITCH Call either an instance method directly or use the shared Model query execution
		switch(action ){
			//case 'syncAccounts':
			case 'syncAll':
				syncAll();				
			case _:
				run();
		}		
	}

	public function  getMissing():String {
		//GET ALL client_id's from ViciBox fly_crm db accounts
		var sql:String = '
SELECT DISTINCT(cl.client_id) FROM clients cl 
INNER JOIN pay_source ps 
ON ps.client_id = cl.client_id;';
        var stmt:PDOStatement = S.syncDbh.query(sql);
		if(untyped stmt==false)
		{
			trace(S.syncDbh.errorInfo());
			S.sendErrors(dbData, ['getMissing query:'=>S.syncDbh.errorInfo()]);
		}
		if(stmt.errorCode() !='00000')
		{
			trace(stmt.errorInfo());
		}
		var res:NativeArray = (stmt.execute()?stmt.fetchAll(PDO.FETCH_NUM):null);	
		
		trace(Syntax.code("count({0})",res));
				
		var cleared:Int = S.dbh.exec('CREATE TEMP TABLE account_contact_ids(id BIGINT)');
		if(S.dbh.errorCode() !='00000')
		{
			trace(S.dbh.errorInfo());
		}
		else 	
			trace('created temp table account_contact_ids');
		var cIDs:NativeArray = Syntax.code("array_map(function($r){return $r[0];}, {0})",res);
		trace(Syntax.code("print_r({0}[0],1)", cIDs));
		var ok:Bool = S.dbh.pgsqlCopyFromArray("account_contact_ids",cIDs);
		if(!ok)
		{
			trace(S.dbh.errorInfo());
		}
		if(S.dbh.errorCode() !='00000')
		{
			trace(S.dbh.errorInfo());
		}
		// SELECT ALL contacts ids which are not in the already existing accounts
		sql = comment(unindent, format)/* 
		SELECT ARRAY_TO_STRING(array_agg(acid.id),',') from account_contact_ids acid
		left join 
		(SELECT 1 as gg,id accounts) c
		ON acid.id=c.id
		where c.id IS NULL
		GROUP BY gg;
		*/;
		stmt = S.dbh.query(sql);
		if(untyped stmt==false)
		{
			trace('$sql ${Std.parseInt(S.dbQuery.dbParams['limit'])}');
			S.sendErrors(dbData, ['getMissingIDs query:'=>S.syncDbh.errorInfo()]);
		}
		if(stmt.errorCode() !='00000')
		{
			trace(stmt.errorInfo());
		}
		var ids:String = (stmt.execute()?stmt.fetch(PDO.FETCH_COLUMN,0):null);
		trace(ids);
		return ids;
	}

	/**
	 * Import or Update accounts
	 */

	function syncAll() {
		trace(param);
		trace(param);
		if(param['offset']==null)
			param['offset'] = '0';
		if(param['limit']==null)			
			param['limit'] = '1000';
		if(Std.parseInt(param['offset'])+Std.parseInt(param['limit'])>Std.parseInt(param['maxImport']))
		{
			param['limit'] = Std.string(Std.parseInt(param['maxImport']) - Std.parseInt(param['offset']));
		}
		trace(param);		
		var ids:String = getMissing();
		// GET ViciBox fly_crm db account data
		var sql:String = comment(unindent,format)/*
		SELECT * FROM pay_source WHERE client_id IN($ids)
		ORDER BY client_id LIMIT  
*/;

		var stmt:PDOStatement = S.syncDbh.query('$sql ${Std.parseInt(param['limit'])} OFFSET ${Std.parseInt(param['offset'])}');
		trace('loading  ${Std.parseInt(param['limit'])} OFFSET ${Std.parseInt(param['offset'])}');		
		if(untyped stmt==false)
		{
			trace(sql);
			S.sendErrors(dbData, ['getMissingAccounts data:'=>S.syncDbh.errorInfo()]);
		}
		if(stmt.errorCode() !='00000')
		{
			S.sendErrors(dbData,['getMissingAccounts data'=>stmt.errorInfo()]);
		}
		var res:NativeArray = (stmt.execute()?stmt.fetchAll(PDO.FETCH_ASSOC):null);
		var got:Int = Syntax.code("count({0})",res);
		trace(got);
		for(row in res.iterator())
		{			
			//trace(row);
			//S.sendErrors(dbData,['syncAll'=>'NOTOK']);
			var stmt:PDOStatement = upsertAccount(row);
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
		trace(dbData.dataInfo);

		importAccountData(res);
		S.sendErrors(dbData,['syncAccounts'=>'NOTOK']);				
		S.sendInfo(dbData,['syncUserDetail'=>'no results???']);
	}

	public function syncBankTransferRequests():Void
    {
		var res:NativeArray = fetchAll('SELECT * FROM `buchungs_anforderungen`',S.syncDbh,'syncBankTransferRequests',PDO.FETCH_NUM);
		trace(res);
		if(res != null)
		{
			//sendRows(res);
			var updated:Int = 0;//syncUserIds(res);
			S.sendInfo(dbData,['syncUserDetail'=>'DONE $updated']);
		}
			
		else 
			S.sendInfo(dbData,['syncUserDetail'=>'no results???']);
		trace('done');
	}
	
	public function importAccountData(cData:NativeArray):Void
	{
		//var cData:NativeArray = getAccountData();
		//trace(cData[0]);        
		//var rows:KeyValueIterator<Int,NativeAssocArray<Dynamic>> = result.keyValueIterator();
		for(row in cData.iterator())
		{			
			//trace(row);
			//S.sendErrors(dbData,['syncAll'=>'NOTOK']);
			var stmt:PDOStatement = upsertAccount(row);
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
	
	function upsertAccount(rD:NativeArray):PDOStatement
	{
		var cD:Map<String,Dynamic> = Util.map2fields(rD, S.syncTableFields('pay_source'));
		var cNames:Array<String> = [for(k in cD.keys()) k];
		//var cVals:String =  [for(v in cD.iterator()) v].map(function (v) return '\'$v\'').join(',');
		var cPlaceholders:Array<String> =  [for(k in cNames) k].map(function (k) return ':$k');
		var cSet:String = [
			for(k in cNames.filter(function(k)return k!='id')) k
			].map(function (k) {
				return (k=='merged'?
				'"$k"=:IF(array_length("merged",1)>0 THEN "merged" ELSE $k)'
				:' "$k"=:$k');}).join(',');
		
		var sql:String = comment(unindent, format) /*
				INSERT INTO accounts (${cNames.join(',')})
				VALUES (${cPlaceholders.join(',')})
				ON CONFLICT (id) DO UPDATE
				SET $cSet returning id;	
			*/;
		trace(sql);
		trace(cSet);

		var stmt:PDOStatement = S.dbh.prepare(sql,Syntax.array(null));
		Util.bindClientData('accounts',stmt,rD,dbData);
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
	
}