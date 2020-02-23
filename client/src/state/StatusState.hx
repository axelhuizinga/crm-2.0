package state;

import state.UserState;

typedef StatusState = {
	?className:String,
    userState:UserState,
	text: String,
	date:Date,
}

