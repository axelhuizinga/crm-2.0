package view.shared;
import react.ReactComponent.ReactFragment;
import react.ReactMacro.jsx;
import react.ReactComponent.ReactComponentOfProps;
import react.router.NavLink;
import react.router.ReactRouter.withRouter;
import react.router.RouterMatch;
import view.shared.RouteTabProps;

typedef TabLinkProps = 
{
	>NavLinkProps,
	?match:RouterMatch,
	?toParams:String->String
}

class TabLink extends ReactComponentOfProps<TabLinkProps>
{
	override function render()
	{
		//trace(Reflect.fields(props));
		//trace(untyped props.staticContext);
		//trace('${props.to} ${props.location.pathname}');
		return jsx('
		<li className=${props.location.pathname.indexOf(props.to) == 0 ?"is-active":""}>
		<$NavLink to=${props.to + '/List/show'}>${props.children}</$NavLink></li>
		');		
	}
}