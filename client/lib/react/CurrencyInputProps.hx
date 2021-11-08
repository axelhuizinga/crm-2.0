package react;

import js.html.InputElement;
import js.html.Element;
import react.ReactComponent.ReactElement;
import react.ReactRef;
import haxe.ds.Either;
import haxe.Constraints.Function;
import react.ControlTypes;

/**
 * ...
 * @author axel@cunity.me
 */

typedef IntlConfig = {
	?locale:String,
	?currency:String
}

typedef CurrencyInputProps = {
	>InputProps,
	?decimalScale:Int,
	?defaultValue:Float,
	?intlConfig:IntlConfig,
	?placeholder:String,	
	?prefix:String,
	?suffix:String,
	?value:Float,//Either<String, Float>,
	?onValueChange: Function //Dynamic->Dynamic->Dynamic->Void,
}