package view;
import react.router.RouterMatch;
import view.shared.io.User;

import comments.StringTransform;
import haxe.Timer;
import history.History;
import history.BrowserHistory;
import state.AppState;
import state.UserState;
import react.Fragment;
import react.ReactComponent.ReactFragment;
import react.React;
import react.ReactComponent;
import react.ReactComponent.*;
import react.ReactMacro.jsx;
import react.React.ReactChildren;
import react.ReactPropTypes;
import react.ReactRef;
import redux.Store;
import redux.Redux;
import react.router.NavLink;
import react.router.Redirect;
import react.router.Route;
import react.router.Router;
import react.router.Route.RouteRenderProps;
import react.router.bundle.Bundle;

import bulma_components.Tabs;

import state.AppState;
import App;
import view.DashBoard;

/**
 * ...
 * @author axel@cunity.me
 */

typedef UIProps =
{
	?store:Store<AppState>,
	?userState:UserState
}

typedef UIState =
{
	?hasError:Bool,
	?rFlag:Int
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
		//trace(aState.user.id);
		//trace(Reflect.fields(aState));
		return {
			userState:aState.userState
		};
	}
	
	public function new(props:Dynamic) {
		trace(Reflect.fields(props));
        super(props);
		state = {hasError:false};
		browserHistory = App.store.getState().locationStore.history;// BrowserHistory.create({basename:"/"});
		//ApplicationStore.historyListener(App.store, browserHistory);
		//trace(this.props.userState.state.last_name);
		if (props.userState.dbUser == null) {			
			//browserHistory.push('/');
			browserHistory.replace('/');
		}
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

	override function render()
	{

		//TODO: USEFUL ERROR MESSAGE!
		if (state.hasError ) {
		  return jsx('<h1>Something went wrong.</h1>');
		}

		return jsx('<$DevForm />');
		

	}
	
	function renderRedirect(?p:Dynamic)
	{
		trace(App.store.getState().locationStore.redirectAfterLogin);
		//return null;
		trace(p);
		if(p!=null&&p.to==null)
			p=null;
		return jsx('<RedirectBox to=${p==null?App.store.getState().locationStore.redirectAfterLogin:p.to}/>');
	}
}