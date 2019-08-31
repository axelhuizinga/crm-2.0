package action;
import action.UserAction;
import action.StatusAction;
import state.AppState;
import haxe.ds.IntMap;
import react.router.RouterMatch;
//import view.shared.FormState;
//import view.shared.io.User;

import state.UserState;

/**
 * @author axel@cunity.me
 */

enum AppAction 
{
	ApplySubState(state:AppState);
	AppWait;
	GlobalState(key:String,value:Dynamic);
	StatusBarStatus(status:String);
	StatusBar(action:StatusAction);
	User(action:UserAction);
}

