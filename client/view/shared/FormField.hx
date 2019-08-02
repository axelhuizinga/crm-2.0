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
	?displayFormat:Function,
	?type:FormInputElement,
	?primary:Bool,
	?readonly:Bool,
	?required:Bool,
	?handleChange:Function,
	?placeholder:String,
	?validate:String->Bool
}