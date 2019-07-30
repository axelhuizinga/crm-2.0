package react.easyform;

import haxe.Constraints.Function;
import react.ReactComponent.ReactFragment;
import react.ReactComponent.ReactComponentOf;

typedef LabelPropTypes = {
	children: ReactFragment,
	className: String,
  	id: String,
	position: Function,
	value: String
};

/*Label.defaultProps = {
	position: 'around'
};*/

typedef LabelChildContextTypes = {
  labelId: String
}

@:jsRequire('react-easy-form')
extern class Label extends ReactComponentOf<LabelPropTypes, Dynamic>
{
	public function new(props:LabelPropTypes);

	public function getChildContext():LabelChildContextTypes;

	override public function render():ReactFragment;	
}