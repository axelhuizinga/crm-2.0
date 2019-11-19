package model;

typedef ContactProps = {
	?id:Int,
	?mandator:Int,
	?creation_date:String,
	?state:String,
	?use_email:Bool,
	?company_name:String,
	?co_field:String,
	?phone_code:String,
	?phone_number:String,
	?fax:String,
	?title:String,
	?title_pro:String,
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
	?last_locktime:String,
	?owner:Int
};

@:rtti
class Contact extends ORM
{

	public function new(props:ContactProps) {
		propertyNames = 'id,mandator,creation_date,state,use_email,company_name,co_field,phone_code,phone_number,fax,title,title_pro,first_name,last_name,address,address_2,city,postal_code,country_code,gender,date_of_birth,mobile,email,comments,edited_by,merged,last_locktime,owner'.split(',');
		super(props);

	}	
		
	@dataType("bigint")
	@:isVar public var id(get,set):Int;
	var initial_id:Int;
	
	function get_id():Int{
		return id;
	}

	function set_id(x:Int):Int{
		if(id != null)
			modified('id');
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
	}
		
	@dataType("bigint")
	@:isVar public var mandator(get,set):Int;
	var initial_mandator:Int;
	
	function get_mandator():Int{
		return mandator;
	}

	function set_mandator(x:Int):Int{
		if(mandator != null)
		{
			trace(mandator);
			modified('mandator');
		}
		trace(x);
		mandator = x;
		if(initial_mandator == null)
			initial_mandator = mandator; 
		return mandator;
	}

	public function reset_mandator():Int{
		return initial_mandator;
	}

	public function clear_mandator():Int{
		mandator = 0;
		return mandator;
	}
		
	@dataType("timestamp(0) without time zone")
	@:isVar public var creation_date(get,set):String;
	var initial_creation_date:String;
	
	function get_creation_date():String{
			return creation_date;
	}

	function set_creation_date(x:String):String{
		if(creation_date != null)
			modified('creation_date');
		creation_date = x;
		if(initial_creation_date == null)
			initial_creation_date = creation_date; 
		return creation_date;
	}

	public function reset_creation_date():String{
		return initial_creation_date;
	}

	public function clear_creation_date():String{
		creation_date = 'CURRENT_TIMESTAMP';
		return creation_date;
	}
		
	@dataType("character varying(64)")
	@:isVar public var state(get,set):String;
	var initial_state:String;
	
	function get_state():String{
		return state;
	}

	function set_state(x:String):String{
		if(state != null)
			modified('state');
		state = x;
		if(initial_state == null)
			initial_state = state; 
		return state;
	}

	public function reset_state():String{
		return initial_state;
	}

	public function clear_state():String{
		state = 'contact';
		return state;
	}
		
	@dataType("boolean")
	@:isVar public var use_email(get,set):Bool;
	var initial_use_email:Bool;
	
	function get_use_email():Bool{
		return use_email;
	}

	function set_use_email(x:Bool):Bool{
		if(use_email != null)
			modified('use_email');
		use_email = x;
		if(initial_use_email == null)
			initial_use_email = use_email; 
		return use_email;
	}

	public function reset_use_email():Bool{
		return initial_use_email;
	}

	public function clear_use_email():Bool{
		use_email = false;
		return use_email;
	}
		
	@dataType("character varying(64)")
	@:isVar public var company_name(get,set):String;
	var initial_company_name:String;
	
	function get_company_name():String{
		return company_name;
	}

	function set_company_name(x:String):String{
		if(company_name != null)
			modified('company_name');
		company_name = x;
		if(initial_company_name == null)
			initial_company_name = company_name; 
		return company_name;
	}

	public function reset_company_name():String{
		return initial_company_name;
	}

	public function clear_company_name():String{
		company_name = '';
		return company_name;
	}
		
	@dataType("character varying(100)")
	@:isVar public var co_field(get,set):String;
	var initial_co_field:String;
	
	function get_co_field():String{
		return co_field;
	}

	function set_co_field(x:String):String{
		if(co_field != null)
			modified('co_field');
		co_field = x;
		if(initial_co_field == null)
			initial_co_field = co_field; 
		return co_field;
	}

	public function reset_co_field():String{
		return initial_co_field;
	}

	public function clear_co_field():String{
		co_field = '';
		return co_field;
	}
		
	@dataType("character varying(10)")
	@:isVar public var phone_code(get,set):String;
	var initial_phone_code:String;
	
	function get_phone_code():String{
		return phone_code;
	}

	function set_phone_code(x:String):String{
		if(phone_code != null)
			modified('phone_code');
		phone_code = x;
		if(initial_phone_code == null)
			initial_phone_code = phone_code; 
		return phone_code;
	}

	public function reset_phone_code():String{
		return initial_phone_code;
	}

	public function clear_phone_code():String{
		phone_code = '49';
		return phone_code;
	}
		
	@dataType("character varying(18)")
	@:isVar public var phone_number(get,set):String;
	var initial_phone_number:String;
	
	function get_phone_number():String{
		return phone_number;
	}

