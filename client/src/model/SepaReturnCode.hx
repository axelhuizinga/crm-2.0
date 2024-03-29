package model;


@:keep
@:rtti
class SepaReturnCode extends ORM
{
	public static var tableName:String = "sepa_return_codes";

	public function new(data:Map<String,String>) {
		super(data);		
	}	
		
	@dataType("character varying")
	@:isVar public var code(default,set):String;

	function set_code(code:String):String{
		if(initialized('code'))
			modified('code');
		this.code = code ;
		return code;
	}	
		
	@dataType("character varying")
	@:isVar public var description(default,set):String;

	function set_description(description:String):String{
		if(initialized('description'))
			modified('description');
		this.description = description ;
		return description;
	}	
		
	@dataType("character varying")
	@:isVar public var locale(default,set):String;

	function set_locale(locale:String):String{
		if(initialized('locale'))
			modified('locale');
		this.locale = locale ;
		return locale;
	}	
	
}