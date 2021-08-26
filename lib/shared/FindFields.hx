package shared;

import js.html.InputElement;
import react.types.SyntheticEvent.KeyboardEvent;
import js.html.Event;
import haxe.Constraints.Function;

enum abstract FindTypes(String){
	var CHAR;
	var FLOAT;
	var INT;
	var TEXT;
}

typedef FindField = {

	var matchBy:Function;
	var type:FindTypes;

}

class FindFields{
/*	public static var findMap:Map<FindTypes,FindField> = [
		CHAR => function(v:String) {
			
		}
	];*/
	public static function iLike(v:String) return 'ILIKE|%$v%';
	public static function enterSubmit(e:KeyboardEvent<InputElement>){
		trace(e.charCode);
		if(e.charCode==13) cast(e.target, InputElement).form.submit();
	} 

}