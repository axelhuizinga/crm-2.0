package db;
import hxjsonast.Json;
import me.cunity.debug.Out;


class DbUser// implements hxbit.Serializable
{
	
	
	@:s public var active:Bool;
	@:s public var change_pass_required:Bool;
	@:s public var contact:Int;
	@:s public var edited_by:Int;
	@:s public var actions:String;
	@:s public var email:String; 
	@:s public var external:String;
	@:s public var first_name:String;	
	@:s public var id:Int;
	@:s public var jwt:String;	
	@:s public var last_locktime:String;	
	@:s public var last_login:String;	
	@:s public var last_name:String;
	@:s public var last_request_time:String;
	@:s public var mandator:Int;
	@:s public var online:Bool;	
	@:s public var password:String;
	@:s public var last_error:String;
	@:s public var settings:String;
	@:s public var new_pass:String;	
	@:s public var user_group:Int;
	@:s public var user_name:String;


	public static function dbUserWrite(u:DbUser):String {
		trace(u);
		return  '';
	}

	public static function dbUserParse(val:Json, name:String):DbUser{
		var dp:DBAccessProps = {action:'load'};
		trace(val);
		return null;
	}
		
	public function new(p:Dynamic){		
		//trace(p);
		//Out.dumpVar(p);
		for(f in Type.getInstanceFields(Type.getClass(this))){
			switch (f){
				case '__uid'|'getCLID'|'serialize'|'unserialize'|'unserializeInit'|'getSerializeSchema':
					//SKIP
				default:
					Reflect.setField(this, f, Reflect.field(p,f));
			}
		}		
	};

}