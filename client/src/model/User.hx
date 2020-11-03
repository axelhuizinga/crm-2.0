package model;

typedef UserProps = {
	?contact:Int,
	?last_login:String,
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
	?last_error:String,
	?mandator:Int,
	?last_locktime:String,
	?phash:String
};

@:rtti
class User extends ORM
{

	public function new(data:Map<String,String>) {
		super(data);
		propertyNames = 'contact,last_login,user_name,active,edited_by,editing,settings,external,user_group,change_pass_required,online,last_request_time,last_error,mandator,last_locktime,phash'.split(',');
	}	
		
	@dataType("bigint")
	@:isVar public var contact(default,set):Int;

	function set_contact(contact:Int):Int{
		if(initialized('contact'))
			modified('contact');
		this.contact = contact ;
		return contact;
	}	
		
	@dataType("timestamp(0) without time zone")
	@:isVar public var last_login(default,set):String;

	function set_last_login(last_login:String):String{
		if(initialized('last_login'))
			modified('last_login');
		this.last_login = last_login ;
		return last_login;
	}	
		
	@dataType("character varying(64)")
	@:isVar public var user_name(default,set):String;

	function set_user_name(user_name:String):String{
		if(initialized('user_name'))
			modified('user_name');
		this.user_name = user_name ;
		return user_name;
	}	
		
	@dataType("boolean")
	@:isVar public var active(default,set):Bool;

	function set_active(active:Bool):Bool{
		if(initialized('active'))
			modified('active');
		this.active = active ;
		return active;
	}	
		
	@dataType("bigint")
	@:isVar public var edited_by(default,set):Int;

	function set_edited_by(edited_by:Int):Int{
		if(initialized('edited_by'))
			modified('edited_by');
		this.edited_by = edited_by ;
		return edited_by;
	}	
		
	@dataType("jsonb")
	@:isVar public var editing(default,set):String;

	function set_editing(editing:String):String{
		if(initialized('editing'))
			modified('editing');
		this.editing = editing ;
		return editing;
	}	
		
	@dataType("jsonb")
	@:isVar public var settings(default,set):String;

	function set_settings(settings:String):String{
		if(initialized('settings'))
			modified('settings');
		this.settings = settings ;
		return settings;
	}	
		
	@dataType("jsonb")
	@:isVar public var external(default,set):String;

	function set_external(external:String):String{
		if(initialized('external'))
			modified('external');
		this.external = external ;
		return external;
	}	
		
	@dataType("bigint")
	@:isVar public var user_group(default,set):Int;

	function set_user_group(user_group:Int):Int{
		if(initialized('user_group'))
			modified('user_group');
		this.user_group = user_group ;
		return user_group;
	}	
		
	@dataType("boolean")
	@:isVar public var change_pass_required(default,set):Bool;

	function set_change_pass_required(change_pass_required:Bool):Bool{
		if(initialized('change_pass_required'))
			modified('change_pass_required');
		this.change_pass_required = change_pass_required ;
		return change_pass_required;
	}	
		
	@dataType("boolean")
	@:isVar public var online(default,set):Bool;

	function set_online(online:Bool):Bool{
		if(initialized('online'))
			modified('online');
		this.online = online ;
		return online;
	}	
		
	@dataType("timestamp without time zone")
	@:isVar public var last_request_time(default,set):String;

	function set_last_request_time(last_request_time:String):String{
		if(initialized('last_request_time'))
			modified('last_request_time');
		this.last_request_time = last_request_time ;
		return last_request_time;
	}	
		
	@dataType("character varying(4096)")
	@:isVar public var last_error(default,set):String;

	function set_last_error(last_error:String):String{
		if(initialized('last_error'))
			modified('last_error');
		this.last_error = last_error ;
		return last_error;
	}	
		
	@dataType("bigint")
	@:isVar public var mandator(default,set):Int;

	function set_mandator(mandator:Int):Int{
		if(initialized('mandator'))
			modified('mandator');
		this.mandator = mandator ;
		return mandator;
	}	
		
	@dataType("timestamp(0) without time zone")
	@:isVar public var last_locktime(default,set):String;

	function set_last_locktime(last_locktime:String):String{
		if(initialized('last_locktime'))
			modified('last_locktime');
		this.last_locktime = last_locktime ;
		return last_locktime;
	}	
		
	@dataType("character varying(64)")
	@:isVar public var phash(default,set):String;

	function set_phash(phash:String):String{
		if(initialized('phash'))
			modified('phash');
		this.phash = phash ;
		return phash;
	}	
	
}