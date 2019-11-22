package view;

import react.ReactComponent.ReactFragment;
import react.ReactType;
import js.html.Image;
import js.html.InputElement;
import js.html.InputEvent;
import js.html.XMLHttpRequest;
import state.AppState;
import state.UserState;
import react.ReactComponent.ReactComponentOf;
import react.ReactMacro.jsx;
import react.ReactUtil;
import redux.Redux;
import action.async.UserAccess;
import view.shared.RouteTabProps;

using shared.Utils;
using StringTools;

typedef LoginProps =
{
	>RouteTabProps,
	?submitLogin:UserState->Dispatch,
	//user:UserState,
	api:String,	
	?change_pass_required:Bool,
	?reset_password:Bool,
	pass:String,
	new_pass:String,
	?jwt:String,
	loggedIn:Bool,
	?loginError:String,
	?last_login:Date,
	//?first_name:String,
	user_name:String,
	redirectAfterLogin:String,
	waiting:Bool
}

/**
 * ...
 * @author axel@cunity.me
 */

//@:expose('default')
@:connect
class LoginForm extends ReactComponentOf<LoginProps, UserState>
{
	var submitValue:String;

	public function new(?props:LoginProps)
	{
		super(props);
		trace(Reflect.fields(props));
		if (props.match != null)
		{
			trace(props.match.path + ':' + props.match.url);	
		}
		trace(props);
		state = {user_name:'',pass:'',new_pass_confirm: '', new_pass: '',waiting:true};
	}

	static function mapDispatchToProps(dispatch:Dispatch) {
		trace('ok');
		return {
			submitLogin: function(lState:UserState) return dispatch(
				lState.new_pass != null ?
				UserAccess.changePassword(lState):
				UserAccess.doLogin(lState)),
			resetPW: function (lState:UserState) return dispatch(UserAccess.resetPassword(lState))
		};
	}

	override public function componentDidMount():Void 
	{
		var img = new Image();
		//setState({waiting:true});
		img.onload = function(){
			trace(state);
			setState({waiting:false});
			trace('ok');
		}
		img.src = "img/schutzengelwerk-logo.png";
		trace(state);
	}
	
	static function mapStateToProps() {

		return function(aState:AppState):LoginProps
		{
			var uState = aState.user;
			trace(aState.locationState.redirectAfterLogin);
			trace(uState);		
			if(aState.locationState.redirectAfterLogin != null && aState.locationState.redirectAfterLogin.startsWith('/ResetPassword'))
			{
				var param:Map<String,Dynamic> = aState.locationState.redirectAfterLogin.argList(
					['action','user_name','oPath']
				);
				return{
					api:App.config.api,
					change_pass_required:false,
					pass:uState.pass,
					new_pass:(uState.new_pass!=null?uState.new_pass:''),
					jwt:uState.jwt,
					//mandator:uState.mandator,
					loggedIn:false,
					user_name:param.get('user_name'),
					redirectAfterLogin:param.get('oPath'),
					user:null,
					waiting:false
				};
			}
			return {
				api:App.config.api,
				change_pass_required:uState.change_pass_required,
				pass:uState.pass,
				new_pass:(uState.new_pass!=null?uState.new_pass:''),
				jwt:uState.jwt,
				//mandator:uState.mandator,
				loggedIn:uState.loggedIn,
				loginError:uState.loginError,
				last_login:uState.last_login,
				//first_name:uState.first_name,
				user:uState,
				user_name:uState.user_name,
				redirectAfterLogin:aState.locationState.redirectAfterLogin,
				waiting:uState.waiting
			};
		};
	}	
	
	function handleChange(e:InputEvent)
	{
		var s:Dynamic = {};
		var t:InputElement = cast e.target;
		trace(t.name);
		trace(t.value);
		if(t.name == 'new_pass'&& t.value==props.pass)
		{
			t.value='';
		}
		//t.className = 'input';
		Reflect.setField(s, t.name, t.value);
		//trace(props.dispatch + '==' + App.store.dispatch);
		//trace(props.dispatch == App.store.dispatch);
		//App.store.dispatch(AppAction.LoginChange(s));
		//TODO: PUT INTO Global State to avoid rerender
		this.setState(s);
		trace(this.state);
	}
	
