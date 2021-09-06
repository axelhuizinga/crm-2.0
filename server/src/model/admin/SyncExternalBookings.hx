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
		//totalCount = 0;//count();
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
		var stmt:PDOStatement = S.syncDbh.query('SELECT * FROM buchungs_anforderungen');
		S.checkStmt(S.syncDbh, stmt, 'buchungsAnforderungenCount:'+Std.string(S.syncDbh.errorInfo()));
		dbData.dataInfo.set('buchungsAnforderungenCount',(stmt.execute()?stmt.fetch(PDO.FETCH_COLUMN):null));
		return dbData.dataInfo.get('buchungsAnforderungenCount');
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

	function getMaxImported():Int {
		var sql = comment(unindent, format) /*
		SELECT max(id) from booking_requests ;				
		*/;
		var stmt = S.dbh.query(sql);
		var got:Int = Std.parseInt(stmt.execute()?stmt.fetchColumn(0):null);		
		trace('got:$got');	
		return got;	
	}
	function  getAllBaIDs():String {
		var sql = comment(unindent, format) /*		
		SELECT string_agg(id::varchar,',') from booking_requests ;				
		*/;
		var stmt = S.dbh.query(sql);
		//var res:String = (stmt!==false?stmt.fetchColumn(0):null);SET SESSION group_concat_max_len = 1000000;
		return (stmt.rowCount()==1?stmt.fetchColumn(0):null);
	}

	/*function  getAllBaIDs() {
		sql = "	COPY ba_ids FROM '/tmp/buaIDs.txt' CSV HEADER;";
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

		trace('ok');
	}*/

	function getMissing() {
		//get all BaID's
		return syncBookingRequests(S.dbh,getAllBaIDs());
		//return syncBookingRequests(S.dbh,getMaxImported());	
	}

	function importAll() {
		trace(param);
		//empty table
	/*	if(!S.dbh.query('TRUNCATE TABLE booking_requests').execute()){
			S.sendErrors(dbData,['TRUNCATE TABLE booking_requests'=>'NOTOK']);
		};*/
		syncBookingRequests(S.dbh);
		// above exits on success
		S.sendErrors(dbData,['importAll'=>'NOTOK']);
	}
	
	//public function syncBookingRequests(dbh:PDO,minID:Int=0):Void 
	public function syncBookingRequests(dbh:PDO,ids:String=''):Void 
	{		
		var bookings:NativeArray = null;
		var dD:Map<String,Dynamic> = Util.map2fieldsNum(bookings[0], keys);
		trace(dD.toString());
		var dNames:Array<String> = [for(k in dD.keys()) k];		
		/*dNames = dNames.filter(function(n:String) {
			return n!='id'&&n!='mandator';
		});*/
		var dPlaceholders:Array<String> =  [for(k in dNames) k].map(function (k) return ':$k');
		trace(dPlaceholders);
		var sql:String = comment(unindent, format) /*
		INSERT INTO ${table} (${dNames.join(',')})
		VALUES (${dPlaceholders.join(',')}) ON CONFLICT DO NOTHING;				
		*/;
		trace(sql);		
		//while(synced<totalCount){
			//	LOAD LIVE PBX DATA
			bookings = getCrmData(ids);
			while(synced<totalCount){
				var stmt:PDOStatement = S.dbh.prepare(sql,Syntax.array(null));
			//trace('totalRecords:' + dbData.dataInfo['totalRecords']);
			for(row in bookings.iterator())
			{
				//trace(synced);
				//trace(row);
				//trace(Std.string(row));
				var rVal:Map<String,Dynamic> = Lib.hashOfAssociativeArray(row);
				//trace(Std.string(rVal));	
				rVal['28'] = Std.string(Std.parseInt(rVal['28']));
				//trace(Std.string(rVal['28']));	
				//Syntax.code('$row[28]=${0}',rVal.28);*/
				row = Lib.associativeArrayOfHash(rVal);
				//trace(Std.string(row));
				row = Util.bindClientDataNum(table,stmt,row,dbData);		
				//
				if(!stmt.execute(row)){
					trace(row);
					trace(stmt.errorInfo());
					S.sendErrors(dbData, ['execute'=>Lib.hashOfAssociativeArray(stmt.errorInfo()),
					'sql'=>sql,
					'id'=>Std.string(Syntax.code("{0}['id']",row))]);
				}
				synced++;
			}
			// GOT LIVE PBX DATA

			trace('totalCount:${totalCount} offset:${offset.int} + synced:${synced}');
			offset = Util.offset(synced);
			if(offset.int+limit.int>totalCount)
			{
				limit = Util.limit(totalCount - offset.int);
			}										
			//trace('offset:'+ offset.int);
			//trace(param);
		}
		trace('done');
		Sys.exit(S.sendInfo(dbData, ['importedBookingRequests'=>'OK'])?1:0);
	}
	
	//public function getCrmData(maxImported:Int=0):NativeArray
	public function getCrmData(ids:String = ''):NativeArray	
	{		        
		//`buchungsanforderungID`>$maxImported WHERE  Termin>'2021-01-01'
		
        var sql = (ids==''? 
			comment(unindent,format)/*
				SELECT *, 1 AS 'mandator' FROM buchungs_anforderungen 
			ORDER BY buchungsanforderungID 
			*/
			:comment(unindent,format)/*
					SELECT *, 1 AS 'mandator' FROM buchungs_anforderungen WHERE  buchungsanforderungID NOT IN(${ids})
			ORDER BY buchungsanforderungID 
			*/
		);
		trace('loading $sql ${limit.sql} ${offset.sql}' + S.syncDbh.getAttribute(PDO.ATTR_SERVER_INFO));
		var stmt:PDOStatement = S.syncDbh.query('$sql ${limit.sql} ${offset.sql}');
		trace('...');
		trace(stmt.errorInfo()[2]);
		if(untyped stmt==false)
		{
			trace('$sql ${limit.sql} ${offset.sql}');
			S.sendErrors(dbData, ['getCrmData query:'=>S.syncDbh.errorInfo()]);
		}
		if(stmt.errorCode() !='00000')
		{
			trace(stmt.errorInfo());
		}
		//trace(res);
		var res:NativeArray = (stmt.execute()?stmt.fetchAll(PDO.FETCH_NUM):null);
		//var res:NativeArray = (stmt.execute()?stmt.fetchAll(PDO.FETCH_BOTH):null);
		trace(Syntax.code('count({0})',res));
		if(offset.int==0)
		{
			//stmt = S.syncDbh.query(sql);
			var totalRes:String = Syntax.code('count({0})',res);//stmt.fetchColumn();
			trace(totalRes);
			totalCount = Std.parseInt(dbData.dataInfo['totalRecords'] = totalRes);
		}
		return res;
	}
}