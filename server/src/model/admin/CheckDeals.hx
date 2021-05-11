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


class CheckDeals extends Model 
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
			case 'xxx':
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
		var getSEPACodes:PDOStatement = S.dbh.query(sql);
		if (!untyped getSEPACodes)
		{
			trace(S.dbh.errorInfo());
			Sys.exit(0);
		}
		getSEPACodes.execute(null);
		trace(getSEPACodes.rowCount);

		var SEPACodes:Array<String> = getSEPACodes.fetchColumn().split(',');
		trace(SEPACodes);
		json_encode();
	}

}