package model.data;
import haxe.Exception;
import haxe.macro.Expr.Catch;
import php.db.PDO;
import php.Global;
import Model.RData;
import php.Lib;
import php.db.PDOStatement;
import comments.CommentString.*;

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

class Contacts extends Model
{
	private static var vicdial_list_fields = 'lead_id,entry_date,modify_date,status,user,vendor_lead_code,source_id,list_id,gmt_offset_now,called_since_last_reset,phone_code,phone_number,title,first_name,middle_initial,last_name,address1,address2,address3,city,state,province,postal_code,country_code,gender,date_of_birth,alt_phone,email,security_phrase,comments,called_count,last_local_call_time,rank,owner,entry_list_id'.split(',');		
	
	public function new(?param:Map<String,String>) 
	{
		//table = 'contacts';
		super(param);
		go();
	}

	function go():Void {
		trace(action);
		switch(action ){
			case 'getDetails':
				getDetails();
			case 'sync':
				sync();
			case _:
				run();
		}		
	}	

	function getDetails() {
		//var c_fields:Array<String> = buildFieldsSql('contacts',['alias' =>'co']);
		//trace(c_fields);
		/*
		var rData:RData =  {
			info:['count'=>Std.string(count()),'page'=>(param.exists('page') ? param.get('page') : '1')],
			rows: doSelect()
		};
		trace(rData.rows);*/
		// TODO: GROUP lead_id's | deals per contact
		var sql = 'SELECT contacts.*,lead_id FROM contacts 
		LEFT JOIN deals ON contacts.id = deals.contact 
		WHERE contacts.id=${param["filter"].id}';			
		//S.sendData(dbData,rData);
		trace(sql);
		var stmt:PDOStatement = S.dbh.query(sql);
		var cData:NativeArray = (stmt.execute()?stmt.fetchAll(PDO.FETCH_ASSOC):null);
		var lead_id:Int;
		trace(Global.count(cData));
		//trace(Global.count(cData));
		if(Global.count(cData)==1){			
			try{
				var row:Map<String,String> = Lib.hashOfAssociativeArray(cData[0]);
				trace(row.toString());
				if((lead_id = Std.parseInt(row['lead_id'])) != null){
					var recordings = getRecordings(lead_id);
					dbData.dataInfo['recordings'] = recordings;						
				}
			
			}
			catch(e:Exception){
				trace(e.message);
			}

		}
		//sendRows(cData);		
		S.sendData(dbData,{rows:cData});
	}
	
	function getRecordings1(lead_id:Int):NativeArray
	{
		return query(
		'SELECT location, start_time, length_in_sec FROM recording_log WHERE lead_id = $lead_id AND length_in_sec>60 ORDER BY start_time DESC'
		);			
	}
	
	function sync()
	{
		trace(param);
	}
	
}