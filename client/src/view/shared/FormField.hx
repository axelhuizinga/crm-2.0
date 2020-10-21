package view.shared;
import haxe.Constraints.Function;
import js.html.InputEvent;
import view.shared.FormInputElement;

typedef FormField =
{
	?className:String,
	?classPath:String,
	?name:String,
	?label:String,
	?dataBase:String, 
	?options:Dynamic,
	?value:Dynamic,
	?dataTable:String,
	?dataField:String,
	?preset:Any,
	?displayFormat:String,
	?type:FormInputElement,
	?primary:Bool,
	?disabled:Bool,
	?multiple:Bool,
	?required:Bool,
	?handleChange:Function,
	?placeholder:String,
	?submit:String,
	?validate:String->Bool
}