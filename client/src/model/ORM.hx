package model;
import js.lib.RegExp;
using Lambda;

class ORM {
	
	public var fieldsModified:Array<String>;
	var edited_by:Int;
	static var fieldNames:Array<String>;
	var mandator:Int;

	public function new(props:Dynamic) {
		fieldsModified = new Array();
		edited_by = props.user.id;
		mandator = props.mandator;
	}

	public function modified(?attName:String):Bool {
		if(attName==null)
			return fieldsModified.filter(function(p:String)return fieldsModified.has(p)).length>0;
		if(!fieldsModified.has(attName))
			fieldsModified.push(attName);
		return true;
	}
}