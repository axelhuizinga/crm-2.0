package view.shared;
import haxe.Constraints.Function;
import view.shared.SMItem;

typedef SMenuBlock =
{
	?dataClassPath:String,
	?disabled:Bool,
	//?viewClassPath:String,
	?className:String,
	//?handlerInstance:DataAccessForm,
	?onActivate:Function,
	?img:String,
	?info:String,
	?isActive:Bool,
	?items:Array<SMItem>,
	?label:String,	
	?section:String
}