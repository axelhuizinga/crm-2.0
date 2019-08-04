package react;

import haxe.Constraints.Function;
import react.intl.IntlShape;

typedef InputProps = 
{
	?disabled:Bool,
	?name:String,
	?intl:IntlShape,
    ?onChange: Function,		
	?responseClass:String,
	?placeholder:String,
	?value:Dynamic
}