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

class DbQuery// implements hxbit.Serializable @:s 
{
	/*@:jcustomparse(DbQuery.dbUserParse)
	@:jcustomwrite(DbQuery.dbUserWrite)
	public var dbUser:DbUser;
	@:jcustomparse(DbQuery.dbParamsParse)
	@:jcustomwrite(DbQuery.dbParamsWrite)
	@:jcustomparse(DbQuery.relationsParse)
	@:jcustomwrite(DbQuery.relationsWrite)	*/
	public var relations:Map<String,DbRelation>;
	public var dbParams:Map<String,String>;

	public static function relationsWrite(v:Map<String,DbRelation>):String {
		trace(v);
		return  '';
	}

	public static function relationsParse(val:Json, name:String):Map<String,DbRelation>{
		var dp:DBAccessProps = {action:'load'};
		trace(val);
		return [];
	}

	public function new(?dp:DBAccessProps) 
	{
		dbParams = new Map();
		if(dp!=null){
			//dbUser = dp.dbUser;		
			//relations = dp.relations;
			for(f in Reflect.fields(dp)){
				switch (f){
					case '__uid'|'getCLID'|'serialize'|'unserialize'|'unserializeInit'|'getSerializeSchema':
					//case '__uid'|'dbUser'|'relations'|'getCLID'|'serialize'|'unserialize'|'unserializeInit'|'getSerializeSchema':					
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