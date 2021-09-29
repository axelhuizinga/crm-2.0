package db;
import db.DBAccessProps;
import db.DbUser;
import db.DbRelation;
import haxe.Exception;
import haxe.Unserializer;
import haxe.ds.Map;

import hxbit.Schema;
import hxbit.Serializable;
import hxbit.Serializer;
import state.UserState;

/**
 * ...
 * @author axel@cunity.me
 */

class DbQuery implements hxbit.Serializable //@:s (default, set)
{
	@:s public var dbUser:DbUser;
	@:s public var relations:Map<String,DbRelation>;
	@:s public var dbJoins:Array<String>;
	@:s public var dbJoinParams:Map<String,Dynamic>;

	@:s public var dbParams:Map<String,Dynamic>;

	public function new(?dp:DBAccessProps) 
	{		
		dbParams = new Map();
		dbJoins = new Array();
		dbJoinParams = new Map();
		if(dp!=null){
			trace(dp);
			dbUser = dp.dbUser;		
			relations = dp.relations;
			for(f in Reflect.fields(dp)){
				switch (f){
					//case '__uid'|'getCLID'|'serialize'|'unserialize'|'unserializeInit'|'getSerializeSchema':
					case '__uid'|'dbUser'|'getCLID'|'relations'|'serialize'|'unserialize'|'unserializeInit'|'getSerializeSchema':	
						//SKIP
					case 'dbJoinParams':
						setJoinParams(f, Reflect.field(dp,f));
					default:
						var v = Reflect.field(dp,f);
						//trace(v);
						trace('$f:'+Type.typeof(v));						
						dbParams.set(f, v);
						//dbParams.set(f,v);
						trace(f +':'+dbParams.get(f));
				}
			}			
		}
	}

	function setJoinParams(k:String, p:Map<String,Dynamic>):Map<String,Dynamic> {
		trace(p);
		if(p!=null){
			for(f in Reflect.fields(p)){
					dbJoinParams.set(f,p);
			}
				dbJoinParams = p.copy();
		}
		return dbJoinParams;
	}
}