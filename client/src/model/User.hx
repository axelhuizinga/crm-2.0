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
	?last_locktime:String
};

class User extends ORM
{
	public static var varNames:String = 'id,contact,last_login,password,user_name,active,edited_by,editing,settings,external,user_group,change_pass_required,online,last_request_time,request,mandator,last_locktime';
		public function new(props:UserProps) {
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
	@:isVar public var contact(get,set):Int;
	var initial_contact:Int;
	
	function get_contact():Int{
		return contact;
	}

	function set_contact(x:Int):Int{

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

	//{"type":"timestamp(0) without time zone","default":"'null'","attnum":"3"}
	@:isVar public var last_login(get,set):String;
	var initial_last_login:String;
	
	function get_last_login():String{
			return last_login;
	}

	function set_last_login(x:String):String{

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

	//{"type":"character varying(512)","default":"''","attnum":"4"}
	@:isVar public var password(get,set):String;
	var initial_password:String;
	
	function get_password():String{
		return password;
	}

	function set_password(x:String):String{

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

	//{"type":"character varying(64)","default":"''","attnum":"5"}
	@:isVar public var user_name(get,set):String;
	var initial_user_name:String;
	
	function get_user_name():String{
		return user_name;
	}

	function set_user_name(x:String):String{

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

	//{"type":"boolean","default":"true","attnum":"6"}
	@:isVar public var active(get,set):Bool;
	var initial_active:Bool;
	
	function get_active():Bool{
		return active;
	}

	function set_active(x:Bool):Bool{

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

	//{"type":"bigint","default":"null","attnum":"7"}
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
		edited_by = null;
		return edited_by;
	}

	//{"type":"jsonb","default":"'{}'","attnum":"8"}
	@:isVar public var editing(get,set):String;
	var initial_editing:String;
	
	function get_editing():String{
			return editing;
	}

	function set_editing(x:String):String{

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

	//{"type":"jsonb","default":"'{}'","attnum":"9"}
	@:isVar public var settings(get,set):String;
	var initial_settings:String;
	
	function get_settings():String{
			return settings;
	}

	function set_settings(x:String):String{

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

	//{"type":"jsonb","default":"'{}'","attnum":"10"}
	@:isVar public var external(get,set):String;
	var initial_external:String;
	
	function get_external():String{
			return external;
	}

	function set_external(x:String):String{

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

	//{"type":"bigint","default":"null","attnum":"11"}
	@:isVar public var user_group(get,set):Int;
	var initial_user_group:Int;
	
	function get_user_group():Int{
		return user_group;
	}

	function set_user_group(x:Int):Int{

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

	//{"type":"boolean","default":"false","attnum":"12"}
	@:isVar public var change_pass_required(get,set):Bool;
	var initial_change_pass_required:Bool;
	
	function get_change_pass_required():Bool{
		return change_pass_required;
	}

	function set_change_pass_required(x:Bool):Bool{

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

	//{"type":"boolean","default":"false","attnum":"13"}
	@:isVar public var online(get,set):Bool;
	var initial_online:Bool;
	
	function get_online():Bool{
		return online;
	}

	function set_online(x:Bool):Bool{

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

	//{"type":"timestamp without time zone","default":"'null'","attnum":"14"}
	@:isVar public var last_request_time(get,set):String;
	var initial_last_request_time:String;
	
	function get_last_request_time():String{
			return last_request_time;
	}

	function set_last_request_time(x:String):String{

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

	//{"type":"character varying(4096)","default":"''","attnum":"15"}
	@:isVar public var request(get,set):String;
	var initial_request:String;
	
	function get_request():String{
		return request;
	}

	function set_request(x:String):String{

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

	//{"type":"bigint","default":"0","attnum":"16"}
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

	//{"type":"timestamp(0) without time zone","default":"'CURRENT_TIMESTAMP'","attnum":"17"}
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
}