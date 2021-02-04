package model;

typedef ActivityProps = {
	?action:String,
	?request:String,
	?user:Int,
	?date:String
};

@:rtti
class Activity extends ORM
{
	public function new(data:Map<String,String>) {
		super(data);
		
	}	
		
	@dataType("character varying(64)")
	@:isVar public var action(default,set):String;

	function set_action(action:String):String{
		if(initialized('action'))
			modified('action');
		this.action = action ;
		return action;
	}	
		
	@dataType("jsonb")
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