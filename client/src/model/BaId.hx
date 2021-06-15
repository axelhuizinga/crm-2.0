package model;

typedef BaIdProps = {
	?id:Int
};

@:rtti
class BaId extends ORM
{
	public static var tableName:String = "ba_ids";

	public function new(data:Map<String,String>) {
		super(data);		
	}	
		
	@dataType("bigint")
	@:isVar public var id(default,set):Int;

	function set_ba_id(id:Int):Int{
		if(initialized('id'))
			modified('id');
		this.id = id ;
		return id;
	}	
	
}