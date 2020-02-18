package model;
import haxe.rtti.Meta;
import view.shared.io.DataAccess.DataView;

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

	public function new(props:ContactProps, view:DataView) {
		//propertyNames = 'id,mandator,creation_date,state,use_email,company_name,co_field,phone_code,phone_number,fax,title,title_pro,first_name,last_name,address,address_2,city,postal_code,country_code,gender,date_of_birth,mobile,email,comments,edited_by,merged,last_locktime,owner'.split(',');
		super(props, view);
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
		this.id = id ;
		id_initialized = true; 
		return id;
	}	
		
	@dataType("bigint")
	@:isVar public var mandator(get,set):Int;
	var mandator_initialized:Bool;
	
	function get_mandator():Int{
		return mandator;
	}

	function set_mandator(mandator:Int):Int{
		if(mandator_initialized)
			modified('mandator');
		this.mandator = mandator ;
		mandator_initialized = true; 
		return mandator;
	}	
		
	@dataType("timestamp(0) without time zone")
	@:isVar public var creation_date(get,set):String;
	var creation_date_initialized:Bool;
	
	function get_creation_date():String{
			return creation_date;
	}

	function set_creation_date(creation_date:String):String{
		if(creation_date_initialized)
			modified('creation_date');
		this.creation_date = creation_date ;
		creation_date_initialized = true; 
		return creation_date;
	}	
		
	@dataType("character varying(64)")
	@:isVar public var state(get,set):String;
	var state_initialized:Bool;
	
	function get_state():String{
		return state;
	}

	function set_state(state:String):String{
		if(state_initialized)
			modified('state');
		this.state = state ;
		state_initialized = true; 
		return state;
	}	
		
	@dataType("boolean")
	@:isVar public var use_email(get,set):Bool;
	var use_email_initialized:Bool;
	
	function get_use_email():Bool{
		return use_email;
	}

	function set_use_email(use_email:Bool):Bool{
		if(use_email_initialized)
			modified('use_email');
		this.use_email = use_email ;
		use_email_initialized = true; 
		return use_email;
	}	
		
	@dataType("character varying(64)")
	@:isVar public var company_name(get,set):String;
	var company_name_initialized:Bool;
	
	function get_company_name():String{
		return company_name;
	}

	function set_company_name(company_name:String):String{
		if(company_name_initialized)
			modified('company_name');
		this.company_name = company_name ;
		company_name_initialized = true; 
		return company_name;
	}	
		
	@dataType("character varying(100)")
	@:isVar public var co_field(get,set):String;
	var co_field_initialized:Bool;
	
	function get_co_field():String{
		return co_field;
	}

	function set_co_field(co_field:String):String{
		if(co_field_initialized)
			modified('co_field');
		this.co_field = co_field ;
		co_field_initialized = true; 
		return co_field;
	}	
		
	@dataType("character varying(10)")
	@:isVar public var phone_code(get,set):String;
	var phone_code_initialized:Bool;
	
	function get_phone_code():String{
		return phone_code;
	}

	function set_phone_code(phone_code:String):String{
		if(phone_code_initialized)
			modified('phone_code');
		this.phone_code = phone_code ;
		phone_code_initialized = true; 
		return phone_code;
	}	
		
	@dataType("character varying(18)")
	@:isVar public var phone_number(get,set):String;
	var phone_number_initialized:Bool;
	
	function get_phone_number():String{
		return phone_number;
	}

	function set_phone_number(phone_number:String):String{
		if(phone_number_initialized)
			modified('phone_number');
		this.phone_number = phone_number ;
		phone_number_initialized = true; 
		return phone_number;
	}	
		
	@dataType("character varying(18)")
	@:isVar public var fax(get,set):String;
	var fax_initialized:Bool;
	
	function get_fax():String{
		return fax;
	}

	function set_fax(fax:String):String{
		if(fax_initialized)
			modified('fax');
		this.fax = fax ;
		fax_initialized = true; 
		return fax;
	}	
		
	@dataType("character varying(64)")
	@:isVar public var title(get,set):String;
	var title_initialized:Bool;
	
	function get_title():String{
		return title;
	}

	function set_title(title:String):String{
		if(title_initialized)
			modified('title');
		this.title = title ;
		title_initialized = true; 
		return title;
	}	
		
	@dataType("character varying(64)")
	@:isVar public var title_pro(get,set):String;
	var title_pro_initialized:Bool;
	
	function get_title_pro():String{
		return title_pro;
	}

	function set_title_pro(title_pro:String):String{
		if(title_pro_initialized)
			modified('title_pro');
		this.title_pro = title_pro ;
		title_pro_initialized = true; 
		return title_pro;
	}	
		
	@dataType("character varying(32)")
	@:isVar public var first_name(get,set):String;
	var first_name_initialized:Bool;
	
	function get_first_name():String{
		return first_name;
	}

	function set_first_name(first_name:String):String{
		if(first_name_initialized)
			modified('first_name');
		this.first_name = first_name ;
		first_name_initialized = true; 
		return first_name;
	}	
		
	@dataType("character varying(32)")
	@:isVar public var last_name(get,set):String;
	var last_name_initialized:Bool;
	
	function get_last_name():String{
		return last_name;
	}

	function set_last_name(last_name:String):String{
		if(last_name_initialized)
			modified('last_name');
		this.last_name = last_name ;
		last_name_initialized = true; 
		return last_name;
	}	
		
	@dataType("character varying(64)")
	@:isVar public var address(get,set):String;
	var address_initialized:Bool;
	
	function get_address():String{
		return address;
	}

	function set_address(address:String):String{
		if(address_initialized)
			modified('address');
		this.address = address ;
		address_initialized = true; 
		return address;
	}	
		
	@dataType("character varying(64)")
	@:isVar public var address_2(get,set):String;
	var address_2_initialized:Bool;
	
	function get_address_2():String{
		return address_2;
	}

	function set_address_2(address_2:String):String{
		if(address_2_initialized)
			modified('address_2');
		this.address_2 = address_2 ;
		address_2_initialized = true; 
		return address_2;
	}	
		
	@dataType("character varying(50)")
	@:isVar public var city(get,set):String;
	var city_initialized:Bool;
	
	function get_city():String{
		return city;
	}

	function set_city(city:String):String{
		if(city_initialized)
			modified('city');
		this.city = city ;
		city_initialized = true; 
		return city;
	}	
		
	@dataType("character varying(10)")
	@:isVar public var postal_code(get,set):String;
	var postal_code_initialized:Bool;
	
	function get_postal_code():String{
		return postal_code;
	}

	function set_postal_code(postal_code:String):String{
		if(postal_code_initialized)
			modified('postal_code');
		this.postal_code = postal_code ;
		postal_code_initialized = true; 
		return postal_code;
	}	
		
	@dataType("character varying(3)")
	@:isVar public var country_code(get,set):String;
	var country_code_initialized:Bool;
	
	function get_country_code():String{
		return country_code;
	}

	function set_country_code(country_code:String):String{
		if(country_code_initialized)
			modified('country_code');
		this.country_code = country_code ;
		country_code_initialized = true; 
		return country_code;
	}	
		
	@dataType("character varying(64)")
	@:isVar public var gender(get,set):String;
	var gender_initialized:Bool;
	
	function get_gender():String{
		return gender;
	}

	function set_gender(gender:String):String{
		if(gender_initialized)
			modified('gender');
		this.gender = gender ;
		gender_initialized = true; 
		return gender;
	}	
		
	@dataType("date")
	@:isVar public var date_of_birth(get,set):String;
	var date_of_birth_initialized:Bool;
	
	function get_date_of_birth():String{
			return date_of_birth;
	}

	function set_date_of_birth(date_of_birth:String):String{
		if(date_of_birth_initialized)
			modified('date_of_birth');
		this.date_of_birth = date_of_birth ;
		date_of_birth_initialized = true; 
		return date_of_birth;
	}	
		
	@dataType("character varying(19)")
	@:isVar public var mobile(get,set):String;
	var mobile_initialized:Bool;
	
	function get_mobile():String{
		return mobile;
	}

	function set_mobile(mobile:String):String{
		if(mobile_initialized)
			modified('mobile');
		this.mobile = mobile ;
		mobile_initialized = true; 
		return mobile;
	}	
		
	@dataType("character varying(64)")
	@:isVar public var email(get,set):String;
	var email_initialized:Bool;
	
	function get_email():String{
		return email;
	}

	function set_email(email:String):String{
		if(email_initialized)
			modified('email');
		this.email = email ;
		email_initialized = true; 
		return email;
	}	
		
	@dataType("character varying(4096)")
	@:isVar public var comments(get,set):String;
	var comments_initialized:Bool;
	
	function get_comments():String{
		return comments;
	}

	function set_comments(comments:String):String{
		if(comments_initialized)
			modified('comments');
		this.comments = comments ;
		comments_initialized = true; 
		return comments;
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
		this.edited_by = edited_by ;
		edited_by_initialized = true; 
		return edited_by;
	}	
		
	@dataType("bigint[]")
	@:isVar public var merged(get,set):Array<Int>;
	var merged_initialized:Bool;
	
	function get_merged():Array<Int>{
		return merged;
	}

	function set_merged(merged:Array<Int>):Array<Int>{
		if(merged_initialized)
			modified('merged');
		this.merged = merged ;
		merged_initialized = true; 
		return merged;
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
		this.last_locktime = last_locktime ;
		last_locktime_initialized = true; 
		return last_locktime;
	}	
		
	@dataType("bigint")
	@:isVar public var owner(get,set):Int;
	var owner_initialized:Bool;
	
	function get_owner():Int{
		return owner;
	}

	function set_owner(owner:Int):Int{
		if(owner_initialized)
			modified('owner');
		this.owner = owner ;
		owner_initialized = true; 
		return owner;
	}	
	
}