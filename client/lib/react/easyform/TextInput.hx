package react.easyform;

import react.ReactComponent.ReactComponentOf;
import react.ReactComponent.ReactFragment;
import haxe.Constraints.Function;

typedef TextInputProps = {
  ?className: String,
  ?disabled: Bool,
  ?id: String,
  name: String,
  ?pattern: String,
  ?placeholder: String,
  ?required: Bool,
  ?title: String,
  ?type: String
};

/*TextInput.defaultProps = {
  disabled: false,
  required: false,
  type: 'text'
};*/

typedef TextInputContextTypes = {
  labelId: String,
  updateFormData: Function,
  getFormData: Function
}

@:jsRequire('react-easy-form')
extern class TextInput extends ReactComponentOf<TextInputProps, Dynamic>
{
	public function new(props:TextInputProps);

	override public function render():ReactFragment;
}