package view.shared;
import state.FormState.HandlerAction;
import react.ReactType;
import haxe.Constraints.Function;

typedef MItem =
{
	?action:String,
	?className:String,
	?section:String,
	?disabled:Bool,	
	?handler:Function,//default:action
	?img:String,
	?info:String,
	?label:String,
	?closeAfter:Bool,	
	?onlySm:Bool	
}