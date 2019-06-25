package react;

import haxe.Timer;
import js.Lib;
import react.ReactComponent.ReactComponentOfProps;
import react.ReactMacro.jsx;
import react.DatePicker;

/**
 * ...
 * @author axel@cunity.me
 */

typedef DateTimeProps2 =
{
	?className:String,
	?locale:String,
	?input:Bool,
	value:Any
}

class DateTimeControl extends ReactComponentOfProps<Dynamic>
{
	static var css = js.Lib.require('react-datepicker/dist/react-datepicker.css');
	public function new(props) 
	{
		//trace( props.value );
		super(props);
		trace(props);
	}
	
	override public function render()
	{
		//trace( props.value );
		var val:String = props.value;
		val = val.split('+')[0];
		return switch(props.type)
		{
			case 'datetime-local':
				jsx('
				<$DatePicker     
					selected=${Date.fromString(props.value.split('+')[0])}
					showTimeSelect
					timeFormat="HH:mm"
					timeIntervals={15}
					dateFormat=${props.dateFormat}
					timeCaption="time" onChange=${props.onChange}/>
				');
			default:
				jsx('
				<$DatePicker     
					selected=${Date.fromString(props.value)}
					showTimeSelect
					timeFormat="HH:mm"
					timeIntervals={15}
					dateFormat=${props.dateFormat}
					timeCaption="time" onChange=${props.onChange}/>
				');
		}
		/*return jsx('
			<$DateInput type=${props.type} lang="de" date-format=${props.dateFormat} value=${props.value} onChange=${props.onChange}/>
		');*/
	}
}