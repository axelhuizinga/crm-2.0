package model.admin;

import php.Global;
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

	function getAllExtIds():NativeArray {
		var offset:Int = ( param['offset']>0?param['offset']:0);
		var sql:String = 'SELECT pay_source_id id FROM pay_source ORDER BY pay_source_id';
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

	public function getMissing():Map<String,Int> {
		
		//return Lib.hashOfAssociativeArray(res);
		return null;
	}

	/**
I kno	 * Import or Update accounts
	 */

	function syncAll() {
		var start = Sys.time();
		getAllExtIds();
		trace('$start $synced ${param['totalRecords']}');
		if(offset.int+limit.int>param['totalRecords'])
		{
			limit = Util.limit(param['totalRecords'] - offset.int);
		}		

		while(synced<param['totalRecords']){
			importExtAccounts();
			trace('offset:'+ offset.int);
			trace(param);
		}
		trace('done:' + Std.string(Sys.time()-start));
		Sys.exit(untyped ['syncAccounts'=>'OK']);
	}		
		//var ids:Map<String,Int> = getMissing();
	function importExtAccounts() {
		// GET ViciBox fly_crm db account data
		var sql:String = comment(unindent,format)/*
		SELECT pay_source_id id, client_id contact, debtor account_holder,bank_name,account,blz bic,iban,sign_date, pay_source_state status,creation_date, ${S.dbQuery.dbUser.id} edited_by,1 mandator FROM pay_source 
		ORDER BY id 
		${limit.sql} ${offset.sql}		
		*/;
		trace(sql);
		var stmt:PDOStatement = S.syncDbh.query(sql);
		trace('loading  ${limit.sql} ${offset.sql}');		
		S.checkStmt(S.syncDbh, stmt,'importExtAccounts data:');
		var res:NativeArray = (stmt.execute()?stmt.fetchAll(PDO.FETCH_ASSOC):null);
		offset = Util.offset(offset.int + Syntax.code("count({0})",res));
		//return res;
		trace('id:' + Type.typeof(untyped res[0]['id']));
		var cD:Map<String,Dynamic> = Util.map2fields(res[0], keys);
		//trace(cD);
		var cNames:Array<String> = [for(k in cD.keys()) k];
		//trace(cNames);
		var _1st:Bool = true;
		for(row in res.iterator())
		{			
			stmt = upsertAccount(row, cD, cNames);
			try{
				var res:NativeArray = stmt.fetchAll(PDO.FETCH_ASSOC);
				if(_1st){
					_1st=false;
					trace(row);
					trace(res);
					//Sys.exit(333);
				}		
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
		trace('${offset.int} + ${synced}');
		offset = Util.offset(synced);
		if(offset.int+limit.int>param['totalRecords'])
		{
			limit = Util.limit(param['totalRecords'] - offset.int);
			trace('${offset.int} + ${synced}');
		}			
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
	
	/*public function importAccountData(cData:NativeArray):Void
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
	}*/
	
	function upsertAccount(rD:NativeArray, cD:Map<String,Dynamic>, cNames:Array<String>):PDOStatement
	{
		//var cVals:String =  [for(v in cD.iterator()) v].map(function (v) return '\'$v\'').join(',');
		//for(k in cNames.filter(function(k)return k!='id')) k
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
		//trace(sql);
		//trace(cSet);
		//trace(Lib.toHaxeArray(rD).length);

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