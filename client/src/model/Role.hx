package model;

typedef RoleProps = {
	?id:Int,
	?name:String,
	?description:String,
	?permissions:String,
	?edited_by:Int,
	?mandator:Int
};

@:rtti
class Role extends ORM
{

	public function new(props:RoleProps) {
		propertyNames = 'id,name,description,permissions,edited_by,mandator'.split(',');
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
	@:isVar public var name(get,set):String;
	var name_initialized:Bool;
	
	function get_name():String{
		return name;
	}

	function set_name(name:String):String{
		if(name_initialized)
			modified('name');
		this.name = name;
		name_initialized = true; 
		return name;
	}

	public function clear_name():String{
		name = '';
		return name;
	}	
		
	@dataType("character varying(2048)")
	@:isVar public var description(get,set):String;
	var description_initialized:Bool;
	
	function get_description():String{
		return description;
	}

	function set_description(description:String):String{
		if(description_initialized)
			modified('description');
		this.description = description;
		description_initialized = true; 
		return description;
	}

	public function clear_description():String{
		description = '';
		return description;
	}	
		
	@dataType("jsonb")
	@:isVar public var permissions(get,set):String;
	var permissions_initialized:Bool;
	
	function get_permissions():String{
			return permissions;
	}

	function set_permissions(permissions:String):String{
		if(permissions_initialized)
			modified('permissions');
		this.permissions = permissions;
		permissions_initialized = true; 
		return permissions;
	}

	public function clear_permissions():String{
		permissions = '{"users": [], "groups": [], "routes": []}';
		return permissions;
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