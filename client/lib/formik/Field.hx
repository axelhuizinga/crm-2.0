typedef FieldProps<V> = {
	var field : { var onChange : React.ChangeEvent<Dynamic> -> Void; var onBlur : Dynamic -> Void; var value : Dynamic; var name : String; };
	var form : FormikProps<V>;
};
typedef FieldConfig = {
	@:optional
	var component : haxe.extern.EitherType<String, haxe.extern.EitherType<React.ComponentType<FieldProps<Dynamic>>, React.ComponentType<Void>>>;
	@:optional
	var render : FieldProps<Dynamic> -> React.ReactNode;
	@:optional
	var children : haxe.extern.EitherType<FieldProps<Dynamic> -> React.ReactNode, React.ReactNode>;
	@:optional
	var validate : Dynamic -> haxe.extern.EitherType<String, haxe.extern.EitherType<Promise<Void>, Undefined>>;
	var name : String;
	@:optional
	var type : String;
	@:optional
	var value : Dynamic;
	@:optional
	var innerRef : Dynamic -> Void;
};
extern class FieldTopLevel {
	static var Field : Dynamic;
}
