package model;
class TableField extends ORM
{
	//{"type":"bigint","default":"null","attnum":"1"}
	public var id(get,set):Int;
	var initial_id:Int;
	
	function get_id():Int{
		return id;
	}

	function set_id(x:Int):Int{

		modified(this,id);
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
	}//{"type":"character varying","default":"''","attnum":"2"}
	public var table_name(get,set):String;
	var initial_table_name:String;
	
	function get_table_name():String{
		return table_name;
	}

	function set_table_name(x:String):String{

		modified(this,table_name);
		table_name = x;
		if(initial_table_name == null)
			initial_table_name = table_name; 
		return table_name;
	}

	public function reset_table_name():String{
		return initial_table_name;
	}

	public function clear_table_name():String{
		table_name = '';
		return table_name;
	}//{"type":"bigint","default":"","attnum":"3"}
	public var mandator(get,set):Int;
	var initial_mandator:Int;
	
	function get_mandator():Int{
		return mandator;
	}

	function set_mandator(x:Int):Int{

		modified(this,mandator);
		mandator = x;
		if(initial_mandator == null)
			initial_mandator = mandator; 
		return mandator;
	}

	public function reset_mandator():Int{
		return initial_mandator;
	}

	public function clear_mandator():Int{
		mandator = ;
		return mandator;
	}//{"type":"character varying","default":"''","attnum":"4"}
	public var field_name(get,set):String;
	var initial_field_name:String;
	
	function get_field_name():String{
		return field_name;
	}

	function set_field_name(x:String):String{

		modified(this,field_name);
		field_name = x;
		if(initial_field_name == null)
			initial_field_name = field_name; 
		return field_name;
	}

	public function reset_field_name():String{
		return initial_field_name;
	}

	public function clear_field_name():String{
		field_name = '';
		return field_name;
	}//{"type":"boolean","default":"false","attnum":"5"}
	public var readonly(get,set):String;
	var initial_readonly:String;
	
	function get_readonly():String{
			return readonly;
	}

	function set_readonly(x:String):String{

		modified(this,readonly);
		readonly = x;
		if(initial_readonly == null)
			initial_readonly = readonly; 
		return readonly;
	}

	public function reset_readonly():String{
		return initial_readonly;
	}

	public function clear_readonly():String{
		readonly = false;
		return readonly;
	}//{"type":"element","default":"'Input'","attnum":"6"}
	public var element(get,set):String;
	var initial_element:String;
	
	function get_element():String{
			return element;
	}

	function set_element(x:String):String{

		modified(this,element);
		element = x;
		if(initial_element == null)
			initial_element = element; 
		return element;
	}

	public function reset_element():String{
		return initial_element;
	}

	public function clear_element():String{
		element = 'Input';
		return element;
	}//{"type":"jsonb","default":"'{}'","attnum":"7"}
	public var any(get,set):String;
	var initial_any:String;
	
	function get_any():String{
			return any;
	}

	function set_any(x:String):String{

		modified(this,any);
		any = x;
		if(initial_any == null)
			initial_any = any; 
		return any;
	}

	public function reset_any():String{
		return initial_any;
	}

	public function clear_any():String{
		any = '{}';
		return any;
	}//{"type":"boolean","default":"false","attnum":"8"}
	public var required(get,set):String;
	var initial_required:String;
	
	function get_required():String{
			return required;
	}

	function set_required(x:String):String{

		modified(this,required);
		required = x;
		if(initial_required == null)
			initial_required = required; 
		return required;
	}

	public function reset_required():String{
		return initial_required;
	}

	public function clear_required():String{
		required = false;
		return required;
	}//{"type":"boolean","default":"false","attnum":"9"}
	public var use_as_index(get,set):String;
	var initial_use_as_index:String;
	
	function get_use_as_index():String{
			return use_as_index;
	}

	function set_use_as_index(x:String):String{

		modified(this,use_as_index);
		use_as_index = x;
		if(initial_use_as_index == null)
			initial_use_as_index = use_as_index; 
		return use_as_index;
	}

	public function reset_use_as_index():String{
		return initial_use_as_index;
	}

	public function clear_use_as_index():String{
		use_as_index = false;
		return use_as_index;
	}//{"type":"boolean","default":"false","attnum":"10"}
	public var admin_only(get,set):String;
	var initial_admin_only:String;
	
	function get_admin_only():String{
			return admin_only;
	}

	function set_admin_only(x:String):String{

		modified(this,admin_only);
		admin_only = x;
		if(initial_admin_only == null)
			initial_admin_only = admin_only; 
		return admin_only;
	}

	public function reset_admin_only():String{
		return initial_admin_only;
	}

	public function clear_admin_only():String{
		admin_only = false;
		return admin_only;
	}//{"type":"data_type","default":"null","attnum":"11"}
	public var field_type(get,set):String;
	var initial_field_type:String;
	
	function get_field_type():String{
			return field_type;
	}

	function set_field_type(x:String):String{

		modified(this,field_type);
		field_type = x;
		if(initial_field_type == null)
			initial_field_type = field_type; 
		return field_type;
	}

	public function reset_field_type():String{
		return initial_field_type;
	}

	public function clear_field_type():String{
		field_type = null;
		return field_type;
	}
}