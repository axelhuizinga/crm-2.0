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
		var sql:String = comment(unindent, format)/*		
		SELECT COUNT(*),  date(date_trunc('month',Termin)), SUM(Betrag) 
		FROM bank_transfers ${filter} GROUP BY  date(date_trunc('month',Termin)) 
		ORDER BY date(date_trunc('month',Termin))
		*/;
		var hData:NativeArray = fetchAll(sql,S.dbh);
		dbData.dataInfo = ['count'=>Lib.toHaxeArray(hData).length];
		sendRows(hData);
	}
	
}