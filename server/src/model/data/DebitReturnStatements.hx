package model.data;
import haxe.Exception;
import shared.DbData;
import php.Global;
import db.DataSource;
import db.DbRelation;
import php.Syntax;
import haxe.ds.StringMap;
import haxe.ds.IntMap;
import haxe.Unserializer;
import php.Lib;
import php.db.PDOStatement;
import php.db.PDO;
import comments.CommentString.*;

import php.NativeArray;

using Lambda;
using Util;

/**
 * ...
 * @author axel@cunity.me
 */

class DebitReturnStatements extends Model
{
	private static var vicdial_list_fields = 'lead_id,entry_date,modify_date,status,user,vendor_lead_code,source_id,list_id,gmt_offset_now,called_since_last_reset,phone_code,phone_number,title,first_name,middle_initial,last_name,address1,address2,address3,city,state,province,postal_code,country_code,gender,date_of_birth,alt_phone,email,security_phrase,comments,called_count,last_local_call_time,rank,owner,entry_list_id'.split(',');		
	
	var iData:Array<Map<String,Dynamic>>;
	var rbaIds:Array<String>;
	var returnReasons:Array<Dynamic>;

	//public function new(?param:Map<String,String>, ?ipost:Map<String,Dynamic>) 
	public function new(?param:Map<String,String>) 
	{
		super(param);
		//trace(setValues.length);
		rbaIds = [];
		returnReasons = Lib.toHaxeArray( S.dbh.query(
			"SELECT code FROM sepa_return_codes WHERE locale='de_DE'").fetchAll(PDO.FETCH_COLUMN));
		trace(returnReasons.join('|'));
		if(param.exists('table'))
			table = param.get('table');
		go();
	}

	function go():Void {
		trace(action);
		switch(action ){
			case 'get':
				get();
			case 'insert':
				insert();
			//case 'sync':
				//sync();
			case _: 
				run();
		}		
	}	

	override function get() {
		var fields:Array<String> = [];
		trace(param.toString());
		if(param.get('dataSource') != null)
		{
			dataSource = Unserializer.run(param.get('dataSource'));
		}
		var fields:Array<String> = [];
		if(dataSource != null)
		{
			try{				
				trace(Reflect.hasField(dataSource,'keys')?'Y':'N');
				if(Std.isOfType(dataSource,String)){
					trace(cast(dataSource, String));
					//trace(Unserializer.run(cast(dataSource, String)));
					dataSource = Unserializer.run(param.get('dataSource'));
					trace(Reflect.hasField(dataSource,'keys')?'Y':'N');
					//return;
				}
				//trace(Std.isOfType(dataSource,String));
				//trace(dataSource);
				var tKeys:Iterator<String> = dataSource.keys();
				while(tKeys.hasNext())
				{
					var tableName = tKeys.next();
					tableNames.push(tableName);
					var tableProps:Map<String,Dynamic> = dataSource.get(tableName);
					trace(Std.string(tableProps));

					fields = fields.concat(buildFieldsSql(tableName, tableProps));
					/*if(action == 'create')
					{
						fields.remove('id');
						fieldNames = fields;
						buildValues(tableProps.get('data'));
						setSql = fields.map(function (_)return '?').join(',');
						setSql = '($setSql)';
					}*/
					if(tableProps.exists('filter'))
						filterSql += buildCond(tableProps.get('filter'));
					trace('filterSql:$filterSql::${1}');
				}			
				queryFields += fields.length > 0 ? fields.join(','):'';
			}catch(ex:Exception){
				trace(ex.details());
				trace(cast(dataSource, String));
				//trace(Type.typeof(dataSource));
				
			}

		}				
		if (tableNames.length>1)
		{
			joinSql = buildJoin();
		}			
		trace('${action}:' + tableNames.join('|'));
		trace(queryFields);		
		trace(setSql);	
		super.get();
	}

	public function getStati(ids:Array<Int>,mandator:Int):Dynamic{
		var endReasons:IntMap<String> = untyped Lib.hashOfAssociativeArray(query(
			'SELECT id,reason FROM end_reasons WHERE mandator=${param.get('mandator')}'));
		trace(endReasons);
		var affectedDeals:StringMap<Dynamic> = Lib.hashOfAssociativeArray(query(
			'SELECT id,contact,end_reason, repeat_date FROM deals WHERE contact IN(${ids.join(',')})
			AND mandator=${param.get('mandator')}'
		));
		trace(affectedDeals);
		return ['dummy'=>666];
	}
	
