package view.shared;

import react.ReactType;
import haxe.ds.Map;
import haxe.Constraints.Function;
import macrotools.Macro.model;
import shared.DBMetaData;
import shared.DbData;
import js.html.XMLHttpRequest;
import haxe.http.HttpJs;
import react.ReactComponent.ReactFragment;
import react.ReactMacro.jsx;
import view.shared.io.DataAccess;

import react.DateControl;
import react.DateTimeControl;

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
		//trace('>>>${props.match.params.acton}<<<');
	}  

	/*function renderElements(fields:Map<String, FormField>, model:String):ReactFragment
	{
		var ki:Int = 0;
		//return fields.array().map(function(field:FormField){
		return [for(name => field in fields){
			switch (field.type)
			{
				case FormElement.Hidden:
					null;
				case FormElement.Button:
					jsx('<button type="submit">
						${field.value.value}
					</button>');
				case FormElement.DateTimePicker:
				    jsx('
					<div key=${ki++} className="g_row_2" role="rowgroup">
						<div className="g_cell" role="cell">${field.label}</div>
						<div className="g_cell_r" role="cell">
							<$Control controlProps=${{
								options:{
									dateFormat:field.displayFormat(), 
									onChange:comp.handleChange, time_24hr:true
								}
							}}
							disabled=${field.readonly} 
								model="${model}.${name}" 
								mapProps=${{name:model+'.'+ name, _inline:field.readonly}}
								component=${DateTimeControl} />
						</div>
					</div>');
				case FormElement.DatePicker:
					jsx('
					<div key=${ki++} className="g_row_2" role="rowgroup">
						<div className="g_cell" role="cell">${field.label}</div>
						<div className="g_cell_r" role="cell">
							<$Control controlProps=${{
								//cComp:comp,
								onChange:comp.handleChange}} 
								model="${model}.${name}"
								mapProps=${{
									options:{
										dateFormat:field.displayFormat(),
										defaultDate:Date.now(),
										_inline:field.readonly
									},
									name:name									
								}}
								component=${DateControl} />
						</div>
					</div>');
				default:
					jsx('
					<div key=${ki++} className="g_row_2" role="rowgroup">
						<div className="g_cell" role="cell">${field.label}</div>
						<div className="g_cell_r" role="cell">
						<$Control model="${model}.${name}" disabled=${field.readonly} mapProps=${{
							onUpdate:comp.handleChange
							}}/>
						</div>
					</div>
					');
			}
		}].array();
		//trace(fields.array());
		return null;
	}	 */

	function renderElement():ReactFragment
	{

		return null;
	}

   /* public function renderLocal(fState:FormState, initialState:Dynamic):ReactFragment
    {
		return jsx('
			<$LocalForm model=${fState.model} onSubmit=${comp.handleSubmit} className="tabComponentForm formField" 
				 initialState=${initialState}>
				<div className="grid_box" role="table" aria-label="Destinations">
				<div className="g_caption" >${fState.title}</div>
				${renderElements(fState.fields, fState.model)}
				<div><button type="submit">
						Speichern
					</button></div>
				</div>
			</$LocalForm>		
		');
    }

    public function render(fState:FormState, initialState:Dynamic):ReactFragment
    {
		return jsx('
			<$Form model=${fState.model} onSubmit=${comp.handleSubmit} className="tabComponentForm formField">
				<div className="grid_box" role="table" aria-label="Destinations">
				<div className="g_caption" >${fState.title}</div>
				${renderElements(fState.fields, fState.model)}
				</div>
			</$Form>		
		');
    }*/
	
	function renderFormElements(fields:Map<String, FormField>, model:String):ReactFragment
	{
		var ki:Int = 0;
		//return fields.array().map(function(field:FormField){
		return [for(name => field in fields){
			switch (field.type)
			{
				case FormElement.Hidden:
					null;
				case FormElement.Button:
					jsx('<button type="submit">
						${field.value.value}
					</button>');
				case FormElement.DateTimePicker:
				    jsx('
					<div key=${ki++} className="g_row_2" role="rowgroup">
						<div className="g_cell" role="cell">${field.label}</div>
						<div className="g_cell_r" role="cell">
							<$DateTimeControl options=${{
									dateFormat:field.displayFormat(), 
									onChange:comp.handleChange, time_24hr:true,
									_inline:field.readonly
								}}
								disabled=${field.readonly} 
								name="${model}.${name}" 								
							 />
						</div>
					</div>');
				case FormElement.DatePicker:
					jsx('
					<div key=${ki++} className="g_row_2" role="rowgroup">
						<div className="g_cell" role="cell">${field.label}</div>
						<div className="g_cell_r" role="cell">
							<$DateControl 
								//cComp:comp,
								onChange=${comp.handleChange}
								name="${model}.${name}"
								options=${{
										dateFormat:field.displayFormat(),
										defaultDate:Date.now(),
										_inline:field.readonly
									}}
							 />
						</div>
					</div>');
				default:
					jsx('
					<div key=${ki++} className="g_row_2" role="rowgroup">
						<div className="g_cell" role="cell">${field.label}</div>
						<div className="g_cell_r" role="cell">
						<input name=${name}  type="text" disabled=${field.readonly} required=${field.required}/>
						</div>
					</div>
					');
			}
		}].array();
		//trace(fields.array());
		return null;
	}	

    public function renderForm(fState:FormState, initialState:Dynamic):ReactFragment
    {
		return jsx('
			<form name=${fState.model} onSubmit=${fState.handleSubmit}  className="tabComponentForm formField">
				<div className="grid_box" role="table" aria-label="Destinations">
					<div className="g_caption" >${fState.title}</div>	
					${renderFormElements(fState.fields, fState.model)}
					<div><button type="submit">
						Speichern
					</button></div>
				</div>	
			</form>
		');
		
    }	

	public function  hidden(cm:String):ReactFragment
	{
		//return null;
		return jsx('<input type="hidden" name=${cm} />');
	}
}

