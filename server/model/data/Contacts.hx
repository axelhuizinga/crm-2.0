package model.data;
import comments.CommentString.*;
import haxe.ds.StringMap;
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
@:keep
class Contacts extends Model
{
	private static var vicdial_list_fields = 'lead_id,entry_date,modify_date,status,user,vendor_lead_code,source_id,list_id,gmt_offset_now,called_since_last_reset,phone_code,phone_number,title,first_name,middle_initial,last_name,address1,address2,address3,city,state,province,postal_code,country_code,gender,date_of_birth,alt_phone,email,security_phrase,comments,called_count,last_local_call_time,rank,owner,entry_list_id'.split(',');		
	private static var contact_fields = S.tableFields('contacts');	
	
	/*private static var custom_fields_map:StringMap<String> = [
		'title'=>'anrede',
		//'co_field'=>'addresszusatz',
		'geburts_datum'=>'birth_date',
	];	*/
	
	public static function create(param:StringMap<String>):Contacts
	{
		trace(!param.exists('table')?'Y':'N');
		if(!(param.exists('table')&&param.get('table').any2bool()))
		{
			param.set('table', 'contacts');
		}
		trace(param);
		var self:Contacts = new Contacts(param);		

		if(param.get('action')==null)
		{
			return self;
		}
		//trace(param);
		Reflect.callMethod(self, Reflect.field(self,param.get('action')), [param]);
		return self;
	}
	
	
	public function edit(param:StringMap<Dynamic>):Void
	{		
		trace(param);
		 json_encode();		
	}
	
	function getRecordings(lead_id:Int):NativeArray
	{
		return query(
		'SELECT location, start_time, length_in_sec FROM recording_log WHERE lead_id = $lead_id AND length_in_sec>60 ORDER BY start_time DESC'
		);			
	}
	
	function save(q:StringMap<Dynamic>):Bool
	{
		var id = q.get('id');
		self.fieldNames.remove('id');
		return false;
	}
	
	public static function syncFromCRM1()
	{
		
	}
	
}