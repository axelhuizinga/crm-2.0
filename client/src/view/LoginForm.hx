package view;

import js.html.Event;
import haxe.Timer;
import js.html.audio.WaveShaperOptions;
import action.UserAction;
import react.ReactComponent.ReactFragment;
import react.ReactType;
import js.html.Image;
import js.html.InputElement;
import js.html.InputEvent;
import js.html.XMLHttpRequest;
import state.AppState;
import state.UserState;
import react.Partial;
import react.ReactComponent.ReactComponentOf;
import react.ReactMacro.jsx;
import react.ReactUtil.copy;
import redux.Redux;
import action.async.UserAccess;
import view.shared.RouteTabProps;

using shared.Utils;
using StringTools;


typedef LoginProps =
{
	//>RouteTabProps,
	
	//?loginTask:LoginTask,
	?resetPassword:UserState->Dispatch,
	?stateChange:UserState->Dispatch,
	?submitLogin:UserState->Dispatch,
	user:UserState,
	//api:String,	
	/*?change_pass_required:Bool,
	?reset_password:Bool,	
	?email:String,
	pass:String,
	new_pass:String,
	?jwt:String,
	loggedIn:Bool,	
	?loginError:String,
	?last_login:Date,
	//?first_name:String,
	user_name:String,*/
	redirectAfterLogin:String,
	//waiting:Bool
}

/**
 * ...
 * @author axel@cunity.me
 */


@:connect
class LoginForm extends ReactComponentOf<LoginProps, UserState>
{
	var submitValue:String;
	static var uBCC:Dynamic;
	static var uBState:Dynamic;

	public function new(?props:LoginProps)
	{
		trace(Reflect.fields(props));
		super(props);
		trace(props);
		submitValue = '';
		state = copy(props.user,{waiting:true});//{user_name:'',pass:'',new_pass_confirm: '', new_pass: '',waiting:true};
	}

	/*static function doTry(ev:Event):Dynamic {
		ev.preventDefault();
		uBCC[1]('logout');
		uBState[1]('logout');
		trace(uBCC[0]);
		trace(uBState[0]);

		return false;
	}

	static public function WinCom() {

		uBCC = App.useBrowserContextCommunication('channel');
		trace(uBCC);		
		uBState = App.useState('login');
		trace(uBState);			
		//uBState[1]('logout');
		return jsx('<div>
		<span onClick=${doTry} >${uBState[0]}</span>
		</div>');
	}*/

	static function mapDispatchToProps(dispatch:Dispatch) {
		trace('ok');
		return {
			dispatch:dispatch,
			submitLogin: function(lState:UserState) return dispatch(
				lState.new_pass != null ?
				UserAccess.changePassword(lState):
				UserAccess.doLogin(lState)),
			resetPassword: function (lState:UserState) return dispatch(UserAccess.resetPassword(lState)),
			stateChange: function (lState:UserState) return dispatch(UserAction.LoginChange(lState))
		};
	}

	override public function shouldComponentUpdate(nextProps:LoginProps, nextState:UserState) {
		trace('propsChanged:${nextProps!=props}');
		trace('stateChanged:${nextState!=state}');
		if(nextState!=state)
		{
			state.compare(nextState);
		}
		if(nextProps!=props)
		{
			//props.compare(nextProps);
			props.user.compare(nextProps.user);
		}
		return true;
	}

	override public function componentDidMount():Void 
	{
		var img = new Image();
		//setState({waiting:true});
		img.onload = function(){
			trace(state);
			Timer.delay(function() setState({waiting:false}),500);
			trace('ok');
		}
		img.src = "img/schutzengelwerk-logo.png";
		trace(props.redirectAfterLogin);
	}
	
	static function mapStateToProps() {

		return function(aState:AppState):Partial<LoginProps>
		{
			var uState = aState.user;
			trace(aState.locationStore.redirectAfterLogin);
			trace(uState);		
			if(uState.loginTask == LoginTask.ChangePassword)
			//if(aState.locationState.redirectAfterLogin != null && aState.locationState.redirectAfterLogin.startsWith('/ChangePassword'))
			{
				var rAL:String = aState.locationStore.redirectAfterLogin;
				trace(rAL);
				var param:Map<String,Dynamic> = rAL.argList(
					['action','jwt','user_name','opath']
				);
				trace(param);
				
				return {
					user:uState,
					redirectAfterLogin:aState.locationStore.redirectAfterLogin
				};
			}
			return {
				user:uState,
				redirectAfterLogin:aState.locationStore.redirectAfterLogin
			};
		};
	}	
	
