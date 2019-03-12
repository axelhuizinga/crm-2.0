package view.shared.io;
import react.ReactComponent.ReactFragment;
import view.shared.io.FormApi;
import view.shared.FormState;
import react.router.Route;
import model.UserState;

typedef DataFormProps =
{
	>ChildrenRouteProps,
    ?formApi:FormApi,
	?fullWidth:Bool,
	?setStateFromChild:FormState->Void,
	?sideMenu:SMenuProps,
	?render:FormState->ReactFragment,
	user:UserState,
	model:String
}