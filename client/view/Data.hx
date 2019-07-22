package view;
import model.UserState;
import react.ReactType;
import view.shared.io.User;

import action.AppAction;
import bulma_components.Tabs;
import model.LocationState;
//import view.shared.io.UserState;
import react.Partial;
import react.React;
import react.ReactComponent;
//import react.ReactComponent.*;
//import react.ReactPropTypes;
import react.ReactMacro.jsx;
import redux.Redux.Dispatch;
import react.router.Route;
import react.router.Redirect;
//import react.router.Route.RouteRenderProps;
//import react.router.Switch;
import react.router.NavLink;
import view.shared.io.FormApi;
import view.shared.RouteTabProps;
import view.shared.CompState;
import view.LoginForm;
//import react.redux.form.Control.ControlProps;
//import react.redux.form.Control;
import redux.Redux;

//import Webpack.*;
import model.AppState;
import view.data.Contacts;
import view.data.Deals;
import view.data.Accounts;

using model.CState;

@:connect
class Data extends ReactComponentOf<RouteTabProps,CompState>
{
	//static var user = {first_name:'dummy'};
	var mounted:Bool = false;
	var rendered:Bool = false;
	var renderCount:Int = 0;
	public function new(?props:Dynamic)
	{
		state = {hasError:false,mounted:false};
		//trace('location.pathname:${props.history.location.pathname} match.url: ${props.match.url} user:${props.user}');
		super(props);
		if (props.match.url == '/Data' && props.match.isExact)
		{
			props.history.push('/Data/Contacts');
			trace('pushed2: /Data/Contacts');
		}
	}
	
	override public function componentDidMount():Void 
	{
		mounted = true;
		//trace(mounted);
		//trace(props.history.listen);
		//this.addComponent();
	}
	
	override function componentDidCatch(error, info) {
		// Display fallback UI
		if(mounted)
		this.setState({ hasError: true });
		trace(error);
		trace(info);
	}		
	
	override public function componentWillUnmount():Void 
	{
		trace('leaving...');
		return;
		super.componentWillUnmount();
	}
	
	static function mapDispatchToProps(dispatch:Dispatch):Dynamic
    {
		trace(dispatch + ':' + (dispatch == App.store.dispatch? 'Y':'N'));
        return {
			setThemeColor: function() dispatch(AppAction.SetTheme('violet'))//,
			//initChildren: function() dispatch()
		};
    }

	static function mapStateToProps(aState:AppState) {
		var uState:UserProps = aState.appWare.user;
		trace(uState.first_name);
		//trace(' ${aState.appWare.history.location.pathname + (aState.appWare.compState.exists('contacts') && aState.appWare.compState.get('contacts').isMounted ? "Y":"N")}');
		
		return {
			appConfig:aState.appWare.config,
			redirectAfterLogin:aState.appWare.redirectAfterLogin,
			user:uState/*
			user_name:uState.user_name,
			pass:uState.pass,
			jwt:uState.jwt,
		//	isMounted:mounted,
			loggedIn:uState.loggedIn,
			loginError:uState.loginError,
			last_login:uState.last_login,
			first_name:uState.first_name,
			//locationHistory:aState.appWare.history,
			waiting:uState.waiting*/
		};		
	}		
	
    override function render() 
	{	
		//trace(this.state);
		//trace(props.history.location.pathname);
		//trace(props.user);
		if (state.hasError)
			return jsx('<h1>Fehler in ${Type.getClassName(Type.getClass(this))}.</h1>');
		trace(Reflect.fields(props));
		trace(Reflect.fields(state));
		return jsx('
		<>
			<div className="tabNav2" >
				<Tabs  className="is-boxed" >
					<TabLink to="/Data/Contacts" ${...props}>Kontakte</TabLink>
					<TabLink to="/Data/Deals" ${...props}>Aufträge</TabLink>
					<TabLink to="/Data/Accounts" ${...props}>Konten</TabLink>
				</Tabs>
			</div>
            <div className="tabContent2" >
				<Route path="/Data/Contacts/:action?/:id?"  ${...props} component={Contacts}/>
				<Route path="/Data/Deals/:action?/:id?"  ${...props} component={Deals}/>
				<Route path="/Data/Accounts/:action?"   ${...props} component={Accounts}/>	
            </div>
			<StatusBar ${...props}/>
		</>
			');			
    }

	function renderComponent(comp:Dynamic,props:Dynamic, user:UserState):ReactFragment
	{
		trace(user.first_name);
		props.user = user;
		//return React.createElement(Comp,props);
		return switch(comp)
		{	
			case Contacts:
				jsx('<$Contacts  user=${this.props.user} ${...props}/>');			
			case Deals:
				jsx('<$Deals  user=${this.props.user} ${...props}/>');			
			case Accounts:
				jsx('<$Accounts  user=${this.props.user} ${...props}/>');
			default:
				null;
		}
	}
	
	function internalRedirect(path:String = '/Data/Contacts')
	{
		props.history.push(path);
		return null;
	}
	
	function TabLink(rprops)
	{
		//trace(Reflect.fields(rprops));
		//trace(rprops.children);
		return jsx('
		<li className=${rprops.location.pathname.indexOf(rprops.to) == 0 ?"is-active":""}><NavLink to=${rprops.to}>${rprops.children}</NavLink></li>
		');
	}
}
