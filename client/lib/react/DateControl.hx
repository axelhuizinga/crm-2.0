package react;

import js.html.Document;
import react.ReactComponent.ReactFragment;
import haxe.Constraints.Function;
import haxe.ds.Either;
import haxe.Timer;
import js.Lib;
import react.ReactComponent.ReactComponentOfProps;
import react.ReactMacro.jsx;
import react.DateControlTypes;
import react.DateTimePicker;

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

	public function new(props) 
	{
		//trace( props.value );
		super(props);
		flatpickr.localize(German);
		trace(props);
	}
	
	override public function render():ReactFragment
	{
		trace( props.value );
		//var val:String = props.value;
		//val = val.split('+')[0];
		return 	jsx('
		<$DateTimePicker     
			options=${{
				allowInput:false,
				altFormat:props.options.dateFormat,
				//dateFormat:'U',// seconds since Unix Epoch
				dateFormat:'Y-m-d',
				altInput:true,
				defaultValue:props.value,
				locale:'de',
				onChange:onChange
			}}
			value=${Date.fromString(props.value)}
			name=${props.name}
			/>
		');
	}
	/**${function (_,str,me){
				trace(str);
				trace(me);
			}}
	 * [Description]
	 * @param sDates 
	 * @param val 
	 * @param me 
	 */

	function onChange(sDates:Array<Dynamic>,val:String,me:DateTimePicker) {
		trace(val);
		trace(props.name);
	}
}