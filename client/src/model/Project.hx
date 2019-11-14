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

class Project extends ORM
{
	public static var varNames:String = 'id,mandator,name,description,edited_by,provision_percent,cancellation_liable,target_account';
		public function new(props:ProjectProps) {
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

	//{"type":"bigint","default":"null","attnum":"2"}
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

	//{"type":"character varying(64)","default":"''","attnum":"3"}
	@:isVar public var name(get,set):String;
	var initial_name:String;
	
	function get_name():String{
		return name;
	}

	function set_name(x:String):String{

		modified('name');
		name = x;
		if(initial_name == null)
			initial_name = name; 
		return name;
	}

	public function reset_name():String{
		return initial_name;
	}

	public function clear_name():String{
		name = '';
		return name;
	}

	//{"type":"character varying(4096)","default":"''","attnum":"4"}
	@:isVar public var description(get,set):String;
	var initial_description:String;
	
	function get_description():String{
		return description;
	}

	function set_description(x:String):String{

		modified('description');
		description = x;
		if(initial_description == null)
			initial_description = description; 
		return description;
	}

	public function reset_description():String{
		return initial_description;
	}

	public function clear_description():String{
		description = '';
		return description;
	}

	//{"type":"bigint","default":"null","attnum":"5"}
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

	//{"type":"double precision","default":"'(0.0)'","attnum":"6"}
	@:isVar public var provision_percent(get,set):String;
	var initial_provision_percent:String;
	
	function get_provision_percent():String{
			return provision_percent;
	}

	function set_provision_percent(x:String):String{

		modified('provision_percent');
		provision_percent = x;
		if(initial_provision_percent == null)
			initial_provision_percent = provision_percent; 
		return provision_percent;
	}

	public function reset_provision_percent():String{
		return initial_provision_percent;
	}

	public function clear_provision_percent():String{
		provision_percent = '(0.0)';
		return provision_percent;
	}

	//{"type":"integer","default":"'0'","attnum":"7"}
	@:isVar public var cancellation_liable(get,set):String;
	var initial_cancellation_liable:String;
	
	function get_cancellation_liable():String{
			return cancellation_liable;
	}

	function set_cancellation_liable(x:String):String{

		modified('cancellation_liable');
		cancellation_liable = x;
		if(initial_cancellation_liable == null)
			initial_cancellation_liable = cancellation_liable; 
		return cancellation_liable;
	}

	public function reset_cancellation_liable():String{
		return initial_cancellation_liable;
	}

	public function clear_cancellation_liable():String{
		cancellation_liable = '0';
		return cancellation_liable;
	}

	//{"type":"bigint","default":"0","attnum":"8"}
	@:isVar public var target_account(get,set):Int;
	var initial_target_account:Int;
	
	function get_target_account():Int{
		return target_account;
	}

	function set_target_account(x:Int):Int{

		modified('target_account');
		target_account = x;
		if(initial_target_account == null)
			initial_target_account = target_account; 
		return target_account;
	}

	public function reset_target_account():Int{
		return initial_target_account;
	}

	public function clear_target_account():Int{
		target_account = 0;
		return target_account;
	}
}