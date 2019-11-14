package model;

typedef EndReasonProps = {
	?id:Int,
	?reason:String,
	?edited_by:Int,
	?mandator:Int
};

class EndReason extends ORM
{
	public static var varNames:String = 'id,reason,edited_by,mandator';
		public function new(props:EndReasonProps) {
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
	@:isVar public var reason(get,set):String;
	var initial_reason:String;
	
	function get_reason():String{
		return reason;
	}

	function set_reason(x:String):String{

		modified('reason');
		reason = x;
		if(initial_reason == null)
			initial_reason = reason; 
		return reason;
	}

	public function reset_reason():String{
		return initial_reason;
	}

	public function clear_reason():String{
		reason = '';
		return reason;
	}

	//{"type":"bigint","default":"null","attnum":"3"}
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

	//{"type":"bigint","default":"null","attnum":"4"}
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