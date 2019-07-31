package shared;

import haxe.ds.Map;
import hxbit.Schema;
import hxbit.Serializable;
import hxbit.Serializer;

/**
 * ...
 * @author axel@cunity.me
 */
class DbData implements Serializable 
{

	@:s public var dataErrors:Map<String,Dynamic>;
	@:s public var dataInfo:Map<String,Dynamic>;
	@:s public var dataParams:Map<String,Map<String,Dynamic>>;
	@:s public var dataRows:Array<Map<String,Dynamic>>;
	
	public function new() 
	{
		dataErrors = new Map();
		dataInfo = new Map();
		dataParams = new Map();
		dataRows = new Array();		
	}

	public function stateToDataParams(dT:Dynamic):Map<String,Map<String,Dynamic>>
   {
      	dataParams =  [
         	for(f in Reflect.fields(dT))
            	f => dynToMap(Reflect.field(dT, f))
      	];
		return dataParams;
   }

   public function dynToMap(d:Dynamic):Map<String,Dynamic>
   {
      	return [
         	for(f in Reflect.fields(d))
            	f => Reflect.field(d, f)
      	];
   }
	
}