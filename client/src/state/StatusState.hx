package state;

import state.UserState;

typedef StatusState = {
	?className:String,
    userState:UserState,
	path: String,
	?text: String,
	date:Date,
}

