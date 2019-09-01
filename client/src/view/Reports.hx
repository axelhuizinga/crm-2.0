package view;

import bulma_components.*;
import state.AppState;
import react.ReactComponent;
import react.ReactDateTimeClock;
import react.ReactMacro.jsx;
import redux.Redux.Dispatch;
import react.Partial;
import react.router.Route.RouteRenderProps;
import view.LoginForm;
import view.shared.RouteTabProps;


import Webpack.*;


//@:expose('default')
@:connect
class Reports extends ReactComponentOfProps<RouteTabProps>
	
{
	var mounted:Bool = false;
	
	public function new(?props:Dynamic, context:Dynamic)
	{
		trace(context);
		super(props);
		//this.state = App.store.getState();
		//trace(this.state);
	}
	
	override public function componentDidMount():Void 
	{
		mounted = true;
		//trace(this.state);
		trace('Ok');
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
			var uState = aState.user;

			//trace(uState);
			
			return {
				appConfig:aState.config,
				redirectAfterLogin:aState.redirectAfterLogin,
				user:uState/*
				id:uState.id,
				pass:uState.pass,
				jwt:uState.jwt,
				loggedIn:uState.loggedIn,
				loginError:uState.loginError,
				last_login:uState.last_login,
				first_name:uState.first_name,
				waiting:uState.waiting*/
			};
		};
	}	
	
    override function render() {
        return jsx('
		<>
            <div className="tabComponent">
				...
            </div>
			<StatusBar {...props}/>
        </>
        ');
    }
}
