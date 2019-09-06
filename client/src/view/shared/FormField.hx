package view.shared;
import haxe.Constraints.Function;
import js.html.InputEvent;
import view.shared.FormInputElement;

typedef FormField =
{
	?className:String,
	?name:String,
	?label:String,
	?dataBase:String, 
	?options:Dynamic,
	?value:Dynamic,
	?dataTable:String,
	?dataField:String,
	?preset:Any,
	?displayFormat:Function,
	?type:FormInputElement,
	?primary:Bool,
	?disabled:Bool,
	?multiple:Bool,
	?required:Bool,
	?handleChange:Function,
	?placeholder:String,
	?validate:String->Bool
}