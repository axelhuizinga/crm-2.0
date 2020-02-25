package model;

typedef UserGroupProps = {
	?id:Int,
	?name:String,
	?description:String,
	?can:String,
	?mandator:Int,
	?edited_by:Int
};

@:rtti
class UserGroup extends ORM
{

	public function new(props:UserGroupProps) {
		propertyNames = 'id,name,description,can,mandator,edited_by'.split(',');
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
		
	@dataType("character varying(1024)")
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
	@:isVar public var can(get,set):String;
	var can_initialized:Bool;
	
	function get_can():String{
			return can;
	}

	function set_can(can:String):String{
		if(can_initialized)
			modified('can');
		this.can = can ;
		can_initialized = true; 
		return can;
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
	
}