	function insert():Void//Array<String>
	{		
		//trace(table+':'+dbData.dataInfo.get('data'));		
		trace(table+':'+dbData.dataInfo);		
		//var iData:Dynamic = Unserializer.run(dbData.dataInfo.get('data'));
		iData = Unserializer.run(dbData.dataInfo.get('data'));
		//var iData:Array<Map<String,Dynamic>> = dbData.dataInfo.get('data');
		if(iData==null)
			S.sendInfo(dbData);		
		trace(iData[0]);
		
		//dbData.dataInfoRows = new Map<String,Dynamic>();//,'statementBaIds' => statementBaIds];
		dbData.dataInfo['rows'] = Std.string(iData.length);//,'statementBaIds' => statementBaIds];
		//dbData.dataInfo = ['inserted' => new Map<String,Dynamic>(), 'rows' => iData.length ];//,'statementBaIds' => statementBaIds];
		trace(Type.typeof(iData[0]));
		if(table != null)
		{
			fieldNames = param.exists('fields')? 
				param.get('fields').split(',').map(function (f)return quoteIdent(f)): 
				S.tableFields(table).map(function (f)return quoteIdent(f));
			tableNames = [table];
			queryFields = fieldNames.join(',');
			trace(queryFields);
		}
		//else
			//tableNames = [];
		var fields:Array<String> = [];		
		var ids:Array<String> = [];
		var statementBaIds:Array<String> = [];
		var tableFields:Array<String> = S.tableFields(tableNames[0]);		
		for (k in iData.iterator().next().keys())
			if(tableFields.contains(k))
				fields.push(k);
		var rps = fields.map( function(_) return '?').join(',');
		var setPlaceholders:String = '($rps)';
		
		for(row in iData){
			statementBaIds.push(row['ba_id']);
			setValues = new Array();
		
			for( f in fields){
				setValues.push(row.get(f));
			}
			setSql = 'VALUES ${setPlaceholders}';
			var sqlBf:StringBuf = new StringBuf();
			//trace(queryFields);
			sqlBf.add('INSERT INTO ');
			sqlBf.add('${quoteIdent(tableNames[0])} (${fields.join(",")}) ${setSql} ON CONFLICT DO NOTHING RETURNING ba_id');	
			var data:NativeArray = execute(sqlBf.toString(),true, PDO.FETCH_COLUMN);
			if(data == null || !data.iterator().hasNext()){
				// INSERT failed
				trace(sqlBf.toString());
				trace(S.dbh.errorInfo());
				/*dbData.dataInfo['inserted'][row['ba_id']] = 'INSERT failed4:' + row['ba_id'] + '::' + (
					S.dbh.errorInfo()[2] == null ? 
					' schon eingetragen!' : 
					Std.string(S.dbh.errorInfo())
				);*/
				continue;
			}
			var rba_id:String = data[0];
			ids.push(rba_id);
		}
		//trace(ids);
		trace(dbData);
		sync();
		S.sendInfo(new DbData(),dbData.dataInfo);
		//S.sendData(dbData);
		//return ids;
	}
	
	//function sync(ba_ID:String, sepa_code)	
	function sync()
	{
		//trace(param);
		for(row in iData){
			switch (row['sepa_code']){
				case 'RR01'|'RR02'|'RR03'|'RR04'|'BE01'|'BE05'|'MD01'|'MD02'|'FF05'|'FF01':
					// UNGÜLTIGES MANDAT ODER FEHLERHAFTE ANGABEN
					deactivateInvalidMandate(row);
				case 'AC04'|'MD07':
					// KONTO AUFGELÖST
					deactivateCancelledAccount(row);
				case 'AC06'|'MD06'|'MS02'|'SL01':
					// WIDERSPRUCH
					deactivateObjection(row);
				case 'AC01'|'RC01':
					// Falsche IBAN (oder BIC)
					deactivateIBANerror(row);
				case 'MS03'|'AM04'|'AM05'|'AC13'|'AG01'|'AG02':
					// SONSTIGE
					syncOther(row);
			}
		}
	}

	function deactivateCancelledAccount(drs:Map<String,Dynamic>) {	}
	function deactivateObjection(drs:Map<String,Dynamic>) {
		trace(drs['id'] + ':' + drs['sepa_code']);				
	}
	
	function deactivateIBANerror(drs:Map<String,Dynamic>) {	}
	function syncOther(drs:Map<String,Dynamic>) {	
		trace(drs['id'] + ':' + drs['sepa_code']);		
	}


	function deactivateInvalidMandate(drs:Map<String,Dynamic>) {

	}
		
}