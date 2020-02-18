package model;
import view.shared.io.DataAccess.DataView;

typedef EndReasonProps = {
	?id:Int,
	?reason:String,
	?edited_by:Int,
	?mandator:Int
};

@:rtti
class EndReason extends ORM
{

	public function new(props:EndReasonProps, view:DataView) {
		propertyNames = 'id,reason,edited_by,mandator'.split(',');
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
	@:isVar public var reason(get,set):String;
	var reason_initialized:Bool;
	
	function get_reason():String{
		return reason;
	}

	function set_reason(reason:String):String{
		if(reason_initialized)
			modified('reason');
		this.reason = reason ;
		reason_initialized = true; 
		return reason;
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
	
}