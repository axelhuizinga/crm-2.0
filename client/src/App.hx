import action.async.CRUD;
import db.DBAccessProps;
import js.Lib;
import jwt.JWT;
import js.html.FormData;
import haxe.ds.StringMap;
import shared.DbData;
import js.lib.Promise;
import react.ReactUtil;
import state.DataAccessState;
import haxe.macro.Expr.Catch; 
import store.DataStore;
import haxe.Constraints.Function;
import haxe.Timer;
import haxe.Serializer;
import haxe.Unserializer;
import haxe.ds.List;
import js.html.DivElement;

import haxe.Json;
import haxe.io.Bytes;
import history.BrowserHistory;
import history.History;
import history.Location;
import history.TransitionManager;
import js.Browser;
import me.cunity.debug.Out;
import view.UiView;
import action.AppAction;
import action.ConfigAction;
import action.DataAction;
import action.async.LocationAccess;
import action.LocationAction;
import action.StatusAction;
import action.UserAction;
import action.async.UserAccess;
import state.AppState;
import state.CState;
import state.ConfigState;
import state.FormState;
import store.AppStore;
import store.ConfigStore;
import store.LocationStore;
import store.StatusStore;
import store.UserStore;
import react.React;
import react.ReactComponent.ReactComponentOf;
import react.ReactMacro.jsx;

import react.ReactRef;
import react.ReactUtil.copy;
import react.intl.ReactIntl;
import react.intl.comp.IntlProvider;
import redux.react.Provider;
import redux.Redux;
import redux.Store; 
import redux.StoreBuilder.*;
import redux.thunk.Thunk;
import redux.thunk.ThunkMiddleware;
import uuid.Uuid;
import view.shared.io.FormApi;
import view.shared.FormBuilder;

using Lambda;
using StringTools;
 
typedef AppProps =
{
	?load:DBAccessProps->Promise<DbData>,
	?waiting:Bool
}

class App extends ReactComponentOf<AppProps, AppState>
{
	//static var fa = require('./node_modules/font-awesome/css/font-awesome.min.css');
	public static var _app:App;
  	static var STYLES = Webpack.require('App.scss');
  	static var ConfigData = Webpack.require('../config.json');
 
	public static var browserHistory:History;
	
	public static var store:Store<AppState>;

	public static var config:ConfigState = js.Lib.require('config.js').config;
	public static var devIP = (untyped __devIP__ == 'X'?'':__devIP__);
	public static var devPassword = '';//(untyped __password__ == 'X' ? '' : __password__);
	public static var devUser = (untyped __user_name__ == 'X' ? '' : __user_name__);
	public static var pbxUserData:Map<String,Map<String,String>>;
	public static var flatpickr:Function = Webpack.require('flatpickr');
	public static var German = js.Lib.require('flatpickr/dist/l10n/de.js');
	static var flat = js.Lib.require('flatpickr/dist/flatpickr.min.css');
	//static var rvirt = js.Lib.require('react-virtualized/styles.css');	
	//static var flat = js.Lib.require('flatpickr/dist/themes/light.css');	
	public static var sprintf:Function = Webpack.require('sprintf-js').sprintf;
	//public static var useBrowserContextCommunication:Dynamic = Webpack.require('react-window-communication-hook');
	//public static var useState:Dynamic = Webpack.require('react').useState;
	public static var modalBox:ReactRef<DivElement> = React.createRef();
	public static var onResizeComponents:List<Dynamic> = new List();
	public static var defaultUrl = '/Data/Contacts/List/get';
	public static var mandator:Int = 1;
	public static var maxLoginAttempts:Int = 8;

	var globalState:Map<String,Dynamic>;
	var tul:TUnlisten;

	private function initStore(history:History):Store<AppState>
	{
		var userStore = new UserStore();
		trace(Reflect.fields(userStore));
		var appWare = new AppStore();
		var locationStore =  new LocationStore(history);

		var rootReducer = Redux.combineReducers(
		{
			//app:mapReducer(AppAction, appWare),
			config: mapReducer(ConfigAction, new ConfigStore(config)),
			dataStore: mapReducer(DataAction, new DataStore()),
			locationStore: mapReducer(LocationAction,locationStore),
			status: mapReducer(StatusAction, new StatusStore()),
			userState: mapReducer(UserAction, userStore)
		});
		//var dataStore:DataAccessState = loadFromLocalStorage();
		//trace(dataStore);		
		//trace(rootReducer); 
		//return createStore(rootReducer, {dataStore:loadFromLocalStorage()},  
		return createStore(rootReducer, null,  
			Redux.applyMiddleware(
				mapMiddleware(Thunk, new ThunkMiddleware()),
				mapMiddleware(AppAction, appWare),
				mapMiddleware(LocationAction, locationStore)
				//mapMiddleware(UserAction, userStore)
			)
		);
	}

