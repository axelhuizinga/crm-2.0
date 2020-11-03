package model;

typedef ProductProps = {
	?name:String,
	?description:String,
	?value:String,
	?attributes:String,
	?mandator:Int,
	?active:Bool,
	?edited_by:Int
};

@:rtti
class Product extends ORM
{

	public function new(data:Map<String,String>) {
		super(data);
		propertyNames = 'name,description,value,attributes,mandator,active,edited_by'.split(',');
	}	
		
	@dataType("character varying(1024)")
	@:isVar public var name(default,set):String;

	function set_name(name:String):String{
		if(initialized('name'))
			modified('name');
		this.name = name ;
		return name;
	}	
		
	@dataType("character varying(4096)")
	@:isVar public var description(default,set):String;

	function set_description(description:String):String{
		if(initialized('description'))
			modified('description');
		this.description = description ;
		return description;
	}	
		
	@dataType("numeric(10,2)")
	@:isVar public var value(default,set):String;

	function set_value(value:String):String{
		if(initialized('value'))
			modified('value');
		this.value = value ;
		return value;
	}	
		
	@dataType("jsonb")
	@:isVar public var attributes(default,set):String;

	function set_attributes(attributes:String):String{
		if(initialized('attributes'))
			modified('attributes');
		this.attributes = attributes ;
		return attributes;
	}	
		
	@dataType("bigint")
	@:isVar public var mandator(default,set):Int;

	function set_mandator(mandator:Int):Int{
		if(initialized('mandator'))
			modified('mandator');
		this.mandator = mandator ;
		return mandator;
	}	
		
	@dataType("boolean")
	@:isVar public var active(default,set):Bool;

	function set_active(active:Bool):Bool{
		if(initialized('active'))
			modified('active');
		this.active = active ;
		return active;
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