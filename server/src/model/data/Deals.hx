package model.data;
import comments.CommentString.*;
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

	public function go():Void {
		trace(action);
		switch(action){
			case 'getQC':
				getQC();
			case 'loadQC':
				loadQC();		
			case qc if( ~/qc_*/.match(qc)):
				doQC();		
			case _:
				run();
		}		
	}	

	/**
	 * End QC with status
	 */
	function doQC() {
		trace('...');
		trace(param);
		/*switch (action){
			case 'qc_ok'|'qc_bad':
				//SAVE STATE AND MOVE TO LIST
				var sql:String = action == 'qc_ok' ?				
					'UPDATE dev.vicidial_list SET status="QCOK", list_id=10000 WHERE lead_id=${param["id"]}':
					'UPDATE dev.vicidial_list SET status="QCBAD", list_id=1800 WHERE lead_id=${param["id"]}';
				trace(sql);
			default:
				trace(action);// qc_save*/
				saveQC();
		//}
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
	function loadQC() {
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


	public function endQC(sql:String):Void
	{
		var stmt:PDOStatement = S.viciBoxDbh.query(sql);
		if(!stmt.execute()){
			S.sendErrors(dbData,['endQC' =>S.errorInfo(stmt.errorInfo())]);
		};
	}	

	public function saveQC():Void
	{
		var sqlBf:StringBuf = new StringBuf();
		var dataFields:Array<String> = Reflect.fields(param['data']);
		var set:Array<String> = new Array();	
		var setValues:Array<String> = [];
		var svM:Map<String,String> = [];
		if(dataFields.length>0){
			var vc_update_fields:Array<String> = vicdial_list_fields.filter(function(f:String) {
				return dataFields.contains(f) && f!='lead_id' && f!='vendor_lead_code';
			});
			trace(vicdial_list_fields.join('|'));
			trace(vc_update_fields.join('|'));
			trace(dataFields.join('|'));

			var sql:String = comment(unindent, format) /*
			SELECT GROUP_CONCAT(COLUMN_NAME) FROM information_schema.columns WHERE table_schema = "${S.dbViciBoxDB}" AND table_name = "custom_${param["filter"].entry_list_id}"
			*/;
			trace(sql);
			var cuFields:Array<String> = S.viciBoxDbh.query(sql).fetchColumn().split(',').filter(function(f:String) {
				return dataFields.contains(f) && f!='lead_id';
			});
			var qcJoin:Bool = false;
			for(dF in dataFields){
				if(cuFields.contains(dF)){				
					qcJoin = true;
					break;
				}
			}
			// CUSTOM QC FIELDS CHANGED - WE CAN UPDATE JOIN
			//trace(qcJoin?'Y':'N');
			if(qcJoin){
				sqlBf.add(
					'UPDATE ${S.dbViciBoxDB}.vicidial_list vl INNER JOIN ${S.dbViciBoxDB}.custom_${param["filter"].entry_list_id} cu 
					ON vl.lead_id=cu.lead_id '
				);

				for(dF in dataFields){
					if(vc_update_fields.contains(dF)){
						set.push('vl.$dF=:$dF');
						svM[':$dF'] = Reflect.field(param['data'],dF);
						//set.push('vl."$dF"=?');
						//setValues.push(Reflect.field(data,dF));
					}
					if(cuFields.contains(dF)){
						set.push('cu.$dF=:$dF');
						svM[':$dF'] = Reflect.field(param['data'],dF);
					}				
				}
				sqlBf.add('SET ' + set.join(',') + ' WHERE vl.lead_id=${param["filter"].id}');
			}
			else {
				// SAVE VICIDIAL_LIST DATA ONLY
				trace(dataFields.join('|'));
				sqlBf.add(
					'UPDATE ${S.dbViciBoxDB}.vicidial_list '
				);
				for(dF in dataFields){
					trace(dF);
					if(vc_update_fields.contains(dF)){
						//trace('$dF=?');					
						set.push('$dF=:$dF');
						svM[':$dF'] = Reflect.field(param['data'],dF);
					}
				}
				sqlBf.add('SET ' + set.join(',') + ' WHERE lead_id=${param["filter"].id}');
			}
			trace(sqlBf.toString()) ;
			
			var stmt:PDOStatement =  S.viciBoxDbh.prepare(sqlBf.toString(),Syntax.array(null));
			//var stmt:PDOStatement =  S.viciBoxDbh.query(sqlBf.toString());
			var i:Int = 0;
			var values2bind:NativeArray = null;

				//for (fV in setValues)
				for (k => v in svM)
				{
					//if (!stmt.bindValue(i, fV))
					if (!stmt.bindValue(k, v))
					{
						trace('ooops:' + stmt.errorInfo());
						S.sendErrors(dbData, ['bindValue' =>  stmt.errorInfo()] );
					}
					//values2bind[':k'] = v;

				}	
				
			trace(svM.toString());
			trace(Std.string(Lib.associativeArrayOfHash(svM)));
			if (!stmt.execute(Lib.associativeArrayOfHash(svM)))
			//if (!stmt.execute())
			{
				trace(stmt.errorInfo());
				S.sendErrors(dbData,['execute' =>S.errorInfo(stmt.errorInfo())]);
			}
			dbData.dataInfo['count'] = Std.string(stmt.rowCount());
		}
		switch (action){
			case 'qc_ok'|'qc_bad':
				//SAVE STATE AND MOVE TO LIST
				var sql:String = action == 'qc_ok' ?				
					'UPDATE dev.vicidial_list SET status="QCOK", list_id=10000 WHERE lead_id=${param["filter"].id}':
					'UPDATE dev.vicidial_list SET status="QCBAD", list_id=1800 WHERE lead_id=${param["filter"].id}';
				trace(sql);
				endQC(sql);
			default:
				trace(action);// qc_save
		}
		S.sendInfo(dbData);
		//S.viciBoxDbh.query()
	}
}