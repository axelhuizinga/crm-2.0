package view;
import action.async.UserAccess;
import react.ReactComponent;
import react.ReactMacro.jsx;
import react.router.Route;
import react.router.Route.RouteComponentProps;
import react.router.Link;
import react.router.NavLink;
import bulma_components.Tabs;
import view.shared.SLink;

/**
 * ...
 * @author axel@cunity.me
 */
typedef NavProps =
{
	> RouteComponentProps,
	debug:String
}

@:wrap(react.router.ReactRouter.withRouter)
class NavTabs extends ReactComponentOfProps<NavProps>
{
	static var tabsRendered:Int=0;
	
	public function new(?props:NavProps, ?context:Dynamic) 
	{
		trace(Reflect.fields(props));
		//trace(context);
		super(props);		
	}
	
	override public function render()
	{
		return jsx('
			<Tabs className="is-centered" >				
				${buildNav()}
			</Tabs>		
		');
	}	
	
	function TabLink(rprops)
	{
		return jsx('
		<li className=${rprops.location.pathname.indexOf(rprops.to) == 0 ?"is-active":""}><NavLink to=${rprops.to}>${rprops.children}</NavLink></li>
		');
	}

	function logOff() {
		App.store.dispatch( UserAccess.logOff());
	}

	function buildNav()
	{
		var state = App.store.getState().user;
		//trace(state);
		if (state.waiting || state.id == 0|| state.jwt == null || state.jwt == '')
		{
			// WE REQUIRE TO LOGIN FIRST
			return null;
		}
		else		
		return jsx('
		<>
			<TabLink to="/DashBoard" ${...props}>DashBoard</TabLink> 
			<TabLink to="/Data" ${...props}>Daten</TabLink>
			<TabLink to="/Qc" ${...props}>QC</TabLink>
			<TabLink to="/Accounting" ${...props}>Buchhaltung</TabLink>
			<TabLink to="/Reports" ${...props}>Berichte</TabLink>
			<i className = "icon abs-right fa fa-sign-out"  title = "Abmelden"  onClick=${logOff}
			style={{margin:".8rem .5rem",fontSize:"1.7rem", cursor:"pointer", color:"#801111"}}></i>
		</>
		');
	}
}