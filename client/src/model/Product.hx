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

@:rtti
class Product extends ORM
{

	public function new(data:Map<String,String>) {
		super(data);
		propertyNames = 'id,name,description,value,attributes,mandator,active,edited_by'.split(',');
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
		
	@dataType("character varying(1024)")
	@:isVar public var name(get,set):String;
	var name_initialized:Bool;
	
	function get_name():String{
		return name;
	}

	function set_name(name:String):String{
		if(name_initialized)
			modified('name');
		this.name = name ;
		name_initialized = true; 
		return name;
	}	
		
	@dataType("character varying(4096)")
	@:isVar public var description(get,set):String;
	var description_initialized:Bool;
	
	function get_description():String{
		return description;
	}

	function set_description(description:String):String{
		if(description_initialized)
			modified('description');
		this.description = description ;
		description_initialized = true; 
		return description;
	}	
		
	@dataType("numeric(10,2)")
	@:isVar public var value(get,set):String;
	var value_initialized:Bool;
	
	function get_value():String{
			return value;
	}

	function set_value(value:String):String{
		if(value_initialized)
			modified('value');
		this.value = value ;
		value_initialized = true; 
		return value;
	}	
		
	@dataType("jsonb")
	@:isVar public var attributes(get,set):String;
	var attributes_initialized:Bool;
	
	function get_attributes():String{
			return attributes;
	}

	function set_attributes(attributes:String):String{
		if(attributes_initialized)
			modified('attributes');
		this.attributes = attributes ;
		attributes_initialized = true; 
		return attributes;
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
	
}