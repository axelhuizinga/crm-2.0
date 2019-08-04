package react;

import js.lib.intl.DateTimeFormat;
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
import js.lib.Date;
import react.ReactComponent.ReactComponentOfProps;
import react.ReactMacro.jsx;
import react.DateControlTypes;
import react.intl.ReactIntl;
import react.intl.DateTimeFormatOptions;
import react.intl.IntlShape;
import react.intl.ReactIntl.*;
import react.intl.comp.FormattedDate;
import shared.DateFormat;
import view.shared.io.Tooltip;
import haxe.EnumTools.EnumValueTools;

using haxe.EnumTools;
using shared.DateFormat;

/**
 * ...
 * @author axel@cunity.me
 */
//@:noPublicProps
//@:wrap(injectIntl)
class DateControl
{
	var fpRef:ReactRef<InputElement>;
	var fpInstance:Dynamic;//FlashPicker instance
	var tip:Tooltip;
	public var props:DateTimeProps;

	public function new(props:DateTimeProps) 
	{
		//trace( props.value );
		this.props = props;
		trace( ReactIntl.formatDate );
		trace(Reflect.fields(props));
		fpRef = React.createRef();
	}

	public function createFlatPicker():Void 
	{
		var fP:Dynamic = App.flatpickr;
		var val = (props.value == null ?'0000.00.00':props.value);
		fpInstance = fP(fpRef.current,{
				allowInput:true,
				altFormat:props.options.dateFormat,
				dateFormat:'Y-m-d',
				altInput:true,
				altInputClass: "form-control input",
				defaultValue:val,
				locale:'de',
				onChange:onChange,
				onClose:onClose
		});

		var altInput:InputElement = fpInstance.altInput;
		//trace(Reflect.fields(fP));
		trace(Reflect.fields(altInput));

		altInput.addEventListener('keyup', function(ev:KeyboardEvent){
			//trace(ev.key);
			fpInstance.close();
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
			var pd:Date = fpInstance.parseDate(val, fpInstance.config.altFormat);
			//trace('$val === ${pd.toString()}');
			var fD:String = fpInstance.formatDate(pd, fpInstance.config.altFormat);
			trace('$val==$fD');
			if(val==fD)
			{
				fpInstance.setDate(val,true,fpInstance.config.altFormat);
			}
		});

		altInput.addEventListener('blur', function(ev:KeyboardEvent){
			//trace(ev.key);
//			fpInstance.close();	
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

			//trace(fpInstance.input);
			//trace(fpInstance.input.value);
			var val:String = altInput.value;
			var pd:Date = fpInstance.parseDate(val, fpInstance.config.altFormat);
			//trace('$val === ${pd.toString()}');
			var fD:String = fpInstance.formatDate(pd, fpInstance.config.altFormat);
			trace('$val==$fD');
			if(val==fD)
			{
				fpInstance.setDate(val,true,fpInstance.config.altFormat);
				if(tip != null)
					tip.clear();
			}
		});		
		/*if(props.comp != null)
		altInput.addEventListener('change', function (evt:InputEvent)
		{
			trace(Reflect.fields(props));
			props.onChange(props.name, cast(evt.target, InputElement).value);
		});*/
	}

	function onChange(_) {
		if(props.comp != null)
		{
			props.comp.doChange(props.name, fpInstance.input.value);
		}
	}

	function onClose (sDates:Array<Dynamic>,val:String,me:DateTimePicker)
	{
		trace(tip);
		trace(fpInstance.altInput.value);
		trace(val + '==' + fpInstance.formatDate(fpInstance.parseDate(fpInstance.altInput.value), fpInstance.config.altFormat));
		if(tip != null)
			tip.clear();			
		if(val==fpInstance.formatDate(fpInstance.parseDate(fpInstance.altInput.value), fpInstance.config.altFormat))
		{

		}
		else 
		{
			fpInstance.altInput.value = fpInstance.formatDate(fpInstance.input.value, fpInstance.config.altFormat);
			tip = new Tooltip(fpInstance.altInput.parentElement, {data: 'DateFormat',classes:['danger','active']});

		}
		

	}//fpInstance.formatDate(fpInstance.parseDate(fpInstance.altInput.value), fpInstance.config.altFormat);
	
	public function render():ReactFragment
	{
		if(props == null)
		{
			trace(null);
			return null;
		}
			
		trace( props.name );		
		var val = (props.value == null ?'0000.00.00':props.value);
		return jsx('<$FormattedDate value=${Date.now()} month=${MonthFormat.TwoDigit} day=${NumericFormat.TwoDigit} year=${NumericFormat.Numeric} />');
		//var val:String = props.value;
		//val = val.split('+')[0];props.intl.formatDate(val
		var date = new Date(Date.parse(val));
		val = new DateTimeFormat('de',{
			year:YearRepresentation.Numeric,
			month: MonthRepresentation.TwoDigit, 
			day: DayRepresentation.TwoDigit }).format(date);
		return  jsx('<input className="h100" name=${props.name} id=${props.name} ref=${fpRef} 
			defaultValue=${val}/>');
	}	
}