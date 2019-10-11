package model.admin;
import comments.CommentString.*;
import php.db.PDO;
import php.db.PDOStatement;
import php.Lib;
import php.NativeArray;
import php.Syntax;
import shared.DbData;

class SyncExternalDeals {

	static var dKeys:Array<String> =  S.tableFields('deals');

	public static function importDeals(dbh:PDO, dbData:DbData, deals:NativeArray):Void 
	{
		
		var dealsRows:Int = Syntax.code("count({0})",deals);
		trace('dealsRows:$dealsRows');
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
		var stmt:PDOStatement = S.dbh.prepare(sql,Syntax.array(null));
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
		}
        trace('done');
		//dbData.dataInfo['offset'] = param['offset'] + synced;
		trace(dbData.dataInfo);
        //S.sendData(dbData, null);
		S.sendInfo(dbData,['imported'=>'OK:' + stmt.rowCount()]);
	}
	

}