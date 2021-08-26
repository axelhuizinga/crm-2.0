package view;

import redux.Store;
import db.DbUser;
import haxe.Exception;
import me.cunity.debug.Out;
import js.html.HTMLDocument;
import js.Browser;
import js.html.Document;
import action.AppAction;
import db.LoginTask;
import js.html.Event;
import haxe.Timer;
import js.html.audio.WaveShaperOptions;
import action.UserAction;
import react.ReactComponent.ReactFragment;
import react.ReactType;
import js.html.FormElement;
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
	?resetPassword:UserState->Dispatch,
	?stateChange:UserState->Dispatch,
	?submitLogin:UserState->Dispatch,
	userState:UserState,
	redirectAfterLogin:String,
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
		trace(props.submitLogin);
		super(props);
		submitValue = '';
		if(props.userState.dbUser == null ){
			trace(App.store.getState().userState);
		}
		state = copy(props.userState,{waiting:false});//{user_name:'',pass:'',new_pass_confirm: '', new_pass: '',waiting:true};
	}

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
		trace('propsChanged:${nextProps!=props} stateChanged:${nextState!=state}');
		if(nextState!=state)
		{
			state.compare(nextState);
		}
		if(nextProps!=props)
		{
			//props.compare(nextProps);
			props.userState.dbUser.compare(nextProps.userState);
		}
		return true;
	}

	override public function componentDidMount():Void 
	{
		var img = new Image();
		//setState({waiting:true});
		img.onload = function(){
			//Out.dumpObject(state);
			//Timer.delay(function() setState({waiting:false}),500);
			trace('img.onload:ok');
		}
		img.src = "img/schutzengelwerk-logo.png";
		if(App.devPassword!='' && App.devUser!=''){
			var doc:HTMLDocument = Browser.document;
			var user_name:InputElement = cast(doc.querySelector('input[name="user_name"]'),InputElement);
			//props.userState.dbUser.user_name = user_name.value = App.devUser;
			props.userState.dbUser.user_name = App.devUser;
			var password:InputElement = cast(doc.querySelector('input[name="password"]'),InputElement);
			var formElement:FormElement = cast(doc.querySelector('form[name="form"]'),FormElement);
			//props.userState.dbUser.password = password.value = App.devPassword;
			props.userState.dbUser.password = App.devPassword;
			//formElement.submit();
			Out.dumpObject(props.userState);
			props.submitLogin(props.userState);
		}
		trace(props.redirectAfterLogin);
	}
	
	static function mapStateToProps() {

		return function(aState:AppState):Partial<LoginProps>
		{
			var uState = aState.userState;
			trace(aState.locationStore.redirectAfterLogin);
			//Out.dumpObject(uState);		
			if(uState.loginTask == LoginTask.ChangePassword)
			{
				var rAL:String = aState.locationStore.redirectAfterLogin;
				trace(rAL);
				var param:Map<String,Dynamic> = rAL.argList(
					['action','jwt','user_name','opath']
				);
				trace(param);
				
				return {
					userState:uState,
					redirectAfterLogin:aState.locationStore.redirectAfterLogin
				};
			}
			return {
				userState:uState,
				redirectAfterLogin:aState.locationStore.redirectAfterLogin
			};
		};
	}	
	
	function handleChange(e:InputEvent)
	{
		var s:Dynamic = {dbUser:props.userState.dbUser};
		var t:InputElement = cast e.target;
		trace(t.name);
		if(t.name!='password' && t.name!='new_pass')
		trace(t.value);
		try{
			if(t.name == 'new_pass' && t.value==props.userState.dbUser.password)
			{
				//password not changed
				t.value='';
			}
			//TODO: HANDLE CHANGE
			Reflect.setField((t.name.indexOf('new_pass')==-1? s.dbUser:s), t.name, t.value);
			props.stateChange(copy(props.userState,s));
			//trace(props.dispatch + '==' + App.store.dispatch);
			//App.store.dispatch(UserAction.LoginChange(s));
			//TODO: PUT INTO Global State to avoid rerender
			//this.setState(s);
			trace(this.state);
		}
		catch(ex:Exception){
			trace(ex.details);
		}
	}
	
	function handleSubmit(e:InputEvent)
	{
		e.preventDefault();
		trace(props);
		trace(state);
		trace(submitValue);
		if(submitValue=='Login')
		{
			//props.userState.dbUser.updateDyn(
				//{user_name:props.userState.dbUser.user_name, password:props.userState.dbUser.password, jwt:''});
			if(props.userState.dbUser==null){
				var appStore:Store<AppState> = App.store;//.getState();
				//trace(appStore);
				// CREATE USER INSTANCE
				//appStore.dispatch({});
				return;
				//props.userState.dbUser = new DbUser();
			}
			props.submitLogin(props.userState);		
			return;	
		}
		switch (props.userState.loginTask)
		{
			case LoginTask.ResetPassword:
				trace('Reset Password requested');
				trace(props);
				props.resetPassword(props.userState);
				return;
			case LoginTask.ChangePassword:
				
				props.submitLogin({ new_pass:props.userState.new_pass, dbUser: props.userState.dbUser.updateDyn({
					user_name:props.userState.dbUser.user_name,
					password:props.userState.dbUser.password, 
					jwt:props.userState.dbUser.jwt
				})});
			default:
				var dbUserProps = props.userState.dbUser.updateDyn({
					user_name:props.userState.dbUser.user_name,
					password:props.userState.dbUser.password, 
					jwt:props.userState.dbUser.jwt
				});
				props.submitLogin(
					props.userState.dbUser.change_pass_required?
					{ new_pass:props.userState.new_pass,dbUser: dbUserProps}:
					{ dbUser: dbUserProps});			 	
		} 
		return;
	}	

	public function  renderForm():ReactFragment
	{				
		trace(props.redirectAfterLogin);
		//Out.dumpObject(props.userState.dbUser);
		trace('error_style password:'+errorStyle("password"));
		//if(props.redirectAfterLogin != null && props.redirectAfterLogin.startsWith('/ResetPassword'))
		
		if(props.userState.loginTask == CheckEmail)
		return jsx('
				  	<form name="form" onSubmit={handleSubmit} className="login" >
						<div className="formField">
							<img className="center" src="img/emblem-mail.png"/>
						</div>
						<div className="formField">
							<span className="center">${props.userState.dbUser.email} hat eine neue Nachricht!</span>
						</div>
					</form>
		');
		if(props.userState.loginTask == ChangePassword)
		{
			return jsx('
					<form name="form" onSubmit={handleSubmit} className="login" >
						<input  name="password" type="hidden" value=${props.userState.dbUser.password} />														
						<div className="formField">
							<h3>Bitte neues Passwort eintragen!</h3>
						</div>
						<div className="formField">
								<label className="fa userIcon" forhtml="login_user_name">
										<span className="hidden">User ID</span>
								</label>
								<input id="login_user_name" name="user_name" disabled="disabled" 
								className=${errorStyle("user_name") + "form-input"}  
								placeholder="User ID" value=${props.userState.dbUser.user_name} onChange={handleChange} />
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

		if(props.userState.dbUser != null && props.userState.dbUser.change_pass_required)
		{trace('props.userState.dbUser.change_pass_required:'+props.userState.dbUser.change_pass_required);
			return jsx('
					<form name="form" onSubmit={handleSubmit} className="login" >
						<input  name="password" type="hidden" value=${props.userState.dbUser.password} />														
						<div className="formField">
							<h3>Bitte neues Passwort eintragen!</h3>
						</div>
						<div className="formField">
								<label className="fa userIcon" forhtml="login_user_name">
										<span className="hidden">User ID</span>
								</label>
								<input id="login_user_name" name="user_name" disabled="disabled" 
								className=${errorStyle("user_name") + "form-input"}  
								placeholder="User ID" value=${props.userState.dbUser.user_name} onChange={handleChange} />
						</div>
						<div className="formField">
								<label className="fa lockIcon" forhtml="pw">
										<span className="hidden">Password</span>
								</label>
								<input  className=${errorStyle("new_pass") + "form-input"} name="new_pass" type="password" placeholder="New Password" value=${props.userState.new_pass} onChange=${handleChange} />
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
		//trace(props.userState.loginTask);value=${props.userState.dbUser == null?'':props.userState.dbUser.user_name} 
		return jsx('
				  	<form name="form" onSubmit={handleSubmit} className="login" >
						<div className="formField">
								<label className="fa userIcon" forhtml="login_user_name">
										<span className="hidden">User ID</span>
								</label>
								<input id="login_user_name" name="user_name"  autoComplete="username"
								className=${errorStyle("user_name") + " form-input"}  
								placeholder="User ID" onChange=${handleChange} />
						</div>
						<div className="formField">
								<label className="fa lockIcon" forhtml="pw">
										<span className="hidden">Password</span>
								</label>
								<input id="pw" className=${errorStyle("password") + " form-input"} name="password"  autoComplete="current-password"  type="password" placeholder="Password" onChange=${handleChange} />
						</div>
						<div className="formField">
								<input type="submit" style=${{width:'100%'}} value="Login" onClick=${function(){submitValue='Login';return true;}}/>
						</div>
						<div className="formField" style=${{display: (
							props.userState.loginTask == ResetPassword || props.userState.lastError!=null && props.userState.lastError.indexOf("password")>-1 ? 'flex':'none')}} 
						 onClick=${function(){submitValue='ResetPassword';return true;}}>
								<input type="submit" value="Passwort vergessen?"/>
						</div>
					</form>
		');
		return null;
		//value=${props.userState.dbUser.password}
	}

	override public function render()
	{
		//trace(Reflect.fields(props));
		//trace(props.userState.lastError);
		//trace(state.waiting);
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
		trace(name);
		var eStyle = switch(name)
		{
			case "password":
				var res = (props.userState.lastError!=null && props.userState.lastError.indexOf("password")>-1?"error ":"");
				trace(res);
				res;
				
			case "user_name":
				var res =  props.userState.lastError!=null && props.userState.lastError.indexOf("user_name")>-1?"error ":"";
				res;
			
			case "new_pass_confirm":
				var res = props.userState.new_pass != props.userState.new_pass_confirm?"error ":"";
				res;

			default:
				"";
		}
		//Out.dumpObject(props.userState);
		//trace(eStyle);
		return eStyle;
	}
	
}