	function handleSubmit(e:InputEvent)
	{
		e.preventDefault();
		trace(submitValue);
		if(submitValue == 'resetPW')
		{
			return;
		}
		//trace(state); //return;
		//this.setState({waiting:true});
		//props.dispatch(AppAction.Login("{user_name:state.user_name,pass:state.pass}"));
		//trace(props.dispatch);
		props.submitLogin(
			props.change_pass_required?
			{user_name:state.user_name, new_pass:state.new_pass,pass:props.pass, jwt:''}:
			{user_name:state.user_name, pass:state.pass, jwt:''});
		//trace(_dispatch == App.store.dispatch);
		//trace(App.store.dispatch(UserAction.loginReq(state)));
		//trace(props.dispatch(AppAction.LoginReq(state)));
	}	

	function resetPW(_)
	{
		trace('OK');
	}

	public function  renderForm():ReactFragment
	{		
		trace(props.redirectAfterLogin);
		if(props.redirectAfterLogin != null && props.redirectAfterLogin.startsWith('/ResetPassword'))
		{
			return jsx('
					<form name="form" onSubmit={handleSubmit} className="login" >
						<input  name="pass" type="hidden" value=${props.pass} />														
						<div className="formField">
							<h3>Bitte neues Passwort eintragen!</h3>
						</div>
						<div className="formField">
								<label className="fa userIcon" forhtml="login_user_name">
										<span className="hidden">User ID</span>
								</label>
								<input id="login_user_name" name="user_name" disabled="disabled" 
								className=${errorStyle("user_name") + "form-input"}  
								placeholder="User ID" value=${state.user_name} onChange={handleChange} />
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
								<input type="submit" style=${{width:'100%'}} value="Login" />
						</div>
					</form>'
				);
		}

		if(props.change_pass_required)
		{
			return jsx('
					<form name="form" onSubmit={handleSubmit} className="login" >
						<input  name="pass" type="hidden" value=${props.pass} />														
						<div className="formField">
							<h3>Bitte neues Passwort eintragen!</h3>
						</div>
						<div className="formField">
								<label className="fa userIcon" forhtml="login_user_name">
										<span className="hidden">User ID</span>
								</label>
								<input id="login_user_name" name="user_name" disabled="disabled" 
								className=${errorStyle("user_name") + "form-input"}  
								placeholder="User ID" value=${state.user_name} onChange={handleChange} />
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
								placeholder="User ID" value=${state.user_name} onChange=${handleChange} />
						</div>
						<div className="formField">
								<label className="fa lockIcon" forhtml="pw">
										<span className="hidden">Password</span>
								</label>
								<input id="pw" className=${errorStyle("pass") + "form-input"} name="pass" type="password" placeholder="Password" value=${state.pass} onChange=${handleChange} />
						</div>
						<div className="formField">
								<input type="submit" style=${{width:'100%'}} value="Login" />
						</div>
						<div className="formField" style=${{display: (props.loginError == null? 'none':'flex')}}>
								<input type="submit" value="Passwort vergessen?" name="resetPW"  onClick=${function(){this.submitValue="resetPW";}}/>
						</div>
					</form>
		');
		return null;
	}

	override public function render()
	{
		trace(Reflect.fields(props));
		
		trace(props.loginError);
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
				var res = props.loginError == "pass"?"error ":"";
				trace(res);
				res;
				
			case "user_name":
				props.loginError == "user_name"?"error ":"";
			
			case "new_pass_confirm":
				state.new_pass != state.new_pass_confirm?"error ":"";

			default:
				'';
		}
		trace(eStyle);
		return eStyle;
	}
	
}