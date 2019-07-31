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
	static var flatpickr = js.Lib.require('flatpickr');
	static var German = js.Lib.require('flatpickr/dist/l10n/de.js');



	public function new(props) 
	{
		//trace( props.value );
		super(props);
		flatpickr.localize(German);
		trace(props);
	}
	
	override public function render():ReactFragment
	{
		var val = (props.value == null ?'0000.00.00':props.value);
		return jsx('
			<$Flatpickr     
				options=${{
					clickOpens:(props.disabled==null?true:!props.disabled),
					dateFormat:props.options.dateFormat,
					enableTime: true,
					//defaultDate:props.modelValue,
					//'inline': props.options != null && props.options._inline != null && props.options._inline,
					time_24hr:true,
					minuteIncrement:5,
					locale:'de'
				}}
				value=${Date.fromString(val)}
				disabled=${props.disabled}		
				onChange=${props.onChange}/>
		');
	}
}