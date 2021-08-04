package model.data;
import php.Syntax;
import php.Global;
import php.db.PDO;
import php.Lib;
import php.db.PDOStatement;
import php.NativeArray;
import Model;

class Deals extends Model
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
		switch(action){
			case 'getQC':
				getQC();
			case 'doQC':
				doQC();				
			case _:
				run();
		}		
	}	

	function getQC(){
		var sql:String = 'SELECT * FROM vicidial_list INNER JOIN vicidial_users ON vicidial_users.user=vicidial_list.owner WHERE list_id=1900 AND status="NEW" ORDER BY last_local_call_time';
		trace(sql);
		var stmt:PDOStatement = S.viciboxDbh.query(sql);
		var qcData:NativeArray = (stmt.execute()?stmt.fetchAll(PDO.FETCH_ASSOC):null);
		//trace(Std.string(qcData));
		sendRows(qcData);
	}

	function doQC() {
		var qc_fields:String = vicdial_list_fields.map(function(f:String) {
			return 'vl.${f}';
		}).join(',');
		// TODO: Read array content for field names from runtime config file
		var c_fields:Array<String> = 'anrede,co_field,geburts_datum,account,blz,iban,bank_name,spenden_hoehe,period,start_monat,buchungs_tag,buchungs_zeitpunkt,mailing,client_status'.split(',');
		qc_fields += ',' + c_fields.map(function(f:String) {
			return 'cu.${f}';
		}).join(',');
		trace('SELECT $qc_fields FROM vicidial_list vl INNER JOIN `custom_${param["filter"].entry_list_id}` cu ON cu.lead_id=vl.lead_id WHERE vl.lead_id=${param["filter"].lead_id}');
		var stmt:PDOStatement = S.viciboxDbh.query(
			'SELECT $qc_fields FROM vicidial_list vl INNER JOIN `custom_${param["filter"].entry_list_id}` cu ON cu.lead_id=vl.lead_id WHERE vl.lead_id=${param["filter"].lead_id}');
		var qcData:NativeArray = (stmt.execute()?stmt.fetchAll(PDO.FETCH_ASSOC):null);
		trace(Global.count(qcData));
		if(Global.count(qcData)==1){
			var recordings = getRecordings(param["filter"].lead_id);
			dbData.dataInfo['recordings'] = recordings;
			//trace(getRecordings(param["filter"].lead_id));
			//Syntax('')
		}
		sendRows(qcData);		
	}

	//function getRecordings(lead_id:Dynamic):Array<Map<String,String>>
	function getRecordings(lead_id:Dynamic):Array<Map<String,String>>
	{
		var m_length = 30;
		var recMap:Array<Map<String,String>> = new Array();
		//var records:Array<Map<String,String>> = Lib.toHaxeArray(query('SELECT location,start_time,length_in_sec FROM recording_log WHERE lead_id="$lead_id" ORDER BY start_time DESC',null,S.viciboxDbh)).map(function() {
		var records:NativeArray = query('SELECT location,start_time,length_in_sec FROM recording_log WHERE lead_id="$lead_id" AND length_in_sec > $m_length ORDER BY start_time DESC',null,S.viciboxDbh);
		Syntax.foreach(records, function(ri:Int, row:NativeArray){			
			trace('$ri => $row'); 
			//Syntax.foreach(records, function(key:String, row:NativeArray){
			//trace('$key => $value'); 
			recMap.push(Lib.hashOfAssociativeArray(row));
		});
		//var rc:Int = records.length;
		//trace ('$rc == ' + records.length);
		return recMap;//.filter(function(r:Dynamic) return  (Std.parseInt(untyped r['length_in_sec']) > m_length)).map();		
		//return Lib.toPhpArray(records.filter(function(r:Dynamic) return  (Std.parseInt(r['length_in_sec']) > 60)));		
		//TODO: CONFIG FOR MIN LENGTH_IN_SEC, NUM_DISPLAY FOR RECORDINGS	
		//return Lib.toPhpArray(records.filter(function(r:Dynamic) return untyped Lib.objectOfAssociativeArray(r).length_in_sec > 60));		
		
	}
}