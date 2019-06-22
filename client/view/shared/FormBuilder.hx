package view.shared;

import haxe.ds.Map;
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
import react.DateTimePicker;

using Lambda;

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
	
	public function new(rc:Dynamic)
	{
		comp = rc;
		//trace(sM);
		requests = [];
		if(rc.props != null)
		{
			
		}
		//dbData = new DbData();
		//trace('>>>${props.match.params.action}<<<');
	}  

	function renderElements(fields:Map<String, FormField>, model:String):ReactFragment
	{
		var ki:Int = 0;
		//return fields.array().map(function(field:FormField){
		return [for(name => field in fields){
			switch (field.type)
			{
				case FormElement.Hidden:
					null;
				case FormElement.DatePicker:
					null;
				default:
					jsx('
					<div key=${ki++} className="g_row_2" role="rowgroup">
						<div className="g_cell" role="cell">${field.label}</div>
						<div className="g_cell_r" role="cell">
						<$Control model="${model}.${name}" disabled=${field.readonly}/>
						</div>
					</div>
					');
			}
		}].array();
		//trace(fields.array());
		return null;
	}	 

	function renderElement():ReactFragment
	{

		return null;
	}

    public function render(fState:FormState, initialState:Dynamic):ReactFragment
    {
		return jsx('
			<$LocalForm model=${fState.model} onSubmit=${comp.handleSubmit} className="tabComponentForm"  initialState=${initialState}>
				<div className="grid_box" role="table" aria-label="Destinations">
				<div className="g_caption" >${fState.title}</div>
				${renderElements(fState.fields, fState.model)}
				</div>
			</$LocalForm>		
		');
    }

	public function  hidden(cm:String):ReactFragment
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
				jsx('
			<tbody>
			<tr>
				<td>Vorname</td>
				<td><$ControlText className="test" model=${model(initialState, contact, first_name)}>
				</$ControlText></td>
			</tr>	
			</tbody>
			');
 */
