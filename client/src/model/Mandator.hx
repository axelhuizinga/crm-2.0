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

@:rtti
class Mandator extends ORM
{

	public function new(data:Map<String,String>) {
		super(data);
		propertyNames = 'id,contact,name,description,any,edited_by,parent,last_locktime'.split(',');
	}	
		
	@dataType("bigint")
	@:isVar public var id(default,set):Int;

	function set_id(id:Int):Int{
		if(initialized('id'))
			modified('id');
		this.id = id ;
		return id;
	}	
		
	@dataType("bigint")
	@:isVar public var contact(default,set):Int;

	function set_contact(contact:Int):Int{
		if(initialized('contact'))
			modified('contact');
		this.contact = contact ;
		return contact;
	}	
		
	@dataType("character varying(64)")
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
		
	@dataType("jsonb")
	@:isVar public var any(default,set):String;

	function set_any(any:String):String{
		if(initialized('any'))
			modified('any');
		this.any = any ;
		return any;
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
	@:isVar public var parent(default,set):Int;

	function set_parent(parent:Int):Int{
		if(initialized('parent'))
			modified('parent');
		this.parent = parent ;
		return parent;
	}	
		
	@dataType("timestamp without time zone")
	@:isVar public var last_locktime(default,set):String;

	function set_last_locktime(last_locktime:String):String{
		if(initialized('last_locktime'))
			modified('last_locktime');
		this.last_locktime = last_locktime ;
		return last_locktime;
	}	
	
}