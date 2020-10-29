package view;
//import bulma_components.*;
import bulma_components.Tabs;
import action.AppAction;
import action.ConfigAction;

import state.LocationState;
//import react.Partial;
import react.React;
import react.ReactComponent;
import react.ReactMacro.jsx;
import redux.Redux;
import redux.Redux.Dispatch;
import react.router.Route;
import react.router.RouterMatch;
import react.router.Redirect;
import react.router.Switch;
import react.router.NavLink;
import view.shared.io.FormApi;
import view.shared.DataProps;
import view.shared.RouteTabProps;
import view.shared.CompState;
import view.shared.TabLink;
import view.LoginForm;
import view.StatusBar;
//import Webpack.*;
import state.AppState;
import view.data.Accounts;
import view.accounting.Imports;
using state.CState;
using shared.Utils;

@:connect
class Accounting extends ReactComponentOfProps<RouteTabProps>
	
{
	var mounted:Bool = false;
	
	public function new(?props:Dynamic, context:Dynamic)
	{
		trace(context);
		//this.state = App.store.getState();
		super(props);
		//trace(this.state);
	}

	static function mapDispatchToProps(dispatch:Dispatch) {
		return {
			onTodoClick: function(id:Int) return dispatch(Config(SetTheme('orange')))
		};
	}
	
	override public function componentDidMount():Void 
	{
		mounted = true;
		//trace(state);
	}
	
	override function componentDidCatch(error, info) {
		// Display fallback UI
		//this.setState({ hasError: true });
		// You can also log the error to an error reporting service
		//logErrorToMyStore(error, info);
		trace(error);
	}	
	
	static function mapStateToProps() {

		return function(aState:state.AppState) 
		{
			var uState = aState.userState;

			//trace(uState);
			
			return {
				appConfig:aState.config,
				userState:aState.userState,
				/*pass:uState.pass,
				jwt:uState.jwt,
				online:uState.online,
				loginError:uState.loginError,
				last_login:uState.last_login,
				first_name:uState.first_name,
				id:uState.id,*/
				redirectAfterLogin:aState.locationStore.redirectAfterLogin
			};
		};
	}	
	
    override function render() 
	{
		return jsx('
		<>
			<div className="tabNav2" >
				<$Tabs className="is-boxed" >					
					<$TabLink to=${{
						key:props.location.key,
						hash:props.location.hash,
						pathname:"/Accounting/Accounts",
						search:'',
						state:props.location.state.extend({contact:props.location.hash})
					}} ${...props} >Konten</$TabLink>
					<$TabLink to="/Accounting/Imports" ${...props} >Imports</$TabLink>
				</$Tabs>
			</div>		
            <div className="tabContent2">
				<$Switch>
					<$Route path="/Accounting/Accounts/:section?/:action?/:id?"   ${...props} component={Accounts}/>	
					<$Route path="/Accounting/Imports/:section?/:action?/:id?"  ${...props} component={Imports}/>
				</$Switch>
            </div>
			<StatusBar {...props}/>
        </>
		');
    /**
     * <>
			<div className="tabNav2" >
				<$Tabs className="is-boxed" >
					<$TabLink to="/Data/Contacts" ${...props} >Kontakte</$TabLink>
					<$TabLink to=${{
						key:props.location.key,
						hash:'',
						pathname:"/Data/Deals",
						search:'',
						state:props.location.state.extend({contact:props.location.hash})
					}} ${...props} >Abschlüsse</$TabLink>					
					<$TabLink to=${{
						key:props.location.key,
						hash:props.location.hash,
						pathname:"/Data/Accounts",
						search:'',
						state:props.location.state.extend({contact:props.location.hash})
					}} ${...props} >Konten</$TabLink>
					<$TabLink to="/Data/QC" ${...props} >QC</$TabLink>
				</$Tabs>
			</div>
            <div className="tabContent2" >
			<$Switch>
				<$Route path="/Data/Contacts/:section?/:action?/:id?"  ${...props} component={Contacts}/>
				<$Route path="/Data/Deals/:section?/:action?/:id?"  ${...props} component={Deals}/>
				<$Route path="/Data/Accounts/:section?/:action?/:id?"   ${...props} component={Accounts}/>	
				<$Route path="/Data/QC/:section?/:action?/:id?"  ${...props} component={QC}/>
            </$Switch>
			</div>
			<$StatusBar ${...props}/>
		</>
     */
    }
}
