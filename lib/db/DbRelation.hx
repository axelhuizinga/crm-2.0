package db;
import haxe.ds.StringMap;
import hxbit.Serializable;

class DbRelation implements hxbit.Serializable{

	@:s var alias:String;
	@:s var fields:Array<String>;
	@:s var filter:Dynamic;
	@:s var jCond:String;

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