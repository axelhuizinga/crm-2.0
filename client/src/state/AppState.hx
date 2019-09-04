package state;
//import view.shared.io.User;
//import history.Location;
import state.ConfigState;
import state.LocationState;
import state.UserState;
//import view.shared.io.User.UserProps;


typedef AppState =
{
	?app:Dynamic,
	?config:ConfigState,
	?formStates:Map<String, FormState>,
	?dataStore:DataAccessState,
	?locationState:LocationState,
	?redirectAfterLogin:String,
	?status:StatusState,
	?user:UserState
};
