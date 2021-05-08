package tools;

class ClassInfo {
	public static function classPath(obj:Dynamic):String {
		var cL:Dynamic = Type.getClass(obj);
		if(cL!=null){
			return Type.getClassName(cL);		
		}
		return null;
	}
}