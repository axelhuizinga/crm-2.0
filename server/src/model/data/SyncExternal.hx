package model.data;

import php.Global;
import shared.DbData;
import haxe.macro.Type.Ref;
import haxe.ds.Map;
import php.db.Mysqli;
import haxe.Http;
import haxe.Json;
import php.db.PDO;

import haxe.extern.EitherType;
import php.Lib;
import php.NativeArray;
import me.cunity.php.db.*;
import php.Syntax;
import php.db.PDOStatement;
import sys.db.*;
import comments.CommentString.*;
using Lambda;
using Util;

/**
 * ...
 * @author axel@bi4.me
 */

@:keep
class SyncExternal extends Model 
{
	public static function _create(param:Map<String,String>):Void
	{
		var self:SyncExternal = new SyncExternal(param);	
		//self.table = 'columns';
        trace('calling ${param.get("action")}');
		Reflect.callMethod(self, Reflect.field(self,param.get("action")), [param]);
	}	

	public function accountsCount() {
		var stmt:PDOStatement = S.syncDbh.query('SELECT COUNT(*) FROM pay_source');
		S.checkStmt(S.syncDbh, stmt, 'pay_sourceCount query:'+Std.string(S.syncDbh.errorInfo()));			
		dbData.dataInfo.set('pay_sourceCount',(stmt.execute()?stmt.fetch(PDO.FETCH_COLUMN):null));
		stmt = S.dbh.query('SELECT COUNT(*) FROM accounts');
		S.checkStmt(S.dbh, stmt, 'get accounts count query:'+Std.string(S.dbh.errorInfo()));
		dbData.dataInfo.set('accountsCount',(stmt.execute()?stmt.fetch(PDO.FETCH_COLUMN):null));
		S.sendInfo(dbData);	
	}

	public function bookingRequestsCount() {
		var sql:String = 'SELECT COUNT(*) FROM buchungs_anforderungen';
		var stmt:PDOStatement = null;
		if(S.params.exists('filter')&&S.params.get('filter')!=null){
			var eF:EReg = new EReg("(=|<|>)","g");
			var fEl:Array<String> = eF.split(S.params.get('filter'));
			trace(fEl.join('|'));
			if(eF.match(S.params.get('filter'))){
				trace(eF.matched(1));
			}
			var cmp = eF.matched(1);
			if(~/[a-z0-9_]+/.match(fEl[0])){
				stmt = S.syncDbh.prepare('$sql WHERE ${fEl[0]} $cmp ?');//, PDO.PARAM_STR
				//dbData.dataInfo.set('buchungsAnforderungenCount',(stmt.execute(Syntax.array(S.params.get('filter')))?stmt.fetch(PDO.FETCH_COLUMN):null));
				if(stmt.execute(Syntax.array(fEl[1]))){
					dbData.dataInfo.set('buchungsAnforderungenCount',stmt.fetch(PDO.FETCH_COLUMN));
				}
				else{
					dbData.dataInfo.set('buchungsAnforderungenCount',Std.string(stmt.errorInfo));
				}
				stmt = S.dbh.prepare('SELECT COUNT(*) FROM booking_requests WHERE ${fEl[0]} $cmp ?');
				trace(S.dbh.getAttribute(PDO.ATTR_SERVER_INFO));
				if(stmt.execute(Syntax.array(fEl[1]))){
					dbData.dataInfo.set('bookingRequestsCount',stmt.fetch(PDO.FETCH_COLUMN));
				}
				else{
					dbData.dataInfo.set('bookingRequestsCount',Std.string(stmt.errorInfo));
				}							
			}

		}
		else{
			stmt = S.syncDbh.query(sql);
			S.checkStmt(S.syncDbh, stmt, 'buchungsAnforderungenCount:'+Std.string(S.syncDbh.errorInfo()));
			dbData.dataInfo.set('buchungsAnforderungenCount',(stmt.execute()?stmt.fetch(PDO.FETCH_COLUMN):null));
			
			stmt = S.dbh.query('SELECT COUNT(*) FROM booking_requests');
			S.checkStmt(S.dbh, stmt, 'booking_requests count:'+Std.string(S.dbh.errorInfo()));
			dbData.dataInfo.set('bookingRequestsCount',(stmt.execute()?stmt.fetch(PDO.FETCH_COLUMN):null));
		}
		S.sendInfo(dbData);			
	}

