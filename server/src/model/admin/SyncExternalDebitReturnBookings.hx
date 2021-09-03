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

class SyncExternalDebitReturnBookings extends Model{

	var keys:Array<String>;	
	var synced:Int;

	public function new(param:Map<String,String>):Void
	{
		super(param);

		table = tableNames[0] = 'debit_return_statements';
		keys = S.tableFields(table);
		synced = 0;
		//Sys.exit(0);
		//trace(action);
		//SWITCH Call either an instance method directly or use the shared Model query execution
		switch(action ){	
			case 'importAll':
				importAll();					
			case 'getMissing':
				//getAllBaIDs();
				getMissing();
			case _:
				S.sendInfo(dbData,['action'=>action,'result' => 'Nothing']);
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

	function importAll() {
		trace(param);
		//getMissing();
		trace(S.dbh.query('TRUNCATE TABLE $table').execute());
		getMissing(0);
		// above exits on success
		S.sendErrors(dbData,['importAll'=>'NOTOK']);
	}
	
	public function getMissing(?lastKid:Int):Void 
	{		
		if(lastKid==null){
			lastKid = Std.parseInt(
				S.syncDbh.query('SELECT MAX(kid) FROM konto_auszug',PDO.FETCH_COLUMN).fetchColumn()) + 1;
		}
		var bookings:NativeArray = null;

		var sql:String = comment(unindent, format) /*
		SELECT d value_date,e amount,j,k,l,q FROM `konto_auszug` 
		WHERE k LIKE 'Mandatsref%' OR j LIKE 'Mandatsref%'
		AND e<0 AND kid>$lastKid;				
		*/;
		trace(sql);		
		bookings = query(sql,null,S.syncDbh);
		totalCount = Global.count(bookings);
		trace(totalCount);
		/*while(synced<totalCount){
			//	LOAD LIVE PBX DATA
			bookings = getCrmData(ids);
			var stmt:PDOStatement = S.dbh.prepare(sql,Syntax.array(null));
			//trace('totalRecords:' + dbData.dataInfo['totalRecords']);
			for(row in bookings.iterator())
			{
				//trace(synced);
				//trace(row);
				//trace(Std.string(row));
				row = Util.bindClientDataNum(table,stmt,row,dbData);		
				//trace(Std.string(row[25]));	
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

			//trace('totalCount:${totalCount} offset:${offset.int} + synced:${synced}');
			offset = Util.offset(synced);
			if(offset.int+limit.int>totalCount)
			{
				limit = Util.limit(totalCount - offset.int);
			}										
			//trace('offset:'+ offset.int);
			//trace(param);
		}*/
		trace('done');
		Sys.exit(S.sendInfo(dbData, ['SyncExternalDebitReturnBookings'=>'OK'])?1:0);
	}
	
	//public function getCrmData(maxImported:Int=0):NativeArray
	public function getCrmData(ids:String = ''):NativeArray	
	{		        
		//`buchungsanforderungID`>$maxImported 
		
        var sql = (ids==''? 
			comment(unindent,format)/*
				SELECT *, 1 AS 'mandator' FROM buchungs_anforderungen WHERE  Termin>'2021-01-01'
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