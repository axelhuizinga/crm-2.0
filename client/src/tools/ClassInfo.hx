package tools;

class ClassInfo {
	public static function classPath(obj:Dynamic):String {
		var cL:Dynamic = Type.getClass(obj);
		if(cL!=null){
			return Type.getClassName(cL);		
		}
		return null;
	}

	public static function keyNames<K,V>(map:Map<K,V>):Array<K> {
		return [for (key in map.keys()) key];
		var kn:Array<K> = [];
		for(key in map.keys())
			kn.push(key);
		return kn;
	}
}