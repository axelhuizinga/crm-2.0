package model;
import haxe.Constraints.Function;
import haxe.rtti.CType.ClassField;
import haxe.rtti.CType.Classdef;
import haxe.rtti.Rtti.getRtti;
import js.lib.RegExp;
import react.ReactUtil.copy;
using Lambda;

@:keep
class ORM {
	
	public var fieldsModified(default,null):Array<String>;
	public var fieldFormat:Map<String, Function>;
	public var propertyNames:Array<String>;
	//static var fieldNames:Array<String>;
	//var mandator:Int;

	public function new(props:Dynamic) {
		fieldsModified = new Array();
		for(f in propertyNames)
		{
			Reflect.setProperty(this, f, Reflect.field(props, f));
		}		
		//edited_by = props.user.id;
		//mandator = props.mandator;
	}

	public function copy(data:Map<String,Dynamic>, ?cState:Dynamic):Dynamic {
		var t:Dynamic = {};
		var cls:Dynamic = Type.getClass(this);
		
		//trace(data);
		//trace(propertyNames);
		for(pName in propertyNames)
		{
			//trace('$pName:${Reflect.field(this, pName)}');
			Reflect.setField(t, pName, Reflect.field(this, pName));
			if(cState!=null)
			{
				Reflect.setField(cState, pName, Reflect.field(this, pName));
			}
		}
		//trace(cls.propertyNames);
		return t;
	}

	public function store():Dynamic {
		var data:Dynamic = {};
		for(f in fieldsModified)
		{
			//TODO: ADD FORMAT SWITCH BEFORE ADDING DATA TO STORAGE
			Reflect.setField(data, f, Reflect.field(this, f));
		}
		return data;
	}

	public function initFields() {
		//var pNames:Array<String> = propertyNames.split(',');
		var me:Dynamic = Type.getClass(this);
		var rtti:Classdef = getRtti(me);
		var rttiFields:Array<haxe.rtti.CType.ClassField> = rtti.fields;
		//trace(rttiFields[0]);
		trace(propertyNames);
		var dTypes:Array<String> = [];
		for(fld in rttiFields)
		//for(fi in 0...rttiFields.length)
		{
			//var fld:ClassField = rttiFields[fi];
			//trace(fld.name);
			if(propertyNames.has(fld.name))
			{
				//trace('${fld.name}:${fld.type} ${fld.meta[0].params}');
				if(!dTypes.has(fld.meta[0].params[0]))
				{
					dTypes.push(fld.meta[0].params[0]);
				}
				//trace(fld.type);//HAXE TYPE
				//trace(fld.meta[0].params);//DB FIELD DATATYPE
			}
		}
		trace(dTypes);
	}

	public function modified(?attName:String):Bool {
		if(attName==null)			
			return fieldsModified.length>0;
			//return fieldsModified.filter(function(p:String)return fieldsModified.has(p)).length>0;			
		if(!fieldsModified.has(attName))
			fieldsModified.push(attName);
		return true;
	}

	public function reset(?attName:String):Int {
		var r:Int = fieldsModified.length;
		if(fieldsModified.length == 0)
			return 0;
		if(attName!=null)
		{
			return (fieldsModified.remove(attName)?1:0);
		}
		fieldsModified = new Array();
		return r;
	}
}