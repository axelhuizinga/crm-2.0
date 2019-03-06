package view.table;

import haxe.extern.EitherType;
import react.ReactComponent.ReactComponentOf;
import react.ReactComponent.ReactFragment;

/**
 * ...
 * @author axel@cunity.me
 */


class Tr extends ReactComponentOf<Dynamic,Dynamic>
{

	public function new(?props:Dynamic)
	{
		super(props);		
	}
	
	override public function render():ReactFragment
	{
		return jsx('<tr children=${props.children}>');
	}
	
}