import js.html.Window;
import view.shared.FormBuilder;
import view.shared.FormState;
import view.shared.SMenuProps;
import react.intl.DateTimeFormatOptions.NumericFormat;
import haxe.Serializer;
import js.html.BodyElement;
//import js.html.svg.Document;
import haxe.Constraints.Function;
import js.html.TimeElement;
import haxe.Timer;
import haxe.ds.List;
import haxe.http.HttpJs;
import js.html.ButtonElement;
import js.html.DivElement;
import view.shared.io.User;

/**
 * ...
 * @author axel@cunity.me
 */

//import haxe.http.HttpJs;
import haxe.Json;
import haxe.io.Bytes;
import history.BrowserHistory;
import history.History;
import history.Location;
import js.Browser;
import js.Cookie;
import js.Error;
import js.Promise;
import js.html.XMLHttpRequest;
import me.cunity.debug.Out;
import store.ApplicationStore;
import state.CState;
import view.shared.io.User.UserProps;
import react.ReactMacro.jsx;
import react.ReactComponent;
import react.ReactEvent;
import redux.Store;
import redux.StoreMethods;
import react.React;
import react.ReactRef;
import redux.react.Provider;
import shared.DbData;
import shared.DBMetaData;
import Webpack.*;

import react.intl.DateTimeFormatOptions.NumericFormat.Numeric;
import react.intl.ReactIntl;
import react.intl.comp.IntlProvider;
import state.AppState;
import loader.BinaryLoader;
import view.shared.io.FormApi;
import action.AppAction;

import view.UiView;
using StringTools;

typedef AppProps =
{
	?waiting:Bool
}

class App  extends react.ReactComponentOf<AppProps, AppState>
{
	public static var _app:App;
	//static var fa = require('./node_modules/font-awesome/css/font-awesome.min.css');

  	static var STYLES = require('App.scss');
 
	public static var store:Store<AppState>;
	public static var devIP = Webpack.require('./webpack.local.js').ip;
	public static var config:Dynamic = Webpack.require('../httpdocs/config.js').config;
	public static var flatpickr:Function = Webpack.require('flatpickr');
	public static var German = js.Lib.require('flatpickr/dist/l10n/de.js');
	static var flat = js.Lib.require('flatpickr/dist/flatpickr.min.css');
	//static var flat = js.Lib.require('flatpickr/dist/themes/light.css');	
	public static var sprintf:Function = Webpack.require('sprintf-js').sprintf;

	public static var modalBox:ReactRef<DivElement> = React.createRef();
	public static var onResizeComponents:List<Dynamic> = new List();

  public function new(?props:AppProps) 
	{
		super(props);
		trace(flatpickr);
		//trace(German);
		untyped flatpickr.localize(German);
		ReactIntl.addLocaleData({locale:'de'});
		_app = this;
		var ti:Timer = null;
		Browser.window.onresize = function ()
		{
			if(ti!=null)
				ti.stop();
			ti = Timer.delay(function ()
			{
				if(onResizeComponents.isEmpty())
					return;
				var cpi:Iterator<Dynamic>=onResizeComponents.iterator();
				while (cpi.hasNext())
				{
					cpi.next().layOut();
				}
			},250);
		}
		//trace(modalBox);
		//trace('user_name:$user_name jwt:$jwt ' + (!(App.user_name == '' || App.jwt == '')?'Y':'N' ));
		store = ApplicationStore.create();
		state = store.getState();
		//trace(store);
		trace(state.appWare.redirectAfterLogin);
		//CState.init(store);		
		if (!(state.appWare.user.user_name == '' || state.appWare.user.jwt == ''))
		{			
			trace('clientVerify');
			var bL:XMLHttpRequest = BinaryLoader.create(
			'${state.appWare.config.api}', 
			{				
				user_name:state.appWare.user.user_name,
				jwt:state.appWare.user.jwt,
				className:'auth.User',
				action:'clientVerify',
				filter:'user_name|${state.appWare.user.user_name}',//LOGIN NAME
				dataSource:Serializer.run([
					"users" => ["alias" => 'us',
						"fields" => 'user_name,last_login,mandator,id'],
					"contacts" => [
						"alias" => 'co',
						"fields" => 'first_name,last_name,email',
						"jCond"=>'contact=co.id'] 
				]),
				devIP:devIP
			},			
			function(data:DbData)
			{
				//trace(dBytes.toString());
				//trace(data.dataInfo);
				if (data.dataErrors.keys().hasNext())
				{
					trace(data.dataErrors);
					return store.dispatch(AppAction.LoginError(
						{user_name:state.appWare.user.user_name, loginError:data.dataErrors.iterator().next()}));
				}	
				var uState:UserProps = data.dataInfo['user_data'];
				uState.waiting = false;
				return store.dispatch(AppAction.LoginComplete(uState));			
			});					
		}
		else
		{// WE HAVE EITHER NO VALID JWT OR user_name
			trace('LOGIN required');
			store.dispatch(AppAction.LoginRequired(state.appWare.user));
			props = { waiting:false};
		}
		//trace(App.config);
		//trace(props);
		trace(state.appWare.user.jwt);
		
		//state.appWare.history.listen(CState.historyChange);
		trace(Reflect.fields(state));
  }

