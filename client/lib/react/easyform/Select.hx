package react.easyform;

import haxe.Constraints.Function;
import react.ReactComponent.ReactComponentOf;
import react.ReactComponent.ReactFragment;

typedef SelectPropTypes = {
	?className: String,
	?disabled: Bool,
	?id: String,
	name: String,
	values: haxe.extern.EitherType<Array<Dynamic>,Dynamic>
};

/*Select.defaultProps = {
	disabled: false
};*/

typedef SelectContextTypes = {
	labelId: String,
	updateFormData: Function,
	getFormData: Function
}

@:jsRequire('react-easy-form')
extern class Select extends ReactComponentOf<SelectPropTypes, Dynamic>
{
	public function new(props:SelectPropTypes);

	override public function render():ReactFragment;	
}