package view;
import haxe.Constraints.Function;
import js.lib.Promise.PromiseHandler;
import action.async.LocationAccess;
import state.UserState;
import react.ReactType;
import view.shared.io.User;

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
import view.shared.DataProps;
import view.shared.RouteTabProps;
import view.shared.CompState;
import view.shared.TabLink;
import view.LoginForm;
import view.StatusBar;
//import react.redux.form.Control.ControlProps;
//import react.redux.form.Control;
import redux.Redux;
import redux.thunk.Thunk;
//import Webpack.*;
import state.AppState;
import view.data.Contacts;
import view.data.Deals;
import view.data.Accounts;
import view.data.QC;
using state.CState;
using shared.Utils;


@:connect
class Data extends ReactComponentOf<DataProps,CompState>
{
	//static var user = {first_name:'dummy'};
	var mounted:Bool = false;
	var rendered:Bool = false;
	var renderCount:Int = 0;
	var _trace:Bool;
	static  var _strace:Bool;

	public function new(?props:Dynamic)
	{
		state = {hasError:false,mounted:false};
		//if(_trace) trace('location.pathname:${props.history.location.pathname} match.url: ${props.match.url} user:${props.user}');
		super(props);	
		_strace = _trace = false;	
		if(_trace) trace(props.match);
		if(_trace) trace(props.store);
		if (props.match.url == '/Data' && props.match.isExact)
		{
			if(_trace) trace('pushing2: /Data/Contacts/List/get');
			props.history.push('/Data/Contacts/List/get');
		}
	}
	
	override public function componentDidMount():Void 
	{
		mounted = true;
		/*if(_trace) trace(props.history.location);
		if(_trace) trace(props.location);
		if(_trace) trace(props.match);*/
		//internalRedirect();
		//if(path != props.location.pathname)
		//props.history.push(path);
		//if(_trace) trace(mounted);
		//if(_trace) trace(props.history.listen);
		//this.addComponent();
	}
	
	override function componentDidCatch(error, info) {
		// Display fallback UI
		if(mounted)
		this.setState({ hasError: true });
		if(_trace) trace(error);
		if(_trace) trace(info);
	}		
	
	override function shouldComponentUpdate(nextProps:DataProps, nextState:CompState):Bool
	{
		if(_trace) trace('propsChanged:${nextProps!=props}');
		//if(nextProps!=props)			props.compare(nextProps);
		if(_trace) trace('stateChanged:${nextState!=state}');
		if(nextState!=state || nextProps!=props)
		{
			//internalRedirect();
			return true;
		}
			
		return nextProps!=props;
	}
	
	static function mapDispatchToProps(dispatch:Dispatch):Dynamic
    {
		
        return {
			redirect: function(path:String,props:DataProps) return dispatch(LocationAccess.redirect(
				['/Data/Contacts/:section?/:action?/:id?',
				'/Data/Deals/:section?/:action?/:id?',
				'/Data/Accounts/:section?/:action?/:id?'],path,props))
			//setThemeColor: function() dispatch(AppAction.SetTheme('violet'))//,
			//initChildren: function() dispatch()
		};
    }
	/*
	static function mapStateToProps(aState:AppState) {
		var uState:UserProps = aState.user;
		if(_trace) trace(uState.first_name);
		//if(_trace) trace(' ${aState.locationState.history.location.pathname + (aState.compState.exists('contacts') && aState.compState.get('contacts').isMounted ? "Y":"N")}');
		
		return {
			appConfig:aState.config,
			redirectAfterLogin:aState.locationStore.redirectAfterLogin,
			user:uState
		};		
	}		*/
	
    override function render() 
	{	
		//if(_trace) trace(this.state);
		//if(_trace) trace(props.history.location.pathname);
		//if(_trace) trace(props.user);
		if (state.hasError)
			return jsx('<h1>Fehler in ${Type.getClassName(Type.getClass(this))}.</h1>');
		if(_trace) trace(Reflect.fields(props));
		if(_trace) trace(Reflect.fields(state));
		return jsx('
		<>
			<div className="tabNav2" >
				<$Tabs className="is-boxed" >
					<$TabLink to="/Data/Contacts" ${...props} >Kontakte</$TabLink>
					<$TabLink to=${{
						key:props.location.key,
						hash:'',
						pathname:"/Data/Deals",
						search:'',
						state:props.location.state.extend({contact:props.location.hash})
					}} ${...props} >Aufträge</$TabLink>					
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
			');			
    }
//<$Route >${internalRedirect()}</$Route>
	function renderComponent(props:RouteRenderProps):ReactElement
	{
		if(_trace) trace(props.location);
		if(_trace) trace(props.match);
		return null;
	}
	
	function internalRedirect(path:String = '/Data/Contacts/List/get')
	{
		if(_trace) trace('${props.location.pathname} $path');
		//if(_trace) trace(props.match);Action<TReturn>(cb:Dispatch->(Void->TState)->TReturn);
		if(props.location.pathname != path)
		{
		/*	props.history.push(path);
			return null;
		}
		var thunk:Dynamic = null;*/
		if(path != props.location.pathname)
			props.redirect(path, props);
		
		}
	}
	
}
