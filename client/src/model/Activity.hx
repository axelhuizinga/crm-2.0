package model;

typedef ActivityProps = {
	?id:Int,
	?table:String,
	?title:String,
	?active:Bool,
	?edited_by:Int,
	?activated_at:String
};

@:rtti
class Activity extends ORM
{

	public function new(props:ActivityProps) {
		super(props);
		propertyNames = 'id,table,title,active,edited_by,activated_at'.split(',');
		for(f in Reflect.fields(props))
		{
			Reflect.setField(this, f, Reflect.field(props, f));
		}
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
	@:isVar public var table(get,set):String;
	var initial_table:String;
	
	function get_table():String{
		return table;
	}

	function set_table(x:String):String{
		if(table != null)
			modified('table');
		table = x;
		if(initial_table == null)
			initial_table = table; 
		return table;
	}

	public function reset_table():String{
		return initial_table;
	}

	public function clear_table():String{
		table = '';
		return table;
	}	
		
	@dataType("character varying(2048)")
	@:isVar public var title(get,set):String;
	var initial_title:String;
	
	function get_title():String{
		return title;
	}

	function set_title(x:String):String{
		if(title != null)
			modified('title');
		title = x;
		if(initial_title == null)
			initial_title = title; 
		return title;
	}

	public function reset_title():String{
		return initial_title;
	}

	public function clear_title():String{
		title = '';
		return title;
	}	
		
	@dataType("boolean")
	@:isVar public var active(get,set):Bool;
	var initial_active:Bool;
	
	function get_active():Bool{
		return active;
	}

	function set_active(x:Bool):Bool{
		if(active != null)
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
		active = 1;
		return active;
	}	
		
	@dataType("bigint")
	@:isVar public var edited_by(get,set):Int;
	var initial_edited_by:Int;
	
	function get_edited_by():Int{
		return edited_by;
	}

	function set_edited_by(x:Int):Int{
		if(edited_by != null)
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
		
	@dataType("timestamp(3) without time zone")
	@:isVar public var activated_at(get,set):String;
	var initial_activated_at:String;
	
	function get_activated_at():String{
			return activated_at;
	}

	function set_activated_at(x:String):String{
		if(activated_at != null)
			modified('activated_at');
		activated_at = x;
		if(initial_activated_at == null)
			initial_activated_at = activated_at; 
		return activated_at;
	}

	public function reset_activated_at():String{
		return initial_activated_at;
	}

	public function clear_activated_at():String{
		activated_at = '(CURRENT_TIMESTAMP)';
		return activated_at;
	}	
	
}