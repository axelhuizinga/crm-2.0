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
			var stmt:PDOStatement = S.syncDbh.query('SELECT MAX(kid) FROM konto_auszug');
			stmt.setFetchMode(PDO.FETCH_COLUMN,0);//.fetchColumn(0)) + 1;
			lastKid = Std.parseInt(stmt.fetchColumn(0)) + 1;
		}
		var bookings:NativeArray = null;

		var sql:String = comment(unindent, format) /*
		SELECT d value_date,e amount,i,j,k,l,n,kid,z iban FROM `konto_auszug` 
		WHERE e<0 AND (k LIKE 'Mandatsref%' OR j LIKE 'Mandatsref%')
		AND kid>$lastKid;				
		*/;
		trace(sql);		
		bookings = query(sql,null,S.syncDbh);
		totalCount = Global.count(bookings);
		trace(totalCount);
		var sepaMap:Map<String,String> = [
			
			'KONTO AUFGELÖST' => 'AC04',
			'Konto aufgeloes' => 'AC04',
			'KONTO AUFGELOEST' => 'AC04',
			'KONTO GESPERRT' => 'AC06',			
			'KEIN GUELTIGES MANDAT' => 'MD01',			
			'WIDERSPRUCH DURCH ZAHLER' => 'MD06',
			'WIDERSPRUCH DURCH ZPFL' => 'MD06',			
			'SONSTIGE GRÜNDE' => 'MS03',
			'SONSTIGE GRUENDE' => 'MS03',
			'IBAN FEHLERHAFT' => 'AC01',
		];		
		var sepa:String = '';
		var id:Int = 0;
		for(row in bookings.iterator())
		{
			var rowMap:Map<String,String> = Lib.hashOfAssociativeArray(row);
			//trace(rowMap);
			//Sys.exit(S.sendInfo(dbData, ['SyncExternalDebitReturnBookings'=>'OK'])?1:0);
			try{
				id = Std.parseInt(new EReg('Mandatsreferenz.','g').split(rowMap['j']+rowMap['k'])[1]);
				if(id<12001){
					
					//trace(id);
					
					//trace(new EReg(rowMap['j']+rowMap['k'],'g').split('Mandatsreferenz'));
					//trace(new EReg('Mandatsreferenz.','g').split(rowMap['k']));
					//trace(rowMap);
					//Sys.exit(S.sendInfo(dbData, ['SyncExternalDebitReturnBookings'=>'OK'])?1:0);
					continue;
				}
				// GET MATCHING SEPA CODE + BOOKING REQUEST
				var eR:EReg = ~/(AC04|AC01|AC06|MD01|MD06|MS02|MS03|SL01|AM04|AG01)/;
				sepa = eR.match(rowMap['i']+rowMap['j'])?eR.matched(0):'';
				if(sepa==''){
					for(k => v in sepaMap)
					{
						var meR:EReg = new EReg('($k)','m');
						if(meR.match(rowMap['i'])||meR.match(rowMap['l'])||meR.match(rowMap['n'])){
							sepa = v;							
							//trace(rowMap);
							//trace(meR.matched(0));
							break;
						}
						//trace('$sepa >$k< $v l:'  + meR.match(rowMap['l']) + ' n:'   + meR.match(rowMap['n']));
					}
					//if(sepa=='' && ! ~/RUECKRUF/.match(rowMap['h']))
						//trace(rowMap);
				}
			}
			catch(ex:Exception){
				
				trace(ex.message);
				//Sys.exit(S.sendInfo(dbData, ['SyncExternalDebitReturnBookings'=>ex.message])?1:0);
			}
			//trace(Std.string(row));
			if(sepa!=''){
				sql = comment(unindent, format) /*
				INSERT INTO debit_return_statements(deal_id,sepa_code,iban,amount,value_date,kid)
				VALUES(${id},'$sepa','${rowMap["iban"]}',${rowMap["amount"]},'${rowMap["value_date"]}',${rowMap["kid"]})
				ON CONFLICT DO NOTHING
				*/;
				query(sql);
				//trace(sql);		
				synced++;
			}
			//Sys.exit(S.sendInfo(dbData, ['SyncExternalDebitReturnBookings'=>'OK'])?1:0);
		}
		trace('done: $synced of $totalCount');
		S.sendInfo(dbData, ['SyncExternalDebitReturnBookings'=>'$synced', 'total'=>'$totalCount']);
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