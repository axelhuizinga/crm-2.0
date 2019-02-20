package view.shared;

//import react.ReactComponent.ReactComponentOfProps;
import react.ReactComponent.ReactComponentOf;
import react.ReactMacro.jsx;
import react.router.Route.RouteRenderProps;
import view.dashboard.RolesForm;

/**
 * ...
 * @author axel@cunity.me
 */

typedef RouteBoxProps =
{
	> RouteRenderProps,
	component:String,
	connectChild:String->Void,
	isMounted:Bool
}

class RouteBox extends ReactComponentOf<RouteBoxProps, Dynamic>
{
	var parentIsMounted:Bool;
	public function new(?props:RouteBoxProps) 
	{
		super(props);	
		parentIsMounted = false;
		trace(parentIsMounted);
		trace(props.isMounted);
	}
	
	function connectMe()
	{
		//props.connectChild('RolesForm');
		parentIsMounted = true;
		forceUpdate();
	}
	
	override public function render()
	{
		trace(props.isMounted);
		trace(parentIsMounted);
		if ( !parentIsMounted)
		{
			return jsx('<button onClick={connectMe}>ConnectMe</button>');
		}
		var component = props.component;
		trace(component);
		trace(parentIsMounted);
		if ( !parentIsMounted)
		return null;
		return jsx('<div><RolesForm {...props}/></div>');
	}
	
}