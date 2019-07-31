package view.shared;

import haxe.ds.StringMap;
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
	public var dateControls:StringMap<DateControl>;
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
		trace(comp.handleChange);
		requests = [];
		dateControls = new StringMap();
		if(rc.props != null)
		{
			
		}
		//dbData = new DbData();
		//trace('>>>${props.match.params.acton}<<<');
	}  


	function renderElement():ReactFragment
	{

		return null;
	}
	
	function renderFormElements(fields:Map<String, FormField>, model:String, ?compOnChange:Function):ReactFragment
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
					var dC:DateControl = new DateControl({
						comp:comp,
						name:name,
						onChange: comp.dcChange,
						options:{
							dateFormat:field.displayFormat(),
							defaultDate:Date.now(),
							_inline:field.readonly
						}
					});
					dateControls.set('${model}.${name}',dC);
					jsx('
					<div key=${ki++} className="g_row_2" role="rowgroup">
						<div className="g_cell" role="cell">${field.label}</div>
						<div className="g_cell_r" role="cell">
							${dC.render()}
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

    public function renderForm(props:FormState, initialState:Dynamic):ReactFragment
    {
		trace('props');
		//trace(props);
		
		return jsx('
			<form name=${props.model} onSubmit=${props.handleSubmit} ref=${props.ref}  className="tabComponentForm formField">
				<div className="grid_box" role="table" aria-label="Destinations">
					<div className="g_caption" >${props.title}</div>	
					${renderFormElements(props.fields, props.model)}
					<div className="g_fill_row">
						<input type="submit" className="center" value="Speichern"/>
					</div>					
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

