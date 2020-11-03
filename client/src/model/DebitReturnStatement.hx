package model;

typedef DebitReturnStatementProps = {
	?reason:String,
	?iban:String,
	?ba_id:String,
	?amount:String
};

@:rtti
class DebitReturnStatement extends ORM
{

	public function new(data:Map<String,String>) {
		super(data);
		propertyNames = 'reason,iban,ba_id,amount'.split(',');
	}	
		
	@dataType("text")
	@:isVar public var reason(default,set):String;

	function set_reason(reason:String):String{
		if(initialized('reason'))
			modified('reason');
		this.reason = reason ;
		return reason;
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
	
}