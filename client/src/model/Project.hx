package model;
import view.shared.io.DataAccess.DataView;

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

	public function new(props:ProjectProps, view:DataView) {
		propertyNames = 'id,mandator,name,description,edited_by,provision_percent,cancellation_liable,target_account'.split(',');
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
		
	@dataType("character varying(64)")
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
		
	@dataType("double precision")
	@:isVar public var provision_percent(get,set):String;
	var provision_percent_initialized:Bool;
	
	function get_provision_percent():String{
			return provision_percent;
	}

	function set_provision_percent(provision_percent:String):String{
		if(provision_percent_initialized)
			modified('provision_percent');
		this.provision_percent = provision_percent ;
		provision_percent_initialized = true; 
		return provision_percent;
	}	
		
	@dataType("integer")
	@:isVar public var cancellation_liable(get,set):String;
	var cancellation_liable_initialized:Bool;
	
	function get_cancellation_liable():String{
			return cancellation_liable;
	}

	function set_cancellation_liable(cancellation_liable:String):String{
		if(cancellation_liable_initialized)
			modified('cancellation_liable');
		this.cancellation_liable = cancellation_liable ;
		cancellation_liable_initialized = true; 
		return cancellation_liable;
	}	
		
	@dataType("bigint")
	@:isVar public var target_account(get,set):Int;
	var target_account_initialized:Bool;
	
	function get_target_account():Int{
		return target_account;
	}

	function set_target_account(target_account:Int):Int{
		if(target_account_initialized)
			modified('target_account');
		this.target_account = target_account ;
		target_account_initialized = true; 
		return target_account;
	}	
	
}