	function set_phone_number(x:String):String{
		if(phone_number != null)
			modified('phone_number');
		phone_number = x;
		if(initial_phone_number == null)
			initial_phone_number = phone_number; 
		return phone_number;
	}

	public function reset_phone_number():String{
		return initial_phone_number;
	}

	public function clear_phone_number():String{
		phone_number = '';
		return phone_number;
	}
		
	@dataType("character varying(18)")
	@:isVar public var fax(get,set):String;
	var initial_fax:String;
	
	function get_fax():String{
		return fax;
	}

	function set_fax(x:String):String{
		if(fax != null)
			modified('fax');
		fax = x;
		if(initial_fax == null)
			initial_fax = fax; 
		return fax;
	}

	public function reset_fax():String{
		return initial_fax;
	}

	public function clear_fax():String{
		fax = '';
		return fax;
	}
		
	@dataType("character varying(64)")
	@:isVar public var title(get,set):String;
	var initial_title:String;
	
	function get_title():String{
		return title;
	}

	function set_title(x:String):String{
		if(title != null)
			modified('title');
		title = x;
		if(initial_title == null)
			initial_title = title; 
		return title;
	}

	public function reset_title():String{
		return initial_title;
	}

	public function clear_title():String{
		title = '';
		return title;
	}
		
	@dataType("character varying(64)")
	@:isVar public var title_pro(get,set):String;
	var initial_title_pro:String;
	
	function get_title_pro():String{
		return title_pro;
	}

	function set_title_pro(x:String):String{
		if(title_pro != null)
			modified('title_pro');
		title_pro = x;
		if(initial_title_pro == null)
			initial_title_pro = title_pro; 
		return title_pro;
	}

	public function reset_title_pro():String{
		return initial_title_pro;
	}

	public function clear_title_pro():String{
		title_pro = '';
		return title_pro;
	}
		
	@dataType("character varying(32)")
	@:isVar public var first_name(get,set):String;
	var initial_first_name:String;
	
	function get_first_name():String{
		return first_name;
	}

	function set_first_name(x:String):String{
		if(first_name != null)
			modified('first_name');
		first_name = x;
		if(initial_first_name == null)
			initial_first_name = first_name; 
		return first_name;
	}

	public function reset_first_name():String{
		return initial_first_name;
	}

	public function clear_first_name():String{
		first_name = '';
		return first_name;
	}
		
	@dataType("character varying(32)")
	@:isVar public var last_name(get,set):String;
	var initial_last_name:String;
	
	function get_last_name():String{
		return last_name;
	}

	function set_last_name(x:String):String{
		if(last_name != null)
			modified('last_name');
		last_name = x;
		if(initial_last_name == null)
			initial_last_name = last_name; 
		return last_name;
	}

	public function reset_last_name():String{
		return initial_last_name;
	}

	public function clear_last_name():String{
		last_name = '';
		return last_name;
	}
		
	@dataType("character varying(64)")
	@:isVar public var address(get,set):String;
	var initial_address:String;
	
	function get_address():String{
		return address;
	}

	function set_address(x:String):String{
		if(address != null)
			modified('address');
		address = x;
		if(initial_address == null)
			initial_address = address; 
		return address;
	}

	public function reset_address():String{
		return initial_address;
	}

	public function clear_address():String{
		address = '';
		return address;
	}
		
	@dataType("character varying(64)")
	@:isVar public var address_2(get,set):String;
	var initial_address_2:String;
	
	function get_address_2():String{
		return address_2;
	}

	function set_address_2(x:String):String{
		if(address_2 != null)
			modified('address_2');
		address_2 = x;
		if(initial_address_2 == null)
			initial_address_2 = address_2; 
		return address_2;
	}

	public function reset_address_2():String{
		return initial_address_2;
	}

	public function clear_address_2():String{
		address_2 = '';
		return address_2;
	}
		
	@dataType("character varying(50)")
	@:isVar public var city(get,set):String;
	var initial_city:String;
	
	function get_city():String{
		return city;
	}

	function set_city(x:String):String{
		if(city != null)
			modified('city');
		city = x;
		if(initial_city == null)
			initial_city = city; 
		return city;
	}

	public function reset_city():String{
		return initial_city;
	}

	public function clear_city():String{
		city = '';
		return city;
	}
		
	@dataType("character varying(10)")
	@:isVar public var postal_code(get,set):String;
	var initial_postal_code:String;
	
	function get_postal_code():String{
		return postal_code;
	}

	function set_postal_code(x:String):String{
		if(postal_code != null)
			modified('postal_code');
		postal_code = x;
		if(initial_postal_code == null)
			initial_postal_code = postal_code; 
		return postal_code;
	}

	public function reset_postal_code():String{
		return initial_postal_code;
	}

	public function clear_postal_code():String{
		postal_code = '';
		return postal_code;
	}
		
	@dataType("character varying(3)")
	@:isVar public var country_code(get,set):String;
	var initial_country_code:String;
	
	function get_country_code():String{
		return country_code;
	}

