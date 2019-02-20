package formik;
import formik.Types
;
import haxe.extern.EitherType;
import js.Promise;
import Webpack.*;

typedef RegisterFieldFns = 
{
	?reset:Any->Void,
	?validate: Dynamic->EitherType<String, Promise<Void>>
}


@:jsRequire('formik', 'Formik')
extern class Formik<Values, ExtraProps> extends React.Component<Dynamic, FormikState<Dynamic>> {
	static var defaultProps : {
		var validateOnChange : Bool; 
		var validateOnBlur : Bool; 
		var isInitialValid : Bool; 
		var enableReinitialize : Bool; 		
	};
	var initialValues : Values;
	var didMount : Bool;
	var hcCache : { };
	var hbCache : { };
	var fields : { };
	function new(props:Dynamic):Void;
	var registerField : String ->RegisterFieldFns->Void;
	var unregisterField : String -> Void;
	//function componentDidMount():Void;
	//function componentWillUnmount():Void;
	//function componentDidUpdate(prevProps:Readonly<Dynamic>):Void;
	var setErrors : FormikErrors<Values> -> Void;
	var setTouched : FormikTouched<Values> -> Void;
	var setValues : FormikValues -> Void;
	var setStatus : ?Any -> Void;
	var setError : Dynamic -> Void;
	var setSubmitting : Bool -> Void;
	var validateField : String -> Void;
	var runSingleFieldLevelValidation : String -> haxe.extern.EitherType<String, Void> -> Promise<String>;
	function runFieldLevelValidations(values:FormikValues):Promise<FormikErrors<Values>>;
	function runValidateHandler(values:FormikValues):Promise<FormikErrors<Values>>;
	var runValidationSchema : FormikValues -> Promise<{ }>;
	var runValidations : ?FormikValues -> Promise<FormikErrors<Values>>;
	var handleChange : haxe.extern.EitherType<String, React.ChangeEvent<Dynamic>> -> haxe.extern.EitherType<Void, haxe.extern.EitherType<String, React.ChangeEvent<Dynamic>> -> Void>;
	var setFieldValue : String -> Dynamic -> ?Bool -> Void;
	var handleSubmit : haxe.extern.EitherType<React.FormEvent<HTMLFormElement>, Undefined> -> Void;
	var submitForm : Void -> Promise<Void>;
	var executeSubmit : Void -> Void;
	var handleBlur : Dynamic -> haxe.extern.EitherType<Void, Dynamic -> Void>;
	var setFieldTouched : String -> ?Bool -> ?Bool -> Void;
	var setFieldError : String -> haxe.extern.EitherType<String, Undefined> -> Void;
	var resetForm : ?haxe.extern.EitherType<Values, Undefined> -> Void;
	var handleReset : Void -> Void;
	var setFormikState : Dynamic -> ?haxe.extern.EitherType<Void -> Void, Undefined> -> Void;
	var getFormikActions : Void -> FormikActions<Values>;
	var getFormikComputedProps : Void -> { var dirty : Bool; var isValid : Bool; var initialValues : Values; };
	var getFormikBag : Void -> { var registerField : String -> { @:optional
	var reset : haxe.extern.EitherType<?Dynamic -> Void, Undefined>; @:optional
	var validate : haxe.extern.EitherType<Dynamic -> haxe.extern.EitherType<String, haxe.extern.EitherType<Promise<Void>, Undefined>>, Undefined>; } -> Void; var unregisterField : String -> Void; var handleBlur : Dynamic -> haxe.extern.EitherType<Void, Dynamic -> Void>; var handleChange : haxe.extern.EitherType<String, React.ChangeEvent<Dynamic>> -> haxe.extern.EitherType<Void, haxe.extern.EitherType<String, React.ChangeEvent<Dynamic>> -> Void>; var handleReset : Void -> Void; var handleSubmit : haxe.extern.EitherType<React.FormEvent<HTMLFormElement>, Undefined> -> Void; var validateOnChange : Array<Dynamic>; var validateOnBlur : Array<Dynamic>; var dirty : Bool; var isValid : Bool; var initialValues : Values; function setStatus(?status:Dynamic):Void; function setError(e:Dynamic):Void; function setErrors(errors:FormikErrors<Values>):Void; function setSubmitting(isSubmitting:Bool):Void; function setTouched(touched:FormikTouched<Values>):Void; function setValues(values:Values):Void; @:overload(function(field:String, value:Dynamic):Void { })
	function setFieldValue(field:Dynamic, value:Dynamic, ?shouldValidate:haxe.extern.EitherType<Bool, Undefined>):Void; @:overload(function(field:String, message:String):Void { })
	function setFieldError(field:Dynamic, message:String):Void; @:overload(function(field:String, ?isTouched:haxe.extern.EitherType<Bool, Undefined>):Void { })
	function setFieldTouched(field:Dynamic, ?isTouched:haxe.extern.EitherType<Bool, Undefined>, ?shouldValidate:haxe.extern.EitherType<Bool, Undefined>):Void; function validateForm(?values:Dynamic):Void; function validateField(field:String):Void; function resetForm(?nextValues:Dynamic):Void; function submitForm():Void; @:overload(function<K:(haxe.extern.EitherType<String, haxe.extern.EitherType<String, haxe.extern.EitherType<String, haxe.extern.EitherType<String, haxe.extern.EitherType<String, haxe.extern.EitherType<String, haxe.extern.EitherType<String, String>>>>>>>)>(state:Pick<FormikState<Values>, K>, ?callback:haxe.extern.EitherType<Void -> Dynamic, Undefined>):Void { })
	function setFormikState<K:(haxe.extern.EitherType<String, haxe.extern.EitherType<String, haxe.extern.EitherType<String, haxe.extern.EitherType<String, haxe.extern.EitherType<String, haxe.extern.EitherType<String, haxe.extern.EitherType<String, String>>>>>>>)>(f:Readonly<FormikState<Values>> -> Dynamic -> Pick<FormikState<Values>, K>, ?callback:haxe.extern.EitherType<Void -> Dynamic, Undefined>):Void; var values : Dynamic; @:optional
	var error : Dynamic; var errors : FormikErrors<Dynamic>; var touched : FormikTouched<Dynamic>; var isValidating : Bool; var isSubmitting : Bool; @:optional
	var status : Dynamic; var submitCount : Float; };
	var getFormikContext : Void -> FormikContext<Dynamic>;
	function render():JSX.Element;
}
extern class FormikTopLevel {
	static function yupToFormErrors<Values>(yupError:Dynamic):FormikErrors<Values>;
	static function validateYupSchema<T:(FormikValues)>(values:T, schema:Dynamic, ?sync:Bool, ?context:Dynamic):Promise<Partial<T>>;
}
