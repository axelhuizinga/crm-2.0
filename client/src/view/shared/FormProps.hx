package view.shared;
import js.html.InputEvent;
import redux.Redux.Dispatch;
import react.ReactType;
import react.ReactComponent;
import view.shared.FormField;
import view.shared.SMenuProps;

 typedef FormProps =
 {
	>RouteTabProps,
	?elements:Map<String,FormField>,
	?isConnected:Bool,
	?handleChange:Bool,
	?handleSubmit:Bool,
	?handleChangeByParent:InputEvent->Void,
	?handleSubmitByParent:InputEvent->Void,
	?name:String,
	?sideMenu:SMenuProps,
	?submit:FormState->Dispatch
 }
