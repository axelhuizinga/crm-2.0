package db;
import haxe.Json;
import haxe.ds.StringMap;
import hxbit.Serializable;

class DbRelation implements hxbit.Serializable
{

	@:s public var alias:String;
	@:s public var fields:String;	
	//@:s public var jCond:String;
	@:s public var version:String;
	@:s public var filter:String;
	@:s public var tables:Array<DbRelationProps>;	

	public static function create(t:Array<DbRelationProps>):DbRelation {
		if(t.length<2)
		{
			return null;
		}
		var _inst:DbRelation = new DbRelation({fields:t[0].fields,filter:t[0].filter, version:t[0].version});
		_inst.tables = new Array();
		for(ti in t){
			_inst.tables.push(ti);
		}
		return _inst;
	}

	public static function fromMap(rMap:Map<String, DbRelationProps>):DbRelation {
		if(rMap == null|| !rMap.keys().hasNext()){
			return null;
		}
		var _inst:DbRelation = null;
		for(k=>v in rMap.keyValueIterator()){
			trace(v);
			if(_inst==null){
				_inst = new DbRelation({alias:v.alias,fields:v.fields,filter:v.filter,table:k,version:v.version});
				_inst.tables = new Array();
			}
			_inst.tables.push({alias:v.alias,fields:v.fields,filter:v.filter,table:k,version:v.version});
		}
		return _inst;
	}

	public function new(p:DbRelationProps){
		for(f in Type.getInstanceFields(DbRelation)){
			switch (f){
				case '__uid'|'getCLID'|'serialize'|'unserialize'|'getSerializeSchema'|'RelationType':
					//SKIP					
				case 'filter':
					if(p.filter!=null)
						filter = Json.stringify(p.filter);
				default:
					if(Reflect.hasField(p, f))
						Reflect.setField(this, f, Reflect.field(p,f));
			}
		}	
	};	


	public function toString() {
		var sqlBf:StringBuf = new StringBuf();
		for(f in Type.getInstanceFields(DbRelation)){
			switch (f){
				case '__uid'|'getCLID'|'serialize'|'unserialize'|'getSerializeSchema':
					//SKIP
				case 'tables':
					if(tables == null || tables.length <2){						
						return "Wir brauchen hier mindestens 2 Tabellen statt:"	+ (tables!=null?tables.length:0);
					}					
					for(t in tables)
						sqlBf.add(new DbRelation(t).toString());
				default:
					if(Reflect.hasField(this, f))
						sqlBf.add( f +':' + Std.string(Reflect.field(this,f)));
			}
		}		
		return sqlBf.toString();
	}

}