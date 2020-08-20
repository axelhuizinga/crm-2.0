package model.stats;
import php.Lib;
import php.db.PDOStatement;
import comments.CommentString.*;
import Model.RData;
import php.NativeArray;

using Lambda;
using Util;

typedef CustomField = 
{
	var field_label:String;
	var field_name:String;
	var field_type:String;
	//var rank:String;
	//var order:String;
	@:optional var field_options:String;
} 
/**
 * ...
 * @author axel@cunity.me
 */

class History extends Model
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
			case 'get':
				get();
			case _:
				run();
		}		
	}	

	
	override function get()
	{
		//trace(param);
		var filter = (param.get('filter')!=null ? 'WHERE '+param.get('filter') :'');
		var sql1:String = comment(unindent, format)/*		
		SELECT COUNT(*),  date(date_trunc('month',Termin)), SUM(Betrag) 
		FROM bank_transfers ${filter} GROUP BY  date(date_trunc('month',Termin)) 
		ORDER BY date(date_trunc('month',Termin))
		*/;
		S.dbh.beginTransaction();
		var sql:String = comment(unindent, format)/*
		CREATE TEMPORARY TABLE m_bank ON COMMIT DROP AS SELECT * FROM bank_transfers;;
		*/;
		var stmt:PDOStatement = S.dbh.query(sql);
		if(S.dbh.errorCode() != '00000')
		{
			trace(S.dbh.errorInfo());

		}
		sql = comment(unindent, format)/*
		UPDATE m_bank SET termin = date_trunc('month',termin + interval '6 days')
		WHERE date_part('day', termin) >25;
		*/;
		var stmt:PDOStatement = S.dbh.query(sql);
		if(S.dbh.errorCode() != '00000')
		{
			trace(S.dbh.errorInfo());

		}
		stmt.closeCursor();
		sql  = comment(unindent, format)/*
		SELECT COUNT(*),  date(date_trunc('month',Termin)), SUM(Betrag) 
		FROM m_bank WHERE termin<date_trunc('month', CURRENT_DATE) GROUP BY  date(date_trunc('month',Termin)) 
		ORDER BY date(date_trunc('month',Termin))
		*/;
		trace(sql);
		var hData:NativeArray = fetchAll(sql,S.dbh);
		S.dbh.commit();
		dbData.dataInfo = ['count'=>Lib.toHaxeArray(hData).length];
		sendRows(hData);
	}
}