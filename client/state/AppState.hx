package state;
//import view.shared.io.User;
//import history.Location;
import state.GlobalAppState;
import state.LocationState;
//import view.shared.io.User.UserProps;

import store.StatusBarStore.StatusBarState;

typedef AppState =
{
	appWare:GlobalAppState,
	locationHistory:LocationState,
	statusBar:StatusBarState
};
