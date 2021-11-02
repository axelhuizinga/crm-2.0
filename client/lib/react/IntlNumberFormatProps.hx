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

typedef IntlNumberFormatProps = {
	//>InputProps,
	?locale:String,
	?precision:Int,	
	?prefix:String,
	?suffix:String,
	?value:Dynamic,//Either<String, Float>,
	?onChange: Function //Dynamic->Dynamic->Dynamic->Void,
}