package view;
import action.LocationAction;
import state.UserState;
import react.ReactType;
import view.shared.io.User;

import action.AppAction;
import bulma_components.Tabs;
import state.LocationState;
//import view.shared.io.UserState;
import react.Partial;
import react.React;
import react.ReactComponent;
//import react.ReactComponent.*;
//import react.ReactPropTypes;
import react.ReactMacro.jsx;
import redux.Redux.Dispatch;
import react.router.Route;
import react.router.RouterMatch;
import react.router.Redirect;
//import react.router.Route.RouteRenderProps;
import react.router.Switch;
import react.router.NavLink;
import view.shared.io.FormApi;
import view.shared.RouteTabProps;
import view.shared.CompState;
import view.shared.TabLink;
import view.LoginForm;
//import react.redux.form.Control.ControlProps;
//import react.redux.form.Control;
import redux.Redux;

//import Webpack.*;
import state.AppState;
import view.data.Contacts;
import view.data.Deals;
import view.data.Accounts;

using state.CState;

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
		trace(props.match);
		if (props.match.url == '/Data' && props.match.isExact)
		{
			trace('pushing2: /Data/Contacts/List/show');
			props.history.push('/Data/Contacts/List/show');
		}
	}
	
	override public function componentDidMount():Void 
	{
		mounted = true;
		/*trace(props.history.location);
		trace(props.location);
		trace(props.match);*/
		internalRedirect();
		//if(path != props.location.pathname)
		//props.history.push(path);
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
	
	override function shouldComponentUpdate(nextProps:RouteTabProps, nextState:CompState):Bool
	{
		trace('propsChanged:${nextProps!=props}');
		trace('stateChanged:${nextState!=state}');
		if(nextState!=state || nextProps!=props)
		{
			internalRedirect();
			return true;
		}
			
		return nextProps!=props;
	}
	
	/*static function mapDispatchToProps(dispatch:Dispatch):Dynamic
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
			user:uState
		};		
	}		*/
	
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
				<$Tabs className="is-boxed" >
					<$TabLink to="/Data/Contacts" ${...props} >Kontakte</$TabLink>
					<$TabLink to="/Data/Deals" ${...props} >Aufträge</$TabLink>
					<$TabLink to="/Data/Accounts" ${...props} >Konten</$TabLink>
				</$Tabs>
			</div>
            <div className="tabContent2" >
			<$Switch>
				<$Route path="/Data/Contacts/:section?/:action?/:id?"  ${...props} component={Contacts}/>
				<$Route path="/Data/Deals/:section?/:action?/:id?"  ${...props} component={Deals}/>
				<$Route path="/Data/Accounts/:section?/:action?/:id?"   ${...props} component={Accounts}/>	
				
            </$Switch>
			</div>
			<$StatusBar ${...props}/>
		</>
			');			
    }
//<$Route >${internalRedirect()}</$Route>
	function renderComponent(props:RouteRenderProps):ReactElement
	{
		trace(props.location);
		trace(props.match);
		return null;
	}
	
	function internalRedirect(path:String = '/Data/Contacts/List/show')
	{
		trace('${props.location.pathname} $path');
		//trace(props.match);
		if(path != props.location.pathname)
		App.store.dispatch(
			shared.LocationAccess.redirect(
				['/Data/Contacts/:section?/:action?/:id?',
				'/Data/Deals/:section?/:action?/:id?',
				'/Data/Accounts/:section?/:action?/:id?'],path,props));
		//props.history.push(path);
		return null;
	}
	
	/*function TabLink(rprops)
	{
		trace(Reflect.fields(rprops));
		trace('${rprops.to} ${rprops.location.pathname}');
		var match:RouterMatch = rprops.match;
		var baseUrl:String = match.path.split(':section')[0];
		return jsx('
		<li className=${rprops.location.pathname.indexOf(rprops.to) == 0 ?"is-active":""}>
		<NavLink to=${rprops.to}/List/find/${match.params.id==null?"":match.params.id}>${rprops.children}</NavLink></li>
		');
	}*/
}
