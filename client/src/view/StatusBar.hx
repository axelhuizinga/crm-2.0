package view;


import me.cunity.debug.Out;
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
		trace(Reflect.field(this,'setState'));
		state = ReactUtil.copy(props, {date:Date.now()});
		super(props);
		trace(Reflect.fields(state).join('|'));
		trace(state.userState.dbUser.id);
		trace(Reflect.field(this,'setState'));
	}
	
	override public function componentDidMount():Void 
	{
		mounted = true;
		var d:Date = Date.now();
		var s:Int = d.getSeconds();
		trace('start delay at $s set timer start in ${(60 - s ) } seconds');
		Timer.delay(function(){
			trace('timer start at ${Date.now().getSeconds()}');
			//this.setState({ date: Date.now()});
			state.date = Date.now();
			timer = new Timer(60000);
			timer.run = function() this.setState({ date: Date.now()});
		}, (60 - d.getSeconds()) * 1000);
		
		trace(props.children);
	}
	
	override public function componentWillUnmount()
	{
		mounted = false;
		if(timer !=null)
			timer.stop();
	}	
	
	static function mapStateToProps(astate:AppState) 
	{
		return {
			className: astate.status.className==null?'':astate.status.className,
			userState: astate.userState,
			path: astate.status.path,
			text: astate.status.text
		};
	}	
	
	override public function render()
	{
		var userIcon:String = 'fa fa-user-o';
		var display_name:String = 'Gast';
		var display_text:String = props.text;
		if(!Std.isOfType(props.text,String))
		{
			//Out.dumpObject(props.text);
			trace(Reflect.fields(props));
			if(false||props.text==null)
				trace(props);
			//return null;
			display_text = '';
		}
		//trace(props);
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
				<span className="column" >${props.path}</span>	
				<span className="main column ${props.className}" >${display_text}</span>			
				<span className="column flex-end">
				<i className=${userIcon}></i> $display_name</span>
				<$DateTime />			
			</div>
		</Footer>
		');
	}

}