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

class Mandator extends ORM
{
		public function new(props:MandatorProps) {
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

	//{"type":"bigint","default":0,"attnum":"2"}
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
		contact = '0';
		return contact;
	}

	//{"type":"character varying(64)","default":"","attnum":"3"}
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

	//{"type":"character varying(4096)","default":"","attnum":"4"}
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

	//{"type":"jsonb","default":"'{}'","attnum":"5"}
	@:isVar public var any(get,set):String;
	var initial_any:String;
	
	function get_any():String{
			return any;
	}

	function set_any(x:String):String{

		modified('any');
		any = x;
		if(initial_any == null)
			initial_any = any; 
		return any;
	}

	public function reset_any():String{
		return initial_any;
	}

	public function clear_any():String{
		any = ''{}'';
		return any;
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

	//{"type":"bigint","default":0,"attnum":"7"}
	@:isVar public var parent(get,set):Int;
	var initial_parent:Int;
	
	function get_parent():Int{
		return parent;
	}

	function set_parent(x:Int):Int{

		modified('parent');
		parent = x;
		if(initial_parent == null)
			initial_parent = parent; 
		return parent;
	}

	public function reset_parent():Int{
		return initial_parent;
	}

	public function clear_parent():Int{
		parent = '0';
		return parent;
	}

	//{"type":"timestamp without time zone","default":"CURRENT_TIMESTAMP","attnum":"8"}
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