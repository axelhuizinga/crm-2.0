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
	//dataStore:DataAccessState,
	//locationHistory:LocationState,
	redirectAfterLogin:String,
	statusBar:StatusBarState,
	user:UserState
};
