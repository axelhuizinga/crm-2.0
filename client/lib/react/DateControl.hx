package react;

import js.html.Element;
import js.html.FilePropertyBag;
import js.html.Event;
import js.html.InputElement;
import js.html.KeyboardEvent;
import js.html.Document;
import react.ReactComponent.ReactFragment;
import react.ReactRef;
import js.Lib;
import react.ReactComponent.ReactComponentOfProps;
import react.ReactMacro.jsx;
import react.DateControlTypes;
import react.Flatpickr;
import shared.DateFormat;
import haxe.EnumTools.EnumValueTools;

using haxe.EnumTools;

/**
 * ...
 * @author axel@cunity.me
 */

class DateControl extends ReactComponentOfProps<DateTimeProps>
{
	static var css = js.Lib.require('react-datepicker/dist/react-datepicker.css');
	static var flat = js.Lib.require('flatpickr/dist/themes/light.css');
	static var flatpickr = js.Lib.require('flatpickr');
	static var German = js.Lib.require('flatpickr/dist/l10n/de.js');	

	var fpRef:ReactRef<InputElement>;
	var fP:FlatpickrJS;

	public function new(props) 
	{
		//trace( props.value );
		super(props);
		flatpickr.localize(German);
		//trace(props);
	}

	override public function componentDidMount():Void 
	{
		//get flatpickr instance);
		fP = Reflect.field(fpRef, 'flatpickr');
		var altInput:InputElement = fP.altInput;
		trace(Reflect.fields(fP));
		trace(Reflect.fields(altInput));
		altInput.addEventListener('keydown', function(ev:KeyboardEvent){
			trace(ev.key);
			if(ev.key=='Enter')
			{
				var dF:DateFormatted = DateFormat.parseDE(altInput.value);
				//if(dF.result.getName() != DateFormatResult.OK)
				switch (dF.result)//,DateFormatResult.OK))
				{
					case DateFormatResult.OK:
						trace(dF);
					default:
					ev.preventDefault();
					ev.stopImmediatePropagation();
					var container:Element = altInput.parentElement;
					container.classList.add('is-tooltip-danger');
					container.classList.add('tooltip');
					container.classList.add('is-tooltip-active');
					container.dataset.tooltip = Std.string(dF.result);
					trace(dF);					
				}

			}
			trace(fP.input);
			trace(fP.input.value);
			var val:String = altInput.value;
			var pd:Date = fP.parseDate(val, fP.config.altFormat);
			trace('$val === ${pd.toString()}');
			var fD:String = fP.formatDate(pd, fP.config.altFormat);
			trace('$val==$fD');
			if(val==fD)
			{
				fP.setDate(val,true,fP.config.altFormat);
			}
		});
		//trace(Reflect.fields(fpRef));

	}

	override public function render():ReactFragment
	{
		trace( props.value );
		//var val:String = props.value;
		//val = val.split('+')[0];
		return 	jsx('
		<$Flatpickr     
			options=${{
				allowInput:true,
				altFormat:props.options.dateFormat,
				dateFormat:'Y-m-d',
				altInput:true,
				altInputClass: "form-control input",
				defaultValue:props.value,
				locale:'de',
				onChange:onChange
			}}
			ref=${function(fP)this.fpRef = fP}
			value=${Date.fromString(props.value)}
			name=${props.name}
			className="h100" 
			/>
		');
	}	
	
	 /* [Description]
	 * @param sDates 
	 * @param val 
	 * @param me 
	 */

	function onChange(sDates:Array<Dynamic>,val:String,me:DateTimePicker) {
		trace(val);
		trace(props.name);
		fP.close();
	}
}