package view.shared;
import state.FormState.HandlerAction;
import react.ReactType;
import haxe.Constraints.Function;

typedef MItem =
{
	?action:String,
	//?className:String,
	?component:String,
	?section:String,
	?disabled:Bool,	
	?handler:Function,
	?img:String,
	?info:String,
	?label:String,	
}