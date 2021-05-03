package view.shared;
import state.FormState;
import view.shared.FormField;
import state.FormState.HandlerAction;
import react.ReactType;
import haxe.Constraints.Function;

typedef MItem =
{
	?action:String,
	?actions:Array<Function>,
	?className:String,
	?classPath:String,
	?form:FormState,
	?formField:FormField,
	?section:String,
	?disabled:Bool,	
	?handler:Function,//default:action
	?id:String,
	?img:String,
	?info:String,
	?label:String,
	?separator:Bool,	
	?then:String,	
	?onlySm:Bool	
}