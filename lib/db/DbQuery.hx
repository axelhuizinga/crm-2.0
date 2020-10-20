package db;
import state.UserState;
import db.DbUser;
import db.DbRelation;
import haxe.ds.Map;
import hxbit.Schema;
import hxbit.Serializable;

/**
 * ...
 * @author axel@cunity.me
 */
typedef DbQueryResolveMessage = {
	?success:String,
	?failure:String
}
typedef DbQueryParam = {
	?action:String,	
	?classPath:String,
	?extDB:Bool,
	?relations:Map<String,DbRelation>,
	?dataSource:Map<String,Map<String,Dynamic>>,	
	?dbUser:DbUser,
	?devIP:String,	
	?filter:Dynamic,
	?data:Dynamic,	
	?firstBatch:Bool,
	?onlyNew:Bool,
	?limit:Int,
	?maxImport:Int,
	?pages:Int,
	?resolveMessage:DbQueryResolveMessage,
	?offset:Int,
	?table:String,
	?totalRecords:Int,
	?userState:UserState	
};

class DbQuery implements hxbit.Serializable 
{
	@:s public var dbParams:Map<String,Dynamic>;
	@:s public var relations:Map<String,DbRelation>;
	@:s public var dbUser:DbUser;

	public function new(?dp:DbQueryParam) 
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
						//if(v!=null)
							dbParams.set(f, v);
				}
			}			
		}
	}
}