	override function componentDidMount()
	{
		//trace(state.appWare.history);
		trace('yeah');
	}

	override function   componentDidCatch(error, info) 
	{
		trace(error);
	}
	
	override function componentDidUpdate(prevProps:Dynamic, prevState:Dynamic)
	{
		trace('...'); 
		//firstLoad = false;
	}
	// Use trace from props
	public static function edump(el:Dynamic){Out.dumpObject(el); return 'OK'; };

  override function render() {
		//trace(state.appWare.history.location.pathname);	store={store}		
        return jsx('
		<>
			<Provider store={store}><IntlProvider locale="de"><UiView/></IntlProvider></Provider>
		</>			
        ');
  }

	public static function 	await(delay:Int, check:Void->Dynamic, cb:Function):Timer
	{
		
		var ti:Timer = null;
		ti = Timer.delay(function ()
		{			
			switch (check()){
				case -1:
					ti.stop;
				case true:
					cb();		
				default: 
					await(delay, check, cb);
			}
		},delay);

		return  ti;
	} 

	public static function initEState(init:Dynamic, ?comp:Dynamic)
	{
		var fS:FormState =
		{
			clean: true,
			formApi:new FormApi(comp, init.sideMenu),
			//formBuilder:new FormBuilder(comp),
			hasError: false,
			mounted: false,
			sideMenu: init==null? {}:init.sideMenu
		};
		if(init != null)
		{
			for(f in Reflect.fields(init))
			{
				Reflect.setField(fS, f, Reflect.field(init, f));
			}
		}
		return fS;
	}

	public static function jsxDump(el:Dynamic):String
	{
		Out.dumpObject(el);
		return 'OK';
	}

	public static function jwtCheck(data:DbData) 
	{
		if (data.dataErrors.keys().hasNext())
		{
			trace(data.dataErrors);
			store.dispatch(AppAction.LoginError(
				{user_name:_app.state.appWare.user.user_name, loginError:data.dataErrors.iterator().next()}));
		}		
	}
	
	public static function logOut()
	{
		Cookie.set('user.jwt', '', -10, '/');
		//trace(Cookie.get('user.jwt')); 
		trace(Cookie.all());
		store.dispatch(AppAction.LogOut({jwt:'', user_name: store.getState().appWare.user.user_name }));
	}

	public static function queryString2(params:Dynamic)
	{
		var query = Reflect.fields(params)
			.map(function(k){
				 if (Std.is(Reflect.field(params, k), Array))
				 {
					return Reflect.field(params, k)
					  .map(function(val){
						  k.urlEncode() + '[]=' + val.urlEncode();
					  })
					  .join('&');
				}
			 return k.urlEncode() + '=' + StringTools.urlEncode(Reflect.field(params, k));
		})
		.join('&');
		trace(query);
		return query;
	}

}
