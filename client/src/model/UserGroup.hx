package model;

typedef UserGroupProps = {
	?id:Int,
	?name:String,
	?description:String,
	?can:String,
	?mandator:Int,
	?edited_by:Int
};

class UserGroup extends ORM
{
		public function new(props:UserGroupProps) {
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
		id = 'null';
		return id;
	}

	//{"type":"character varying(64)","default":"","attnum":"2"}
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

	//{"type":"character varying(1024)","default":"","attnum":"3"}
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

	//{"type":"jsonb","default":"'{}'","attnum":"4"}
	@:isVar public var can(get,set):String;
	var initial_can:String;
	
	function get_can():String{
			return can;
	}

	function set_can(x:String):String{

		modified('can');
		can = x;
		if(initial_can == null)
			initial_can = can; 
		return can;
	}

	public function reset_can():String{
		return initial_can;
	}

	public function clear_can():String{
		can = ''{}'';
		return can;
	}

	//{"type":"bigint","default":0,"attnum":"5"}
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
		mandator = '0';
		return mandator;
	}

	//{"type":"bigint","default":0,"attnum":"6"}
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
		edited_by = '0';
		return edited_by;
	}
}