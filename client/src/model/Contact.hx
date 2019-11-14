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

class Contact extends ORM
{
	public static var varNames:String = 'id,mandator,creation_date,state,use_email,company_name,co_field,phone_code,phone_number,fax,title,title_pro,first_name,last_name,address,address_2,city,postal_code,country_code,gender,date_of_birth,mobile,email,comments,edited_by,merged,last_locktime,owner';
		public function new(props:ContactProps) {
		super(props);
		for(f in Reflect.fields(props))
		{
			Reflect.setField(this, f, Reflect.field(props, f));
		}
	}

	//{"type":"bigint","default":"null","attnum":"1"}
	@:isVar public var id(get,set):Int;
	var initial_id:Int;
	
	function get_id():Int{
		return id;
	}

	function set_id(x:Int):Int{

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

	//{"type":"bigint","default":"0","attnum":"2"}
	@:isVar public var mandator(get,set):Int;
	var initial_mandator:Int;
	
	function get_mandator():Int{
		return mandator;
	}

	function set_mandator(x:Int):Int{

		modified('mandator');
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

	//{"type":"timestamp(0) without time zone","default":"'CURRENT_TIMESTAMP'","attnum":"3"}
	@:isVar public var creation_date(get,set):String;
	var initial_creation_date:String;
	
	function get_creation_date():String{
			return creation_date;
	}

	function set_creation_date(x:String):String{

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

	//{"type":"character varying(64)","default":"'contact'","attnum":"4"}
	@:isVar public var state(get,set):String;
	var initial_state:String;
	
	function get_state():String{
		return state;
	}

	function set_state(x:String):String{

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

	//{"type":"boolean","default":"false","attnum":"5"}
	@:isVar public var use_email(get,set):Bool;
	var initial_use_email:Bool;
	
	function get_use_email():Bool{
		return use_email;
	}

	function set_use_email(x:Bool):Bool{

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

	//{"type":"character varying(64)","default":"''","attnum":"6"}
	@:isVar public var company_name(get,set):String;
	var initial_company_name:String;
	
	function get_company_name():String{
		return company_name;
	}

	function set_company_name(x:String):String{

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

	//{"type":"character varying(100)","default":"''","attnum":"7"}
	@:isVar public var co_field(get,set):String;
	var initial_co_field:String;
	
	function get_co_field():String{
		return co_field;
	}

	function set_co_field(x:String):String{

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

	//{"type":"character varying(10)","default":"'49'","attnum":"8"}
	@:isVar public var phone_code(get,set):String;
	var initial_phone_code:String;
	
	function get_phone_code():String{
		return phone_code;
	}

	function set_phone_code(x:String):String{

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

	//{"type":"character varying(18)","default":"''","attnum":"9"}
	@:isVar public var phone_number(get,set):String;
	var initial_phone_number:String;
	
	function get_phone_number():String{
		return phone_number;
	}

	function set_phone_number(x:String):String{

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

	//{"type":"character varying(18)","default":"''","attnum":"10"}
	@:isVar public var fax(get,set):String;
	var initial_fax:String;
	
	function get_fax():String{
		return fax;
	}

	function set_fax(x:String):String{

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

	//{"type":"character varying(64)","default":"''","attnum":"11"}
	@:isVar public var title(get,set):String;
	var initial_title:String;
	
	function get_title():String{
		return title;
	}

	function set_title(x:String):String{

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

	//{"type":"character varying(64)","default":"''","attnum":"12"}
	@:isVar public var title_pro(get,set):String;
	var initial_title_pro:String;
	
	function get_title_pro():String{
		return title_pro;
	}

	function set_title_pro(x:String):String{

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

	//{"type":"character varying(32)","default":"''","attnum":"13"}
	@:isVar public var first_name(get,set):String;
	var initial_first_name:String;
	
	function get_first_name():String{
		return first_name;
	}

	function set_first_name(x:String):String{

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

	//{"type":"character varying(32)","default":"''","attnum":"14"}
	@:isVar public var last_name(get,set):String;
	var initial_last_name:String;
	
	function get_last_name():String{
		return last_name;
	}

	function set_last_name(x:String):String{

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

	//{"type":"character varying(64)","default":"''","attnum":"15"}
	@:isVar public var address(get,set):String;
	var initial_address:String;
	
	function get_address():String{
		return address;
	}

	function set_address(x:String):String{

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

	//{"type":"character varying(64)","default":"''","attnum":"16"}
	@:isVar public var address_2(get,set):String;
	var initial_address_2:String;
	
	function get_address_2():String{
		return address_2;
	}

	function set_address_2(x:String):String{

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

	//{"type":"character varying(50)","default":"''","attnum":"17"}
	@:isVar public var city(get,set):String;
	var initial_city:String;
	
	function get_city():String{
		return city;
	}

	function set_city(x:String):String{

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

	//{"type":"character varying(10)","default":"''","attnum":"18"}
	@:isVar public var postal_code(get,set):String;
	var initial_postal_code:String;
	
	function get_postal_code():String{
		return postal_code;
	}

	function set_postal_code(x:String):String{

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

	//{"type":"character varying(3)","default":"''","attnum":"19"}
	@:isVar public var country_code(get,set):String;
	var initial_country_code:String;
	
	function get_country_code():String{
		return country_code;
	}

	function set_country_code(x:String):String{

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

	//{"type":"character varying(64)","default":"''","attnum":"20"}
	@:isVar public var gender(get,set):String;
	var initial_gender:String;
	
	function get_gender():String{
		return gender;
	}

	function set_gender(x:String):String{

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

	//{"type":"date","default":"'null'","attnum":"21"}
	@:isVar public var date_of_birth(get,set):String;
	var initial_date_of_birth:String;
	
	function get_date_of_birth():String{
			return date_of_birth;
	}

	function set_date_of_birth(x:String):String{

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

	//{"type":"character varying(19)","default":"''","attnum":"22"}
	@:isVar public var mobile(get,set):String;
	var initial_mobile:String;
	
	function get_mobile():String{
		return mobile;
	}

	function set_mobile(x:String):String{

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

	//{"type":"character varying(64)","default":"''","attnum":"23"}
	@:isVar public var email(get,set):String;
	var initial_email:String;
	
	function get_email():String{
		return email;
	}

	function set_email(x:String):String{

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

	//{"type":"character varying(4096)","default":"''","attnum":"24"}
	@:isVar public var comments(get,set):String;
	var initial_comments:String;
	
	function get_comments():String{
		return comments;
	}

	function set_comments(x:String):String{

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

	//{"type":"bigint","default":"0","attnum":"25"}
	@:isVar public var edited_by(get,set):Int;
	var initial_edited_by:Int;
	
	function get_edited_by():Int{
		return edited_by;
	}

	function set_edited_by(x:Int):Int{

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

	//{"type":"bigint[]","default":"[]","attnum":"26"}
	@:isVar public var merged(get,set):Array<Int>;
	var initial_merged:Array<Int>;
	
	function get_merged():Array<Int>{
		return merged;
	}

	function set_merged(x:Array<Int>):Array<Int>{

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

	//{"type":"timestamp(0) without time zone","default":"'CURRENT_TIMESTAMP'","attnum":"27"}
	@:isVar public var last_locktime(get,set):String;
	var initial_last_locktime:String;
	
	function get_last_locktime():String{
			return last_locktime;
	}

	function set_last_locktime(x:String):String{

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

	//{"type":"bigint","default":"null","attnum":"28"}
	@:isVar public var owner(get,set):Int;
	var initial_owner:Int;
	
	function get_owner():Int{
		return owner;
	}

	function set_owner(x:Int):Int{

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