package view;
import view.shared.io.User;

import comments.StringTransform;
import haxe.Timer;
import history.History;
import history.BrowserHistory;
import me.cunity.debug.Out;
import state.AppState;
import state.GlobalAppState;
import view.shared.io.User.UserProps;
import react.Fragment;
import react.ReactComponent.ReactFragment;
import react.React;
import react.ReactComponent;
import react.ReactComponent.*;
import react.ReactMacro.jsx;
import react.React.ReactChildren;
import react.ReactPropTypes;
import react.ReactRef;
import redux.react.ReactRedux.connect;
import redux.Store;
import redux.Redux;
//import router.RouteComponentProps;
import react.router.NavLink;
import react.router.Redirect;
import react.router.Route;
//import react.addon.router.Route;
//import react.router.Switch;
import react.router.Router;
//import react.addon.router.BrowserRouter;
//import react.router.Route.RouteComponentProps;
import react.router.Route.RouteRenderProps;
import react.router.bundle.Bundle;

import bulma_components.Tabs;

import action.AppAction;
import store.ApplicationStore;
import App;
//import view.relationsBox;
import view.DashBoard;
//import view.AccountingBox;
//import view.ReportsBox;

/**
 * ...
 * @author axel@cunity.me
 */

/*typedef  NavLinks =
{
	id:Int,
	component:ReactComponent,
	label:String,
	url:String
}*/

typedef UIProps =
{
	?store:Store<AppState>,
	?user:UserProps
}

typedef UIState =
{
	?hasError:Bool
}

@:connect
class UiView extends ReactComponentOf<UIProps, UIState>
{
	var browserHistory:History;
	var dispatchInitial:Dispatch;
	var mounted:Bool;
	//static var _me:UiView;

	static function mapStateToProps(aState:AppState):UIProps
	{
		//trace(aState.appWare.user);
		return {
			user:aState.appWare.user
		};
	}
	
	public function new(props:Dynamic) {
		trace(Reflect.fields(props));
		trace(props.store == App.store);
        super(props);
		state = {hasError:false};
		browserHistory = App.store.getState().appWare.history;// BrowserHistory.create({basename:"/"});
		ApplicationStore.startHistoryListener(App.store, browserHistory);
		//trace(this.props.appWare.user.state.last_name);
		mounted = false;
		//_me = this;
		App.modalBox = React.createRef();
    }

	override function componentDidCatch(error, info) {
		// Display fallback UI
		if(mounted)
		this.setState({ hasError: true });
		// You can also log the error to an error reporting service
		//logErrorToMyStore(error, info);
		trace(error);
	}

    override function componentDidMount() {
		mounted = true;
    }

	override function componentDidUpdate(prevProps:Dynamic, prevState:Dynamic)//,snapshot:Dynamic
	{
		//trace(prevState);
		//trace(prevProps);
		//trace(App.firstLoad); 
		//App.firstLoad = false;
	}

	var tabList:Array<Dynamic> = [];
	/*	{ 'key': 1, 'component': DashBoard, 'label': 'DashBoard', 'url': '/DashBoard' },
		{ 'key': 2, 'component': Data, 'label': 'Data', 'url': '/Data' },
		{ 'key': 3, 'component': QC, 'label': 'QC', 'url': '/qc' },
		{ 'key': 4, 'component': Accounting, 'label': 'Buchhaltung', 'url': '/accounting' },
		{ 'key': 5, 'component': Reports, 'label': 'Berichte', 'url': '/reports' },
	];*/

	function createRoutes()
	{
		var routes:Array<Dynamic> = tabList.map(
		function(el) {
			return jsx('
			<Route path=${el.url} component=${el.component}/>
			');
		});
		return routes;
	}

	override function render()
	{
		trace(props.user.jwt + ':' + props.user.waiting );
		if (state.hasError) {
		  return jsx('<h1>Something went wrong.</h1>');
		}
		if (props.user.waiting)
		{
			return jsx('
			<section className="hero is-alt is-fullheight">
			  <div className="hero-body">
			  <div className="loader"  style=${{width:'7rem', height:'7rem', margin:'auto', borderWidth:'0.58rem'}}/>
			  </div>
			</section>
			');		
		}
		
		//if(props.user.user_name == null || props.user.user_name == '' || props.user.jwt == null || props.user.jwt == '')
		trace('${props.user.jwt} ${props.user.loggedIn}');
		if(props.user.jwt == null || props.user.jwt == '' )//|| !props.user.loggedIn
		{
			// WE NEED TO LOGIN FIRST
			return jsx('<LoginForm {...props.user}/>');
		}
		else
		{			
			trace('render Router :)' + browserHistory.location.pathname);
			return jsx('
			<$Router history={browserHistory} >
			<>
				<div className="modal" ref=${App.modalBox}/>
				<div className="topNav">
					<$Route path="/DashBoard" {...props} component=${NavTabs}/>
					<$Route path="/Accounting" {...props} component=${NavTabs}/>
					<$Route path="/Data" {...props} component=${NavTabs}/>
					<$Route path="/Qc" {...props} component=${NavTabs}/>
					<$Route path="/Reports" {...props} component=${NavTabs}/>
				</div>
				<div className="tabComponent">
					<$Route path="/"  render={renderRedirect} exact={true}/>									
					<$Route path="/DashBoard*" component=${Bundle.load(DashBoard)}/>
					<$Route path="/Accounting" component=${Bundle.load(Accounting)}/>
					
					<$Route path="/Data" component=${Bundle.load(Data)}/>
					<$Route path="/Qc" component=${Bundle.load(QC)}/>
					<$Route path="/Reports" component=${Bundle.load(Reports)}/>
				</div>
			</>
			</$Router>
			');
		}
		
	}
	
	function renderRedirect(p:Dynamic)
	{
		trace(App.store.getState().appWare.redirectAfterLogin);
		//return null;
		return jsx('<RedirectBox {...p} to=${App.store.getState().appWare.redirectAfterLogin}/>');
	}
}