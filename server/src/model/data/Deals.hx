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

	private static var qcdb = 'dev';

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
			//case 'saveQC':
			case qc if( ~/qc_*/.match(qc)):
				saveQC();		
			case _:
				run();
		}		
	}	

	function saveQC() {
		trace('...');
		trace(param);
		switch (action){
			case 'qc_ok'|'qc_bad':
				//SAVE STATE AND MOVE TO LIST
				var sql:String = 'UPDATE dev.vicidial_list SET status="QCOK", list_id=10000 WHERE lead_id=${param["lead_id"]}';
				trace(sql);
			default:
				trace(action);

		}
		S.sendInfo(dbData,['saved'=>1]);
	}

	/**
	 * Get List of QC leads
	 */

	function getQC(){
		var vl_fields:String = vicdial_list_fields.map(function(f:String) {
			return 'vl.${f}';
		}).join(',');		
		var sql:String = 'SELECT $vl_fields,full_name FROM ${qcdb}.vicidial_list vl INNER JOIN vicidial_users vu ON vu.user=vl.owner WHERE list_id=1900 AND status="NEW" ORDER BY last_local_call_time';
		trace(sql);
		trace(S.viciBoxDbh.getAttribute(PDO.ATTR_SERVER_INFO));
		
		var stmt:PDOStatement = S.viciBoxDbh.query(sql);
		trace(stmt.errorInfo());
		var qcData:NativeArray = (stmt.execute()?stmt.fetchAll(PDO.FETCH_ASSOC):null);
		//trace(Std.string(qcData));
		sendRows(qcData);
	}

	/**
	 * Load QC lead data
	 */
	function doQC() {
		var qc_fields:String = vicdial_list_fields.map(function(f:String) {
			return 'vl.${f}';
		}).join(',');
		// TODO: Read array content for field names from runtime config file
		var c_fields:Array<String> = 'anrede,co_field,geburts_datum,account,blz,iban,bank_name,spenden_hoehe,period,start_monat,buchungs_tag,buchungs_zeitpunkt,mailing,client_status'.split(',');
		qc_fields += ',' + c_fields.map(function(f:String) {
			return 'cu.${f}';
		}).join(',');
		trace('SELECT $qc_fields FROM ${qcdb}.vicidial_list vl INNER JOIN `custom_${param["filter"].entry_list_id}` cu ON cu.lead_id=vl.lead_id WHERE vl.lead_id=${param["filter"].lead_id}');
		var stmt:PDOStatement = S.viciBoxDbh.query(
			'SELECT $qc_fields FROM ${qcdb}.vicidial_list vl INNER JOIN `custom_${param["filter"].entry_list_id}` cu ON cu.lead_id=vl.lead_id WHERE vl.lead_id=${param["filter"].lead_id}');
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

}