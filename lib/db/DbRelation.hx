package db;
import haxe.ds.StringMap;
import hxbit.Serializable;

class DbRelation implements hxbit.Serializable{

	@:s public var alias:String;
	@:s public var fields:Array<String>;
	@:s public var filter:Dynamic;
	@:s public var jCond:String;

	public function new(p:Dynamic){
		
		for(f in Type.getInstanceFields(Type.getClass(this))){
			switch (f){
				case '__uid'|'getCLID'|'serialize'|'unserialize'|'getSerializeSchema':
					//SKIP
				default:
					var v = Reflect.field(p,f);
					//if(v!=null)
						Reflect.setField(this, f, v);
			}
		}	
	};	
}