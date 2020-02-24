package state;
//import view.shared.io.User;
//import history.Location;
import db.DbUser;
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
	?locationStore:LocationState,
	//?redirectAfterLogin:String,
	?status:StatusState,
	?userState:UserState
};
