package view.shared;
import haxe.Constraints.Function;
import view.shared.MItem;

typedef MenuBlock =
{
	?dataClassPath:String,
	?disabled:Bool,
	?className:String,
	?hasFindForm:Bool,
	?img:String,
	?info:String,
	?isActive:Bool,
	?items:Array<MItem>,
	?label:String,	
	?onActivate:Function,
	?section:String
}