	public function clientsCount() {
		var stmt:PDOStatement = S.syncDbh.query('SELECT COUNT(*) FROM clients');
		S.checkStmt(S.syncDbh, stmt, 'clientsCount query:'+Std.string(S.syncDbh.errorInfo()));			
		dbData.dataInfo.set('clientsCount',(stmt.execute()?stmt.fetch(PDO.FETCH_COLUMN):null));
		stmt = S.dbh.query('SELECT COUNT(*) FROM contacts WHERE id>9999999');
		S.checkStmt(S.dbh, stmt, 'get contacts count query:'+Std.string(S.dbh.errorInfo()));
		dbData.dataInfo.set('contactsCount',(stmt.execute()?stmt.fetch(PDO.FETCH_COLUMN):null));
		S.sendInfo(dbData);	
	}

	public function dealsCount() {
		var stmt:PDOStatement = S.syncDbh.query('SELECT COUNT(*) FROM pay_plan');
		S.checkStmt(S.syncDbh, stmt, 'getExtIds count query:'+Std.string(S.syncDbh.errorInfo()));			
		dbData.dataInfo.set('pay_planCount',(stmt.execute()?stmt.fetch(PDO.FETCH_COLUMN):null));
		stmt = S.dbh.query('SELECT COUNT(*) FROM deals');
		S.checkStmt(S.dbh, stmt, 'get deals count query:'+Std.string(S.dbh.errorInfo()));
		dbData.dataInfo.set('dealsCount',(stmt.execute()?stmt.fetch(PDO.FETCH_COLUMN):null));
		S.sendInfo(dbData);	
	}

