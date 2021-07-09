package model.data;
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
	
	public function new(?param:Map<String,Dynamic>) 
	{
		super(param);
		trace(setValues.length);
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
			case 'sync':
				sync();
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
			trace(Std.string(dataSource));
			var tKeys:Iterator<String> = dataSource.keys();
			while(tKeys.hasNext())
			{
				var tableName = tKeys.next();
				tableNames.push(tableName);
				var tableProps:DataSource = dataSource.get(tableName);
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

		}				
		if (tableNames.length>1)
		{
			joinSql = buildJoin();
		}			
		trace('${action}:' + tableNames.toString());
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
		trace(table+':'+dbData.dataInfo);		
		//var iData:Dynamic = Unserializer.run(dbData.dataInfo.get('data'));
		var iData:Array<Map<String,Dynamic>> = Unserializer.run(dbData.dataInfo.get('data'));
		//var iData:Array<Map<String,Dynamic>> = dbData.dataInfo.get('data');
		if(iData==null)
			S.sendInfo(dbData);		
		trace(iData[0]);
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
		else
			tableNames = [];
		var fields:Array<String> = [];
		var ids:Array<String> = [];
		var setPlaceholders:Array<String> = [];
		var ri:Int=1;
		var tableFields:Array<String> = S.tableFields(tableNames[0]);
		for(row in iData){
			setValues = new Array();
			if(ri++==1){
				for (k in row.keys())
					if(tableFields.contains(k))
						fields.push(k);
				var rps = fields.map( function(_) return '?').join(',');
				setPlaceholders.push('($rps)');
			}			
			for( f in fields){
				setValues.push(row.get(f));
			}
			setSql = 'VALUES ${setPlaceholders.join(",\n")}';
			var sqlBf:StringBuf = new StringBuf();
			//trace(queryFields);
			sqlBf.add('INSERT INTO ');
			sqlBf.add('${quoteIdent(tableNames[0])} (${fields.join(",")}) ${setSql} ON CONFLICT (ba_id) DO UPDATE SET sepa_code=\'${setValues[3]}\' RETURNING id');			
			//trace(sqlBf.toString());
			//trace(setValues.toString());
			ids.push(cast untyped execute(sqlBf.toString(),true, PDO.FETCH_COLUMN)[0]);
		}
		//trace(ids);
		dbData.dataInfo = ['data' => ids ];
		trace(dbData);
		S.sendData(dbData);
		//return ids;
	}

	function sync()	
	{
		//trace(param);
		var returnReasons = Lib.toHaxeArray( S.dbh.query(
			'SELECT code FROM sepa_return_codes WHERE locale="de_DE"').fetchAll(PDO.FETCH_COLUMN));
		trace(returnReasons.join('|'));
	}
		
}