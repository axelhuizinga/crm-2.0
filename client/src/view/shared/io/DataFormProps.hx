package view.shared.io;
import view.shared.io.FormApi;
import react.ReactComponent;
import react.ReactComponent.ReactFragment;
import state.FormState;
import react.router.Route;
import redux.Redux.Dispatch;
import state.UserState;

typedef DataFormProps =
{
	>ChildrenRouteProps,
	?dataStore:state.DataAccessState,
    ?formApi:FormApi,
	?fullWidth:Bool,
	?parentComponent:Dynamic,
	?setStateFromChild:FormState->Void,
	?setFormState:FormState->Void,
	?sideMenu:SMenuProps,
	?storeFormChange:String->FormState->Void,
	?render:FormState->ReactFragment,
	user:UserState,
	model:String
}