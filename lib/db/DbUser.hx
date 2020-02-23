package db;
import hxbit.Serializable;
//propertyNames = 'id,contact,last_login,password,user_name,active,edited_by,editing,settings,external,user_group,change_pass_required,online,last_request_time,request,mandator,last_locktime,phash'.split(',');
class DbUser implements hxbit.Serializable{
	
	@:s public var active:Bool;
	@:s public var change_pass_required:Bool;
	@:s public var contact:Int;
	@:s public var edited_by:Int;
	@:s public var editing:String;
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

	public function new(p:Dynamic){
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