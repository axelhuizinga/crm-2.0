package shared;

/**
 * ...
 * @author axel@cunity.me
 */

import haxe.Serializer;
import haxe.ds.IntMap;
import redux.Redux.Dispatch;
import haxe.Constraints.Function;
import react.ReactDOM;
import haxe.ds.StringMap;
import me.cunity.debug.Out;


class Utils 
{

	public static function compare(ob1:Dynamic, ob2:Dynamic):Void {
		var keys:Array<String> = Reflect.fields(ob1);
		for(k in keys)
		{
			if(Reflect.field(ob1,k)!=Reflect.field(ob2,k))
			{
				//trace('$k: ${Reflect.field(ob1,k)} != ${Reflect.field(ob2,k)}');
			}
		}
	}

	public static function copyObjectArray<T>(oA:Array<T>):Array<T>
	{
		var oaCopy:Array<T> = [];
		for(el in oA)
		{
			var elCopy:T = null;
			for(f in Reflect.fields(el))
				Reflect.setField(elCopy, f, Reflect.field(el,f));
			oaCopy.push(elCopy);
		}
		return oaCopy;
	}

	public static function getByKey<T>(am:Array<T>, val:String, key:String='id'):T {
		//return null;
		for(ma in am)
			if(Reflect.field(ma, key)==val)
				return ma;
		return null;
	}

	public static function getAllByKey(am:Array<Map<String,String>>, key:String='id'):Array<String> {
		//return null;
		return [
			for(ma in am)
				ma.get(key)
		];
	}


	public static function arrayKeysList(arr:Array<Dynamic>, key:String):Array<String>
	{
		var l:Array<String> = [];
		if(arr==null)
			return l;
		for(el in arr)
		{
			//trace(Reflect.fields(el).join('|'));
			if(Reflect.hasField(el,key))
				l.push(Reflect.field(el,key));
		}
		return l;
	}	

	public static function keysList(ki:Iterator<Int>):Array<Int>
	{
		var l:Array<Int> = [];
		for(k in ki)
		{
			l.push(k);
		}
		return l;
	}

	public static function sKeysList(ki:Iterator<String>):Array<String>
	{
		var l:Array<String> = [];
		for(k in ki)
		{
			l.push(k);
		}
		return l;
	}	

	public static function argList(path:String, keys:Array<String>,del:String='/'):Map<String,Dynamic> {
		//trace(path);
		var segments:Array<String> = path.split(del);
		//remove empty el
		segments.shift();
		var key:String = null;
		var lastKey:String = keys.pop();
		var aL:Map<String,Dynamic> = new Map();
		for(k in keys)
		{
			aL.set(k,segments.shift());
		}
		aL.set(lastKey, (segments.length>0? del+segments.join(del):del));
		return aL;
	}
	
	public static function extend(obj1: Dynamic, obj2: Dynamic): Dynamic {
		
		var keys = Reflect.fields(obj2);
		//trace(keys.join('|'));
		//trace(obj1);
		if(obj1 == null)
			obj1 = {};
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
	
	/*public static function json2Dyn(j:Json, ?d:Dynamic):Dynamic{
		var jD:Dynamic = updateDyn({},d);
		switch(j.value){
			case JObject(fields)://:Array<JObjectField>
				//Reflect.setField(jD, );
				trace(fields.length);
				if(fields.length>0){
					trace(fields[0]);
				}
			case JString(s):
				trace(s);
			case JNumber(s)://:String
				trace(s);
			case JArray(values)://:Array<Json>
				trace(values.length);
				if(values.length>0){
					trace(values[0]);
				}
			case JBool(b)://:Bool
				trace(b);
			default:
				trace('nothing');
		}
		return jD;
	}*/

	public static function stateToDataParams(dT:Dynamic):Map<String,Map<String,Dynamic>>
   	{
      	return  [
         	for(f in Reflect.fields(dT))
            	f => dynToMap(Reflect.field(dT, f))
      		];
	   	}
		
	public static function diff(d1:Dynamic, d2:Dynamic):Map<String,String> {
		var rDiff:Map<String,String> = [];
		for(f in Reflect.fields(d1)){
			if(Reflect.field(d1,f) != Reflect.field(d2,f)){
				rDiff[f] = '${Reflect.field(d1,f)} => ${Reflect.field(d2,f)}';
			}
		}
		return rDiff;
	}
			   
	public static function dynArray2MapArray(dT:Array<Dynamic>):Array<Map<String,Dynamic>> {	   
		    return [
				for(dR in dT)
					dynToMap(dR)
		   	];
	   	}

   	public static function dynToMap(d:Dynamic):Map<String,Dynamic>
   	{
      	return [
         	for(f in Reflect.fields(d))
            	f => Reflect.field(d, f)
      	];
  	}	
	
	public static function dynArray2IntMap(d:Array<Map<String,Dynamic>>,?findBy:String='id'):IntMap<Map<String,Dynamic>>
	{
		var map:IntMap<Map<String,Dynamic>> = new IntMap();
		//trace(findBy);
		for(el in d){			
			//trace(Std.string(el));
			//trace(el[findBy]);
			map.set(el[findBy], el);
			// TODO: check4recursion
		}
			//Reflect.setField(obj, k, v);
		return map;
	}

	public static function dyn2map1(d:Dynamic):Map<String,Dynamic>
	{
		var map:Map<String,Dynamic> = [];
		for(f in Reflect.fields(d)){
			trace(f);
			map[f] = Reflect.field(d,f);
			// TODO: check4recursion
		}
			//Reflect.setField(obj, k, v);
		return map;
	}	

	/**
	 * Serialize :Map<String,Map<String,Dynamic>>
	 * @param map
	 * @return String
	 */
	public static function serializeNestedMap(map:Map<String,Dynamic>):String
	{
		return [
			for(k => v in map.keyValueIterator()){
				trace(k);
				Serializer.run([k=>v]);
				//map[k] = Reflect.field(d,f);
				// TODO: check4recursion
			}
		].join(',');
			//Reflect.setField(obj, k, v);
		return 'map';
	}

	public static function map2dyn(map:Map<String,Dynamic>):Dynamic
	{
		var obj:Dynamic = {};
		for(k=>v in map.keyValueIterator())
			Reflect.setField(obj, k, v);
		return obj;
	}

	public static function errorStatus(status:String):String
	{
		return '<span className="error">$status</span>';
	}

	public static function keyMax(d:Array<Dynamic>, key:String):Float 
	{
		var res:Float = 0;
		if(d.length==0)
			return res;
		trace(Type.typeof(d[0]));
		for(el in d)
		{
			//trace('$key: ${el.get(key)}');
			var v:Float = Std.parseFloat(el.get(key));
			if(!Math.isNaN(v) && v>res)
				res = v;
		}
		return res;
	}

	/*public static function untilDone(fn:redux.Dispatch, check:DbData->Bool, isDone = false):Dispatch {
		if(isDone) return fn;
		var p = fn();
		return fn.then(function(data:DbData)return untilDone(fn, check, check(data)));
	}*/
	
	public static function updateDyn(obj1: Dynamic, obj2: Dynamic): Dynamic {
		
		var keys = Reflect.fields(obj1);
		if(obj1 == null)
			return null;
		for (k in keys) {
			var value: Dynamic = Reflect.field(obj2, k);
			if(Reflect.hasField(obj2, k))
				Reflect.setField(obj1, k, value);
		}
		
		return obj1;
	}
}