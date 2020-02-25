package model;

typedef MandatorProps = {
	?id:Int,
	?contact:Int,
	?name:String,
	?description:String,
	?any:String,
	?edited_by:Int,
	?parent:Int,
	?last_locktime:String
};

@:rtti
class Mandator extends ORM
{

	public function new(props:MandatorProps) {
		propertyNames = 'id,contact,name,description,any,edited_by,parent,last_locktime'.split(',');
		super(propsMwaaa);
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
	@:isVar public var contact(get,set):Int;
	var contact_initialized:Bool;
	
	function get_contact():Int{
		return contact;
	}

	function set_contact(contact:Int):Int{
		if(contact_initialized)
			modified('contact');
		this.contact = contact ;
		contact_initialized = true; 
		return contact;
	}	
		
	@dataType("character varying(64)")
	@:isVar public var name(get,set):String;
	var name_initialized:Bool;
	
	function get_name():String{
		return name;
	}

	function set_name(name:String):String{
		if(name_initialized)
			modified('name');
		this.name = name ;
		name_initialized = true; 
		return name;
	}	
		
	@dataType("character varying(4096)")
	@:isVar public var description(get,set):String;
	var description_initialized:Bool;
	
	function get_description():String{
		return description;
	}

	function set_description(description:String):String{
		if(description_initialized)
			modified('description');
		this.description = description ;
		description_initialized = true; 
		return description;
	}	
		
	@dataType("jsonb")
	@:isVar public var any(get,set):String;
	var any_initialized:Bool;
	
	function get_any():String{
			return any;
	}

	function set_any(any:String):String{
		if(any_initialized)
			modified('any');
		this.any = any ;
		any_initialized = true; 
		return any;
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
		
	@dataType("bigint")
	@:isVar public var parent(get,set):Int;
	var parent_initialized:Bool;
	
	function get_parent():Int{
		return parent;
	}

	function set_parent(parent:Int):Int{
		if(parent_initialized)
			modified('parent');
		this.parent = parent ;
		parent_initialized = true; 
		return parent;
	}	
		
	@dataType("timestamp without time zone")
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
	
}