	function set_country_code(x:String):String{
		if(country_code != null)
			modified('country_code');
		country_code = x;
		if(initial_country_code == null)
			initial_country_code = country_code; 
		return country_code;
	}

	public function reset_country_code():String{
		return initial_country_code;
	}

	public function clear_country_code():String{
		country_code = '';
		return country_code;
	}
		
	@dataType("character varying(64)")
	@:isVar public var gender(get,set):String;
	var initial_gender:String;
	
	function get_gender():String{
		return gender;
	}

	function set_gender(x:String):String{
		if(gender != null)
			modified('gender');
		gender = x;
		if(initial_gender == null)
			initial_gender = gender; 
		return gender;
	}

	public function reset_gender():String{
		return initial_gender;
	}

	public function clear_gender():String{
		gender = '';
		return gender;
	}
		
	@dataType("date")
	@:isVar public var date_of_birth(get,set):String;
	var initial_date_of_birth:String;
	
	function get_date_of_birth():String{
			return date_of_birth;
	}

	function set_date_of_birth(x:String):String{
		if(date_of_birth != null)
			modified('date_of_birth');
		date_of_birth = x;
		if(initial_date_of_birth == null)
			initial_date_of_birth = date_of_birth; 
		return date_of_birth;
	}

	public function reset_date_of_birth():String{
		return initial_date_of_birth;
	}

	public function clear_date_of_birth():String{
		date_of_birth = 'null';
		return date_of_birth;
	}
		
	@dataType("character varying(19)")
	@:isVar public var mobile(get,set):String;
	var initial_mobile:String;
	
	function get_mobile():String{
		return mobile;
	}

	function set_mobile(x:String):String{
		if(mobile != null)
			modified('mobile');
		mobile = x;
		if(initial_mobile == null)
			initial_mobile = mobile; 
		return mobile;
	}

	public function reset_mobile():String{
		return initial_mobile;
	}

	public function clear_mobile():String{
		mobile = '';
		return mobile;
	}
		
	@dataType("character varying(64)")
	@:isVar public var email(get,set):String;
	var initial_email:String;
	
	function get_email():String{
		return email;
	}

	function set_email(x:String):String{
		if(email != null)
			modified('email');
		email = x;
		if(initial_email == null)
			initial_email = email; 
		return email;
	}

	public function reset_email():String{
		return initial_email;
	}

	public function clear_email():String{
		email = '';
		return email;
	}
		
	@dataType("character varying(4096)")
	@:isVar public var comments(get,set):String;
	var initial_comments:String;
	
	function get_comments():String{
		return comments;
	}

	function set_comments(x:String):String{
		if(comments != null)
			modified('comments');
		comments = x;
		if(initial_comments == null)
			initial_comments = comments; 
		return comments;
	}

	public function reset_comments():String{
		return initial_comments;
	}

	public function clear_comments():String{
		comments = '';
		return comments;
	}
		
	@dataType("bigint")
	@:isVar public var edited_by(get,set):Int;
	var initial_edited_by:Int;
	
	function get_edited_by():Int{
		return edited_by;
	}

	function set_edited_by(x:Int):Int{
		if(edited_by != null)
			modified('edited_by');
		edited_by = x;
		if(initial_edited_by == null)
			initial_edited_by = edited_by; 
		return edited_by;
	}

	public function reset_edited_by():Int{
		return initial_edited_by;
	}

	public function clear_edited_by():Int{
		edited_by = 0;
		return edited_by;
	}
		
	@dataType("bigint[]")
	@:isVar public var merged(get,set):Array<Int>;
	var initial_merged:Array<Int>;
	
	function get_merged():Array<Int>{
		return merged;
	}

	function set_merged(x:Array<Int>):Array<Int>{
		if(merged != null)
			modified('merged');
		merged = x;
		if(initial_merged == null)
			initial_merged = merged; 
		return merged;
	}

	public function reset_merged():Array<Int>{
		return initial_merged;
	}

	public function clear_merged():Array<Int>{
		merged = [];
		return merged;
	}
		
	@dataType("timestamp(0) without time zone")
	@:isVar public var last_locktime(get,set):String;
	var initial_last_locktime:String;
	
	function get_last_locktime():String{
			return last_locktime;
	}

	function set_last_locktime(x:String):String{
		if(last_locktime != null)
			modified('last_locktime');
		last_locktime = x;
		if(initial_last_locktime == null)
			initial_last_locktime = last_locktime; 
		return last_locktime;
	}

	public function reset_last_locktime():String{
		return initial_last_locktime;
	}

	public function clear_last_locktime():String{
		last_locktime = 'CURRENT_TIMESTAMP';
		return last_locktime;
	}
		
	@dataType("bigint")
	@:isVar public var owner(get,set):Int;
	var initial_owner:Int;
	
	function get_owner():Int{
		return owner;
	}

	function set_owner(x:Int):Int{
		if(owner != null)
			modified('owner');
		owner = x;
		if(initial_owner == null)
			initial_owner = owner; 
		return owner;
	}

	public function reset_owner():Int{
		return initial_owner;
	}

	public function clear_owner():Int{
		owner = null;
		return owner;
	}
	
}