package db;
import haxe.Unserializer;
import haxe.Serializer;
import haxe.ds.Map;

class Join{
	var param:Map<String,Map<String,Dynamic>>;
	var keys:Array<String>;
	public function new(?p:Map<Map<String,Dynamic>>){
		param = new Map();
		if(p!=null){
			var kv:KeyValueIterator<Map,String<Map<String, Dynamic>> = p.keyValueIterator();
			for(k=>v in kv)){
				param[k] = v;
				keys.push(k);
			}	
		}
	}

	@:keep
	function hxSerialize(s:Serializer) {
	  s.serialize(x);
	}
  
	@:keep
	function hxUnserialize(u:Unserializer) {
	  x = u.unserialize();
	  y = -1;
	}
} 
