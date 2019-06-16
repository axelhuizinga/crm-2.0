package model;
import model.UserState;
import history.History;
import model.LocationState;
import view.shared.FormState;

typedef GlobalAppState = 
{
	config:Dynamic,
	firstLoad:Bool,
	formStates:Map<String, FormState>,
	?hasError:Bool,
	history:History,
	?locale:String,
	?path:String,
	?redirectAfterLogin:String,
	?routeHistory:Array<LocationState>,
	?themeColor:String,
	userList:Array<UserState>,
	user:UserState
}
