package view.shared;

import js.html.InputElement;
import js.html.InputEvent;
import haxe.Constraints.Function;
import js.html.ButtonElement;
import js.html.Event;
import macrotools.Macro.model;
import shared.DBMetaData;
import shared.DbData;
import js.html.XMLHttpRequest;
import haxe.http.HttpJs;
import react.ReactComponent.ReactFragment;
import react.ReactMacro.jsx;
import view.shared.io.DataAccess;
import react.redux.form.LocalForm;
import react.redux.form.Control;
import react.redux.form.Control.*;
import react.redux.form.Errors;
import react.redux.form.Field;
import react.redux.form.Fieldset;

class FormBuilder {
    public var requests:Array<OneOf<HttpJs, XMLHttpRequest>>;
	public var dataAccess:DataAccess;
	public var dbData:DbData;
	public var dbMetaData:DBMetaData;
	public var formColElements:Map<String,Array<FormField>>;
	public var _menuItems:Array<SMItem>;
	public var fState:FormState;
	public var _fstate:FormState;
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

    public function render():ReactFragment
    {
		if(sM.section != null)//TODO: MONITOR PERFORMANCE + INTEGRITY
		{
			trace(sM.section +':'+ comp.props.match.params.section);
			if(sM.section != comp.props.match.params.section)
			 sM.section = comp.props.match.params.section;
		}
		return jsx('
			<LocalForm model="user" onSubmit=${comp.handleSubmit}>
				<label>Your name?</label>
				<$ControlText model="model" />
				<button>Submit!</button>
			</LocalForm>		
		');
    }

	public function  hidden(cm:String) 
	{
		return jsx('<$Control type="hidden" model=${cm} />');
	}
}
/**
 * 
 * <LocalForm model="user" onSubmit={(val) => this.handleSubmit(val)}>
        <label>Your name?</label>
        <Control.text model="name" />
        <button>Submit!</button>
    </LocalForm>
 */
