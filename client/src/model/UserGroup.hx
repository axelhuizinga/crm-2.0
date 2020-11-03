package model;

typedef UserGroupProps = {
	?name:String,
	?description:String,
	?can:String,
	?mandator:Int,
	?edited_by:Int
};

@:rtti
class UserGroup extends ORM
{

	public function new(data:Map<String,String>) {
		super(data);
		propertyNames = 'name,description,can,mandator,edited_by'.split(',');
	}	
		
	@dataType("character varying(64)")
	@:isVar public var name(default,set):String;

	function set_name(name:String):String{
		if(initialized('name'))
			modified('name');
		this.name = name ;
		return name;
	}	
		
	@dataType("character varying(1024)")
	@:isVar public var description(default,set):String;

	function set_description(description:String):String{
		if(initialized('description'))
			modified('description');
		this.description = description ;
		return description;
	}	
		
	@dataType("jsonb")
	@:isVar public var can(default,set):String;

	function set_can(can:String):String{
		if(initialized('can'))
			modified('can');
		this.can = can ;
		return can;
	}	
		
	@dataType("bigint")
	@:isVar public var mandator(default,set):Int;

	function set_mandator(mandator:Int):Int{
		if(initialized('mandator'))
			modified('mandator');
		this.mandator = mandator ;
		return mandator;
	}	
		
	@dataType("bigint")
	@:isVar public var edited_by(default,set):Int;

	function set_edited_by(edited_by:Int):Int{
		if(initialized('edited_by'))
			modified('edited_by');
		this.edited_by = edited_by ;
		return edited_by;
	}	
	
}