	private function loadFromLocalStorage():state.DataAccessState {
		try{
			var sState = Browser.getLocalStorage().getItem('state');
			if(sState == null)
				return {};
			return Unserializer.run(sState);
		} catch(e:Dynamic){
			trace(e);
			return {};
		}

	}

	private function saveToLocalStorage(){
		try{
			//trace('storing ${state.dataStore} locally');
			Browser.getLocalStorage().setItem('state', Serializer.run(store.getState().dataStore));
			//trace( Unserializer.run(Browser.getLocalStorage().getItem('state')));
		}catch(e:Dynamic){
			trace(e);
		}
	}

	static function historyListener(store:Store<AppState>, history:History):TUnlisten
	{
		//trace(history);
		store.dispatch(Location(InitHistory(history)));
	
		return history.listen( function(location:Location, action:history.Action){
			trace(location.pathname);			
			store.dispatch(Status(Update({path:location.pathname, text:''})));
			//store.dispatch(LocationChange(location));
		});
	}	

	static function mapDispatchToProps(dispatch:Dispatch) {
		trace('here we should be ready to load');
        return {
            load: function(param:DBAccessProps) return dispatch(CRUD.read(param))
        };
	}

  	public function new(?props:AppProps) 
	{
		super(props);
		//globalState = new Map();
		//flatpickr.localize(German);
		//ReactIntl.addLocaleData({locale:'de'});
		_app = this;
		var ti:Timer = null;
		App.config.baseUrl = App.config.api.replace('/server.php','');
		trace(props.load);
		trace(store);
		if(store==null){
			store = initStore(BrowserHistory.create({basename:"/", getUserConfirmation:CState.confirmTransition}));
		}
		state = store.getState();
		//trace(Reflect.fields(state));
		//trace(config);
		trace(state.userState.dbUser.id +' jwt:' + state.userState.dbUser.jwt);
		trace(' waiting:' + state.userState.waiting);
		//trace(state);

		trace(state.userState.dbUser.jwt == 'null'||state.userState.dbUser.jwt == ''?'Y':'N');
		if(state.userState.dbUser.jwt == 'null'||state.userState.dbUser.jwt == ''){		
			trace('redirect to login...');			
			store.dispatch(LoginExpired({waiting: false, loginTask: Login, dbUser: state.userState.dbUser}));
			//store.dispatch(LocationAccess.redirect([], 'login'));
			return;
		}
		//trace(devIP);
		tul = historyListener(store, state.locationStore.history);
		//store.subscribe(saveToLocalStorage);
		//var uBCC:Dynamic = react.WinCom.useBrowserContextCommunication('appGlobal');


		Browser.window.onresize = function()
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
		//trace(store);
		//Out.dumpObject(state.userState);
		//CState.init(store);		
		
		if (!(state.userState.dbUser.id == null || state.userState.dbUser.jwt == null))
		{			
			//import ConfigData;
			var jVal:JWTResult<Dynamic> = JWT.verify(state.userState.dbUser.jwt, ConfigData.secret);
			trace(jVal);
			
			switch(jVal){
				case Valid(jwt):
					trace(untyped jwt.validUntil - Date.now().getTime());
					if(untyped jwt.validUntil - Date.now().getTime() > 600000){
						// AT LEAST 10 min valid
						state.userState.dbUser.online = true;
						state.userState.waiting = false;
						store.dispatch(LoginComplete({waiting:false}));							
					}else {
						trace('dispatch LoginExpired');
						state.userState.dbUser.jwt = '';
						store.dispatch(LoginExpired({waiting: false, loginTask: Login, dbUser: state.userState.dbUser}));
					}
					//trace(untyped jwt.validUntil);
					//trace(Date.now().getTime());
				case Invalid(jwt):
					trace(jwt);
				default:
					trace(jVal);
			}

		}
		else
		{// WE HAVE EITHER NO VALID JWT OR id
			trace('LOGIN required');
			store.dispatch(
				User(
					UserAction.LoginRequired(
						ReactUtil.copy( state.userState, {waiting:false}))));
		}
		//trace(Reflect.fields(state));

	}

	public function gGet(key:String):Dynamic
	{
		trace(key);
		return globalState.get(key);
	} 

	public function gSet(key:String,val:Dynamic):Void 
	{
		globalState.set(key,val);
	}

