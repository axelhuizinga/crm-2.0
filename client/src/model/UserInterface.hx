package model;

typedef UserInterfaceProps = {
	?id:Int,
	?key:String,
	?content:String,
	?classPath:String,
	?component:String,
	?edited_by:String,
	?updated_at:String,
	?locale:String,
	?mandator:Int
};

@:rtti
class UserInterface extends ORM
{

	public function new(props:UserInterfaceProps) {
		propertyNames = 'id,key,content,classPath,component,edited_by,updated_at,locale,mandator'.split(',');
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
		trace('id primary key cannot be empty');
		return id;
	}	
		
	@dataType("character varying(64)")
	@:isVar public var key(get,set):String;
	var initial_key:String;
	
	function get_key():String{
		return key;
	}

	function set_key(x:String):String{
		if(key != null)
			modified('key');
		key = x;
		if(initial_key == null)
			initial_key = key; 
		return key;
	}

	public function reset_key():String{
		return initial_key;
	}

	public function clear_key():String{
		key = '';
		return key;
	}	
		
	@dataType("character varying(64)")
	@:isVar public var content(get,set):String;
	var initial_content:String;
	
	function get_content():String{
		return content;
	}

	function set_content(x:String):String{
		if(content != null)
			modified('content');
		content = x;
		if(initial_content == null)
			initial_content = content; 
		return content;
	}

	public function reset_content():String{
		return initial_content;
	}

	public function clear_content():String{
		content = '';
		return content;
	}	
		
	@dataType("character varying(512)")
	@:isVar public var classPath(get,set):String;
	var initial_classPath:String;
	
	function get_classPath():String{
		return classPath;
	}

	function set_classPath(x:String):String{
		if(classPath != null)
			modified('classPath');
		classPath = x;
		if(initial_classPath == null)
			initial_classPath = classPath; 
		return classPath;
	}

	public function reset_classPath():String{
		return initial_classPath;
	}

	public function clear_classPath():String{
		classPath = '';
		return classPath;
	}	
		
	@dataType("character varying(64)")
	@:isVar public var component(get,set):String;
	var initial_component:String;
	
	function get_component():String{
		return component;
	}

	function set_component(x:String):String{
		if(component != null)
			modified('component');
		component = x;
		if(initial_component == null)
			initial_component = component; 
		return component;
	}

	public function reset_component():String{
		return initial_component;
	}

	public function clear_component():String{
		component = '';
		return component;
	}	
		
	@dataType("integer")
	@:isVar public var edited_by(get,set):String;
	var initial_edited_by:String;
	
	function get_edited_by():String{
			return edited_by;
	}

	function set_edited_by(x:String):String{
		if(edited_by != null)
			modified('edited_by');
		edited_by = x;
		if(initial_edited_by == null)
			initial_edited_by = edited_by; 
		return edited_by;
	}

	public function reset_edited_by():String{
		return initial_edited_by;
	}

	public function clear_edited_by():String{
		edited_by = '';
		return edited_by;
	}	
		
	@dataType("timestamp without time zone")
	@:isVar public var updated_at(get,set):String;
	var initial_updated_at:String;
	
	function get_updated_at():String{
			return updated_at;
	}

	function set_updated_at(x:String):String{
		if(updated_at != null)
			modified('updated_at');
		updated_at = x;
		if(initial_updated_at == null)
			initial_updated_at = updated_at; 
		return updated_at;
	}

	public function reset_updated_at():String{
		return initial_updated_at;
	}

	public function clear_updated_at():String{
		updated_at = 'null';
		return updated_at;
	}	
		
	@dataType("character varying(8)")
	@:isVar public var locale(get,set):String;
	var initial_locale:String;
	
	function get_locale():String{
		return locale;
	}

	function set_locale(x:String):String{
		if(locale != null)
			modified('locale');
		locale = x;
		if(initial_locale == null)
			initial_locale = locale; 
		return locale;
	}

	public function reset_locale():String{
		return initial_locale;
	}

	public function clear_locale():String{
		locale = '';
		return locale;
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
		mandator = null;
		return mandator;
	}	
	
}