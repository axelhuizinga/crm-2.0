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
		
	@dataType("character varying(64)")
	@:isVar public var key(get,set):String;
	var key_initialized:Bool;
	
	function get_key():String{
		return key;
	}

	function set_key(key:String):String{
		if(key_initialized)
			modified('key');
		this.key = key;
		key_initialized = true; 
		return key;
	}

	public function clear_key():String{
		key = '';
		return key;
	}	
		
	@dataType("character varying(64)")
	@:isVar public var content(get,set):String;
	var content_initialized:Bool;
	
	function get_content():String{
		return content;
	}

	function set_content(content:String):String{
		if(content_initialized)
			modified('content');
		this.content = content;
		content_initialized = true; 
		return content;
	}

	public function clear_content():String{
		content = '';
		return content;
	}	
		
	@dataType("character varying(512)")
	@:isVar public var classPath(get,set):String;
	var classPath_initialized:Bool;
	
	function get_classPath():String{
		return classPath;
	}

	function set_classPath(classPath:String):String{
		if(classPath_initialized)
			modified('classPath');
		this.classPath = classPath;
		classPath_initialized = true; 
		return classPath;
	}

	public function clear_classPath():String{
		classPath = '';
		return classPath;
	}	
		
	@dataType("character varying(64)")
	@:isVar public var component(get,set):String;
	var component_initialized:Bool;
	
	function get_component():String{
		return component;
	}

	function set_component(component:String):String{
		if(component_initialized)
			modified('component');
		this.component = component;
		component_initialized = true; 
		return component;
	}

	public function clear_component():String{
		component = '';
		return component;
	}	
		
	@dataType("integer")
	@:isVar public var edited_by(get,set):String;
	var edited_by_initialized:Bool;
	
	function get_edited_by():String{
			return edited_by;
	}

	function set_edited_by(edited_by:String):String{
		if(edited_by_initialized)
			modified('edited_by');
		this.edited_by = edited_by;
		edited_by_initialized = true; 
		return edited_by;
	}

	public function clear_edited_by():String{
		edited_by = '';
		return edited_by;
	}	
		
	@dataType("timestamp without time zone")
	@:isVar public var updated_at(get,set):String;
	var updated_at_initialized:Bool;
	
	function get_updated_at():String{
			return updated_at;
	}

	function set_updated_at(updated_at:String):String{
		if(updated_at_initialized)
			modified('updated_at');
		this.updated_at = updated_at;
		updated_at_initialized = true; 
		return updated_at;
	}

	public function clear_updated_at():String{
		updated_at = 'null';
		return updated_at;
	}	
		
	@dataType("character varying(8)")
	@:isVar public var locale(get,set):String;
	var locale_initialized:Bool;
	
	function get_locale():String{
		return locale;
	}

	function set_locale(locale:String):String{
		if(locale_initialized)
			modified('locale');
		this.locale = locale;
		locale_initialized = true; 
		return locale;
	}

	public function clear_locale():String{
		locale = '';
		return locale;
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
		mandator = null;
		return mandator;
	}	
	
}