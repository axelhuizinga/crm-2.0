package model.view;
import me.cunity.debug.Out;
import db.DbUser;
import haxe.Exception;
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
class Forms extends Model
{
	public function new(param:Map<String,Dynamic>):Void
	{
		super(param);			
		trace(param);
		switch(action ){
			case 'getView':
				getView();			
			case 'setView':
				setView();
			case _:
				trace('not implemented');
		}		
	}
	
	public function getView()
	{
		
		var sql =  comment(unindent, format) /*
				SELECT encode(hxbytes, 'hex') hxbytes FROM ux_config 
				WHERE ux_class_path = 'model.deals.DealsModel'
				AND mandator = ${param.get('dbUser').mandator}
				*/;
		trace(sql);
		var stmt:PDOStatement = S.dbh.query(sql, PDO.FETCH_ASSOC);
		if (untyped stmt == false)
		{
			trace(S.dbh.errorInfo());
			//S.send(Serializer.run(['error'=>S.dbh.errorInfo()]));
		}
		var viewFields:NativeArray = stmt.fetch(PDO.FETCH_ASSOC);//DB.serializeRows(
		for(col=>v in viewFields.keyValueIterator()){
			trace('$col => $v');
		}
		//var hFields:Array<Dynamic> = Lib.toHaxeArray(viewFields);
		trace('viewFields found: ' + stmt.rowCount());		
		var rData:RData =  {
			info:['count'=>Std.string(Global.count(viewFields))],
			rows: Syntax.array(viewFields)
		};
		trace(rData);
		trace(dbData);
		S.sendData(dbData, rData);
	}
	
	public function setView()
	{
		trace(param);
		var dbUser:DbUser = param.get('dbUser');
		var data:Dynamic = param.get('data');
		var rD = Lib.associativeArrayOfObject({
			edited_by:dbUser.id,
			ux_class_path:data.ux_class_path,
			hxbytes:data.hxbytes,
			mandator:dbUser.mandator
		});
		var cNames:Array<String> = ['ux_class_path','edited_by','mandator','hxbytes'];
		var cPlaceholders:Array<String> =  [for(k in cNames) k].map(function (k) return ':$k');
		var cSet:String = [
			for(k in cNames.filter(function(k)return k!='id')) k
			].map(function (k) return ' "$k"=:$k').join(',');

		var sql:String = comment(unindent, format) /*
			INSERT INTO "crm"."ux_config" (${cNames.join(',')})
			VALUES (${cPlaceholders.join(',')})
			ON CONFLICT ON CONSTRAINT class_id DO UPDATE
			SET $cSet returning id;
		*/;

		var stmt:PDOStatement = S.dbh.prepare(sql,Syntax.array(null));
		Util.bindClientData('ux_config',stmt,rD,dbData);
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
		return stmt;		
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