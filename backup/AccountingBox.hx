package view;

import react.ReactComponent.ReactComponentOfProps;
import react.ReactMacro.jsx;
import view.Accounting;

/**
 * ...
 * @author axel@cunity.me
 */

class AccountingBox extends ReactComponentOfProps<Dynamic>
{

	public function new(?props:Dynamic, ?context:Dynamic) 
	{
		super(props, context);
		
	}
	
	override public function render()
	{
		trace(props);
		return jsx('
		<Accounting {...props}/>
		');
	}
	
}