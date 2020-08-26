package view.shared;

//import js.lib.Reflect;
import react.ReactUtil;
import js.html.AbortController;
import js.html.Element;
import js.html.Event;
import bulma_components.Button;
import js.html.InputElement;
import react.DateControlTypes.DateTimeProps;
import shared.Utils;
import haxe.ds.StringMap;

import react.React;
import react.ReactType;
import haxe.ds.StringMap;
import haxe.Constraints.Function;
//import macrotools.Macro.model;
import shared.DateFormat;
import shared.DBMetaData;
import shared.DbData;
import js.html.XMLHttpRequest;
import haxe.http.HttpJs;
import react.ReactComponent.ReactFragment;
import react.ReactMacro.jsx;
import view.shared.FormInputElement;
import state.FormState;
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
	public var _menuItems:Array<MItem>;
	public var fState:FormState;
	public var _fstate:FormState;
	public var initialState:Dynamic;
	public var section:String;
	var comp:Dynamic;
	var sM:MenuProps;
	
	public function new(rc:Dynamic)
	{
		comp = rc;
		trace(comp.handleChange);
		requests = [];
		if(rc.props != null)
		{
			
		}
		//dbData = new DbData();
		//trace('>>>${props.match.params.acton}<<<');
	}  


	function renderElement(el:ReactFragment, ki, label):ReactFragment
	{
		return	jsx('
			<div key=${ki} className="g_row_2" role="rowgroup">
				<div className="g_cell" role="cell">${label}</div>
				<div className="g_cell_r" role="cell">
				${el}
				</div>
			</div>
		');	
	}

	function renderOption(si:Int,label:String,?value:Dynamic) {
		return	
			value == null ? jsx('<option>$label</option>'):
			jsx('<option key=${si} value=${value}>$label</option>');
	}

	function renderSelect(name:String,options:StringMap<String>):ReactFragment
	{
		var si:Int = 1;
		return [for (value=>label in options)
		{
			renderOption(si++, label,value);
		}].array();
	}
	
	function renderFormInputElements(fields:Map<String, FormField>, initialData:Dynamic, ?compOnChange:Function):ReactFragment
	{
		var ki:Int = 0;
		//trace(Utils.genKey(1));
		return [for(name => field in fields)
		{
			var value:Dynamic = Reflect.field(initialData,name);
			if(name=='id')trace (field.type +' $name:' + value);
			if(name=='last_name')trace (field.type +' $name:' + value);
			switch (field.type)
			{
				case FormInputElement.Hidden:
					jsx('<input key=${ki++} type="hidden" name=${name} defaultValue=${value}/>');
				case FormInputElement.button: 
					jsx('<button type="submit">
						${value}
					</button>');
				case FormInputElement.Checkbox:		
					//trace(field);//disabled=${field.disabled} required=${field.required}//false;//true;
					trace (field.type +' $name:' + value);
					var checked:Bool = switch(value)
					{
						case "TRUE"|true|"on"|"1":
							true; 
						default:
							false;
					};
					//trace(checked);
					renderElement(
						jsx('<input name=${name}  key=${ki++} type="checkbox" defaultChecked=${checked} onChange=${onChange} />')
						/*(checked?
							jsx('<input name=${name}  key=${ki++} type="checkbox" checked="checked" onChange=${onChange} />') :
							jsx('<input name=${name}  key=${ki++} type="checkbox"  onChange=${onChange} />'	)
						)*/,
						ki++, field.label
					);
				case Select:
				renderElement(
					jsx('<select name=${name} onChange=${onChange}  defaultValue=${value} key=${ki++} 
						multiple=${field.multiple}>${renderSelect(name,field.options)}</select>'),
					ki++, field.label
				);
				case FormInputElement.DateTimePicker:
					var dTC:DateTimeProps = {
						comp:comp,
						name:name,
						disabled:field.disabled,
						onChange: comp.handleChange,						
						options:{
							dateFormat:field.displayFormat(), 
							defaultDate: value,
							time_24hr:true,
							_inline:field.disabled
						},
						value:value
					};
					jsx('
					<div key=${ki++} className="g_row_2" role="rowgroup">
						<div className="g_cell" role="cell">${field.label}</div>
						<div className="g_cell_r" role="cell">
							<$DateTimeControl ${...dTC}/>
						</div>
					</div>');								
				case FormInputElement.DatePicker:
					//trace(field.disabled);
					var dC:DateTimeProps = {
						comp:comp,
						//disabled:field.disabled,
						name:name,
						//onChange: comp.handleChange,
						options:{
							dateFormat:field.displayFormat(),
							defaultDate:Date.now(),
							_inline:field.disabled
						},
						value:value
					};
					jsx('
					<div key=${ki++} className="g_row_2" role="rowgroup">
						<div className="g_cell" role="cell">${field.label}</div>
						<div className="g_cell_r" role="cell">
							<$DateControl ${...dC}/>
						</div>
					</div>');
				default:
					renderElement(
						jsx('<input name=${name} onChange=${onChange} type="text"  defaultValue=${value} disabled=${field.disabled} required=${field.required}/>'),
						ki++, field.label
					);
			}
		}].array();
		//trace(fields.array());
		return null;
	}	

    public function renderForm(props:FormState, initialState:Dynamic):ReactFragment
    {
		trace('props');
		//trace(props);
		var sK:Int = 0;
		
		return jsx('
			<form name=${props.model}  ref=${props.ref} className="tabComponentForm formField">
				<div className="grid_box" role="table" aria-label="Destinations">
					<div className="g_caption" >${props.title}</div>	
					${renderFormInputElements(props.fields, initialState)}
					<div className="g_footer" >
					${for (mI in props.mHandlers) renderButton(mI,++sK)}
					</div>					
				</div>									
			</form>
		');
    }	// children=${renderItems(props.mHandlers)}

	function renderButton(mItem:MItem, i:Int):ReactFragment {
		if(mItem.onlySm)
			return null;
		var mHandler:Function = comp.state.formApi.itemHandler;//Reflect.field(comp,mItem.action);
		return jsx('<$Button key=${i++} onClick=${itemHandler} data-action=${mItem.action}
		data-section=${mItem.section} disabled=${mItem.disabled} type="button" >${mItem.label}</$Button>');	
	}

	public function itemHandler(e:Event)
		{
			//trace(e);
			e.preventDefault();
			var action:String = cast(e.target, Element).getAttribute('data-action');
			//trace(Reflect.field(_me,'callMethod'));
			trace(action);
			//callMethod(action, e);
			//trace(this.comp.state.formApi);
			var mP:Function = Reflect.field(this.comp.state.formApi,'callMethod');
			Reflect.callMethod(this.comp.state.formApi,mP,[action, e]);
		}

	public function  hidden(cm:String):ReactFragment
	{
		return jsx('<input type="hidden" name=${cm} />');
	}
	
	function onChange(ev:Dynamic) {
		trace(ev.target.type);
		switch (ev.target.type)
		{
			case 'checkbox':
				trace('${ev.target.name}:${ev.target.value}:${ev.target.checked?true:false}');
				//trace('doChange:${Reflect.isFunction(Reflect.field(comp,'doChange'))}');
				comp.baseForm.doChange(ev.target.name, switch(ev.target.checked)
				{
					case "TRUE"|true|"on"|"1":
						1;
					default:
						0;
				});
				//ev.target.checked = !ev.target.checked;
				trace('${ev.target.name}:${ev.target.value}:${ev.target.checked?true:false}');
				//comp.setState({actualState:ReactUtil.copy({use_email:(ev.target.checked?1:0)})});
				//comp.forceUpdate();
			case 'select-multiple'|'select-one':
				//trace (ev.target.selectedOptions.length);
				comp.baseForm.doChange(ev.target.name, ev.target.value);
			default:
				//trace('${ev.target.name}:${ev.target.value}');
				comp.baseForm.doChange(ev.target.name, ev.target.value);
		}				
		
	}	
}

