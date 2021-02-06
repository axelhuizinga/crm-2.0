package model.tools;
import Model.RData;
import php.Global;
import haxe.io.Bytes;
import hxbit.Serializer;

import php.Lib;
import php.NativeArray;
import php.Syntax;
import comments.CommentString.*;
import php.Web;
import php.db.PDO;
import php.db.PDOStatement;
import shared.DbData;
import sys.io.File;

/**
 * ...
 * @author axel@bi4.me
 */
class Jsonb extends Model
{
	public function new(param:Map<String,Dynamic>):Void
	{
		super(param);	
		//self.table = 'columns';
		//trace('calling ${action}');
		//trace(action);
		//SWITCH Call either an instance method directly or use the shared Model query execution
		switch(action ){
			case 'getView':
				getView();			
			//case 'syncAll':
				//syncAll();
			case _:
				trace('not implemented');
		}		
	}
	
	public function getView()
	{
		
		var sql =  comment(unindent, format) /*
				SELECT "views"."key",content FROM views 
				WHERE "views"."classPath" = 'model.deals.DealsModel'
				*/;
		trace(sql);
		var stmt:PDOStatement = S.dbh.query(sql, PDO.FETCH_ASSOC);
		if (untyped stmt == false)
		{
			trace(S.dbh.errorInfo());
			//S.send(Serializer.run(['error'=>S.dbh.errorInfo()]));
		}
		var viewFields:NativeArray = stmt.fetchAll(PDO.FETCH_ASSOC);//DB.serializeRows(
		/*for(row in viewFields.iterator()){

		}
		var hFields:Array<Dynamic> = Lib.toHaxeArray(viewFields):*/
		trace('viewFields found: ' + stmt.rowCount());		
		var rData:RData =  {
			info:['count'=>Std.string(Global.count(viewFields))],
			rows: viewFields
		};
		S.sendData(dbData, rData);
	}
	
	public function updateFieldsTable(tableFields:Map<String,String>)
	{
		var tableNames:Iterator<String> = tableFields.keys();
		while (tableNames.hasNext())
		{
			var tableName:String = tableNames.next();
			var fieldNames:String = tableFields[tableName];
			var fields:Array<String> = fieldNames.split(',');
			var sqlFields:Array<String> = fields.map(function(f:String){
				var s:String = comment(unindent, format) /*
				'${f}','{}'::jsonb
				*/;
				return s;
			});			
			var fieldsSql = sqlFields.join(",");
			var sql = comment(unindent, format) /*
			INSERT INTO crm.table_fields VALUES (DEFAULT, '$tableName','{$fieldNames}', jsonb_build_object($fieldsSql), 1)
			ON CONFLICT (table_name) DO UPDATE SET field_names='{$fieldNames}', field_hints=jsonb_build_object($fieldsSql)
			*/;
			for (field in fields)
			{
				sql = comment(unindent, format) /*
				INSERT INTO crm.table_fields VALUES (DEFAULT, '$tableName','$field', jsonb_build_object($fieldsSql), 1)
				ON CONFLICT (table_name) DO UPDATE SET field_names='{$fieldNames}', field_hints=jsonb_build_object($fieldsSql)
				*/;				
				trace(sql);
				var res:PDOStatement = S.dbh.query(sql);
				if (untyped res == false)
				{
					trace(S.dbh.errorInfo());
					//S.send(Serializer.run(['error'=>S.dbh.errorInfo()]));
				}
				trace('Inserted ${tableName}: ' + res.rowCount());				
			}
		}
	}		
	
	public function saveTableFields()
	{
		var dBytes:Bytes = Bytes.ofString(param.get('dbData'));
		var s:Serializer = new Serializer();
		var pData:DbData = s.unserialize(dBytes, DbData);
		trace(pData.dataParams);
		var updated:Int = 0;
		for (k in pData.dataParams.keys())
		{
			//updateFieldsTable(pData.dataParams[k];
			var fields:String = S.dbh.quote(param.get('fields'), PDO.PARAM_STR);
			
			var sql = comment(unindent, format) /*
			UPDATE crm.table_fields SET $fields WHERE id=${Std.parseInt(k)}
			*/;
			
			var stmt:PDOStatement = S.dbh.prepare(sql, Util.initNativeArray());
			if( !Model.paramExecute(stmt, Lib.associativeArrayOfHash(pData.dataParams[k])))
			{
				S.sendErrors(dbData,['${action}' => stmt.errorInfo()]);
			}
			if(stmt.rowCount()==1)
			{
				updated++;
			}
		}
		S.sendInfo(dbData, ['saveTableFields' => 'OK', 'updatedRows' => updated]);
	}
}