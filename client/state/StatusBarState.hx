package state;

import state.UserState;

typedef StatusBarState =
{
	?user:UserState,
	status: String,
	date:Date,
	?hasError:Bool
}
