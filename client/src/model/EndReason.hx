package model;

typedef EndReasonProps = {
	?id:Int,
	?reason:String,
	?edited_by:Int,
	?mandator:Int
};

@:rtti
class EndReason extends ORM
{

	public function new(data:Map<String,String>) {
		super(data);
		propertyNames = 'id,reason,edited_by,mandator'.split(',');
	}	
		
	@dataType("bigint")
	@:isVar public var id(default,set):Int;

	function set_id(id:Int):Int{
		if(initialized('id'))
			modified('id');
		this.id = id ;
		return id;
	}	
		
	@dataType("character varying(64)")
	@:isVar public var reason(default,set):String;

	function set_reason(reason:String):String{
		if(initialized('reason'))
			modified('reason');
		this.reason = reason ;
		return reason;
	}	
		
	@dataType("bigint")
	@:isVar public var edited_by(default,set):Int;

	function set_edited_by(edited_by:Int):Int{
		if(initialized('edited_by'))
			modified('edited_by');
		this.edited_by = edited_by ;
		return edited_by;
	}	
		
	@dataType("bigint")
	@:isVar public var mandator(default,set):Int;

	function set_mandator(mandator:Int):Int{
		if(initialized('mandator'))
			modified('mandator');
		this.mandator = mandator ;
		return mandator;
	}	
	
}