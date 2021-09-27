package db;
import haxe.Unserializer;
import db.DBAccessProps;
import db.DbUser;
import db.DbRelation;
import haxe.ds.Map;

import hxbit.Schema;
import hxbit.Serializable;
import hxbit.Serializer;
import state.UserState;

/**
 * ...
 * @author axel@cunity.me
 */

class DbQuery implements hxbit.Serializable //@:s 
{
	@:s public var dbUser:DbUser;
	@:s public var relations:Map<String,DbRelation>;
	@:s public var dbParams:Map<String,Dynamic>;

	public function new(?dp:DBAccessProps) 
	{
		dbParams = new Map();
		if(dp!=null){
			dbUser = dp.dbUser;		
			relations = dp.relations;
			for(f in Reflect.fields(dp)){
				switch (f){
					//case '__uid'|'getCLID'|'serialize'|'unserialize'|'unserializeInit'|'getSerializeSchema':
					case '__uid'|'dbUser'|'getCLID'|'relations'|'serialize'|'unserialize'|'unserializeInit'|'getSerializeSchema':	
						//SKIP
					default:
						var v = Reflect.field(dp,f);
						trace(v);
						trace('$f:'+Type.typeof(v));
						dbParams.set(f, f=='dataSource' && v!= null ?haxe.Serializer.run(Std.string(v)):v);
						trace(f +':'+dbParams.get(f));
				}
			}			
		}
	}
}