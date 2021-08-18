package model;

typedef DebitReturnStatementProps = {
	?sepa_code:String,
	?iban:String,
	?ba_id:String,
	?amount:String,
	?mandator:Int,
	?last_modified:String,
	?processed:Bool,
	?created_at:String,
	?value_date:String
};

@:keep
@:rtti
class DebitReturnStatement extends ORM
{
	public static var tableName:String = "debit_return_statements";

	public function new(data:Map<String,String>) {
		super(data);		
	}	
		
	@dataType("text")
	@:isVar public var sepa_code(default,set):String;

	function set_sepa_code(sepa_code:String):String{
		if(initialized('sepa_code'))
			modified('sepa_code');
		this.sepa_code = sepa_code ;
		return sepa_code;
	}	
		
	@dataType("character varying")
	@:isVar public var iban(default,set):String;

	function set_iban(iban:String):String{
		if(initialized('iban'))
			modified('iban');
		this.iban = iban ;
		return iban;
	}	
		
	@dataType("character varying")
	@:isVar public var ba_id(default,set):String;

	function set_ba_id(ba_id:String):String{
		if(initialized('ba_id'))
			modified('ba_id');
		this.ba_id = ba_id ;
		return ba_id;
	}	
		
	@dataType("numeric")
	@:isVar public var amount(default,set):String;

	function set_amount(amount:String):String{
		if(initialized('amount'))
			modified('amount');
		this.amount = amount ;
		return amount;
	}	
		
	@dataType("bigint")
	@:isVar public var mandator(default,set):Int;

	function set_mandator(mandator:Int):Int{
		if(initialized('mandator'))
			modified('mandator');
		this.mandator = mandator ;
		return mandator;
	}	
		
	@dataType("timestamp with time zone")
	@:isVar public var last_modified(default,set):String;

	function set_last_modified(last_modified:String):String{
		if(initialized('last_modified'))
			modified('last_modified');
		this.last_modified = last_modified ;
		return last_modified;
	}	
		
	@dataType("boolean")
	@:isVar public var processed(default,set):Bool;

	function set_processed(processed:Bool):Bool{
		if(initialized('processed'))
			modified('processed');
		this.processed = processed ;
		return processed;
	}	
		
	@dataType("timestamp with time zone")
	@:isVar public var created_at(default,set):String;

	function set_created_at(created_at:String):String{
		if(initialized('created_at'))
			modified('created_at');
		this.created_at = created_at ;
		return created_at;
	}	
		
	@dataType("date")
	@:isVar public var value_date(default,set):String;

	function set_value_date(value_date:String):String{
		if(initialized('value_date'))
			modified('value_date');
		this.value_date = value_date ;
		return value_date;
	}	
	
}