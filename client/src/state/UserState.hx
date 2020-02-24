package state;
import db.DbUser;

enum abstract LoginTask(String) {
	var ChangePassword;
	var CheckEmail;
	var Login;
	var ResetPassword;
}

typedef UserState =
{
	?dbUser:DbUser,
	?lastError:Dynamic,
	?loginTask:LoginTask,
	?new_pass_confirm:String,
	?new_pass:String,
	?waiting:Bool    
}