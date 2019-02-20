package view.shared.io;
import react.ReactComponent.ReactFragment;
import view.shared.io.FormContainer;
import view.shared.FormState;
import react.router.Route;
import model.UserState;

typedef DataFormProps =
{
	//>FormProps,
	>ChildrenRouteProps,
    ?formContainer:FormContainer,
	?fullWidth:Bool,
	?setStateFromChild:FormState->Void,
	?sideMenu:SMenuProps,
	?registerFormContainer:FormContainer->Void,
	?render:FormState->ReactFragment,
	user:UserState,
	model:String
}