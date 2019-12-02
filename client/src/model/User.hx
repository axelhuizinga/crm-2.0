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
		super(props);
		propertyNames = 'id,contact,last_login,password,user_name,active,edited_by,editing,settings,external,user_group,change_pass_required,online,last_request_time,request,mandator,last_locktime,phash'.split(',');
		for(f in Reflect.fields(props))
		{
			Reflect.setField(this, f, Reflect.field(props, f));
		}
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
		trace('id primary key cannot be empty');
		return id;
	}	
		
	@dataType("bigint")
	@:isVar public var contact(get,set):Int;
	var initial_contact:Int;
	
	function get_contact():Int{
		return contact;
	}

	function set_contact(x:Int):Int{
		if(contact != null)
			modified('contact');
		contact = x;
		if(initial_contact == null)
			initial_contact = contact; 
		return contact;
	}

	public function reset_contact():Int{
		return initial_contact;
	}

	public function clear_contact():Int{
		contact = 0;
		return contact;
	}	
		
	@dataType("timestamp(0) without time zone")
	@:isVar public var last_login(get,set):String;
	var initial_last_login:String;
	
	function get_last_login():String{
			return last_login;
	}

	function set_last_login(x:String):String{
		if(last_login != null)
			modified('last_login');
		last_login = x;
		if(initial_last_login == null)
			initial_last_login = last_login; 
		return last_login;
	}

	public function reset_last_login():String{
		return initial_last_login;
	}

	public function clear_last_login():String{
		last_login = 'null';
		return last_login;
	}	
		
	@dataType("character varying(512)")
	@:isVar public var password(get,set):String;
	var initial_password:String;
	
	function get_password():String{
		return password;
	}

	function set_password(x:String):String{
		if(password != null)
			modified('password');
		password = x;
		if(initial_password == null)
			initial_password = password; 
		return password;
	}

	public function reset_password():String{
		return initial_password;
	}

	public function clear_password():String{
		password = '';
		return password;
	}	
		
	@dataType("character varying(64)")
	@:isVar public var user_name(get,set):String;
	var initial_user_name:String;
	
	function get_user_name():String{
		return user_name;
	}

	function set_user_name(x:String):String{
		if(user_name != null)
			modified('user_name');
		user_name = x;
		if(initial_user_name == null)
			initial_user_name = user_name; 
		return user_name;
	}

	public function reset_user_name():String{
		return initial_user_name;
	}

	public function clear_user_name():String{
		user_name = '';
		return user_name;
	}	
		
	@dataType("boolean")
	@:isVar public var active(get,set):Bool;
	var initial_active:Bool;
	
	function get_active():Bool{
		return active;
	}

	function set_active(x:Bool):Bool{
		if(active != null)
			modified('active');
		active = x;
		if(initial_active == null)
			initial_active = active; 
		return active;
	}

	public function reset_active():Bool{
		return initial_active;
	}

	public function clear_active():Bool{
		active = true;
		return active;
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
		edited_by = null;
		return edited_by;
	}	
		
	@dataType("jsonb")
	@:isVar public var editing(get,set):String;
	var initial_editing:String;
	
	function get_editing():String{
			return editing;
	}

	function set_editing(x:String):String{
		if(editing != null)
			modified('editing');
		editing = x;
		if(initial_editing == null)
			initial_editing = editing; 
		return editing;
	}

	public function reset_editing():String{
		return initial_editing;
	}

	public function clear_editing():String{
		editing = '{}';
		return editing;
	}	
		
	@dataType("jsonb")
	@:isVar public var settings(get,set):String;
	var initial_settings:String;
	
	function get_settings():String{
			return settings;
	}

	function set_settings(x:String):String{
		if(settings != null)
			modified('settings');
		settings = x;
		if(initial_settings == null)
			initial_settings = settings; 
		return settings;
	}

	public function reset_settings():String{
		return initial_settings;
	}

	public function clear_settings():String{
		settings = '{}';
		return settings;
	}	
		
	@dataType("jsonb")
	@:isVar public var external(get,set):String;
	var initial_external:String;
	
	function get_external():String{
			return external;
	}

	function set_external(x:String):String{
		if(external != null)
			modified('external');
		external = x;
		if(initial_external == null)
			initial_external = external; 
		return external;
	}

	public function reset_external():String{
		return initial_external;
	}

	public function clear_external():String{
		external = '{}';
		return external;
	}	
		
	@dataType("bigint")
	@:isVar public var user_group(get,set):Int;
	var initial_user_group:Int;
	
	function get_user_group():Int{
		return user_group;
	}

	function set_user_group(x:Int):Int{
		if(user_group != null)
			modified('user_group');
		user_group = x;
		if(initial_user_group == null)
			initial_user_group = user_group; 
		return user_group;
	}

	public function reset_user_group():Int{
		return initial_user_group;
	}

	public function clear_user_group():Int{
		user_group = null;
		return user_group;
	}	
		
	@dataType("boolean")
	@:isVar public var change_pass_required(get,set):Bool;
	var initial_change_pass_required:Bool;
	
	function get_change_pass_required():Bool{
		return change_pass_required;
	}

	function set_change_pass_required(x:Bool):Bool{
		if(change_pass_required != null)
			modified('change_pass_required');
		change_pass_required = x;
		if(initial_change_pass_required == null)
			initial_change_pass_required = change_pass_required; 
		return change_pass_required;
	}

	public function reset_change_pass_required():Bool{
		return initial_change_pass_required;
	}

	public function clear_change_pass_required():Bool{
		change_pass_required = false;
		return change_pass_required;
	}	
		
	@dataType("boolean")
	@:isVar public var online(get,set):Bool;
	var initial_online:Bool;
	
	function get_online():Bool{
		return online;
	}

	function set_online(x:Bool):Bool{
		if(online != null)
			modified('online');
		online = x;
		if(initial_online == null)
			initial_online = online; 
		return online;
	}

	public function reset_online():Bool{
		return initial_online;
	}

	public function clear_online():Bool{
		online = false;
		return online;
	}	
		
	@dataType("timestamp without time zone")
	@:isVar public var last_request_time(get,set):String;
	var initial_last_request_time:String;
	
	function get_last_request_time():String{
			return last_request_time;
	}

	function set_last_request_time(x:String):String{
		if(last_request_time != null)
			modified('last_request_time');
		last_request_time = x;
		if(initial_last_request_time == null)
			initial_last_request_time = last_request_time; 
		return last_request_time;
	}

	public function reset_last_request_time():String{
		return initial_last_request_time;
	}

	public function clear_last_request_time():String{
		last_request_time = 'null';
		return last_request_time;
	}	
		
	@dataType("character varying(4096)")
	@:isVar public var request(get,set):String;
	var initial_request:String;
	
	function get_request():String{
		return request;
	}

	function set_request(x:String):String{
		if(request != null)
			modified('request');
		request = x;
		if(initial_request == null)
			initial_request = request; 
		return request;
	}

	public function reset_request():String{
		return initial_request;
	}

	public function clear_request():String{
		request = '';
		return request;
	}	
		
	@dataType("bigint")
	@:isVar public var mandator(get,set):Int;
	var initial_mandator:Int;
	
	function get_mandator():Int{
		return mandator;
	}

	function set_mandator(x:Int):Int{
		if(mandator != null)
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
		
	@dataType("character varying(64)")
	@:isVar public var phash(get,set):String;
	var initial_phash:String;
	
	function get_phash():String{
		return phash;
	}

	function set_phash(x:String):String{
		if(phash != null)
			modified('phash');
		phash = x;
		if(initial_phash == null)
			initial_phash = phash; 
		return phash;
	}

	public function reset_phash():String{
		return initial_phash;
	}

	public function clear_phash():String{
		phash = 'password';
		return phash;
	}	
	
}