	function handleChange(e:InputEvent)
	{
		var s:Dynamic = {};
		var t:InputElement = cast e.target;
		trace(t.name);
		trace(t.value);
		if(t.name == 'new_pass' && t.value==props.user.pass)
		{
			t.value='';
		}
		//t.className = 'input';
		Reflect.setField(s, t.name, t.value);
		props.stateChange(copy(props.user,s));
		//trace(props.dispatch + '==' + App.store.dispatch);
		//trace(props.dispatch == App.store.dispatch);
		//App.store.dispatch(AppAction.LoginChange(s));
		//TODO: PUT INTO Global State to avoid rerender
		//this.setState(s);
		trace(this.state);
	}
	
	function handleSubmit(e:InputEvent)
	{
		e.preventDefault();
		trace(props);
		trace(state);
		trace(submitValue);
		if(submitValue=='Login')
		{
			props.submitLogin({user_name:props.user.user_name, pass:props.user.pass, jwt:''});		
			return true;	
		}
		switch (props.user.loginTask)
		{
			case LoginTask.ResetPassword:
				trace('Reset Password requested');
				trace(props);
				props.resetPassword(props.user);
				return false;
			case LoginTask.ChangePassword:
				props.submitLogin({user_name:props.user.user_name, new_pass:props.user.new_pass,pass:props.user.pass, jwt:props.user.jwt});
			default:
			props.submitLogin(
				props.user.change_pass_required?
				{user_name:props.user.user_name, new_pass:props.user.new_pass,pass:props.user.pass, jwt:props.user.jwt}:
				{user_name:props.user.user_name, pass:props.user.pass, jwt:''});			 	
		} 
		return true;
	}	

	function resetPassword(_)
	{
		trace('OK');
	}

