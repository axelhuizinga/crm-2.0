package action;
import state.UserState;

enum UserAction
{
	LoginChange(state:UserState);
	LoginComplete(state:UserState);
	LoginError(state:UserState);
	LogOut(state:UserState);	
	LoginRequired(state:UserState);		
}