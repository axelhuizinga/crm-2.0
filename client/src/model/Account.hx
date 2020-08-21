package model;

typedef AccountProps = {
	?id:Int,
	?contact:Int,
	?bank_name:String,
	?bic:String,
	?account:String,
	?blz:String,
	?iban:String,
	?creditor:Int,
	?sign_date:String,
	?state:String,
	?creation_date:String,
	?edited_by:Int,
	?last_locktime:String
};

@:rtti
class Account extends ORM
{

	public function new(data:Map<String,String>) {
		super(data);
		propertyNames = 'id,contact,bank_name,bic,account,blz,iban,creditor,sign_date,state,creation_date,edited_by,last_locktime'.split(',');
	}	
		
	@dataType("bigint")
	@:isVar public var id(default,set):Int;

	function set_id(id:Int):Int{
		if(initialized('id'))
			modified('id');
		this.id = id ;
		return id;
	}	
		
	@dataType("bigint")
	@:isVar public var contact(default,set):Int;

	function set_contact(contact:Int):Int{
		if(initialized('contact'))
			modified('contact');
		this.contact = contact ;
		return contact;
	}	
		
	@dataType("character varying(64)")
	@:isVar public var bank_name(default,set):String;

	function set_bank_name(bank_name:String):String{
		if(initialized('bank_name'))
			modified('bank_name');
		this.bank_name = bank_name ;
		return bank_name;
	}	
		
	@dataType("character varying(11)")
	@:isVar public var bic(default,set):String;

	function set_bic(bic:String):String{
		if(initialized('bic'))
			modified('bic');
		this.bic = bic ;
		return bic;
	}	
		
	@dataType("character varying(32)")
	@:isVar public var account(default,set):String;

	function set_account(account:String):String{
		if(initialized('account'))
			modified('account');
		this.account = account ;
		return account;
	}	
		
	@dataType("character varying(12)")
	@:isVar public var blz(default,set):String;

	function set_blz(blz:String):String{
		if(initialized('blz'))
			modified('blz');
		this.blz = blz ;
		return blz;
	}	
		
	@dataType("character varying(32)")
	@:isVar public var iban(default,set):String;

	function set_iban(iban:String):String{
		if(initialized('iban'))
			modified('iban');
		this.iban = iban ;
		return iban;
	}	
		
	@dataType("bigint")
	@:isVar public var creditor(default,set):Int;

	function set_creditor(creditor:Int):Int{
		if(initialized('creditor'))
			modified('creditor');
		this.creditor = creditor ;
		return creditor;
	}	
		
	@dataType("date")
	@:isVar public var sign_date(default,set):String;

	function set_sign_date(sign_date:String):String{
		if(initialized('sign_date'))
			modified('sign_date');
		this.sign_date = sign_date ;
		return sign_date;
	}	
		
	@dataType("accounts_state")
	@:isVar public var state(default,set):String;

	function set_state(state:String):String{
		if(initialized('state'))
			modified('state');
		this.state = state ;
		return state;
	}	
		
	@dataType("timestamp without time zone")
	@:isVar public var creation_date(default,set):String;

	function set_creation_date(creation_date:String):String{
		if(initialized('creation_date'))
			modified('creation_date');
		this.creation_date = creation_date ;
		return creation_date;
	}	
		
	@dataType("bigint")
	@:isVar public var edited_by(default,set):Int;

	function set_edited_by(edited_by:Int):Int{
		if(initialized('edited_by'))
			modified('edited_by');
		this.edited_by = edited_by ;
		return edited_by;
	}	
		
	@dataType("timestamp(0) without time zone")
	@:isVar public var last_locktime(default,set):String;

	function set_last_locktime(last_locktime:String):String{
		if(initialized('last_locktime'))
			modified('last_locktime');
		this.last_locktime = last_locktime ;
		return last_locktime;
	}	
	
}