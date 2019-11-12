package model;
class Account extends ORM
{
	//{"type":"bigint","default":"null","attnum":"1"}
	public var id(get,set):Int;
	var initial_id:Int;
	
	function get_id():Int{
		return id;
	}

	function set_id(x:Int):Int{

		modified(this,id);
		id = x;
		if(initial_id == null)
			initial_id = id; 
		return id;
	}

	public function reset_id():Int{
		return initial_id;
	}

	public function clear_id():Int{
		id = null;
		return id;
	}//{"type":"bigint","default":"","attnum":"2"}
	public var contact(get,set):Int;
	var initial_contact:Int;
	
	function get_contact():Int{
		return contact;
	}

	function set_contact(x:Int):Int{

		modified(this,contact);
		contact = x;
		if(initial_contact == null)
			initial_contact = contact; 
		return contact;
	}

	public function reset_contact():Int{
		return initial_contact;
	}

	public function clear_contact():Int{
		contact = ;
		return contact;
	}//{"type":"character varying(64)","default":"","attnum":"3"}
	public var owner(get,set):String;
	var initial_owner:String;
	
	function get_owner():String{
		return owner;
	}

	function set_owner(x:String):String{

		modified(this,owner);
		owner = x;
		if(initial_owner == null)
			initial_owner = owner; 
		return owner;
	}

	public function reset_owner():String{
		return initial_owner;
	}

	public function clear_owner():String{
		owner = ;
		return owner;
	}//{"type":"character varying(64)","default":"","attnum":"4"}
	public var bank_name(get,set):String;
	var initial_bank_name:String;
	
	function get_bank_name():String{
		return bank_name;
	}

	function set_bank_name(x:String):String{

		modified(this,bank_name);
		bank_name = x;
		if(initial_bank_name == null)
			initial_bank_name = bank_name; 
		return bank_name;
	}

	public function reset_bank_name():String{
		return initial_bank_name;
	}

	public function clear_bank_name():String{
		bank_name = ;
		return bank_name;
	}//{"type":"character varying(11)","default":"''","attnum":"5"}
	public var bic(get,set):String;
	var initial_bic:String;
	
	function get_bic():String{
		return bic;
	}

	function set_bic(x:String):String{

		modified(this,bic);
		bic = x;
		if(initial_bic == null)
			initial_bic = bic; 
		return bic;
	}

	public function reset_bic():String{
		return initial_bic;
	}

	public function clear_bic():String{
		bic = '';
		return bic;
	}//{"type":"character varying(32)","default":"''","attnum":"6"}
	public var account(get,set):String;
	var initial_account:String;
	
	function get_account():String{
		return account;
	}

	function set_account(x:String):String{

		modified(this,account);
		account = x;
		if(initial_account == null)
			initial_account = account; 
		return account;
	}

	public function reset_account():String{
		return initial_account;
	}

	public function clear_account():String{
		account = '';
		return account;
	}//{"type":"character varying(12)","default":"''","attnum":"7"}
	public var blz(get,set):String;
	var initial_blz:String;
	
	function get_blz():String{
		return blz;
	}

	function set_blz(x:String):String{

		modified(this,blz);
		blz = x;
		if(initial_blz == null)
			initial_blz = blz; 
		return blz;
	}

	public function reset_blz():String{
		return initial_blz;
	}

	public function clear_blz():String{
		blz = '';
		return blz;
	}//{"type":"character varying(32)","default":"","attnum":"8"}
	public var iban(get,set):String;
	var initial_iban:String;
	
	function get_iban():String{
		return iban;
	}

	function set_iban(x:String):String{

		modified(this,iban);
		iban = x;
		if(initial_iban == null)
			initial_iban = iban; 
		return iban;
	}

	public function reset_iban():String{
		return initial_iban;
	}

	public function clear_iban():String{
		iban = ;
		return iban;
	}//{"type":"bigint","default":"","attnum":"9"}
	public var creditor(get,set):Int;
	var initial_creditor:Int;
	
	function get_creditor():Int{
		return creditor;
	}

	function set_creditor(x:Int):Int{

		modified(this,creditor);
		creditor = x;
		if(initial_creditor == null)
			initial_creditor = creditor; 
		return creditor;
	}

	public function reset_creditor():Int{
		return initial_creditor;
	}

	public function clear_creditor():Int{
		creditor = ;
		return creditor;
	}//{"type":"date","default":"null","attnum":"10"}
	public var sign_date(get,set):String;
	var initial_sign_date:String;
	
	function get_sign_date():String{
			return sign_date;
	}

	function set_sign_date(x:String):String{

		modified(this,sign_date);
		sign_date = x;
		if(initial_sign_date == null)
			initial_sign_date = sign_date; 
		return sign_date;
	}

	public function reset_sign_date():String{
		return initial_sign_date;
	}

	public function clear_sign_date():String{
		sign_date = null;
		return sign_date;
	}//{"type":"accounts_state","default":"'new'","attnum":"11"}
	public var state(get,set):String;
	var initial_state:String;
	
	function get_state():String{
			return state;
	}

	function set_state(x:String):String{

		modified(this,state);
		state = x;
		if(initial_state == null)
			initial_state = state; 
		return state;
	}

	public function reset_state():String{
		return initial_state;
	}

	public function clear_state():String{
		state = 'new';
		return state;
	}//{"type":"timestamp without time zone","default":"now()","attnum":"12"}
	public var creation_date(get,set):String;
	var initial_creation_date:String;
	
	function get_creation_date():String{
			return creation_date;
	}

	function set_creation_date(x:String):String{

		modified(this,creation_date);
		creation_date = x;
		if(initial_creation_date == null)
			initial_creation_date = creation_date; 
		return creation_date;
	}

	public function reset_creation_date():String{
		return initial_creation_date;
	}

	public function clear_creation_date():String{
		creation_date = now();
		return creation_date;
	}//{"type":"bigint","default":"","attnum":"13"}
	public var edited_by(get,set):Int;
	var initial_edited_by:Int;
	
	function get_edited_by():Int{
		return edited_by;
	}

	function set_edited_by(x:Int):Int{

		modified(this,edited_by);
		edited_by = x;
		if(initial_edited_by == null)
			initial_edited_by = edited_by; 
		return edited_by;
	}

	public function reset_edited_by():Int{
		return initial_edited_by;
	}

	public function clear_edited_by():Int{
		edited_by = ;
		return edited_by;
	}//{"type":"timestamp(0) without time zone","default":"CURRENT_TIMESTAMP","attnum":"14"}
	public var last_locktime(get,set):String;
	var initial_last_locktime:String;
	
	function get_last_locktime():String{
			return last_locktime;
	}

	function set_last_locktime(x:String):String{

		modified(this,last_locktime);
		last_locktime = x;
		if(initial_last_locktime == null)
			initial_last_locktime = last_locktime; 
		return last_locktime;
	}

	public function reset_last_locktime():String{
		return initial_last_locktime;
	}

	public function clear_last_locktime():String{
		last_locktime = CURRENT_TIMESTAMP;
		return last_locktime;
	}
}