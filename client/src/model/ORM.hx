package model;
import js.lib.RegExp;
import react.ReactUtil.copy;
using Lambda;

class ORM {
	
	var fieldsModified:Array<String>;
	//var edited_by:Int;
	static var fieldNames:Array<String>;
	//var mandator:Int;

	public function new(props:Dynamic) {
		fieldsModified = new Array();
		//edited_by = props.user.id;
		//mandator = props.mandator;
	}

	public function copy(data:Map<String,Dynamic>):Dynamic {
		var t:Dynamic = {};
		var cls:Dynamic = Type.getClass(this);
		var varNames:Array<String> = cls.varNames.split(',');
		
		trace(data);
		trace(varNames);
		for(varName in varNames)
		{
			trace('$varName:${Reflect.field(this, varName)}');
			Reflect.setField(t, varName, Reflect.field(this, varName));
		}
		trace(cls.varNames);
		return t;
	}

	public function display() {
		
	}

	public function modified(?attName:String):Bool {
		if(attName==null)			
			return fieldsModified.length>0;
			//return fieldsModified.filter(function(p:String)return fieldsModified.has(p)).length>0;
		if(!fieldsModified.has(attName))
			fieldsModified.push(attName);
		return true;
	}
}