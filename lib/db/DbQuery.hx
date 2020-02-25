package db;
import db.DbUser;
import db.DbRelation;
import haxe.ds.Map;
import hxbit.Schema;
import hxbit.Serializable;

/**
 * ...
 * @author axel@cunity.me
 */

typedef DbQueryParam = {
	?action:String,	
	?className:String,
	?relations:Map<String,DbRelation>,
	?devIP:String,	
	?filter:Map<String,String>,
	?formData:Dynamic,
	?limit:Int,
	?maxImport:Int,
//	?pages:Int,
	?offset:Int,
	?table:String,
	?dbUser:DbUser
};

class DbQuery implements hxbit.Serializable 
{

	@:s public var dbParams:Map<String,Dynamic>;
	//@:s public var formData:Dynamic;
	@:s public var relations:Map<String,DbRelation>;
	@:s public var dbUser:DbUser;

	public function new(?drp:DbQueryParam) 
	{
		dbParams = new Map();
		if(drp!=null){
			dbUser = drp.dbUser;		
			//dbUser = drp.dbUser;		
			relations = drp.relations;
			for(f in Reflect.fields(drp)){
				switch (f){
					case '__uid'|'dbUser'|'relations'|'getCLID'|'serialize'|'unserialize'|'unserializeInit'|'getSerializeSchema':
						//SKIP
					default:
						var v = Reflect.field(drp,f);
						//if(v!=null)
							dbParams.set(f, v);
				}
			}			
		}

	}

}