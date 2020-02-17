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

@:rtti
class TableField extends ORM
{

	public function new(props:TableFieldProps) {
		propertyNames = 'id,table_name,mandator,field_name,readonly,element,any,required,use_as_index,admin_only,field_type'.split(',');
		super(props);
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
		this.id = id;
		id_initialized = true; 
		return id;
	}

	public function clear_id():Int{
		trace('id primary key cannot be empty');
		return id;
	}	
		
	@dataType("character varying")
	@:isVar public var table_name(get,set):String;
	var table_name_initialized:Bool;
	
	function get_table_name():String{
		return table_name;
	}

	function set_table_name(table_name:String):String{
		if(table_name_initialized)
			modified('table_name');
		this.table_name = table_name;
		table_name_initialized = true; 
		return table_name;
	}

	public function clear_table_name():String{
		table_name = '';
		return table_name;
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
		this.mandator = mandator;
		mandator_initialized = true; 
		return mandator;
	}

	public function clear_mandator():Int{
		mandator = null;
		return mandator;
	}	
		
	@dataType("character varying")
	@:isVar public var field_name(get,set):String;
	var field_name_initialized:Bool;
	
	function get_field_name():String{
		return field_name;
	}

	function set_field_name(field_name:String):String{
		if(field_name_initialized)
			modified('field_name');
		this.field_name = field_name;
		field_name_initialized = true; 
		return field_name;
	}

	public function clear_field_name():String{
		field_name = '';
		return field_name;
	}	
		
	@dataType("boolean")
	@:isVar public var readonly(get,set):Bool;
	var readonly_initialized:Bool;
	
	function get_readonly():Bool{
		return readonly;
	}

	function set_readonly(readonly:Bool):Bool{
		if(readonly_initialized)
			modified('readonly');
		this.readonly = readonly;
		readonly_initialized = true; 
		return readonly;
	}

	public function clear_readonly():Bool{
		readonly = false;
		return readonly;
	}	
		
	@dataType("element")
	@:isVar public var element(get,set):String;
	var element_initialized:Bool;
	
	function get_element():String{
			return element;
	}

	function set_element(element:String):String{
		if(element_initialized)
			modified('element');
		this.element = element;
		element_initialized = true; 
		return element;
	}

	public function clear_element():String{
		element = 'Input';
		return element;
	}	
		
	@dataType("jsonb")
	@:isVar public var any(get,set):String;
	var any_initialized:Bool;
	
	function get_any():String{
			return any;
	}

	function set_any(any:String):String{
		if(any_initialized)
			modified('any');
		this.any = any;
		any_initialized = true; 
		return any;
	}

	public function clear_any():String{
		any = '{}';
		return any;
	}	
		
	@dataType("boolean")
	@:isVar public var required(get,set):Bool;
	var required_initialized:Bool;
	
	function get_required():Bool{
		return required;
	}

	function set_required(required:Bool):Bool{
		if(required_initialized)
			modified('required');
		this.required = required;
		required_initialized = true; 
		return required;
	}

	public function clear_required():Bool{
		required = false;
		return required;
	}	
		
	@dataType("boolean")
	@:isVar public var use_as_index(get,set):Bool;
	var use_as_index_initialized:Bool;
	
	function get_use_as_index():Bool{
		return use_as_index;
	}

	function set_use_as_index(use_as_index:Bool):Bool{
		if(use_as_index_initialized)
			modified('use_as_index');
		this.use_as_index = use_as_index;
		use_as_index_initialized = true; 
		return use_as_index;
	}

	public function clear_use_as_index():Bool{
		use_as_index = false;
		return use_as_index;
	}	
		
	@dataType("boolean")
	@:isVar public var admin_only(get,set):Bool;
	var admin_only_initialized:Bool;
	
	function get_admin_only():Bool{
		return admin_only;
	}

	function set_admin_only(admin_only:Bool):Bool{
		if(admin_only_initialized)
			modified('admin_only');
		this.admin_only = admin_only;
		admin_only_initialized = true; 
		return admin_only;
	}

	public function clear_admin_only():Bool{
		admin_only = false;
		return admin_only;
	}	
		
	@dataType("data_type")
	@:isVar public var field_type(get,set):String;
	var field_type_initialized:Bool;
	
	function get_field_type():String{
			return field_type;
	}

	function set_field_type(field_type:String):String{
		if(field_type_initialized)
			modified('field_type');
		this.field_type = field_type;
		field_type_initialized = true; 
		return field_type;
	}

	public function clear_field_type():String{
		field_type = 'null';
		return field_type;
	}	
	
}