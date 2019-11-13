package model;

typedef ProductProps = {
	?id:Int,
	?name:String,
	?description:String,
	?value:String,
	?attributes:String,
	?mandator:Int,
	?active:Bool,
	?edited_by:Int
};

class Product extends ORM
{
		public function new(props:ProductProps) {
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

	//{"type":"character varying(1024)","default":"","attnum":"2"}
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

	//{"type":"character varying(4096)","default":"","attnum":"3"}
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

	//{"type":"numeric(10,2)","default":"","attnum":"4"}
	@:isVar public var value(get,set):String;
	var initial_value:String;
	
	function get_value():String{
			return value;
	}

	function set_value(x:String):String{

		modified('value');
		value = x;
		if(initial_value == null)
			initial_value = value; 
		return value;
	}

	public function reset_value():String{
		return initial_value;
	}

	public function clear_value():String{
		value = '';
		return value;
	}

	//{"type":"jsonb","default":"'{}'","attnum":"5"}
	@:isVar public var attributes(get,set):String;
	var initial_attributes:String;
	
	function get_attributes():String{
			return attributes;
	}

	function set_attributes(x:String):String{

		modified('attributes');
		attributes = x;
		if(initial_attributes == null)
			initial_attributes = attributes; 
		return attributes;
	}

	public function reset_attributes():String{
		return initial_attributes;
	}

	public function clear_attributes():String{
		attributes = ''{}'';
		return attributes;
	}

	//{"type":"bigint","default":0,"attnum":"6"}
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

	//{"type":"boolean","default":true,"attnum":"7"}
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
		active = '1';
		return active;
	}

	//{"type":"bigint","default":0,"attnum":"8"}
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