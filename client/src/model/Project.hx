package model;

typedef ProjectProps = {
	?id:Int,
	?mandator:Int,
	?name:String,
	?description:String,
	?edited_by:Int,
	?provision_percent:String,
	?cancellation_liable:String,
	?target_account:Int
};

@:rtti
class Project extends ORM
{

	public function new(data:Map<String,String>) {
		super(data);
		propertyNames = 'id,mandator,name,description,edited_by,provision_percent,cancellation_liable,target_account'.split(',');
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
	@:isVar public var mandator(default,set):Int;

	function set_mandator(mandator:Int):Int{
		if(initialized('mandator'))
			modified('mandator');
		this.mandator = mandator ;
		return mandator;
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
		
	@dataType("bigint")
	@:isVar public var edited_by(default,set):Int;

	function set_edited_by(edited_by:Int):Int{
		if(initialized('edited_by'))
			modified('edited_by');
		this.edited_by = edited_by ;
		return edited_by;
	}	
		
	@dataType("double precision")
	@:isVar public var provision_percent(default,set):String;

	function set_provision_percent(provision_percent:String):String{
		if(initialized('provision_percent'))
			modified('provision_percent');
		this.provision_percent = provision_percent ;
		return provision_percent;
	}	
		
	@dataType("integer")
	@:isVar public var cancellation_liable(default,set):String;

	function set_cancellation_liable(cancellation_liable:String):String{
		if(initialized('cancellation_liable'))
			modified('cancellation_liable');
		this.cancellation_liable = cancellation_liable ;
		return cancellation_liable;
	}	
		
	@dataType("bigint")
	@:isVar public var target_account(default,set):Int;

	function set_target_account(target_account:Int):Int{
		if(initialized('target_account'))
			modified('target_account');
		this.target_account = target_account ;
		return target_account;
	}	
	
}