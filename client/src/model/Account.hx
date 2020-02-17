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

	public function new(props:AccountProps) {
		propertyNames = 'id,contact,bank_name,bic,account,blz,iban,creditor,sign_date,state,creation_date,edited_by,last_locktime'.split(',');
		super(props);
	}	
		
	@dataType("bigint")
	@:isVar public var id(get,set):Int;
	var id_initialized:Bool;
	
	function get_id():Int{
		return id;
	}

	function set_id(id:Int):Int{
		if(id_initialized)
			modified('id');
		this.id = id;
		id_initialized = true; 
		return id;
	}

	public function clear_id():Int{
		trace('id primary key cannot be empty');
		return id;
	}	
		
	@dataType("bigint")
	@:isVar public var contact(get,set):Int;
	var contact_initialized:Bool;
	
	function get_contact():Int{
		return contact;
	}

	function set_contact(contact:Int):Int{
		if(contact_initialized)
			modified('contact');
		this.contact = contact;
		contact_initialized = true; 
		return contact;
	}

	public function clear_contact():Int{
		contact = null;
		return contact;
	}	
		
	@dataType("character varying(64)")
	@:isVar public var bank_name(get,set):String;
	var bank_name_initialized:Bool;
	
	function get_bank_name():String{
		return bank_name;
	}

	function set_bank_name(bank_name:String):String{
		if(bank_name_initialized)
			modified('bank_name');
		this.bank_name = bank_name;
		bank_name_initialized = true; 
		return bank_name;
	}

	public function clear_bank_name():String{
		bank_name = '';
		return bank_name;
	}	
		
	@dataType("character varying(11)")
	@:isVar public var bic(get,set):String;
	var bic_initialized:Bool;
	
	function get_bic():String{
		return bic;
	}

	function set_bic(bic:String):String{
		if(bic_initialized)
			modified('bic');
		this.bic = bic;
		bic_initialized = true; 
		return bic;
	}

	public function clear_bic():String{
		bic = '';
		return bic;
	}	
		
	@dataType("character varying(32)")
	@:isVar public var account(get,set):String;
	var account_initialized:Bool;
	
	function get_account():String{
		return account;
	}

	function set_account(account:String):String{
		if(account_initialized)
			modified('account');
		this.account = account;
		account_initialized = true; 
		return account;
	}

	public function clear_account():String{
		account = '';
		return account;
	}	
		
	@dataType("character varying(12)")
	@:isVar public var blz(get,set):String;
	var blz_initialized:Bool;
	
	function get_blz():String{
		return blz;
	}

	function set_blz(blz:String):String{
		if(blz_initialized)
			modified('blz');
		this.blz = blz;
		blz_initialized = true; 
		return blz;
	}

	public function clear_blz():String{
		blz = '';
		return blz;
	}	
		
	@dataType("character varying(32)")
	@:isVar public var iban(get,set):String;
	var iban_initialized:Bool;
	
	function get_iban():String{
		return iban;
	}

	function set_iban(iban:String):String{
		if(iban_initialized)
			modified('iban');
		this.iban = iban;
		iban_initialized = true; 
		return iban;
	}

	public function clear_iban():String{
		iban = '';
		return iban;
	}	
		
	@dataType("bigint")
	@:isVar public var creditor(get,set):Int;
	var creditor_initialized:Bool;
	
	function get_creditor():Int{
		return creditor;
	}

	function set_creditor(creditor:Int):Int{
		if(creditor_initialized)
			modified('creditor');
		this.creditor = creditor;
		creditor_initialized = true; 
		return creditor;
	}

	public function clear_creditor():Int{
		creditor = null;
		return creditor;
	}	
		
	@dataType("date")
	@:isVar public var sign_date(get,set):String;
	var sign_date_initialized:Bool;
	
	function get_sign_date():String{
			return sign_date;
	}

	function set_sign_date(sign_date:String):String{
		if(sign_date_initialized)
			modified('sign_date');
		this.sign_date = sign_date;
		sign_date_initialized = true; 
		return sign_date;
	}

	public function clear_sign_date():String{
		sign_date = 'null';
		return sign_date;
	}	
		
	@dataType("accounts_state")
	@:isVar public var state(get,set):String;
	var state_initialized:Bool;
	
	function get_state():String{
			return state;
	}

	function set_state(state:String):String{
		if(state_initialized)
			modified('state');
		this.state = state;
		state_initialized = true; 
		return state;
	}

	public function clear_state():String{
		state = 'new';
		return state;
	}	
		
	@dataType("timestamp without time zone")
	@:isVar public var creation_date(get,set):String;
	var creation_date_initialized:Bool;
	
	function get_creation_date():String{
			return creation_date;
	}

	function set_creation_date(creation_date:String):String{
		if(creation_date_initialized)
			modified('creation_date');
		this.creation_date = creation_date;
		creation_date_initialized = true; 
		return creation_date;
	}

	public function clear_creation_date():String{
		creation_date = 'CURRENT_TIMESTAMP';
		return creation_date;
	}	
		
	@dataType("bigint")
	@:isVar public var edited_by(get,set):Int;
	var edited_by_initialized:Bool;
	
	function get_edited_by():Int{
		return edited_by;
	}

	function set_edited_by(edited_by:Int):Int{
		if(edited_by_initialized)
			modified('edited_by');
		this.edited_by = edited_by;
		edited_by_initialized = true; 
		return edited_by;
	}

	public function clear_edited_by():Int{
		edited_by = null;
		return edited_by;
	}	
		
	@dataType("timestamp(0) without time zone")
	@:isVar public var last_locktime(get,set):String;
	var last_locktime_initialized:Bool;
	
	function get_last_locktime():String{
			return last_locktime;
	}

	function set_last_locktime(last_locktime:String):String{
		if(last_locktime_initialized)
			modified('last_locktime');
		this.last_locktime = last_locktime;
		last_locktime_initialized = true; 
		return last_locktime;
	}

	public function clear_last_locktime():String{
		last_locktime = 'CURRENT_TIMESTAMP';
		return last_locktime;
	}	
	
}