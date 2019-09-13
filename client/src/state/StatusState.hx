package state;

import state.UserState;

typedef StatusState = {
	?className:String,
    user:UserState,
	text: String,
	date:Date,
}

