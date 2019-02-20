package view;

import react.ReactComponent.ReactComponentOfProps;
import react.ReactMacro.jsx;
import react.router.Route.RouteRenderProps;
import view.Reports;

/**
 * ...
 * @author axel@cunity.me
 */

class ReportsBox extends ReactComponentOfProps<RouteRenderProps>
{

	public function new(?props:RouteRenderProps, ?context:Dynamic) 
	{
		super(props, context);
		
	}
	
	override public function render()
	{
		return jsx('<Reports {...props}/>');
	}
	
}