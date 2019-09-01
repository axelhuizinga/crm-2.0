package view.shared;
import react.ReactType;
import haxe.Constraints.Function;

typedef SMItem =
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