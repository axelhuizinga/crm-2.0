package model.roles;


/**
 * ...
 * @author axel@bi4.me
 */

class Users extends Model
{
	public static function _create(param:Map<String,String>):Void
	{
		var self:Users = new Users(param);	
		//Reflect.callMethod(self, Reflect.field(self, action), [param]);
	}

	public function list() 
	{
		trace(param);
		get();
	}
	
}