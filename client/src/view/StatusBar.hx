package view;


import react.ReactUtil;
import state.UserState;
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
	?className:String,
	date:Date,
	userState:UserState,
	path:String,
	?text:String,
	?userList:Array<UserState>
}

typedef StatusBarState = 
{
	?path:String,
	?text:String,
	?date:Date,
	?className:String,
	userState:UserState,
}

@:connect
class StatusBar extends ReactComponentOf<StatusBarProps,StatusBarState>	
{
	var mounted:Bool = false;
	var timer:Timer;
	
	public function new(?props:StatusBarProps,?context:Dynamic)
	{
		state = ReactUtil.copy(props, {date:Date.now()});
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
	
	static function mapStateToProps(astate:AppState) 
	{
		//trace(astate.userState.dbUser.first_name);
		trace(Reflect.fields(astate));
		trace(astate.status);
		//setState({status:astate.statusBar.status})
		return {
			/*date:astate.statusBar.date,*/
			//userList:astate.userList,
			className: astate.status.className==null?'':astate.status.className,
			userState: astate.userState,
			path: astate.status.path,
			text: astate.status.text
		};
		//};
	}	
	
	override public function render()
	{
		var display_name:String = 'Gast';
		var userIcon:String = 'fa fa-user-o';
		trace(props.path);
		if (props.userState.dbUser != null)
		{
		 display_name = props.userState.dbUser.first_name != null &&  props.userState.dbUser.first_name !='' ?
			[props.userState.dbUser.first_name , props.userState.dbUser.last_name].join(' ') :'';
		 userIcon = 'fa fa-user';			
		}
		//trace(display_name +':' + cast display_name.length);
		return jsx('
		<Footer>
			<div className="statusbar">
				<span className="column ${props.className}" >${props.path}</span>	
				<span className="column ${props.className}" >${props.text}</span>			
				<span className="column flex-end">
				<i className=${userIcon}></i> $display_name</span>
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