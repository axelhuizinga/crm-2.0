package db;
import db.DBAccessProps;
import db.DbUser;
import db.DbRelation;
import haxe.ds.Map;

import haxe.Serializer;
import state.UserState;

/**
 * ...
 * @author axel@cunity.me
 */

class DbQuery //implements hxbit.Serializable //@:s 
{
	public var dbUser:DbUser;
	public var relations:Map<String,DbRelation>;
	public var dbParams:Map<String,Dynamic>;

	public function new(?dp:DBAccessProps) 
	{
		dbParams = new Map();
		if(dp!=null){
			dbUser = dp.dbUser;		
			relations = dp.relations;
			for(f in Reflect.fields(dp)){
				switch (f){
					//case '__uid'|'getCLID'|'serialize'|'unserialize'|'unserializeInit'|'getSerializeSchema':
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