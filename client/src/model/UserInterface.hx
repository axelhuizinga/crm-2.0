package model;

typedef UserInterfaceProps = {
	?id:Int,
	?key:String,
	?content:String,
	?classPath:String,
	?component:String,
	?edited_by:String,
	?updated_at:String,
	?locale:String,
	?mandator:Int
};

@:rtti
class UserInterface extends ORM
{

	public function new(data:Map<String,String>) {
		super(data);
		propertyNames = 'id,key,content,classPath,component,edited_by,updated_at,locale,mandator'.split(',');
	}	
		
	@dataType("bigint")
	@:isVar public var id(default,set):Int;

	function set_id(id:Int):Int{
		if(initialized('id'))
			modified('id');
		this.id = id ;
		return id;
	}	
		
	@dataType("character varying(64)")
	@:isVar public var key(default,set):String;

	function set_key(key:String):String{
		if(initialized('key'))
			modified('key');
		this.key = key ;
		return key;
	}	
		
	@dataType("character varying(64)")
	@:isVar public var content(default,set):String;

	function set_content(content:String):String{
		if(initialized('content'))
			modified('content');
		this.content = content ;
		return content;
	}	
		
	@dataType("character varying(512)")
	@:isVar public var classPath(default,set):String;

	function set_classPath(classPath:String):String{
		if(initialized('classPath'))
			modified('classPath');
		this.classPath = classPath ;
		return classPath;
	}	
		
	@dataType("character varying(64)")
	@:isVar public var component(default,set):String;

	function set_component(component:String):String{
		if(initialized('component'))
			modified('component');
		this.component = component ;
		return component;
	}	
		
	@dataType("integer")
	@:isVar public var edited_by(default,set):String;

	function set_edited_by(edited_by:String):String{
		if(initialized('edited_by'))
			modified('edited_by');
		this.edited_by = edited_by ;
		return edited_by;
	}	
		
	@dataType("timestamp without time zone")
	@:isVar public var updated_at(default,set):String;

	function set_updated_at(updated_at:String):String{
		if(initialized('updated_at'))
			modified('updated_at');
		this.updated_at = updated_at ;
		return updated_at;
	}	
		
	@dataType("character varying(8)")
	@:isVar public var locale(default,set):String;

	function set_locale(locale:String):String{
		if(initialized('locale'))
			modified('locale');
		this.locale = locale ;
		return locale;
	}	
		
	@dataType("bigint")
	@:isVar public var mandator(default,set):Int;

	function set_mandator(mandator:Int):Int{
		if(initialized('mandator'))
			modified('mandator');
		this.mandator = mandator ;
		return mandator;
	}	
	
}