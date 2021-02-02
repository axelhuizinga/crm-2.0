package model.admin;
import comments.CommentString.*;
import php.db.PDO;
import php.db.PDOStatement;
import php.Lib;
import php.NativeArray;
import php.Syntax;
import shared.DbData;

class SyncExternalBookings extends Model{

	static var dKeys:Array<String> =  S.tableFields('bank_transfers');
	//var keys:Array<String>;	
	var synced:Int;
	public function new(param:Map<String,String>):Void
	{
		super(param);
		tableNames[0] = param.get('table');
		param['offset'] = Std.string(count());
		//self.table = 'columns';

		if(param.exists('offset'))
		{
			synced = cast param['offset'];
		}
		else synced = 0;
		//keys = S.tableFields('contacts');
        trace('calling ${action}');
		trace(action);
		//SWITCH Call either an instance method directly or use the shared Model query execution
		switch(action ){	
			case 'syncAll':
				syncAll();					
			case 'syncBookingRequests':
				syncBookingRequests(S.dbh, getCrmData());
			case _:
				run();
		}		
	}

	function syncAll() {
		trace(param);
		//getMissing();
		//dbAccessProps = initDbAccessProps();
		if(param['offset']==null)
			param['offset'] = '0';
		if(param['limit']==null)			
			param['limit'] = '1000';
		/*if(Std.parseInt(param['offset'])+Std.parseInt(param['limit'])>Std.parseInt(param['maxImport']))
		{
			param['limit'] = Std.string(Std.parseInt(param['maxImport']) - Std.parseInt(param['offset']));
		}*/
		trace(param);
		syncBookingRequests(S.dbh, getCrmData());
		S.sendErrors(dbData,['syncAll'=>'NOTOK']);
	}

	public function syncBookingRequests(dbh:PDO, bookings:NativeArray):Void 
	{		
		var bookingsRows:Int = Syntax.code("count({0})",bookings);
		trace('bookingsRows:$bookingsRows');
		//trace(bookings[0]);
		var dD:Map<String,Dynamic> = Util.map2fieldsNum(bookings[0], dKeys);
        var dNames:Array<String> = [for(k in dD.keys()) k];		
		var dPlaceholders:Array<String> =  [for(k in dNames) k].map(function (k) return ':$k');
		var dSet:String = [
			for(k in dNames.filter(function(k)return k!='id')) k
			].map(function (k) return ' "$k"=:$k').join(',');		
		var sql:String = comment(unindent, format) /*
				INSERT INTO bank_transfers (${dNames.join(',')})
				VALUES (${dPlaceholders.join(',')}) ON CONFLICT DO NOTHING;				
			*/;
		//ON CONFLICT (ba_id) DO UPDATE
		//SET $dSet returning ba_id;
		var stmt:PDOStatement = S.dbh.prepare(sql,Syntax.array(null));
		trace(sql);
		for(row in bookings.iterator())
		{
			Util.bindClientDataNum('bank_transfers',stmt,row,dbData);
			if(!stmt.execute()){
				trace(row);
				trace(stmt.errorInfo());
				S.sendErrors(dbData, ['execute'=>Lib.hashOfAssociativeArray(stmt.errorInfo()),
				'sql'=>sql,
				'ba_id'=>Std.string(Syntax.code("{0}['ba_id']",row))]);
			}
			synced++;
		}
        trace('done');
		dbData.dataInfo['offset'] = Std.parseInt(param['offset']) + synced;
		trace(dbData.dataInfo);
        //S.sendData(dbData, null);
		S.sendInfo(dbData,['imported'=>'OK:' + stmt.rowCount()]);
	}
	
	public function getCrmData():NativeArray
	{		        
		var firstBatch:Bool = (param['offset']=='0');
		var selectTotalCount:String = '';
		trace('offset:${param['offset']} firstBatch:$firstBatch ');
		if(firstBatch)
		{
			selectTotalCount = 'SQL_CALC_FOUND_ROWS';
		}
        var sql = comment(unindent,format)/*
		SELECT * FROM buchungs_anforderungen
ORDER BY Termin  
LIMIT 
*/;
        var stmt:PDOStatement = S.syncDbh.query('$sql ${Std.parseInt(param['limit'])} OFFSET ${Std.parseInt(param['offset'])}');
		trace('loading  ${Std.parseInt(param['limit'])} OFFSET ${Std.parseInt(param['offset'])}');
		if(untyped stmt==false)
		{
			trace('$sql ${Std.parseInt(param['limit'])}');
			S.sendErrors(dbData, ['getCrmData query:'=>S.syncDbh.errorInfo()]);
		}
		if(stmt.errorCode() !='00000')
		{
			trace(stmt.errorInfo());
		}
		var res:NativeArray = (stmt.execute()?stmt.fetchAll(PDO.FETCH_NUM):null);
		//trace(res);
		if(firstBatch)
		{
			stmt = S.syncDbh.query('SELECT FOUND_ROWS()');
			var totalRes = stmt.fetchColumn();
			trace(totalRes);
			dbData.dataInfo['totalRecords'] = totalRes;
		}
		return res;
	}
}