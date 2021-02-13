package model.admin;
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
				getMissing();
			case _:
				run();
		}		
	}

	function getMissing() {
		//get all BaID's
		offset = Util.offset(0);
		var sql = comment(unindent, format) /*
		SELECT buchungsanforderungID FROM fly_crm.buchungs_anforderungen;				
		*/;
		var stmt = S.syncDbh.query(sql);
		if(untyped stmt==false)
		{
			trace('$sql ${limit.sql} ${offset.sql}');
			S.sendErrors(dbData, ['getCrmData query:'=>S.syncDbh.errorInfo()]);
		}
		if(stmt.errorCode() !='00000')
		{
			trace(stmt.errorInfo());
		}
		var crmBaIds:NativeArray = (stmt.execute()?stmt.fetchAll(PDO.FETCH_COLUMN):null);		
		var got:Int = Global.count(crmBaIds);
		trace('got:$got');
		var missing:NativeArray = Syntax.array(null);
		var mCount:Int = 0;
		while(offset.int<got){
			var aBit:NativeArray = Global.array_slice(crmBaIds,offset.int,limit.int);
			//trace(Type.typeof(aBit));
			//trace(Std.string(aBit));
			//var sep = "),(";
			var bit = Global.implode("),(", aBit);
			//trace(bit.length);
			sql = comment(unindent, format) /*			
				SELECT * FROM (
					VALUES (${bit})
					) b(bid)
				LEFT JOIN				
				(SELECT ba_id FROM crm.${table}) c
				ON ba_id=bid
				WHERE ba_id IS NULL;				
			*/;
			if(false && offset.int==0)
				trace(sql);
			//Sys.exit(0);
			stmt = S.dbh.query(sql);
			if(untyped stmt==false)
			{
				trace('$sql ${limit.sql} ${offset.sql}');
				S.sendErrors(dbData, ['getCrmData query:'=>S.syncDbh.errorInfo()]);
			}
			if(stmt.errorCode() !='00000')
			{
				trace(stmt.errorInfo());
			}			
			//var m_res:NativeArray = (stmt.execute()?stmt.fetchAll(PDO.FETCH_NUM):null);	
			missing = Global.array_merge(missing,stmt.execute()?stmt.fetchAll(PDO.FETCH_COLUMN):null);	
			mCount = Global.count(missing);
			//trace('missing:$mCount @ ${offset.int}');
			offset = Util.offset(offset.int+limit.int);
			trace('missing:$mCount @ ${offset.int} with:${limit.int}');
			
			//Sys.exit(0);
		}
		trace('missingTotal:$mCount');
		if(mCount<1)
			S.send('Done');
		//trace(missing);Sys.exit(0);
		sql = comment(unindent, format) /*
		SELECT * FROM fly_crm.buchungs_anforderungen
		WHERE buchungsanforderungID IN(${Global.implode(',',missing)});				
		*/;
		var stmt = S.syncDbh.query(sql);
		if(untyped stmt==false)
		{
			trace('$sql ${limit.sql} ${offset.sql}');
			S.sendErrors(dbData, ['getCrmData query:'=>S.syncDbh.errorInfo()]);
		}
		if(stmt.errorCode() !='00000')
		{
			trace(stmt.errorInfo());
		}
		var crmBaIdsMissing:NativeArray = (stmt.execute()?stmt.fetchAll(PDO.FETCH_NUM):null);		
		var got:Int = Global.count(crmBaIdsMissing);
		trace('got missing:$got');
		//trace(Std.string(crmBaIdsMissing[0]));Sys.exit(0);
		var dD:Map<String,Dynamic> = Util.map2fieldsNum(missing[0], keys);
        var dNames:Array<String> = [for(k in dD.keys()) k];		
		var dPlaceholders:Array<String> =  [for(k in dNames) k].map(function (k) return ':$k');		
		sql = comment(unindent, format) /*
			INSERT INTO ${table} (${dNames.join(',')})
			VALUES (${dPlaceholders.join(',')}) ON CONFLICT DO NOTHING;				
			*/;
		var stmt:PDOStatement = S.dbh.prepare(sql,Syntax.array(null));
		trace(sql);
		
		for(row in crmBaIdsMissing.iterator())
		{
			//trace(Std.string(row));Sys.exit(0);
			Util.bindClientDataNum(table,stmt,row,dbData);			
			if(!stmt.execute()){
				trace(row);
				trace(stmt.errorInfo());
				S.sendErrors(dbData, ['execute'=>Lib.hashOfAssociativeArray(stmt.errorInfo()),
				'sql'=>sql,
				'buchungsanforderungID'=>Std.string(Syntax.code("{0}['buchungsanforderungID']",row))]);
			}
			synced++;
			//trace(synced);
		}
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
ORDER BY Termin  

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