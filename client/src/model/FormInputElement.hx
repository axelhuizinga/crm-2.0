package model;

import haxe.rtti.Meta;
import react.ReactUtil.copy;

typedef FormInputElementProps = {
	?type:String
};

@:keep
@:rtti
class FormInputElement extends ORM
{
	public static var tableName:String = "form_input_elements";

	public static var _meta_fields:Dynamic<Dynamic<Array<Dynamic>>> = copy(Meta.getFields(ORM), Meta.getFields(FormInputElement));

	public function new(data:Map<String,String>) {
		super(data);		
	}	
		
	@dataType("text")
	@:isVar public var type(default,set):String;

	function set_type(type:String):String{
		if(initialized('type'))
			modified('type');
		this.type = type ;
		return type;
	}	
	
}