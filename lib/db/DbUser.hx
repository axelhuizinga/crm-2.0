package db;
import hxbit.Serializable;

class DbUser implements hxbit.Serializable{

	@:s public var email:String;
	@:s public var first_name:String;
	@:s public var last_name:String;
	@:s public var mandator:Int;
	@:s public var jwt:String;
	@:s public var pass:String;
	@:s public var new_pass:String;
	@:s public var user_name:String;
	@:s public var id:Int;

	public function new(p:Dynamic){
		for(f in Type.getInstanceFields(Type.getClass(this))){
			switch (f){
				case '__uid'|'getCLID'|'serialize'|'unserialize'|'unserializeInit'|'getSerializeSchema':
					//SKIP
				default:
					Reflect.setField(this, f, Reflect.field(p,f));
			}
		}		
	};

}