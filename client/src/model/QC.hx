package model;

import model.Contact.ContactProps;

typedef QCProps = {
	>ContactProps,

};

@:rtti
class QC extends Contact
{
	public static var tableName:String = "_memory";
	public static var customFields:Array<String> = 'lead_id,period,anrede,co_field,geburts_datum,account,blz,iban,bank_name,spenden_hoehe,start_monat,buchungs_tag,buchungs_zeitpunkt,mailing,client_status'.split(',');

	public function new(data:Map<String,String>) {
		super(data);		
		for(f in customFields)
		{
			if(data.exists(f)){
				var nv:Dynamic = data.get(f);
				//trace('$f => $nv ' + Reflect.field(fields, f).dataType[0]);
				Reflect.setField(this, f, nv);				
			}
		}
	}	
		
}