	public function sync2dev() {
		// GET QC LEADS COPIED TO DEV DB		
		//var sql:String = 'INSERT INTO dev.$table SELECT * FROM asterisk.$table WHERE list_id=1900';
		var table:String = 'vicidial_list';
		var sql:String = 'SELECT lead_id FROM asterisk.$table WHERE list_id=1900';
		trace(S.syncDbh.query(sql).fetchAll(PDO.FETCH_COLUMN));
		syncTable2dev('vicidial_list');
		//syncTable2dev('vicidial_list');
		//S.sendInfo(dbData);	
		var stmt:PDOStatement = S.syncDbh.query('SELECT DISTINCT entry_list_id FROM dev.vicidial_list');
		var entry_lists:NativeArray = stmt.fetchAll(PDO.FETCH_COLUMN);
		trace('entry_lists:' +  Global.count(entry_lists));
		var synced:Int = 0;
		for(eid in entry_lists){
			//	GET ALL TABLES STARTING WITH 'custom'
			var stmt:PDOStatement = S.syncDbh.query('
			SELECT table_name 
			from information_schema.tables
			where table_type = "BASE TABLE"
				and table_name like "custom_${eid}"
			and table_schema = "asterisk"');
	
			//S.checkStmt(S.syncDbh, stmt, 'get custom_* tables:'+Std.string(S.syncDbh.errorInfo()));	

			if(stmt.execute()){
				// success - continue
				var res:NativeArray = stmt.fetchAll(PDO.FETCH_COLUMN);
				if(Global.count(res)==0)
					continue;
				trace(res);
				
					//S.sendInfo(dbData);	
				for(tname in res){
				//var it:Iterator<Map<String,Dynamic>> = res.iterator();
					trace(Std.string(tname));
					syncTable2dev(tname);
					synced++;
				}
				dbData.dataInfo.set('results',['custom_* tables copied:', synced]);
			}
		}
		S.sendInfo(dbData);	
	}
	
	//function syncTable2dev(table:String, ?entry_lists:String) {
	function syncTable2dev(table:String) {
    
		//S.syncDbh.exec('DROP TABLE dev.$table');
		S.syncDbh.exec('CREATE TABLE IF NOT EXISTS dev.$table LIKE asterisk.$table');
		// 
		if(S.syncDbh.errorCode() == '00000'){
			// CREATED TABLE IF NOT EXISTS
			//trace('DROP dev.$table');
			S.syncDbh.exec('
			TRUNCATE TABLE dev.$table;
			FLUSH TABLE dev.$table;');
			if(S.syncDbh.errorCode() == '00000'){
				// EMPTIED TABLE		
				//var stmtc:PDOStatement = S.syncDbh.query('SELECT COUNT(*) FROM dev.$table');
				/*var stmtc:PDOStatement = S.syncDbh.query('ALTER TABLE dev.$table AUTO_INCREMENT=1;FLUSH TABLE dev.$table;');
				if(!stmtc.execute()){
					dbData.dataErrors.set('$table',"$table count check failed");
					S.sendErrors(dbData);
				}
				else{
					trace('should be 0:' + Std.string(stmtc.errorInfo()));
				}*/
				//S.sendInfo(dbData);		
				// COPY QC DATA	
				var sql:String = (table == 'vicidial_list'?				
					'INSERT IGNORE INTO dev.$table SELECT * FROM asterisk.$table WHERE list_id=1900':
					//'SELECT COUNT(*) FROM dev.$table':
					'INSERT IGNORE INTO dev.$table SELECT * FROM asterisk.$table');
				trace(sql);
				var stmt:PDOStatement = S.syncDbh.query(sql);
				//trace(stmt.debugDumpParams)
				if(!stmt.execute()){
					dbData.dataErrors.set('$table',"copy failed");
				}
				trace('synced into $table:' + stmt.rowCount());
				if(table == 'vicidial_list'){
					
					//dbData.dataInfo.set('qc_leads',stmt.rowCount());
					dbData.dataInfo.set('qc_leads',S.syncDbh.query('SELECT COUNT(*) FROM dev.$table').fetchColumn());
				}
			}
		};
	}
	

    function saveContactDetails():DbData
    {
        var updated:Int = 0;
        //dbData = new DbData();
        var stmt:PDOStatement = null;
        trace(dbData.dataRows[dbData.dataRows.length-2]);
        for(dR in dbData.dataRows)
        {
           /* var sql:String = 'SELECT external FROM users WHERE user_name = \'${dR['user']}\'';
            var q:EitherType<PDOStatement,Bool> = S.dbh.query(sql);
            if(!q)
            {
                dbData.dataErrors = ['${action}' => S.dbh.errorInfo()];
                return dbData;
            }
            var eStmt:PDOStatement = cast(q, PDOStatement);

            var external:NativeArray = eStmt.fetch();
            trace(sql);
            //trace(Type.typeof(external));

            if(1 == updated++)
            trace(external);*/
            var external_text = row2jsonb(Lib.objectOfAssociativeArray(Lib.associativeArrayOfHash(dR)));
            var sql = comment(unindent, format) /*
            UPDATE crm.users SET active='${dR['active']}',edited_by=${S.dbQuery.dbUser.id}, external = jsonb_object('{$external_text}')::jsonb WHERE user_name='${dR['user']}'
            */;
            
            var q:EitherType<PDOStatement,Bool> = S.dbh.query(sql);
            if(!q)
            {
               dbData.dataErrors = ['${action}' => Std.string(S.dbh.errorInfo())];
               return dbData;
            } 
        }        
        dbData.dataInfo = ['saveContactDetails' => 'OK', 'updatedRows' => Std.string(updated)];
        trace(dbData.dataInfo);
		return dbData; 
    }

/*    public function getViciDialData():Map<String,Dynamic> 
	{		        
        S.saveLog(S.conf.get('ini'));
        var ini:NativeArray = S.conf.get('ini');
        ini = ini['vicidial'];
        var fields:Array<String> = Reflect.fields(Lib.objectOfAssociativeArray(ini));
        var info:Map<String,Dynamic> = [
            for(f in fields)
            f => ini[f]
        ];
        //S.saveLog(info);
        return info;
		S.sendInfo(dbData, info);
	}*/

}