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

	public function new(data:Map<String,String>) {
		super(data);
		propertyNames = 'id,result,request,user,date'.split(',');
	}	
		
	@dataType("bigint")
	@:isVar public var id(default,set):Int;

	function set_id(id:Int):Int{
		if(initialized('id'))
			modified('id');
		this.id = id ;
		return id;
	}	
		
	@dataType("character varying(64)")
	@:isVar public var result(default,set):String;

	function set_result(result:String):String{
		if(initialized('result'))
			modified('result');
		this.result = result ;
		return result;
	}	
		
	@dataType("text")
	@:isVar public var request(default,set):String;

	function set_request(request:String):String{
		if(initialized('request'))
			modified('request');
		this.request = request ;
		return request;
	}	
		
	@dataType("bigint")
	@:isVar public var user(default,set):Int;

	function set_user(user:Int):Int{
		if(initialized('user'))
			modified('user');
		this.user = user ;
		return user;
	}	
		
	@dataType("timestamp(3) without time zone")
	@:isVar public var date(default,set):String;

	function set_date(date:String):String{
		if(initialized('date'))
			modified('date');
		this.date = date ;
		return date;
	}	
	
}