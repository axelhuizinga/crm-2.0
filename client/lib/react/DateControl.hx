package react;

import js.html.InputEvent;
import haxe.Timer;
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
//import react.Flatpickr;
import shared.DateFormat;
import view.shared.io.Tooltip;
import haxe.EnumTools.EnumValueTools;

using haxe.EnumTools;
using shared.DateFormat;

/**
 * ...
 * @author axel@cunity.me
 */

class DateControl
{
	//static var css = js.Lib.require('react-datepicker/dist/react-datepicker.css');
	//static var flat = js.Lib.require('flatpickr/dist/themes/light.css');

		

	var fpRef:ReactRef<InputElement>;
	//var fP:FlatpickrJS;
	var tip:Tooltip;
	public var props:DateTimeProps;

	public function new(props:DateTimeProps) 
	{
		//trace( props.value );
		this.props = props;
		
		trace(Reflect.fields(props));
		fpRef = React.createRef();
	}

	public function createFlatPicker():Void 
	{
		var fP = App.flatpickr;
		trace(Type.typeof(fP));
		trace(Reflect.isFunction(fP));
		var val = (props.value == null ?'0000.00.00':props.value);
		trace(untyped fP(fpRef.current,{
				allowInput:true,
				altFormat:props.options.dateFormat,
				dateFormat:'Y-m-d',
				altInput:true,
				altInputClass: "form-control input",
				defaultValue:val,
				locale:'de',
				//onChange:onChange,
				onClose:onClose
}));
		//get flatpickr instance);
	/*var fP:Dynamic = App.flatpickr(fpRef.current, {});
		trace('flatpickr Instance: ${fP}');
		if(fP==null)
			return;		*/

		var fP:Dynamic = Reflect.field(fpRef, 'flatpickr');
		trace('flatpickr Instance: ${fP}');
		if(fP==null)
			return;
		var altInput:InputElement = fP.altInput;
		trace(Reflect.fields(fP));
		trace(Reflect.fields(altInput));

		altInput.addEventListener('keyup', function(ev:KeyboardEvent){
			//trace(ev.key);
			fP.close();
			if(ev.key=='Enter')
			{
				var dF:DateFormatted = altInput.value.parseDE();
				//if(dF.result.getName() != DateFormatResult.OK)
				switch (dF.result)//,DateFormatResult.OK))
				{
					case DateFormatResult.OK:
						if(tip != null)
							tip.clear();
					default:
					ev.preventDefault();
					ev.stopImmediatePropagation();
					tip = new Tooltip(altInput.parentElement, {data: Std.string(dF.result),classes:['danger','active']});			
				}

			}
			//trace(fP.input);
			//trace(fP.input.value);
			var val:String = altInput.value;
			var pd:Date = fP.parseDate(val, fP.config.altFormat);
			//trace('$val === ${pd.toString()}');
			var fD:String = fP.formatDate(pd, fP.config.altFormat);
			trace('$val==$fD');
			if(val==fD)
			{
				fP.setDate(val,true,fP.config.altFormat);
			}
		});

		altInput.addEventListener('blur', function(ev:KeyboardEvent){
			//trace(ev.key);
//			fP.close();	
			var dF:DateFormatted = altInput.value.parseDE();
			//if(dF.result.getName() != DateFormatResult.OK)
			switch (dF.result)//,DateFormatResult.OK))
			{
				case DateFormatResult.OK:
					if(tip != null)
						tip.clear();
				default:
				ev.preventDefault();
				ev.stopImmediatePropagation();
				tip = new Tooltip(altInput.parentElement, {data: Std.string(dF.result),classes:['danger','active']});			
			}

			//trace(fP.input);
			//trace(fP.input.value);
			var val:String = altInput.value;
			var pd:Date = fP.parseDate(val, fP.config.altFormat);
			//trace('$val === ${pd.toString()}');
			var fD:String = fP.formatDate(pd, fP.config.altFormat);
			trace('$val==$fD');
			if(val==fD)
			{
				fP.setDate(val,true,fP.config.altFormat);
			}
		});		
		if(props.comp != null)
		fP.input.addEventListener('change', function (evt:InputEvent)
		{
			trace(Reflect.fields(props));
			props.onChange(props.name, cast(evt.target, InputElement).value);
		});
	}

	function onChange() {
		
	}

	function onClose (sDates:Array<Dynamic>,val:String,me:DateTimePicker)
	{
		trace(sDates);
		trace(val);
		if(tip != null)
			tip.clear();
	}
	
	public function render():ReactFragment
	{
		if(props == null)
		{
			trace(null);
			return null;
		}
			
		trace( props.name );		
		var val = (props.value == null ?'0000.00.00':props.value);
		//var val:String = props.value;
		//val = val.split('+')[0];
		return  jsx('<input className="h100" name=${props.name} id=${props.name} ref=${fpRef} />');
	}	
}