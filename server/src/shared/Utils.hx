package shared;

/**
 * ...
 * @author axel@cunity.me
 */


import me.cunity.debug.Out;


class Utils 
{

	public static function keysList(ki:Iterator<Int>):Array<Int>
	{
		var l:Array<Int> = [];
		for(k in ki)
		{
			l.push(k);
		}
		return l;
	}
	
	public static function extend(obj1: Dynamic, obj2: Dynamic): Dynamic {
		
		var keys = Reflect.fields(obj2);
		
		for (k in keys) {
			var value: Dynamic = Reflect.field(obj2, k);
			Reflect.setField(obj1, k, value);
		}
		
		return obj1;
	}
	
	public static function each(object: Dynamic, cb: String -> Dynamic -> Void) {
		
		var keys = Reflect.fields(object);
		
		for (k in keys) {
			cb(k, Reflect.field(object, k));
		}
		
	}
	
	public static function dynaMap(object:Dynamic):Map<String,String>
	{
		return [
			for (k in Reflect.fields(object))
				k => Std.string(Reflect.field(object, k))
		];
	}

	public static function dynaDynMap(object:Dynamic):Map<String,Map<String,String>>
	{
		return [
			for (k in Reflect.fields(object))
				k => dynaMap(Reflect.field(object, k))			
		];
	}

	static var kIndex:Int = 0;
	public static function genKey(v :Dynamic, ?i :haxe.PosInfos ) :String 
	{
		var msg = if( i != null ) i.fileName+":"+i.methodName +":"+i.lineNumber+":" else "";
		var key:String = i.methodName + '_' + Std.string(++kIndex);
		//untyped console.log('$msg $v $key');
		return key;
	}

	public static function stateToDataParams(dT:Dynamic):Map<String,Map<String,Dynamic>>
   	{
      	return  [
         	for(f in Reflect.fields(dT))
            	f => dynToMap(Reflect.field(dT, f))
      	];
   	}

   	public static function dynToMap(d:Dynamic):Map<String,Dynamic>
   	{
      	return [
         	for(f in Reflect.fields(d))
            	f => Reflect.field(d, f)
      	];
  	}	
}