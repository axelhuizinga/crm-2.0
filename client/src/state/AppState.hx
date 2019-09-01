package state;
//import view.shared.io.User;
//import history.Location;
import state.ConfigState;
import state.LocationState;
import state.UserState;
//import view.shared.io.User.UserProps;

import state.StatusBarState;

typedef AppState =
{
	config:ConfigState,
	formStates:Map<String, FormState>,
	//dataStore:DataAccessState,
	//locationHistory:LocationState,
	redirectAfterLogin:String,
	status:StatusState,
	user:UserState
};
