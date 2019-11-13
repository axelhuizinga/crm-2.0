package model;

typedef TableFieldProps = {
	?id:Int,
	?table_name:String,
	?mandator:Int,
	?field_name:String,
	?readonly:Bool,
	?element:String,
	?any:String,
	?required:Bool,
	?use_as_index:Bool,
	?admin_only:Bool,
	?field_type:String
};

class TableField extends ORM
{
		public function new(props:TableFieldProps) {
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
		id = 'null';
		return id;
	}

	//{"type":"character varying","default":"''","attnum":"2"}
	@:isVar public var table_name(get,set):String;
	var initial_table_name:String;
	
	function get_table_name():String{
		return table_name;
	}

	function set_table_name(x:String):String{

		modified('table_name');
		table_name = x;
		if(initial_table_name == null)
			initial_table_name = table_name; 
		return table_name;
	}

	public function reset_table_name():String{
		return initial_table_name;
	}

	public function clear_table_name():String{
		table_name = '''';
		return table_name;
	}

	//{"type":"bigint","default":0,"attnum":"3"}
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
		mandator = '0';
		return mandator;
	}

	//{"type":"character varying","default":"''","attnum":"4"}
	@:isVar public var field_name(get,set):String;
	var initial_field_name:String;
	
	function get_field_name():String{
		return field_name;
	}

	function set_field_name(x:String):String{

		modified('field_name');
		field_name = x;
		if(initial_field_name == null)
			initial_field_name = field_name; 
		return field_name;
	}

	public function reset_field_name():String{
		return initial_field_name;
	}

	public function clear_field_name():String{
		field_name = '''';
		return field_name;
	}

	//{"type":"boolean","default":"false","attnum":"5"}
	@:isVar public var readonly(get,set):Bool;
	var initial_readonly:Bool;
	
	function get_readonly():Bool{
		return readonly;
	}

	function set_readonly(x:Bool):Bool{

		modified('readonly');
		readonly = x;
		if(initial_readonly == null)
			initial_readonly = readonly; 
		return readonly;
	}

	public function reset_readonly():Bool{
		return initial_readonly;
	}

	public function clear_readonly():Bool{
		readonly = 'false';
		return readonly;
	}

	//{"type":"element","default":"'Input'","attnum":"6"}
	@:isVar public var element(get,set):String;
	var initial_element:String;
	
	function get_element():String{
			return element;
	}

	function set_element(x:String):String{

		modified('element');
		element = x;
		if(initial_element == null)
			initial_element = element; 
		return element;
	}

	public function reset_element():String{
		return initial_element;
	}

	public function clear_element():String{
		element = ''Input'';
		return element;
	}

	//{"type":"jsonb","default":"'{}'","attnum":"7"}
	@:isVar public var any(get,set):String;
	var initial_any:String;
	
	function get_any():String{
			return any;
	}

	function set_any(x:String):String{

		modified('any');
		any = x;
		if(initial_any == null)
			initial_any = any; 
		return any;
	}

	public function reset_any():String{
		return initial_any;
	}

	public function clear_any():String{
		any = ''{}'';
		return any;
	}

	//{"type":"boolean","default":"false","attnum":"8"}
	@:isVar public var required(get,set):Bool;
	var initial_required:Bool;
	
	function get_required():Bool{
		return required;
	}

	function set_required(x:Bool):Bool{

		modified('required');
		required = x;
		if(initial_required == null)
			initial_required = required; 
		return required;
	}

	public function reset_required():Bool{
		return initial_required;
	}

	public function clear_required():Bool{
		required = 'false';
		return required;
	}

	//{"type":"boolean","default":"false","attnum":"9"}
	@:isVar public var use_as_index(get,set):Bool;
	var initial_use_as_index:Bool;
	
	function get_use_as_index():Bool{
		return use_as_index;
	}

	function set_use_as_index(x:Bool):Bool{

		modified('use_as_index');
		use_as_index = x;
		if(initial_use_as_index == null)
			initial_use_as_index = use_as_index; 
		return use_as_index;
	}

	public function reset_use_as_index():Bool{
		return initial_use_as_index;
	}

	public function clear_use_as_index():Bool{
		use_as_index = 'false';
		return use_as_index;
	}

	//{"type":"boolean","default":"false","attnum":"10"}
	@:isVar public var admin_only(get,set):Bool;
	var initial_admin_only:Bool;
	
	function get_admin_only():Bool{
		return admin_only;
	}

	function set_admin_only(x:Bool):Bool{

		modified('admin_only');
		admin_only = x;
		if(initial_admin_only == null)
			initial_admin_only = admin_only; 
		return admin_only;
	}

	public function reset_admin_only():Bool{
		return initial_admin_only;
	}

	public function clear_admin_only():Bool{
		admin_only = 'false';
		return admin_only;
	}

	//{"type":"data_type","default":"","attnum":"11"}
	@:isVar public var field_type(get,set):String;
	var initial_field_type:String;
	
	function get_field_type():String{
			return field_type;
	}

	function set_field_type(x:String):String{

		modified('field_type');
		field_type = x;
		if(initial_field_type == null)
			initial_field_type = field_type; 
		return field_type;
	}

	public function reset_field_type():String{
		return initial_field_type;
	}

	public function clear_field_type():String{
		field_type = '';
		return field_type;
	}
}