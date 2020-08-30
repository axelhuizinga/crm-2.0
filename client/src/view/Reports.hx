package view;

import bulma_components.*;
import state.AppState;
import react.ReactComponent;
import react.ReactDateTimeClock;
import react.ReactMacro.jsx;
import react.router.Route;
import react.router.RouterMatch;
import react.router.Redirect;
import react.Partial;
import react.router.Route.RouteRenderProps;
import react.router.Switch;
import react.router.NavLink;
import view.shared.io.FormApi;
import view.shared.DataProps;
import view.shared.RouteTabProps;
import view.shared.CompState;
import view.shared.TabLink;
import view.stats.History;
import view.stats.Performance;
import view.stats.Preview;

@:connect
class Reports extends ReactComponentOf<DataProps,CompState>	
{
	var mounted:Bool = false;
	
	public function new(?props:DataProps, context:Dynamic)
	{
		trace(context);
		super(props);
		//this.state = App.store.getState();
		//trace(this.state);
		if (props.match.url == '/Reports' && props.match.isExact)
		{
			trace('pushing2: /Reports/History');
			props.history.push('/Reports/History/Charts/get');
		}		
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
			trace(Reflect.fields(aState));
			return {
				appConfig:aState.config,
				//redirectAfterLogin:aState.locationStore.redirectAfterLogin,
				userState:aState.userState
			};
		};
	}	
	
    override function render() {
        return jsx('
		<>
            <div className="tabNav2" >
				<$Tabs className="is-boxed" >
					<$TabLink to="/Reports/History" ${...props} >Entwicklung</$TabLink>
					<$TabLink to="/Reports/Preview" ${...props} >Vorschau</$TabLink>
				</$Tabs>
			</div>
            <div className="tabContent2" >
			<$Switch>
				<$Route path="/Reports/History/:section?/:action?/:id?"  ${...props} component={History}/>
				<$Route path="/Reports/Preview/:section?/:action?/:id?"   ${...props} component={Preview}/>	
				
            </$Switch>
			</div>
			<StatusBar {...props}/>
        </>
        ');
    }
}
/**
					<$TabLink to="/Reports/Performance" ${...props} >Leistung</$TabLink>
				<$Route path="/Reports/Performance/:section?/:action?/:id?"  ${...props} component={Performance}/>

 * 
 */