	public function  renderForm():ReactFragment
	{		
		
		trace(props.redirectAfterLogin);
		trace(props.user);
		
		//if(props.redirectAfterLogin != null && props.redirectAfterLogin.startsWith('/ResetPassword'))
		
		if(props.user.loginTask == CheckEmail)
		return jsx('
				  	<form name="form" onSubmit={handleSubmit} className="login" >
						<div className="formField">
							<img className="center" src="img/emblem-mail.png"/>
						</div>
						<div className="formField">
							<span className="center">${props.user.email} hat eine neue Nachricht!</span>
						</div>
					</form>
		');
		if(props.user.loginTask == ChangePassword)
		{
			return jsx('
					<form name="form" onSubmit={handleSubmit} className="login" >
						<input  name="pass" type="hidden" value=${props.user.pass} />														
						<div className="formField">
							<h3>Bitte neues Passwort eintragen!</h3>
						</div>
						<div className="formField">
								<label className="fa userIcon" forhtml="login_user_name">
										<span className="hidden">User ID</span>
								</label>
								<input id="login_user_name" name="user_name" disabled="disabled" 
								className=${errorStyle("user_name") + "form-input"}  
								placeholder="User ID" value=${props.user.user_name} onChange={handleChange} />
						</div>
						<div className="formField">
								<label className="fa lockIcon" forhtml="pw">
										<span className="hidden">Password</span>
								</label>
								<input  className=${errorStyle("new_pass") + "form-input"} name="new_pass" type="password" placeholder="New Password" value=${state.new_pass} onChange=${handleChange} />
						</div>
						<div className="formField">
								<label className="fa lockIcon" forhtml="pw">
										<span className="hidden">Password</span>
								</label>
								<input  className=${errorStyle("new_pass_confirm") + "form-input"} name="new_pass_confirm" type="password" placeholder="Confirm New Password" value=${state.new_pass_confirm} onChange=${handleChange} />
						</div>							
						<div className="formField">
								<input type="submit" style=${{width:'100%'}} value="Absenden" />
						</div>
					</form>'
				);
		}

		if(props.user.change_pass_required)
		{
			return jsx('
					<form name="form" onSubmit={handleSubmit} className="login" >
						<input  name="pass" type="hidden" value=${props.user.pass} />														
						<div className="formField">
							<h3>Bitte neues Passwort eintragen!</h3>
						</div>
						<div className="formField">
								<label className="fa userIcon" forhtml="login_user_name">
										<span className="hidden">User ID</span>
								</label>
								<input id="login_user_name" name="user_name" disabled="disabled" 
								className=${errorStyle("user_name") + "form-input"}  
								placeholder="User ID" value=${props.user.user_name} onChange={handleChange} />
						</div>
						<div className="formField">
								<label className="fa lockIcon" forhtml="pw">
										<span className="hidden">Password</span>
								</label>
								<input  className=${errorStyle("new_pass") + "form-input"} name="new_pass" type="password" placeholder="New Password" value=${props.user.new_pass} onChange=${handleChange} />
						</div>
						<div className="formField">
								<label className="fa lockIcon" forhtml="pw">
										<span className="hidden">Password</span>
								</label>
								<input  className=${errorStyle("new_pass_confirm") + "form-input"} name="new_pass_confirm" type="password" placeholder="Confirm New Password" value=${state.new_pass_confirm} onChange=${handleChange} />
						</div>							
						<div className="formField">
								<input type="submit" style=${{width:'100%'}} value="Login" />
						</div>
					</form>'
				);
		}		

		return jsx('
				  	<form name="form" onSubmit={handleSubmit} className="login" >
						<div className="formField">
								<label className="fa userIcon" forhtml="login_user_name">
										<span className="hidden">User ID</span>
								</label>
								<input id="login_user_name" name="user_name" 
								className=${errorStyle("user_name") + "form-input"}  
								placeholder="User ID" value=${props.user.user_name} onChange=${handleChange} />
						</div>
						<div className="formField">
								<label className="fa lockIcon" forhtml="pw">
										<span className="hidden">Password</span>
								</label>
								<input id="pw" className=${errorStyle("pass") + "form-input"} name="pass" value=${props.user.pass} type="password" placeholder="Password" onChange=${handleChange} />
						</div>
						<div className="formField">
								<input type="submit" style=${{width:'100%'}} value="Login" onClick=${function(){submitValue='Login';return true;}}/>
						</div>
						<div className="formField" style=${{display: (props.user.loginTask == ResetPassword? 'flex':'none')}} 
						 onClick=${function(){submitValue='ResetPassword';return true;}}>
								<input type="submit" value="Passwort vergessen?"/>
						</div>
					</form>
		');
		return null;
	}

	override public function render()
	{
		trace(Reflect.fields(props));
		
		trace(props.user.loginError);
		trace(state.waiting);
		var style = 
		{
			maxWidth:'32rem'
		};
		
		if (state.waiting)
		{
			return jsx('
			<section className="hero is-alt is-fullheight">
			  <div className="hero-body">
			  <div className="loader"  style=${{width:'7rem', height:'7rem', margin:'auto', borderWidth:'0.58rem'}}/>
			  </div>
			</section> 
			');		
		}

		return jsx('
			<section className="hero is-alt is-fullheight">
			<div className="formContainer">
				<div className="formBox is-rounded" style=${style}>
					<div className="logo">
					<img src="img/schutzengelwerk-logo.png" style=${{width:'100%'}}/>
					<h2 className="overlaySubTitle">				  
					crm 2.0
					</h2>
					</div> 
					<div className="form2">						
						${renderForm()}						
					</div>
				</div>
			</div>
			</section>		
		');
	}
	
	function errorStyle(name:String):String
	{
		var eStyle = switch(name)
		{
			case "pass":
				var res = props.user.loginError == "pass"?"error ":"";
				trace(res);
				res;
				
			case "user_name":
				props.user.loginError == "user_name"?"error ":"";
			
			case "new_pass_confirm":
				props.user.new_pass != props.user.new_pass_confirm?"error ":"";

			default:
				'';
		}
		trace(eStyle);
		return eStyle;
	}
	
}