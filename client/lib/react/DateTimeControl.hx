package react;

import haxe.Timer;
import js.Lib;
import react.ReactComponent.ReactComponentOfProps;
import react.ReactMacro.jsx;
import react.DateInput;

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
		return jsx('
			<input type="date" lang="de" date-format=${props.dateFormat} value=${props.value} onChange=${props.onChange}/>
		');
	}
}