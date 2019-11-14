package model;

typedef RoleProps = {
	?id:Int,
	?name:String,
	?description:String,
	?permissions:String,
	?edited_by:Int,
	?mandator:Int
};

class Role extends ORM
{
	public static var varNames:String = 'id,name,description,permissions,edited_by,mandator';
		public function new(props:RoleProps) {
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

	//{"type":"character varying(64)","default":"''","attnum":"2"}
	@:isVar public var name(get,set):String;
	var initial_name:String;
	
	function get_name():String{
		return name;
	}

	function set_name(x:String):String{

		modified('name');
		name = x;
		if(initial_name == null)
			initial_name = name; 
		return name;
	}

	public function reset_name():String{
		return initial_name;
	}

	public function clear_name():String{
		name = '';
		return name;
	}

	//{"type":"character varying(2048)","default":"''","attnum":"3"}
	@:isVar public var description(get,set):String;
	var initial_description:String;
	
	function get_description():String{
		return description;
	}

	function set_description(x:String):String{

		modified('description');
		description = x;
		if(initial_description == null)
			initial_description = description; 
		return description;
	}

	public function reset_description():String{
		return initial_description;
	}

	public function clear_description():String{
		description = '';
		return description;
	}

	//{"type":"jsonb","default":"'{\"users\": [], \"groups\": [], \"routes\": []}'","attnum":"4"}
	@:isVar public var permissions(get,set):String;
	var initial_permissions:String;
	
	function get_permissions():String{
			return permissions;
	}

	function set_permissions(x:String):String{

		modified('permissions');
		permissions = x;
		if(initial_permissions == null)
			initial_permissions = permissions; 
		return permissions;
	}

	public function reset_permissions():String{
		return initial_permissions;
	}

	public function clear_permissions():String{
		permissions = '{"users": [], "groups": [], "routes": []}';
		return permissions;
	}

	//{"type":"bigint","default":"null","attnum":"5"}
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

	//{"type":"bigint","default":"null","attnum":"6"}
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
		mandator = null;
		return mandator;
	}
}