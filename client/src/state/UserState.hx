package state;

enum abstract LoginTask(String) {
	var ChangePassword;
	var CheckEmail;
	var Login;
	var ResetPassword;
}

typedef UserState =
{
	?change_pass_required:Bool,
	?contact:Int,
	?email:String,
	?external:Dynamic,
	?first_name:String,
	?last_name:String,
	?active:Bool,
	?loggedIn:Bool,
	?last_login:Date,
	?loginError:Dynamic,
	?loginTask:LoginTask,
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