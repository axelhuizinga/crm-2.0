package view.shared;

import react.intl.NumberFormatOptions.CurrencyDisplay;
import react.intl.NumberFormatOptions.NumberStyle;
import react.intl.comp.FormattedNumber;
import react.Fragment;
import view.data.contacts.Deals;
import view.shared.io.BaseForm;
import react.IntlNumberFormatProps;
import react.ReactUtil;
import js.html.AbortController;
import js.html.Element;
import js.html.Event;
import bulma_components.Button;
import js.html.InputElement;
import react.DateControlTypes.DateTimeProps;
//import react.NumberFormat;
import react.IntlNumberInput;
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
//import react.CurrencyInputFactory;

using Lambda;
using StringTools;

typedef BButton = bulma_components.Button;

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
	var col:Int;
	var i:Int;
	
	public function new(rc:Dynamic)
	{
		comp = rc;
		col = i = 1;
		requests = [];
		if(rc.props != null)
		{
			//trace(Reflect.fields(comp));
		}
		//dbData = new DbData();
		//trace('>>>${props.match.params.acton}<<<');
	}  


	function renderElement(el:ReactFragment, label):ReactFragment
	{
		//trace(i);
		return	jsx('
			<div key=${i++} className="g_row_2" role="rowgroup">
				<div className="g_cell" key=${i+'_l'} role="cell">${label}</div>
				<div className="g_cell_r" key=${i+'_r'}role="cell">
				${el}
				</div>
			</div>
		');	
	}

	function renderOption(si:Int,label:String,?value:Dynamic) {
		//trace('$i $value');
		return	
			value == null ? jsx('<option key=${i++}>$label</option>'):
			jsx('<option key=${i++} title=${value} value=${value}>$label</option>');
	}

	function renderSelect(options:StringMap<String>):ReactFragment
	{
		var si:Int = 1;
		return [for (value=>label in options)
		{
			renderOption(si++, label,value);
		}];
	}

	function renderRadio(name:String,options:StringMap<String>, actValue:String):ReactFragment
	{
		//trace(options.toString());
		return [for (value=>label in options)
		{			
			var check:String = (actValue==value ? 'on':'');
			//trace('$i::label:$label');
			jsx('
			<Fragment key=${i++}>
				<label key=${"label_"+i} >${label}</label>
				<input key=${"option_"+i} type="radio" name=${name} defaultChecked=${check} onChange=${onChange} value=${value}/>
			</Fragment>');
		}];
	}

	public function renderFormInputElements(fields:Map<String, FormField>, initialData:Dynamic, ?compOnChange:Function):ReactFragment
	{
		return [for(name => field in fields)
		{
			var value:Dynamic = Reflect.field(initialData,name);
			if(name=='entry_date')trace (field.type +' $name:' + value);
			trace(field.type + ':$i::$name $value');
			switch (field.type)
			{
				case FormInputElement.Box:
					trace(field);
					renderElement(jsx('<div/>'),'');
						
				case FormInputElement.Hidden:
					jsx('<input key=${i++} type="hidden" name=${name} defaultValue=${value}/>');
				case FormInputElement.Button: 
					jsx('<button type="submit" key=${i++} >
						${value}
					</button>');
				case FormInputElement.Checkbox:		
					//trace(field);//disabled=${field.disabled} required=${field.required}//false;//true;
					//trace (field.type +' $name:' + value);
					var checked:Bool = switch(value)
					{
						case "TRUE"|true|"on"|"1":
							true; 
						default:
							false;
					};
					//trace(checked);
					renderElement(
						jsx('<input name=${name}  key=${i++} type="checkbox" defaultChecked=${checked} onChange=${onChange} />'),
						field.label
					);
				case Radio:
					trace (field.type +' $name:' + value);
					jsx('<div key=${i++} className="g_row_2_radio" role="rowgroup" >
						<div className="g_cell" role="cell" key=${name+'_'+i}>${field.label}</div>
						<div className="g_cell_r optLabel" role="cell" key=${name+'_opt'}>
							${renderRadio(name,field.options, value)}
						</div>
					</div>');				
				case Select:
					trace('$i:: $name: $value');
				renderElement(
					jsx('<select name=${name} onChange=${onChange} className=${field.className} defaultValue=${value} key=${i++} 
						multiple=${field.multiple}>${renderSelect(field.options)}</select>'),
					field.label
				);
				case FormInputElement.DateTimePicker:
					var dTC:DateTimeProps = {
						comp:comp,
						name:name,
						disabled:field.disabled,
						onChange: onChange,						
						options:{
							dateFormat:field.displayFormat, 
							defaultDate: value,
							time_24hr:true,
							_inline:field.disabled
						},
						value:value
					};
					jsx('
					<div key=${i++} className="g_row_2" role="rowgroup">
						<div className="g_cell" key=${i+'_l'} role="cell">${field.label}</div>
						<div className="g_cell_r" key=${i+'_r'} role="cell">
							<$DateTimeControl ${...dTC}/>
						</div>
					</div>');								
				case FormInputElement.DatePicker:
					//trace(field.disabled);
					var dC:DateTimeProps = {
						comp:comp,
						disabled:field.disabled,
						name:name,
						onChange: onChange,
						options:{
							dateFormat:field.displayFormat,
							defaultDate:'00.00.0000',//Date.now(),
							_inline:field.disabled
						},
						value:value
					};
					jsx('
					<div key=${i++} className="g_row_2" role="rowgroup">
						<div className="g_cell" key=${i+'_l'} role="cell">${field.label}</div>
						<div className="g_cell_r" key=${i+'_r'} role="cell">
							<$DateControl ${...dC}/>
						</div>
					</div>');
				case FormInputElement.NFormat:
					jsx('<$FormattedNumber value={100.66} style=${NumberStyle.Currency} currency=${"EUR"}/>');
					//jsx('<$FormattedNumber value={100.66} style=${Currency} currencyDisplay=${Symbol}/>');
					
					//renderElement(jsx('<$FormattedNumber value={100.66} />',${field.label}));
					/*var nfP:IntlNumberFormatProps = {
						//getInputRef:React.createRef(),
						precision:2,
						locale: 'de-DE',
						//name:name,
						onChange: onChange,
						suffix: ' €',
						value:value
					};//	<$NumberFormat ${...nfP}/>
					trace(nfP);	*/
	 
					/*renderElement((field.cellFormat != null?
					//trace(new Intl.NumberFormat('de-DE', { style: 'currency', currency: 'EUR' }).format(11.11));
						jsx('<input name=${name} className=${field.className}  onChange=${onChange} type="text" value=${field.cellFormat(value)} disabled=${field.disabled}  key=${i++} required=${field.required}/>')
						:
						jsx('<input name=${name} className=${field.className} onChange=${onChange} type="text" defaultValue=${value} disabled=${field.disabled}  key=${i++} required=${field.required}/>')),
						field.label
					);		 */
					/*jsx('
					<div key=${i++} className="g_row_2" role="rowgroup">
						<div className="g_cell" role="cell">${field.label}</div>
						<div className="g_cell_r" role="cell">$IntlNumberInput ${...nfP}/>
						</div>
					</div>');			*/
				case FormInputElement.Upload:
					jsx('
					<div key=${i++} className="g_row_2" role="rowgroup">
						<div className="g_cell" role="cell">${field.label}</div>
						<div className="g_cell_r" role="cell">
							Dummy
						</div>
					</div>');
				case TextArea:
					trace(field);
					if(value==null)
						value='';
					if(field.className=='big_comment')
						jsx('<><div key=${i++} className="g_row_2 g_span_2" role="rowgroup">${field.label}</div>
					<div key=${i++} className="g_row_2 g_span_2" role="rowgroup">
					<textarea className=${field.className} name=${name} defaultValue=${value} onChange=${onChange}/>
					</div>
				</>');
					else
						jsx('<div key=${i++} className="g_row_2 g_span_2" role="rowgroup">
					<div className="g_cell" key=${i+'_l'} role="cell">${field.label}</div>
						<div className="g_cell_100_r" key=${i+'_r'} role="cell">
							<textarea className=${field.className} name=${name} defaultValue=${value} onChange=${onChange}/>
						</div>
					</div>');
				default:
					renderElement((field.cellFormat != null?
						jsx('<input name=${name} className=${field.className}  onChange=${onChange} type="text" value=${field.cellFormat(value)} disabled=${field.disabled}  key=${i++} required=${field.required}/>')
						:
						jsx('<input name=${name} className=${field.className} onChange=${onChange} type="text" defaultValue=${value} disabled=${field.disabled}  key=${i++} required=${field.required}/>')),
						field.label
					);
			}
		}];
	}	

    public function renderForm(props:FormState, initialState:Dynamic):ReactFragment
    {
		trace(props.model);
		//return null;formField<div className="g_block" ></div>${renderForms(props.modals)}
		//trace(Std.string(props.fields));
		trace(Reflect.fields(initialState).join('|'));
		//trace(props); ref=${props.ref} <div className="g_footer" ></div>	
		//trace(Std.string(initialState));
		//trace(Std.string(initialState.state));
		var sK:Int = 0;
		
		return jsx('<form name=${props.model} key=${props.model} className="tabComponentForm formField" ref=${props.formRef}>
				<div className=${props.gridCSSClass != null ? props.gridCSSClass : "grid_box col_gap"} role="table" key=${props.model+"_grid_box"} >
					<div className="g_caption" key=${props.model+'caption'}>${props.title}</div>			${renderFormInputElements(props.fields, initialState)}					
				</div>			
			</form>
		');				
	}	

	function renderButton(mItem:MItem, i:Int):ReactFragment {
		if(mItem.onlySm)
			return null;
		if(mItem.separator)
			return jsx('<hr className="menuSeparator"/>');
		trace(mItem.handler);
		return jsx('<$BButton key=${i++} onClick=${mItem.handler} 
		data-section=${mItem.section} disabled=${mItem.disabled} type="button" >${mItem.label}</$BButton>');	
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
	
	function onChange(ev:Dynamic,?value:Dynamic,?maskedValue:Dynamic) {
		
		trace(Reflect.fields(ev.target).join('|'));
		trace(ev.target.value + ':' + value);
		trace(ev.target.type + ':' + maskedValue);
		switch (ev.target.type)
		{
			case 'checkbox':
				trace('${ev.target.name}:${ev.target.value}:${ev.target.checked?true:false}');
				//trace('doChange:${Reflect.isFunction(Reflect.field(comp,'doChange'))}');
				BaseForm.doChange(comp,ev.target.name, switch(ev.target.checked)
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
				BaseForm.doChange(comp,ev.target.name, ev.target.value);
			default:
				//trace('${ev.target.name}:${ev.target.value}');
				BaseForm.doChange(comp, ev.target.name, ev.target.value);
		}				
		
	}	
}

