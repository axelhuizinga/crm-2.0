package model;

typedef UserProps = {
	?id:Int,
	?contact:Int,
	?last_login:String,
	?password:String,
	?user_name:String,
	?active:Bool,
	?edited_by:Int,
	?editing:String,
	?settings:String,
	?external:String,
	?user_group:Int,
	?change_pass_required:Bool,
	?online:Bool,
	?last_request_time:String,
	?request:String,
	?mandator:Int,
	?last_locktime:String,
	?phash:String
};

@:rtti
class User extends ORM
{

	public function new(props:UserProps) {
		propertyNames = 'id,contact,last_login,password,user_name,active,edited_by,editing,settings,external,user_group,change_pass_required,online,last_request_time,request,mandator,last_locktime,phash'.split(',');
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
		contact = 0;
		return contact;
	}	
		
	@dataType("timestamp(0) without time zone")
	@:isVar public var last_login(get,set):String;
	var last_login_initialized:Bool;
	
	function get_last_login():String{
			return last_login;
	}

	function set_last_login(last_login:String):String{
		if(last_login_initialized)
			modified('last_login');
		this.last_login = last_login;
		last_login_initialized = true; 
		return last_login;
	}

	public function clear_last_login():String{
		last_login = 'null';
		return last_login;
	}	
		
	@dataType("character varying(512)")
	@:isVar public var password(get,set):String;
	var password_initialized:Bool;
	
	function get_password():String{
		return password;
	}

	function set_password(password:String):String{
		if(password_initialized)
			modified('password');
		this.password = password;
		password_initialized = true; 
		return password;
	}

	public function clear_password():String{
		password = '';
		return password;
	}	
		
	@dataType("character varying(64)")
	@:isVar public var user_name(get,set):String;
	var user_name_initialized:Bool;
	
	function get_user_name():String{
		return user_name;
	}

	function set_user_name(user_name:String):String{
		if(user_name_initialized)
			modified('user_name');
		this.user_name = user_name;
		user_name_initialized = true; 
		return user_name;
	}

	public function clear_user_name():String{
		user_name = '';
		return user_name;
	}	
		
	@dataType("boolean")
	@:isVar public var active(get,set):Bool;
	var active_initialized:Bool;
	
	function get_active():Bool{
		return active;
	}

	function set_active(active:Bool):Bool{
		if(active_initialized)
			modified('active');
		this.active = active;
		active_initialized = true; 
		return active;
	}

	public function clear_active():Bool{
		active = true;
		return active;
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
		
	@dataType("jsonb")
	@:isVar public var editing(get,set):String;
	var editing_initialized:Bool;
	
	function get_editing():String{
			return editing;
	}

	function set_editing(editing:String):String{
		if(editing_initialized)
			modified('editing');
		this.editing = editing;
		editing_initialized = true; 
		return editing;
	}

	public function clear_editing():String{
		editing = '{}';
		return editing;
	}	
		
	@dataType("jsonb")
	@:isVar public var settings(get,set):String;
	var settings_initialized:Bool;
	
	function get_settings():String{
			return settings;
	}

	function set_settings(settings:String):String{
		if(settings_initialized)
			modified('settings');
		this.settings = settings;
		settings_initialized = true; 
		return settings;
	}

	public function clear_settings():String{
		settings = '{}';
		return settings;
	}	
		
	@dataType("jsonb")
	@:isVar public var external(get,set):String;
	var external_initialized:Bool;
	
	function get_external():String{
			return external;
	}

	function set_external(external:String):String{
		if(external_initialized)
			modified('external');
		this.external = external;
		external_initialized = true; 
		return external;
	}

	public function clear_external():String{
		external = '{}';
		return external;
	}	
		
	@dataType("bigint")
	@:isVar public var user_group(get,set):Int;
	var user_group_initialized:Bool;
	
	function get_user_group():Int{
		return user_group;
	}

	function set_user_group(user_group:Int):Int{
		if(user_group_initialized)
			modified('user_group');
		this.user_group = user_group;
		user_group_initialized = true; 
		return user_group;
	}

	public function clear_user_group():Int{
		user_group = null;
		return user_group;
	}	
		
	@dataType("boolean")
	@:isVar public var change_pass_required(get,set):Bool;
	var change_pass_required_initialized:Bool;
	
	function get_change_pass_required():Bool{
		return change_pass_required;
	}

	function set_change_pass_required(change_pass_required:Bool):Bool{
		if(change_pass_required_initialized)
			modified('change_pass_required');
		this.change_pass_required = change_pass_required;
		change_pass_required_initialized = true; 
		return change_pass_required;
	}

	public function clear_change_pass_required():Bool{
		change_pass_required = false;
		return change_pass_required;
	}	
		
	@dataType("boolean")
	@:isVar public var online(get,set):Bool;
	var online_initialized:Bool;
	
	function get_online():Bool{
		return online;
	}

	function set_online(online:Bool):Bool{
		if(online_initialized)
			modified('online');
		this.online = online;
		online_initialized = true; 
		return online;
	}

	public function clear_online():Bool{
		online = false;
		return online;
	}	
		
	@dataType("timestamp without time zone")
	@:isVar public var last_request_time(get,set):String;
	var last_request_time_initialized:Bool;
	
	function get_last_request_time():String{
			return last_request_time;
	}

	function set_last_request_time(last_request_time:String):String{
		if(last_request_time_initialized)
			modified('last_request_time');
		this.last_request_time = last_request_time;
		last_request_time_initialized = true; 
		return last_request_time;
	}

	public function clear_last_request_time():String{
		last_request_time = 'null';
		return last_request_time;
	}	
		
	@dataType("character varying(4096)")
	@:isVar public var request(get,set):String;
	var request_initialized:Bool;
	
	function get_request():String{
		return request;
	}

	function set_request(request:String):String{
		if(request_initialized)
			modified('request');
		this.request = request;
		request_initialized = true; 
		return request;
	}

	public function clear_request():String{
		request = '';
		return request;
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
		this.mandator = mandator;
		mandator_initialized = true; 
		return mandator;
	}

	public function clear_mandator():Int{
		mandator = 0;
		return mandator;
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
		
	@dataType("character varying(64)")
	@:isVar public var phash(get,set):String;
	var phash_initialized:Bool;
	
	function get_phash():String{
		return phash;
	}

	function set_phash(phash:String):String{
		if(phash_initialized)
			modified('phash');
		this.phash = phash;
		phash_initialized = true; 
		return phash;
	}

	public function clear_phash():String{
		phash = 'password';
		return phash;
	}	
	
}