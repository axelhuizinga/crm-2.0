package model.data;
import haxe.ds.StringMap;
import haxe.ds.IntMap;
import haxe.Unserializer;
import php.Lib;
import php.db.PDOStatement;
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
			case 'insert':
				insert();
			case 'sync':
				sync();
			case _: 
				run();
		}		
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
	
	function insert():NativeArray
	{		
		var iData:Array<Map<String,Dynamic>> = Unserializer.run(dbData.dataInfo.get('data'));
		if(iData==null)
			return null;
		trace(iData[0]);

		if(table != null)
		{
			fieldNames = param.exists('fields')? 
				param.get('fields').split(',').map(function (f)return quoteIdent(f)): 
				S.tableFields(table).map(function (f)return quoteIdent(f));
			tableNames = [table];
			queryFields = fieldNames.join(',');
			trace(tableNames);
		}
		else
			tableNames = [];
		var fields:Array<String> = [];
		for (k in iData[0].keys())
			fields.push(k);
		trace(setValues.length);
		var setPlaceholders:Array<String> = [];
		var rps = fields.map( function(_) return '?').join(',');
		for(row in iData){
			setPlaceholders.push('($rps)');
			for( f in fields){
				setValues.push(row.get(f));
			}
		}
		trace(setValues.length);
		setSql = 'VALUES ${setPlaceholders.join(",\n")}';
		var sqlBf:StringBuf = new StringBuf();
		trace(queryFields);
		sqlBf.add('INSERT INTO ');
		sqlBf.add('${quoteIdent(tableNames[0])} (${fields.join(",")}) ${setSql} ON CONFLICT DO NOTHING RETURNING id');
		return execute(sqlBf.toString());
	}

	function sync()	
	{
		//trace(param);
	}
		
}