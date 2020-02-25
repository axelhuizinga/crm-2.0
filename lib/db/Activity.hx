package model;

typedef ActivityProps = {
	?id:Int,
	?result:String,
	?request:String,
	?user:Int,
	?date:String
};

@:rtti
class Activity extends ORM
{

	public function new(props:ActivityProps) {
		propertyNames = 'id,result,request,user,date'.split(',');
		super(propsMwaaa);
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
		
	@dataType("character varying(64)")
	@:isVar public var result(get,set):String;
	var result_initialized:Bool;
	
	function get_result():String{
		return result;
	}

	function set_result(result:String):String{
		if(result_initialized)
			modified('result');
		this.result = result ;
		result_initialized = true; 
		return result;
	}	
		
	@dataType("character varying(4096)")
	@:isVar public var request(get,set):String;
	var request_initialized:Bool;
	
	function get_request():String{
		return request;
	}

	function set_request(request:String):String{
		if(request_initialized)
			modified('request');
		this.request = request ;
		request_initialized = true; 
		return request;
	}	
		
	@dataType("bigint")
	@:isVar public var user(get,set):Int;
	var user_initialized:Bool;
	
	function get_user():Int{
		return user;
	}

	function set_user(user:Int):Int{
		if(user_initialized)
			modified('user');
		this.user = user ;
		user_initialized = true; 
		return user;
	}	
		
	@dataType("timestamp(3) without time zone")
	@:isVar public var date(get,set):String;
	var date_initialized:Bool;
	
	function get_date():String{
			return date;
	}

	function set_date(date:String):String{
		if(date_initialized)
			modified('date');
		this.date = date ;
		date_initialized = true; 
		return date;
	}	
	
}