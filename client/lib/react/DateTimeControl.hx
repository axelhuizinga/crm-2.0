package react;

import react.ReactComponent.ReactFragment;
import haxe.Constraints.Function;
import haxe.ds.Either;
import haxe.Timer;
import js.Lib;
import react.ReactComponent.ReactComponentOfProps;
import react.ReactMacro.jsx;
import react.DateTimePicker;
import react.DateControlTypes;
import react.Flatpickr;

/**
 * ...
 * @author axel@cunity.me
 */

class DateTimeControl extends ReactComponentOfProps<DateTimeProps>
{
	static var css = js.Lib.require('react-datepicker/dist/react-datepicker.css');
	static var flat = js.Lib.require('flatpickr/dist/themes/light.css');



	public function new(props) 
	{
		//trace( props.value );
		super(props);
		trace(props);
	}
	
	override public function render():ReactFragment
	{
		//trace( props.value );
		//var val:String = props.value;
		//val = val.split('+')[0];
		return switch(props.type)
		{
			case 'DateTimePicker':
				jsx('
				<$DateTimePicker     
					options=${{
						clickOpens:false,
						dateFormat:props.dateFormat,
						//'inline': props.options != null && props.options._inline != null && props.options._inline,
						time_24hr:true,
						minuteIncrement:5
					}}
					
					
					 onChange=${props.onChange}/>
				');
			/**
			 * 					selected=${Date.fromString(props.value.split('+')[0])}
					showTimeSelect
					timeFormat="HH:mm"
					timeIntervals={15}
					dateFormat=${props.dateFormat}
					timeCaption="time" onChange=${props.onChange}/>
			 */
			default:
				jsx('
				<$DateTimePicker     

					dateFormat=${props.dateFormat}
					onChange=${props.onChange}/>
				');
		}
		/*return jsx('
			<$DateInput type=${props.type} lang="de" date-format=${props.dateFormat} value=${props.value} onChange=${props.onChange}/>
		');*/
	}
}