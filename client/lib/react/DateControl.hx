package react;

import react.PureComponent.PureComponentOfProps;
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

class DateControl extends PureComponentOfProps<DateTimeProps>
{
	var fpRef:ReactRef<InputElement>;
	var fpInstance:Dynamic;//FlashPicker instance
	var tip:Tooltip;

	public function new(props:DateTimeProps) 
	{
		//trace( props.value );
		super(props);
		//this.props = props;
		//trace(Reflect.fields(props));
		fpRef = React.createRef();
	}

	//public function createFlatPicker():Void 
	override public function componentDidMount():Void 
	{
		var fP:Dynamic = App.flatpickr;
		var val = (props.value == null ?'':props.value);
		trace('$val =>${props.value}<<');
		fpInstance = fP(fpRef.current,{
				allowInput:!props.disabled,
				altFormat:props.options.dateFormat,
				dateFormat:'Y-m-d',
				altInput:true,
				altInputClass: "form-control input",
				defaultValue:props.value,
				//locale:'de',
				onChange:onChange,
				onClose:onClose,
				onOpen:onOpen,
				onReady:onReady
		});
		trace('fpInstance.input.value:${fpInstance.input.value}');
		var altInput:InputElement = fpInstance.altInput;
		//trace(Reflect.fields(fP));
		trace('${props.value}:${fpInstance.config.altFormat}');
		altInput.value = (val == '' ? '': fpInstance.formatDate(new Date(Date.parse(props.value)), fpInstance.config.altFormat));
		trace(altInput.value + '::' + fpInstance.formatDate(new Date(Date.parse(props.value)), fpInstance.config.altFormat));

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
			//trace(fpInstance.input.value);
			var val:String = altInput.value;
			var pd:Date = fpInstance.parseDate(val, fpInstance.config.altFormat);
			//trace('$val === ${pd.toString()}');
			var fD:String = fpInstance.formatDate(pd, fpInstance.config.altFormat);
			//trace('$val==$fD');
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
			//trace('$val==$fD');
			if(val==fD)
			{
				fpInstance.setDate(val,true,fpInstance.config.altFormat);
				if(tip != null)
					tip.clear();
			}
		});		
	}

	function onOpen(e:Dynamic) {
		trace(e);
	}

	function onChange(_) {
		if(props.comp != null)
		{
			props.comp.baseForm.doChange(props.name, fpInstance.input.value);
		}
	}

	function onClose (sDates:Array<Dynamic>,val:String,me:DateTimePicker)
	{
		trace(val);
		//trace(fpInstance.altInput.value);
		//if(fpInstance.altInput.value!=null)
		//trace(val + '==' + fpInstance.formatDate(fpInstance.parseDate(fpInstance.altInput.value), fpInstance.config.altFormat));
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

	function onReady(sDates:Array<Dynamic>,val:String,me:Dynamic)
	{
		trace('${sDates} $val ');
		//trace(me);
	}
	
	override public function render():ReactFragment
	{
		if(props == null)
		{
			trace(null);
			return null;
		}

		return  jsx('<input className="h100" name=${props.name} id=${props.name} ref=${fpRef} 
			defaultValue=${props.value}/>');
	}	
}
//rops.value==null?"":props.value