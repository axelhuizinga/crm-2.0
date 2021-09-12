package view.shared;
import model.ORM;
import haxe.Constraints.Function;
import js.html.InputEvent;
import view.shared.FormInputElement;

typedef BaseField =
{	
	?alias:String,
	?className:String,
	?classPath:String,
	?disabled:Bool,
	?name:String,
	?label:String,
	?dataBase:String, 
	?options:Map<String,String>,
	?value:String,
	?dbTableName:String,
	?dataField:String,
	?preset:Bool,
	?primary:Bool,
	?type:FormInputElement,
	?multiple:Bool,
	?required:Bool,
	?placeholder:String,
	?src:String,
	?submit:String,
}

typedef FormField = {
	>BaseField,	
	?handleChange:Function,
	?handleKeyUp:Function,
	?cellFormat:Function,
	?findFormat:Function,
	?matchFormat:Function,
	?displayFormat:String,	
	?id:Int,
	?jwt:String,
	?orm:ORM,
	?validate:String->Bool
}