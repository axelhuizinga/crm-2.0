package model.data;
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
	
	public function new(?param:Map<String,String>) 
	{
		super(param);
		trace(setValues.length);
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
	
	function insert():NativeArray
	{		
		var iData:Array<Map<String,Dynamic>> = Unserializer.run(dbData.dataInfo.get('data'));
		trace(iData[0]);
		if(param.exists('table'))
			table = param.get('table');
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
		//var dataFields = Reflect.fields(param.get('data'));
		//fields = S.tableFields(param.get('table'),S.db).filter(function(field) return dataFields.contains(field) ).map(function(field) return '${quoteIdent(field)}');
		//fields.remove('id');
		//fieldNames = fields;
		//buildValues(param.get('data'));
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
		//queryFields = fields.map(function (_)return '?').join(',');
		setSql = 'VALUES ${setPlaceholders.join(",\n")}';			
		//queryFields += fields.length > 0 ? fields.join(','):'';		
		//trace(queryFields);
		//trace(setSql);

		//S.exit({'res':'OK'});
		var sqlBf:StringBuf = new StringBuf();
		trace(queryFields);
		sqlBf.add('INSERT INTO ');
		/*if (tableNames.length>1)
		{
			S.sendErrors(dbData, ['error'=> S.errorInfo('Create with join not supported!')]);
			return null;
		}		
		else
		{
			sqlBf.add('${quoteIdent(tableNames[0])} ');
		}*/
		sqlBf.add('${quoteIdent(tableNames[0])} (${fields.join(",")}) ${setSql} ON CONFLICT DO NOTHING RETURNING id');
		if (filterSql != null)
		{
			sqlBf.add(filterSql);
		}		
		//trace(sqlBf.toString());
		return execute(sqlBf.toString());
	}

	function sync()	
	{
		trace(param);
	}
		
}