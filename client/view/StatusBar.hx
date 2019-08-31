package view;


import react.ReactComponent.ReactFragment;
import haxe.Timer;
import bulma_components.*;
import react.Partial;
import react.ReactComponent.ReactComponentOf;
import react.ReactDateTimeClock;
import view.shared.io.User;

import react.ReactMacro.jsx;
import redux.react.IConnectedComponent;
import redux.Redux;
import react.router.Route.RouteComponentProps;
import redux.StoreMethods;
import action.AppAction;
import state.AppState;
import view.shared.io.User.UserProps;
import view.shared.DateTime;

import react.intl.ReactIntl;
import react.intl.comp.FormattedDate;
import react.intl.DateTimeFormatOptions.NumericFormat.Numeric;
import react.intl.DateTimeFormatOptions.NumericFormat.TwoDigit;
//import react.addon.intl.FormattedDate;
/**
 * ...
 * @author axel@cunity.me
 */

typedef StatusBarProps =
{
	> RouteComponentProps,
	date:Date,
	status:String,
	user:UserProps,
	userList:Array<UserProps>
}

typedef StatusBarState = 
{
	?date:Date
}
//@:expose('default')
@:connect
class StatusBar extends ReactComponentOf<StatusBarProps,StatusBarState>
	
{
	var mounted:Bool = false;
	var timer:Timer;
	
	public function new(?props:StatusBarProps,?context:Dynamic)
	{
		state = {date:Date.now()};
		//trace(props);
		//trace(context);
		trace('ok');
		super(props);
		//trace(this);
		/*trace(ReactIntl.formatDate(
			Date.now(),	{
			hour: Numeric,
			minute: Numeric
		}));*/
	}
	
	override public function componentDidMount():Void 
	{
		mounted = true;
		var d:Date = Date.now();
		var s:Int = d.getSeconds();
		trace('start delay at $s set timer start in ${(60 - s ) } seconds');
		//return;
		Timer.delay(function(){
			if (!mounted)
			{
				trace('not mounted - will do nothing');
				return;
			}
			trace('timer start at ${Date.now().getSeconds()}');
			//store.dispatch(Tick(Date.now()));
			this.setState({ date: Date.now()});
			timer = new Timer(60000);
			timer.run = function() this.setState({ date: Date.now()});
		}, (60 - d.getSeconds()) * 1000);
		
		//trace(props.dispatch);
	}
	
	override public function componentWillUnmount()
	{
		mounted = false;
		if(timer !=null)
			timer.stop();
	}	
	
	static function mapStateToProps(state:AppState) 
	{
		trace(state.appWare.user.first_name);
		trace(Reflect.fields(state));
		trace(state.appWare.statusBar);
		//setState({status:state.appWare.statusBar.status})
		return {
			/*date:state.statusBar.date,*/
			userList:state.appWare.userList,
			user:state.appWare.user,
			status: state.appWare.statusBar.status//state.appWare.history.location.pathname
		};
		//};
	}

	static function mapDispatchToProps(dispatch:Dispatch, ownProps:Dynamic) {
		//trace(ownProps);
		return {};
	}		
	
	override public function render()
	{
		var id:String = 'Gast';
		var userIcon:String = 'fa fa-user-o';
		//trace(props.user);
		if (props.user != null)
		{
		 id = props.user.first_name != null &&  props.user.first_name !='' ?
		[props.user.first_name , props.user.last_name].join(' ') :'';
		 userIcon = 'fa fa-user';			
		}
		//trace(id +':' + cast id.length);
		return jsx('
		<Footer>
			<div className="statusbar">
				<span className="column" > Status: ${props.status}</span>				
				<span className="column flex-end">
				<i className=${userIcon}></i> $id</span>
				<$DateTime />			
			</div>
		</Footer>
		');
	}

	function DateTimeClock(p:Dynamic):ReactFragment
	{
		trace(p);
		return null;
	}
	
}