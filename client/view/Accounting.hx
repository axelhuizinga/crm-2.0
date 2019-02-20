package view;
import bulma_components.*;
import action.AppAction;
import react.ReactComponent;
import react.ReactDateTimeClock;
import react.ReactMacro.jsx;
import react.Partial;
import react.router.Route.RouteRenderProps;
import redux.react.IConnectedComponent;
import redux.Redux;
import redux.StoreMethods;
import view.shared.RouteTabProps;
//import react.form.Form;
//import react.form.Text;


import Webpack.*;
import model.AppState;

//@:expose('default')
@:connect
class Accounting extends ReactComponentOfProps<RouteTabProps>
	
{
	var mounted:Bool = false;
	
	public function new(?props:Dynamic, context:Dynamic)
	{
		trace(context);
		//this.state = App.store.getState().appWare;
		super(props);
		//trace(this.state);
	}

	static function mapDispatchToProps(dispatch:Dispatch) {
		return {
			onTodoClick: function(id:Int) return dispatch(AppAction.SetTheme('orange'))
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

		return function(aState:model.AppState) 
		{
			var uState = aState.appWare.user;

			//trace(uState);
			
			return {
				appConfig:aState.appWare.config,
				user:uState,
				/*pass:uState.pass,
				jwt:uState.jwt,
				loggedIn:uState.loggedIn,
				loginError:uState.loginError,
				last_login:uState.last_login,
				first_name:uState.first_name,
				user_name:uState.user_name,*/
				redirectAfterLogin:aState.appWare.redirectAfterLogin
			};
		};
	}	
	
    override function render() 
	{
		return jsx('
		<>
            <div className="tabContent2">
				...
            </div>
			<StatusBar {...props}/>
        </>
        ');
    }
}
