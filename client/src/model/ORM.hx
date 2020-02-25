package model;
import haxe.rtti.Meta;
import view.shared.io.DataAccess.DataView;
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
	var fields:Dynamic<Dynamic<Array<Dynamic>>>;

	public function new(data:Map<String,Dynamic>) {
		fieldsModified = new Array();
		fields = Meta.getFields(Type.getClass(this));
		propertyNames = Reflect.fields(fields);
		trace(fields);
		if(data != null)
			for(f in propertyNames)
			{
				if(data.exists(f)){
					var nv:Dynamic = data[f];
					Reflect.setProperty(this, f, switch(Reflect.field(fields, f).dataType[0]){				
						case('bigint[]'):
							nv==null?[]:nv;
						case _.indexOf('timestamp') => 0:
							nv == null? '': nv;
						case('date'):
							nv == null? '': nv;
						default:
							nv;
					});				
				}
			}		
	}

	public function load(data:Map<String,Dynamic>):ORM {
		
		for(pName in propertyNames)
		{
			//trace('$pName:${Reflect.field(this, pName)}');
			if(data.exists(pName))
				Reflect.setProperty(this, pName, data[pName]);
		}
		//trace(cls.propertyNames);
		return this;
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