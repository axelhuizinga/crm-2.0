package model;
import view.shared.io.DataAccess.DataView;

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

	public function new(props:ActivityProps, view:DataView) {
		propertyNames = 'id,table,title,active,edited_by,activated_at'.split(',');
		super(props, view);
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
	@:isVar public var table(get,set):String;
	var table_initialized:Bool;
	
	function get_table():String{
		return table;
	}

	function set_table(table:String):String{
		if(table_initialized)
			modified('table');
		this.table = table ;
		table_initialized = true; 
		return table;
	}	
		
	@dataType("character varying(2048)")
	@:isVar public var title(get,set):String;
	var title_initialized:Bool;
	
	function get_title():String{
		return title;
	}

	function set_title(title:String):String{
		if(title_initialized)
			modified('title');
		this.title = title ;
		title_initialized = true; 
		return title;
	}	
		
	@dataType("boolean")
	@:isVar public var active(get,set):Bool;
	var active_initialized:Bool;
	
	function get_active():Bool{
		return active;
	}

	function set_active(active:Bool):Bool{
		if(active_initialized)
			modified('active');
		this.active = active ;
		active_initialized = true; 
		return active;
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
		
	@dataType("timestamp(3) without time zone")
	@:isVar public var activated_at(get,set):String;
	var activated_at_initialized:Bool;
	
	function get_activated_at():String{
			return activated_at;
	}

	function set_activated_at(activated_at:String):String{
		if(activated_at_initialized)
			modified('activated_at');
		this.activated_at = activated_at ;
		activated_at_initialized = true; 
		return activated_at;
	}	
	
}