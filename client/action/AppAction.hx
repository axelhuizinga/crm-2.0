package action;

import view.shared.FormState;
import view.shared.io.User;

import model.UserState;

/**
 * @author axel@cunity.me
 */

enum AppAction 
{
	// COMPONENTS
	//AddComponent(path:String, cState:CompState);
	FormChange(cp:String, state:FormState);

	Load;
	// LOGIN TODO: MOVE TO USERACTIONS
	//LoginReq(state:UserState);
	LoginChange(state:UserState);
	LoginComplete(state:UserState);
	LoginWait;

	LoginError(state:UserState);
	LogOut(state:UserState);	
	LoginRequired(state:UserState);	
	// LOGINEND
	
	//AddContact(id:Int);
	SetLocale(locale:String);
	SetTheme(color:String);

	User(state:UserState);
	//Users(filter:UserFilter);
	//SetEntries(entries:Array<DataCell>);
}

enum StatusAction
{
	Tick(date:Date);	
}
