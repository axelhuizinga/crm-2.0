package db;
import haxe.ds.StringMap;
import hxbit.Serializable;

typedef DbRelationProps = {
	?alias:String,
	?fields:Array<String>,
	?jCond:String,
	?filter:Array<String>,
	//?tables:Array<DbRelationProps>,
	?version:String
}

class DbRelation implements hxbit.Serializable
{

	@:s public var alias:String;
	@:s public var fields:Array<String>;
	
	@:s public var jCond:String;
	@:s public var version:String;
	@:s public var filter:Array<String>;
	@:s public var tables:Array<DbRelationProps>;
	

	public function new(p:DbRelationProps){
		
		for(f in Type.getInstanceFields(DbRelation)){
			switch (f){
				case '__uid'|'getCLID'|'serialize'|'unserialize'|'getSerializeSchema':
					//SKIP
				case 'tables':
					if(tables == null){
						tables = new Array();				
					}
					var pTables:Array<DbRelationProps> = Reflect.field(p,f);
					if(pTables != null)
					for(p in pTables)
						tables.push(new DbRelation(p));
					//END
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