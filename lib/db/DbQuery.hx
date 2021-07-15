package db;
import hxjsonast.Json;
import db.DBAccessProps;
import db.DbUser;
import db.DbRelation;
import haxe.ds.Map;
/*import hxbit.Schema;
import hxbit.Serializable;*/
import state.UserState;

/**
 * ...
 * @author axel@cunity.me
 */

class DbQuery// implements hxbit.Serializable 
{
	@:s public var dbParams:Map<String,String>;
	@:s public var relations:Map<String,DbRelation>;
	@:s public var dbUser:DbUser;

	public static function customWrite(v:DbQuery):String {
		trace(v);
		return v.getTime() + '';
	}

	public static function customParse(val:Json, name:String):DbQuery{
		var dp:DBAccessProps = {};
		
	}

	public function new(?dp:DBAccessProps) 
	{
		dbParams = new Map();
		if(dp!=null){
			dbUser = dp.dbUser;		
			relations = dp.relations;
			for(f in Reflect.fields(dp)){
				switch (f){
					case '__uid'|'dbUser'|'relations'|'getCLID'|'serialize'|'unserialize'|'unserializeInit'|'getSerializeSchema':
						//SKIP
					default:
						var v = Reflect.field(dp,f);
						dbParams.set(f, v);
						//trace(f +':'+dbParams.get(f));
				}
			}			
		}
	}
}