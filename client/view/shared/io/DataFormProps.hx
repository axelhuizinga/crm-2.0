package view.shared.io;
import react.ReactComponent.ReactFragment;
import view.shared.io.FormFunctions;
import view.shared.FormState;
import react.router.Route;
import model.UserState;

typedef DataFormProps =
{
	>ChildrenRouteProps,
    ?formFunctions:FormFunctions,
	?fullWidth:Bool,
	?setStateFromChild:FormState->Void,
	?sideMenu:SMenuProps,
	?render:FormState->ReactFragment,
	user:UserState,
	model:String
}