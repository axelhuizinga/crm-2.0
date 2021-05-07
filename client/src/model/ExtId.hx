package model;

typedef ExtIdProps = {
	?ext_id:Int
};

@:rtti
class ExtId extends ORM
{
	public static var tableName:String = "ext_ids";

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
	
}