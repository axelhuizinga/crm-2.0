package view.shared;

import js.html.InputElement;
import js.html.InputEvent;
import haxe.Constraints.Function;
import js.html.ButtonElement;
import js.html.Event;
import shared.DBMetaData;
import shared.DbData;
import js.html.XMLHttpRequest;
import haxe.http.HttpJs;
import react.ReactComponent.ReactFragment;
import react.ReactMacro.jsx;
import view.shared.io.DataAccess;

class FormBuilder {
    public var requests:Array<OneOf<HttpJs, XMLHttpRequest>>;
	public var dataAccess:DataAccess;
	public var dbData:DbData;
	public var dbMetaData:DBMetaData;
	public var formColElements:Map<String,Array<FormField>>;
	//public var dataDisplay:Map<String,DataState>;
	public var _menuItems:Array<SMItem>;
	public var fState:FormState;
	public var _fstate:FormState;
	//public var modalFormTableHeader:ReactRef<DivElement>;
	//public var modalFormTableBody:ReactRef<DivElement>;
	//public var autoFocus:ReactRef<InputElement>;
	public var initialState:Dynamic;
	public var section:String;
	var comp:Dynamic;
	var sM:SMenuProps;
	
	public function new(rc:Dynamic,?sM:SMenuProps)
	{
		comp = rc;

		//trace(sM);
		requests = [];
		if(rc.props != null)
		{
			trace(rc.props.match);
			this.sM = sM==null?rc.props.sideMenu:sM;
			//trace(rc.props.history);			
		}
		dbData = new DbData();
		//trace('>>>${props.match.params.action}<<<');
		trace(Reflect.fields(sM));

        trace(dbData);
	}   

    public function itemHandler(e:Event)
	{
		var action:String = cast(e.target, ButtonElement).getAttribute('data-action');
		trace(comp.props.history.location.pathname);
		//trace(comp.props.history);
		trace(comp.props.match.params.action);
		trace(comp.props.match.params.section);
		trace(comp.props.match);
		trace('${comp.props.match.params.section}/${action}');
		var path:String = Std.string(comp.props.match.path).split(':')[0];
		trace(path);
		comp.props.history.push('${path}${comp.props.match.params.section}/${action}');
		callMethod(action);
	}

	public function callMethod(method:String):Bool
	{
		var fun:Function = Reflect.field(comp,method);
		if(Reflect.isFunction(fun))
		{
			Reflect.callMethod(comp,fun,null);
			return true;
		}
		return false;
	}

	public function handleChange(e:InputEvent)
	{
		var t:InputElement= cast e.target;
		trace('${t.name} ${t.value}');
	} 

    public function render(content:ReactFragment):ReactFragment
    {
		if(sM.section != null)//TODO: MONITOR PERFORMANCE + INTEGRITY
		{
			trace(sM.section +':'+ comp.props.match.params.section);
			if(sM.section != comp.props.match.params.section)
			 sM.section = comp.props.match.params.section;
		}
		return jsx('
			<div className="columns">
				${content}
				<$SMenu className="menu" {...sM} ${...comp.props} itemHandler=${itemHandler} />
			</div>			
		');
    }
}