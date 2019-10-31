package view.shared.io;
import view.shared.io.FormApi;
import react.ReactComponent;
import react.ReactComponent.ReactFragment;
import state.FormState;
import react.router.Route;
import redux.Redux.Dispatch;
import shared.DbData;
import state.UserState;

typedef DataFormProps =
{
	>ChildrenRouteProps,
	?dataStore:state.DataAccessState,
    ?formApi:FormApi,
	?fullWidth:Bool,
	
	?limit:Int,

	?parentComponent:Dynamic,
	?setStateFromChild:FormState->Void,
	?setFormState:FormState->Void,
	?sideMenu:SMenuProps,
	?storeContactsList:DbData->Void,
	?storeFormChange:String->FormState->Void,
	?render:FormState->ReactFragment,
	user:UserState,
	model:String
}