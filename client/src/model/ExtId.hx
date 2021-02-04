package model;

typedef ExtIdProps = {
	?ext_id:Int,
	?auth_user:Int,
	?action:String,
	?table_name:String,
	?creation_date:String
};

@:rtti
class ExtId extends ORM
{
	public function new(data:Map<String,String>) {
		super(data);
		
	}	
		
	@dataType("bigint")
	@:isVar public var ext_id(default,set):Int;

	function set_ext_id(ext_id:Int):Int{
		if(initialized('ext_id'))
			modified('ext_id');
		this.ext_id = ext_id ;
		return ext_id;
	}	
		
	@dataType("bigint")
	@:isVar public var auth_user(default,set):Int;

	function set_auth_user(auth_user:Int):Int{
		if(initialized('auth_user'))
			modified('auth_user');
		this.auth_user = auth_user ;
		return auth_user;
	}	
		
	@dataType("text")
	@:isVar public var action(default,set):String;

	function set_action(action:String):String{
		if(initialized('action'))
			modified('action');
		this.action = action ;
		return action;
	}	
		
	@dataType("text")
	@:isVar public var table_name(default,set):String;

	function set_table_name(table_name:String):String{
		if(initialized('table_name'))
			modified('table_name');
		this.table_name = table_name ;
		return table_name;
	}	
		
	@dataType("timestamp with time zone")
	@:isVar public var creation_date(default,set):String;

	function set_creation_date(creation_date:String):String{
		if(initialized('creation_date'))
			modified('creation_date');
		this.creation_date = creation_date ;
		return creation_date;
	}	
	
}