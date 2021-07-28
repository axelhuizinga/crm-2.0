package model.data;
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
		var stmt:PDOStatement = S.viciboxDbh.query('SELECT * FROM vicidial_list WHERE list_id=1900 AND status="NEW" ORDER BY last_local_call_time');
		var qcData:NativeArray = (stmt.execute()?stmt.fetchAll(PDO.FETCH_ASSOC):null);
		sendRows(qcData);
		//qc_deals:NativeArray = execute('');
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
		sendRows(qcData);		
	}
	
}