	override function componentDidMount()
	{
		//trace(state.history);
		//trace(state.userState.dbUser);
		//store.dispatch(action.async.UserAccess.verify());
		trace('yeah');
		trace(' waiting:' + state.userState.waiting);
		var p:Promise<DbData> = cast( store.dispatch(CRUD.read({//props.load({		
			classPath:'auth.User',
			action:'getPbxUserData',
			dbUser: state.userState.dbUser,
			extDB:true,	
			viciBoxDB:true,			
			devIP:App.devIP
		})));//untyped UserAccess.userList();
		p.then(function(dbData:DbData){
				trace(dbData.dataRows[0]);
				pbxUserData =  [
					for(row in dbData.dataRows) row.get('user') => row
				];
				trace(pbxUserData);
				//var uState:UserState = state.userState.dbUser;
				setState({userState:copy({waiting:false})});
			}
			,function(dbData:DbData){
				trace(dbData);
				if(dbData.dataErrors.exists('LoginError')){
					trace(dbData.dataErrors['LoginError']);
				}
			}
		);
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

	override function componentWillUnmount() 
	{
		tul();
	}
	// Use trace from props
	public static function edump(el:Dynamic){Out.dumpObject(el); return 'OK'; };

  	override function render() {
		//Out.dumpObject(state.userState);
		//trace(state.history.location.pathname);	store={store}	<UiView/>	<div>more soon...</div>
		if(pbxUserData!=null){
			var uD:Map<String,String> = pbxUserData[pbxUserData.keys().next()];
			trace((uD));
			if(uD != null)
			trace((uD['user']));
		}
		trace('pbxUserData!=null ? ' + (pbxUserData!=null?'Y':'N'));
		trace(state.userState);
		//trace('props.userState.dbUser.jwt ${props.userState.dbUser.jwt == null} ${props.userState.dbUser.online}');
		//trace(pbxUserData==null||!pbxUserData.keys().hasNext()?'':'');
		//return (pbxUserData==null||!pbxUserData.keys().hasNext()?jsx('
		//trace('!pbxUserData.keys().hasNext()'+(!pbxUserData.keys().hasNext()?'Y':'N'));
		var hProps:Dynamic = Reflect.getProperty(pbxUserData, 'h');
		trace('hProps!=null? '+(hProps!=null?hProps:'null'));
		var hFields:Array<String> = Reflect.fields(pbxUserData);
		trace(hFields.join('|'));
        return pbxUserData==null?jsx('
		<section className="hero is-alt is-fullheight">
		  <div className="hero-body">
		  <div className="loader"  style=${{width:'7rem', height:'7rem', margin:'auto', borderWidth:'0.58rem'}}/>
		  </div>
		</section>
		'):jsx('
			<$Provider store={store}>
				<$IntlProvider locale="de">
					<$UiView/>
				</$IntlProvider>
			</$Provider>
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
	
	public static function initEState(init:Dynamic, comp:Dynamic)
	{
		//var fA:FormApi = new FormApi(comp, init.sideMenu);
		var fS:FormState =
		{
			clean: true,
			formApi:new FormApi(comp, init.sideMenu),
			formBuilder:new FormBuilder(comp),
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
		if(init.sideMenu!=null && init.sideMenu.items!=null)
			trace(init.sideMenu.items[0]);
		if(comp.props.sideMenu !=null && comp.props.sideMenu.items !=null)
			trace(comp.props.sideMenu.items[0]);
		if(fS.formApi.sM != null && fS.formApi.sM.items!=null)
		trace(fS.formApi.sM.items[0]);
		if(comp.props.match != null && comp.props.match.params.section != null && fS.formApi.sM != null 
			&& fS.formApi.sM.menuBlocks != null && fS.formApi.sM.menuBlocks.exists(comp.props.match.params.section)){
			trace(fS.formApi.sM.menuBlocks[comp.props.match.params.section].items[0]);
			//trace(Utils.arrayKeysList(this.sM.menuBlocks[comp.props.match.params.section].items, 'id'));
		}
		if(comp!=null){		
			fS.uid = Uuid.nanoId();
			fS.relDataComps = [fS.uid => comp];
		}
		return fS;
	}

	public static function initSectionState(init:Dynamic, ?comp:Dynamic)
	{
		var fS:FormState =
		{
			clean: true,
			formApi:new FormApi(comp, comp.props.parentComponent.state.sideMenu),
			formBuilder:new FormBuilder(comp),
			hasError: false,
			mounted: false,
			sideMenu: comp.props.parentComponent.state.sideMenu
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
