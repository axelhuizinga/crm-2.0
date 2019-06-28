package react;

import react.ReactComponent.ReactFragment;
import haxe.Constraints.Function;
import haxe.ds.Either;
import haxe.Timer;
import js.Lib;
import react.ReactComponent.ReactComponentOfProps;
import react.ReactMacro.jsx;
import react.DateControlTypes;
import react.Flatpickr;

/**
 * ...
 * @author axel@cunity.me
 */

class DateControl extends ReactComponentOfProps<DateTimeProps>
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
		return 	jsx('
		<$Flatpickr     
			options=${{
				dateFormat:props.options.dateFormat,
				defaultValue:props.value
			}}
			value=${props.value}
			onChange=${props.onChange}/>
		');
	}
}