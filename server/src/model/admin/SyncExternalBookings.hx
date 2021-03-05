package model.admin;
import haxe.Exception;
import php.Global;
import comments.CommentString.*;
import php.Lib;
import php.NativeArray;
import php.Syntax;
import php.db.PDO;
import php.db.PDOStatement;
import shared.DbData;

class SyncExternalBookings extends Model{

	var keys:Array<String>;	
	var synced:Int;

	public function new(param:Map<String,String>):Void
	{
		super(param);

		table = tableNames[0] = 'booking_requests';
		keys = S.tableFields(table);
		totalCount = count();
		trace(totalCount);
		if(param.exists('synced'))
		{
			synced = cast param['synced'];
		}
		else synced = 0;
        trace('calling ${action}');

		if(param.exists('offset'))
		{
			synced = cast param['offset'];
		}
		else synced = 0;
		Util.offset(synced);
		trace('calling ${action} @ ${offset} with ${limit}');
		//Sys.exit(0);
		//trace(action);
		//SWITCH Call either an instance method directly or use the shared Model query execution
		switch(action ){	
			case 'importAll':
				importAll();					
			case 'syncBookingRequests':
				syncBookingRequests(S.dbh);
			case 'getMissing':
				//getAllBaIDs();
				getMissing();
			case _:
				run();
		}		
	}

	override public function count():Int
	{
		var sqlBf:StringBuf = new StringBuf();
		sqlBf.add('SELECT COUNT(*) AS count FROM ');

		if (tableNames.length>1)
		{
			sqlBf.add(buildJoin());
		}		
		else
		{
			trace(tableNames);
			trace('${tableNames[0]} ');
			sqlBf.add('${tableNames[0]} ');
		}
		if (filterSql != null)
		{
			sqlBf.add(filterSql);
		}
		trace(sqlBf.toString());
		var res:NativeArray = execute(sqlBf.toString());
		return Lib.hashOfAssociativeArray(res[0]).get('count');
	}

	function getMaxImported() {
		var sql = comment(unindent, format) /*
		SELECT buchungsanforderungID FROM fly_crm.buchungs_anforderungen;				
		*/;
	}

	function  getAllBaIDs() {
		var sql = comment(unindent, format) /*
		COPY ba_ids(ba_id) FROM '/root/buaIDs.txt' DELIMITER '|' FORMAT csv;				
		*/;
		sql = comment(unindent, format) /*
		COPY ba_ids FROM '/tmp/buaIDs.txt' CSV HEADER;				
		*/;
		trace(sql);
		var stmt = null;
		try{
			stmt = S.dbh.query(sql);
			trace(stmt);
			if(untyped stmt==false)
			{
				trace('$sql ${limit.sql} ${offset.sql}');
				S.sendErrors(dbData, ['getCrmData query:'=>S.dbh.errorInfo()]);
			}
			if(stmt.errorCode() !='00000')
			{
				trace(stmt.errorInfo());
			}
		}
		catch(ex:Exception){
			trace(ex.message);
			trace(stmt.errorInfo());
		}
		/*var crmBaIds:NativeArray = (stmt.execute()?stmt.fetchAll(PDO.FETCH_COLUMN):null);		
		var got:Int = Global.count(crmBaIds);
		trace('got:$got');*/
		trace('ok');
	}

	function getMissing() {
		//get all BaID's
		offset = Util.offset(0);
		var sql = comment(unindent, format) /*
		SELECT * FROM ba_ids WHERE ba_id NOT IN
(SELECT bi.ba_id FROM "ba_ids" bi
INNER JOIN "booking_requests" br
ON br.ba_id=bi.ba_id);		
		*/;
		var stmt = S.dbh.query(sql);
		if(untyped stmt==false)
		{
			trace('$sql');
			S.sendErrors(dbData, ['getCrmData query:'=>S.dbh.errorInfo()]);
		}
		if(stmt.errorCode() !='00000')
		{
			trace(stmt.errorInfo());
		}
		var crmBaIds:NativeArray = (stmt.execute()?stmt.fetchAll(PDO.FETCH_COLUMN):null);		
		var got:Int = Global.count(crmBaIds);
		trace('got:$got');
		
	}

	function importAll() {
		trace(param);
		//getMissing();
		syncBookingRequests(S.dbh);
		// above exits on success
		S.sendErrors(dbData,['importAll'=>'NOTOK']);
	}


	public function syncBookingRequests(dbh:PDO):Void 
	{		
		var bookings:NativeArray = null;
		var dD:Map<String,Dynamic> = Util.map2fieldsNum(bookings[0], keys);
        var dNames:Array<String> = [for(k in dD.keys()) k];		
		var dPlaceholders:Array<String> =  [for(k in dNames) k].map(function (k) return ':$k');
		var sql:String = comment(unindent, format) /*
		INSERT INTO ${table} (${dNames.join(',')})
		VALUES (${dPlaceholders.join(',')}) ON CONFLICT DO NOTHING;				
		*/;
		while(synced<totalCount){
			//	LOAD LIVE PBX DATA
			bookings = getCrmData();
			var stmt:PDOStatement = S.dbh.prepare(sql,Syntax.array(null));
			trace(sql);
			for(row in bookings.iterator())
			{
				trace(synced);
				Util.bindClientDataNum(table,stmt,row,dbData);			
				if(!stmt.execute()){
					trace(row);
					trace(stmt.errorInfo());
					S.sendErrors(dbData, ['execute'=>Lib.hashOfAssociativeArray(stmt.errorInfo()),
					'sql'=>sql,
					'ba_id'=>Std.string(Syntax.code("{0}['ba_id']",row))]);
				}
				synced++;
			}
			// GOT LIVE PBX DATA

			trace('${offset.int} + ${synced}');
			offset = Util.offset(synced);
			if(offset.int+limit.int>totalCount)
			{
				limit = Util.limit(totalCount - offset.int);
			}										
			trace('offset:'+ offset.int);
			trace(param);
		}
		trace('done');
		Sys.exit(S.sendInfo(dbData, ['importedBookingRequests'=>'OK'])?1:0);
	}
	
	public function getCrmData():NativeArray
	{		        
        var sql = comment(unindent,format)/*
		SELECT * FROM buchungs_anforderungen
ORDER BY buchungsanforderungID WHERE anforderungs_datum>'2021-01-01'
*/;
		trace('loading $sql ${limit.sql} ${offset.sql}');
		var stmt:PDOStatement = S.syncDbh.query('$sql ${limit.sql} ${offset.sql}');
		if(untyped stmt==false)
		{
			trace('$sql ${limit.sql} ${offset.sql}');
			S.sendErrors(dbData, ['getCrmData query:'=>S.syncDbh.errorInfo()]);
		}
		if(stmt.errorCode() !='00000')
		{
			trace(stmt.errorInfo());
		}
		var res:NativeArray = (stmt.execute()?stmt.fetchAll(PDO.FETCH_NUM):null);
		//trace(res);
		if(offset.int==0)
		{
			stmt = S.syncDbh.query('SELECT COUNT(*) FROM buchungs_anforderungen');
			var totalRes = stmt.fetchColumn();
			trace(totalRes);
			dbData.dataInfo['totalRecords'] = totalRes;
		}
		return res;
	}
}