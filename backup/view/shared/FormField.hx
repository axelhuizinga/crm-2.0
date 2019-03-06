package view.shared;
import haxe.Constraints.Function;
import js.html.InputEvent;
import view.shared.FormElement;

typedef FormField =
{
	?className:String,
	?primaryId:String,
	?name:String,
	?label:String,
	?value:Dynamic,
	?dataBase:String, 
	?dataTable:String,
	?dataField:String,
	?displayFormat:Function,
	?type:FormElement,
	?primary:Bool,
	?readonly:Bool,
	?required:Bool,
	?handleChange:InputEvent->Void,
	?placeholder:String,
	?validate:String->Bool
}