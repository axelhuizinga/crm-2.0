package model;

typedef QCProps = {
	?mandator:Int,
	?creation_date:String,
	?status:String,
	?use_email:Bool,
	?company_name:String,
	?care_of:String,
	?phone_code:String,
	?phone_number:String,
	?fax:String,
	?title:String,
	?first_name:String,
	?last_name:String,
	?address:String,
	?address_2:String,
	?city:String,
	?postal_code:String,
	?country_code:String,
	?gender:String,
	?date_of_birth:String,
	?mobile:String,
	?email:String,
	?comments:String,
	?edited_by:Int,
	?merged:Array<Int>,
	?last_updated:String,
	?owner:Int
};

@:rtti
class QC extends Contact
{
	public static var tableName:String = "contacts";

	public function new(data:Map<String,String>) {
		super(data);		
	}	
		
}