package state;

typedef UserState =
{
	?change_pass_required:Bool,
	?contact:Int,
	?external:Dynamic,
	?first_name:String,
	?last_name:String,
	?email:String,
	?active:Bool,
	?loggedIn:Bool,
	?last_login:Date,
	?loginError:Dynamic,
	?mandator:Int,
	?jwt:String,
	?pass:String,
	?phone:String,
	?phone_pass:String,
	?new_pass:String,
	?new_pass_confirm:String,
	?user_name:String,
	?id:Int,
	?waiting:Bool    
}