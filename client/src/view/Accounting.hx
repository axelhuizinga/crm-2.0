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
import view.accounting.Bookings;
import view.accounting.Debits;
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
		if (props.match.url == '/Accounting' && props.match.isExact)
		{
			if(true) trace('pushing2: /Accounting/Debits/Files');
			props.history.push('/Accounting/Debits/List');
		}		
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
						pathname:"/Accounting/Bookings",
						search:'',
						state:props.location.state.extend({contact:props.location.hash})
					}} ${...props} >Buchungen</$TabLink>
					<$TabLink to="/Accounting/Debits" ${...props} >Lastschriften</$TabLink>
				</$Tabs>
			</div>		
            <div className="tabContent2">
				<$Switch>
					<$Route path="/Accounting/Bookings/:section?/:action?/:id?"   ${...props} component={Bookings}/>	
					<$Route path="/Accounting/Debits/:section?/:action?/:id?"  ${...props} component={Debits}/>
				</$Switch>
            </div>
			<StatusBar {...props}/>
        </>
		');
    }
}
