package view;

import react.ReactComponent.ReactComponentOfProps;
import react.ReactMacro.jsx;
import react.router.Redirect;
/**
 * ...
 * @author axel@cunity.me
 */

class RedirectBox extends ReactComponentOfProps<Dynamic>
{

	public function new(?props:Dynamic, ?context:Dynamic) 
	{
		super(props, context);
		
	}
	
	override public function render()
	{
		trace(props);
		return jsx('<Redirect to="/DashBoard/Roles"/>');
	}
	
}