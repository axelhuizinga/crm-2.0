package model.data;
import php.db.PDO;
import php.Lib;
import php.db.PDOStatement;
import php.NativeArray;
import Model;

class Deals extends Model
{
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
	
}