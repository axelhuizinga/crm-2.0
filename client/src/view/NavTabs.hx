package view;
import react.ReactType;
import action.async.UserAccess;
import react.ReactComponent;
import react.ReactMacro.jsx;
import react.router.Route;
import react.router.Route.RouteComponentProps;
import react.router.Link;
import react.router.NavLink;
import bulma_components.Tabs;
import view.shared.SLink;
import view.shared.TabLink;

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

	function logOut() {
		App.store.dispatch( UserAccess.logOut());
	}
	
	override public function render()
	{
		return jsx('
			<Tabs className="is-centered" >				
				${cast buildNav()}
			</Tabs>		
		');
	}		

	function buildNav()
	{
		var userState = App.store.getState().userState;
		//trace(userState);
		if (userState.waiting || userState.dbUser.id == 0|| userState.dbUser.jwt == null || userState.dbUser.jwt == '')
		{
			// WE REQUIRE TO LOGIN FIRST
			return null;
		}
		else		
		return jsx('
		<>
			<$TabLink to="/DashBoard" ${...props}>DashBoard</$TabLink> 
			<$TabLink to="/Data" ${...props}>Daten</$TabLink>			
			<$TabLink to="/Accounting" ${...props}>Buchhaltung</$TabLink>
			<$TabLink to="/Reports" ${...props}>Berichte</$TabLink>
			<i className = "icon abs-right fa fa-sign-out"  title = "Abmelden"  onClick=${logOut}
			style={{margin:".8rem .5rem",fontSize:"1.7rem", cursor:"pointer", color:"#801111"}}></i>
		</>
		');
	}
}