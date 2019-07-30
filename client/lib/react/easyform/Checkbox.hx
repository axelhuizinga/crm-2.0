package react.easyform;

import haxe.Constraints.Function;
import react.ReactComponent.ReactComponentOf;
import react.ReactComponent.ReactFragment;

typedef CheckboxPropTypes = {
	className: String,
	disabled: Bool,
	id: String,
	name: String,
	required: Bool,
	title: String
};

/*Checkbox.defaultProps = {
  disabled: false,
  required: false
};*/

typedef CheckboxContextTypes = {
  labelId: String,
  updateFormData: Function,
  getFormData: Function
}

@:jsRequire('react-easy-form')
extern class Checkbox extends ReactComponentOf<CheckboxPropTypes, Dynamic>
{
	public function new(props:CheckboxPropTypes);

	override public function render():ReactFragment;
}