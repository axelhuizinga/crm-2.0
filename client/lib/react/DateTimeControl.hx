package react;

import js.lib.intl.DateTimeFormat;
import js.html.InputElement;
import js.html.KeyboardEvent;
import js.lib.Date;
import react.ReactComponent.ReactFragment;
import react.ReactRef;
import react.ReactMacro.jsx;
import react.DateControlTypes;
import view.shared.io.Tooltip;

using shared.DateFormat;

/**
 * ...
 * @author axel@cunity.me
 */

class DateTimeControl
{
	var fpRef:ReactRef<InputElement>;
	var fpInstance:Dynamic;//FlashPicker instance
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
		var fP:Dynamic = App.flatpickr;
		var val = (props.value == null ?'0000.00.00':props.value);
		trace('$val ${props.options.dateFormat}');
		fpInstance = fP(fpRef.current,{
				allowInput:!props.disabled,
				altFormat:props.options.dateFormat,
				dateFormat:'Y-m-d H:i',
				altInput:true,
				altInputClass: "form-control input",
				//defaultValue:val, 
				//onChange:onChange,
				onClose:onClose
		});

		var altInput:InputElement = fpInstance.altInput;
		trace(fpInstance.altInput.value);
		trace(untyped  fpRef.current.value);
		if(!props.disabled)
		{
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
						return;		
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
		}
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
		if(fpInstance.altInput.value!=null)
		trace(val + '==' + fpInstance.formatDate(fpInstance.parseDate(fpInstance.altInput.value), fpInstance.config.altFormat));
		if(tip != null)
			tip.clear();
		if(fpInstance.altInput.value==null)
		if(val==fpInstance.formatDate(fpInstance.parseDate(fpInstance.altInput.value), fpInstance.config.altFormat))
		{

		}
		else 
		{
			fpInstance.altInput.value = fpInstance.formatDate(fpInstance.input.value, fpInstance.config.altFormat);
			tip = new Tooltip(fpInstance.altInput.parentElement, {data: 'DateFormat',classes:['danger','active']});

		}		

	}
	
	public function render():ReactFragment
	{
		if(props == null)
		{
			trace(null);
			return null;
		}
			
		trace( props.name );		
		var val:Dynamic = (props.value == null ?'2000-01-01 00:00':props.value);
		trace(val);		
		val = Date.parse(val);
		if(!Math.isNaN(val))
		{
			trace(val);
			var d:Date = new Date(val);
			
			trace(d.toDateString());
			val = App.sprintf('%d-%02d-%02d %02d:%02d',
				d.getFullYear(),
				d.getMonth()+1,
				d.getDate(),
				d.getHours(),
				d.getMinutes()
			);

		}
		else
			val = '';
		trace(val == '2000-01-01 00:00');
		//val = '2000-01-01 00:00';
		trace(val);	
		return  jsx('<input className="h100"  name=${props.name} id=${props.name} ref=${fpRef} disabled=${props.disabled}
			defaultValue=${val}/>');
	}	
}