package action;
import action.StatusAction;
import state.AppState;
import haxe.ds.IntMap;
import react.router.RouterMatch;
import view.shared.FormState;
import view.shared.io.User;

import state.UserState;

/**
 * @author axel@cunity.me
 */

enum AppAction 
{

	ApplySubState(state:AppState);

	FormChange(cfp:String, state:FormState);

	DataLoaded(component:String,sData:IntMap<Map<String,Dynamic>>);

	GlobalState(key:String,value:Dynamic);
	//Load;
	// LOGIN TODO: MOVE TO USERACTIONS
	//LoginReq(state:UserState);
	LoginChange(state:UserState);
	LoginComplete(state:UserState);
	AppWait;

	LoginError(state:UserState);
	LogOut(state:UserState);	
	LoginRequired(state:UserState);	
	// LOGINEND
	
	//AddContact(id:Int);
	SetLocale(locale:String);
	SetTheme(color:String);
	User(state:UserState);
	//Users(filter:UserFilter);
	StatusBarStatus(status:String);
	StatusBarAction(action:StatusAction);
	//SetEntries(entries:Array<DataCell>);
}

