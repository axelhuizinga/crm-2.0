package view;

import bulma_components.*;
import model.AppState;
import react.ReactComponent;
import react.ReactDateTimeClock;
import react.ReactMacro.jsx;
import redux.Redux.Dispatch;
import react.Partial;
import react.router.Route.RouteRenderProps;
import redux.react.IConnectedComponent;
import redux.StoreMethods;
import view.shared.RouteTabProps;
//import react.form.Form;
//import react.form.Text;


import Webpack.*;

//@:expose('default')
@:connect
class QC extends ReactComponentOf<RouteTabProps, Dynamic>
	
{
	var mounted:Bool = false;
	
	public function new(?props:Dynamic, context:Dynamic)
	{
		trace(context);
		//this.state = App.store.getState().appWare;
		super(props);
		///trace(this.state);
	}
	
	override public function componentDidMount():Void 
	{
		mounted = true;
		//trace(this);
	}
	
	override function componentDidCatch(error, info) {
		// Display fallback UI
		//this.setState({ hasError: true });
		// You can also log the error to an error reporting service
		//logErrorToMyStore(error, info);
		trace(error);
	}	
		
	static function mapStateToProps() {

		return function(aState:model.AppState) 
		{
			var uState = aState.appWare.user;

			//trace(uState);
			
			return {
				appConfig:aState.appWare.config,
				redirectAfterLogin:aState.appWare.redirectAfterLogin,
				user:uState/*
				user_name:uState.user_name,
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
		trace(props);	
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
