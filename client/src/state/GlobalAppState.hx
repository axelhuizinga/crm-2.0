package state;
import state.UserState;
import history.History;
import state.LocationState;
import state.StatusBarState;
import state.FormState;

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
	statusBar:StatusBarState,
	?themeColor:String,
	userList:Array<UserState>,
	user:UserState
}
