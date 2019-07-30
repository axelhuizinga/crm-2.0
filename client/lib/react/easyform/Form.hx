package react.easyform;

import js.html.Event;
import haxe.Constraints.Function;
import haxe.extern.Rest;
import react.ReactComponent.ReactFragment;
import react.ReactComponent.ReactComponentOf;

typedef EasyFormProps = 
{
	children: ReactFragment,
	className: String,
	initialData: Dynamic,
	onSubmit: Function
}

typedef FormChildContextTypes = {
  updateFormData: Function,
  getFormData: Function
}

@:jsRequire('react-easy-form')
extern class Form extends ReactComponentOf<EasyFormProps, Dynamic>
{
	public function new(props:EasyFormProps);

  	public function getChildContext():FormChildContextTypes;

  	public function updateFormData(inputName:String, value:Dynamic):Void;
	
	public function submit():Void;

	public function getFormData(inputName:String):Dynamic;

	function _onSubmit(event:Event):Bool;

	public function clear():Void;

	override public function render():ReactFragment;

}