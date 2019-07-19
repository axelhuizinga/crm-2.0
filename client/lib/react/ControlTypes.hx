package react;

import haxe.Constraints.Function;

typedef InputProps = 
{
	?disabled:Bool,
	?name:String,
    ?onChange: Function,		
	?responseClass:String,
	?value:Dynamic
}