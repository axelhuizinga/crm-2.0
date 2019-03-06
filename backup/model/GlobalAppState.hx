package model;
import model.UserState;
import history.History;
import model.LocationState;


typedef GlobalAppState = 
{
	config:Dynamic,
	firstLoad:Bool,
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
