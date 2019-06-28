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
		return jsx('
			<$Flatpickr     
				options=${{
					clickOpens:false,
					dateFormat:props.options.dateFormat,
					//defaultDate:props.modelValue,
					//'inline': props.options != null && props.options._inline != null && props.options._inline,
					time_24hr:true,
					minuteIncrement:5
				}}
				value=${props.value}		
				disabled=${props.disabled}		
				onChange=${props.onChange}/>
		');
	}
}