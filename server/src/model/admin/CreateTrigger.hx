package model.admin;


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


class CreateTrigger extends Model 
{
	public function new(?param:Map<String,String>) 
	{
		//table = 'contacts';
		super(param);
		go();
	}

	function go():Void {
		trace(action);
		switch(action ){
			case 'on_update_current_time':
				createFunction();
			case _:
				run();
		}		
	}	

	function createFunction() {
		var sql:String = comment(unindent, format) /*
			CREATE OR REPLACE FUNCTION update_modified_column() 
			RETURNS TRIGGER AS $$
			BEGIN
				NEW.modified = now();
				RETURN NEW; 
			END;
			$$ language 'plpgsql';
		*/;		
	}

	override function run():Void
	{
		var sql:String = comment(unindent, format) /*
			SELECT string_agg(table_name, ',')
			FROM information_schema.tables 
			WHERE table_schema LIKE 'crm' GROUP BY (table_schema)
		*/;
		//trace(sql);
		var getTableNames:PDOStatement = S.dbh.query(sql);
		if (!untyped getTableNames)
		{
			trace(S.dbh.errorInfo());
			Sys.exit(0);
		}
		getTableNames.execute(null);
		trace(getTableNames.rowCount);

		var tableNames:Array<String> = getTableNames.fetchColumn().split(',');
		var getActiveTriggerTables:PDOStatement = S.dbh.query( comment(unindent, format) /*
		select string_agg(tbl.relname, ',') as trigger_tables
FROM pg_trigger trg JOIN pg_class tbl on trg.tgrelid = tbl.oid
WHERE trg.tgname = 'audit_trigger_row' AND  trg.tgenabled='O'
GROUP BY(trg.tgname);
		*/
		);
		getActiveTriggerTables.execute(null);
		var actTTNames:Array<String> = getActiveTriggerTables.fetchColumn().split(',');
		for (name in tableNames)
		{
			if (actTTNames.has(name))
			{
				trace('HistoryTrigger on Table $name is active');
				//S.add2Response({content:'$name ist aktiv'});
				Syntax.code("array_push({0},{1})", data.rows,'$name ist aktiv');
			}
			else
			{
				trace(name);
				createTrigger(name);	
				//S.add2Response({content:'$name erstellt'});
				Syntax.code("array_push({0},{1})", data.rows,'$name erstellt');
			}

		}
		trace(Syntax.code("count({0})", data.rows));
		json_encode();
	}
	
	function createTrigger(tableName:String)
	{		
		var triggerSQL = comment(unindent, format) /*
		CREATE TRIGGER t_last_modified BEFORE UPDATE ON crm.$tableName FOR EACH ROW EXECUTE PROCEDURE update_modified_timestamp()
		*/;		
		
		trace(triggerSQL);
		S.dbh.exec(triggerSQL);
		if (S.dbh.errorCode() != '00000')
		{
			trace(S.dbh.errorInfo());
			Sys.exit(0);
		}
		
	}
}

/**
 * BEGIN;

DROP TRIGGER IF EXISTS t_last_modified ON debit_return_statements;

CREATE TRIGGER t_last_modified
  BEFORE UPDATE
  ON debit_return_statements
  FOR EACH ROW
  EXECUTE PROCEDURE update_modified_timestamp();

COMMIT;
 */
