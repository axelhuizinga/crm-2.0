package model;

typedef BaIdProps = {
	?ba_id:Int
};

@:rtti
class BaId extends ORM
{
	public static var tableName:String = "ba_ids";

	public function new(data:Map<String,String>) {
		super(data);		
	}	
		
	@dataType("bigint")
	@:isVar public var ba_id(default,set):Int;

	function set_ba_id(ba_id:Int):Int{
		if(initialized('ba_id'))
			modified('ba_id');
		this.ba_id = ba_id ;
		return ba_id;
	}	
	
}