package model;
class Activity extends ORM
{
	//{"type":"bigint","default":"null","attnum":"1"}
	public var id(get,set):Int;
	var initial_id:Int;
	
	function get_id():Int{
		return id;
	}

	function set_id(x:Int):Int{

		modified(this,id);
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
	}//{"type":"character varying(64)","default":"","attnum":"2"}
	public var table(get,set):String;
	var initial_table:String;
	
	function get_table():String{
		return table;
	}

	function set_table(x:String):String{

		modified(this,table);
		table = x;
		if(initial_table == null)
			initial_table = table; 
		return table;
	}

	public function reset_table():String{
		return initial_table;
	}

	public function clear_table():String{
		table = ;
		return table;
	}//{"type":"character varying(2048)","default":"","attnum":"3"}
	public var title(get,set):String;
	var initial_title:String;
	
	function get_title():String{
		return title;
	}

	function set_title(x:String):String{

		modified(this,title);
		title = x;
		if(initial_title == null)
			initial_title = title; 
		return title;
	}

	public function reset_title():String{
		return initial_title;
	}

	public function clear_title():String{
		title = ;
		return title;
	}//{"type":"boolean","default":"","attnum":"4"}
	public var active(get,set):String;
	var initial_active:String;
	
	function get_active():String{
			return active;
	}

	function set_active(x:String):String{

		modified(this,active);
		active = x;
		if(initial_active == null)
			initial_active = active; 
		return active;
	}

	public function reset_active():String{
		return initial_active;
	}

	public function clear_active():String{
		active = ;
		return active;
	}//{"type":"bigint","default":"","attnum":"5"}
	public var edited_by(get,set):Int;
	var initial_edited_by:Int;
	
	function get_edited_by():Int{
		return edited_by;
	}

	function set_edited_by(x:Int):Int{

		modified(this,edited_by);
		edited_by = x;
		if(initial_edited_by == null)
			initial_edited_by = edited_by; 
		return edited_by;
	}

	public function reset_edited_by():Int{
		return initial_edited_by;
	}

	public function clear_edited_by():Int{
		edited_by = ;
		return edited_by;
	}//{"type":"timestamp(3) without time zone","default":"(CURRENT_TIMESTAMP)","attnum":"6"}
	public var activated_at(get,set):String;
	var initial_activated_at:String;
	
	function get_activated_at():String{
			return activated_at;
	}

	function set_activated_at(x:String):String{

		modified(this,activated_at);
		activated_at = x;
		if(initial_activated_at == null)
			initial_activated_at = activated_at; 
		return activated_at;
	}

	public function reset_activated_at():String{
		return initial_activated_at;
	}

	public function clear_activated_at():String{
		activated_at = (CURRENT_TIMESTAMP);
		return activated_at;
	}
}