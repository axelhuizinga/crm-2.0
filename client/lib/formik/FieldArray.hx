typedef ArrayHelpers = {
	var push : Dynamic -> Void;
	var handlePush : Dynamic -> Void -> Void;
	var swap : Float -> Float -> Void;
	var handleSwap : Float -> Float -> Void -> Void;
	var move : Float -> Float -> Void;
	var handleMove : Float -> Float -> Void -> Void;
	var insert : Float -> Dynamic -> Void;
	var handleInsert : Float -> Dynamic -> Void -> Void;
	var replace : Float -> Dynamic -> Void;
	var handleReplace : Float -> Dynamic -> Void -> Void;
	var unshift : Dynamic -> Float;
	var handleUnshift : Dynamic -> Void -> Void;
	var handleRemove : Float -> Void -> Void;
	var handlePop : Void -> Void -> Void;
	function remove<T>(index:Float):haxe.extern.EitherType<T, Undefined>;
	function pop<T>():haxe.extern.EitherType<T, Undefined>;
};
extern class FieldArrayTopLevel {
	static var move : Array<Dynamic> -> Float -> Float -> Array<Dynamic>;
	static var swap : Array<Dynamic> -> Float -> Float -> Array<Dynamic>;
	static var insert : Array<Dynamic> -> Float -> Dynamic -> Array<Dynamic>;
	static var replace : Array<Dynamic> -> Float -> Dynamic -> Array<Dynamic>;
	static var FieldArray : Dynamic;
}
