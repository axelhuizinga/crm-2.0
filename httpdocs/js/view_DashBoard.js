(function ($hx_exports, $global) { "use-strict";
var $s = $global.$hx_scope, $_;
var React_Component = $s.a, $hxClasses = $s.b, redux_Action = $s.c, action_AppAction = $s.d, action_ConfigAction = $s.e, $extend = $s.f, haxe_Log = $s.g, react_ReactType = $s.h, js_Boot = $s.i, React = $s.j, Reflect = $s.k, React_Fragment = $s.l, bulma_$components_Tabs = $s.m, view_shared_TabLink = $s.n, react_router_Route = $s.o, view_shared_io_FormApi = $s.p, view_table_Table = $s.aa, haxe_ds_Either = $s.ab, haxe_http_HttpJs = $s.ac, $bind = $s.ad, Std = $s.ae, me_cunity_debug_Out = $s.af, App = $s.ag, view_shared_Menu = $s.ah, redux_react_ReactRedux = $s.ai, react_ReactTypeOf = $s.aj, haxe_ds_StringMap = $s.ak, react_ReactRef = $s.al, haxe_Unserializer = $s.am, haxe_NativeStackTrace = $s.an, haxe_Exception = $s.ao, haxe_Serializer = $s.ap, view_shared_FormBuilder = $s.ba, action_async_CRUD = $s.bb, action_StatusAction = $s.bc, action_async_LivePBXSync = $s.bd, action_UserAction = $s.be, loader_BinaryLoader = $s.bf, shared_DbDataTools = $s.bg, model_deals_DealsModel = $s.bh, view_StatusBar = $s.bi;
$hx_exports["me"] = $hx_exports["me"] || {};
$hx_exports["me"]["cunity"] = $hx_exports["me"]["cunity"] || {};
$hx_exports["me"]["cunity"]["debug"] = $hx_exports["me"]["cunity"]["debug"] || {};
$hx_exports["me"]["cunity"]["debug"]["Out"] = $hx_exports["me"]["cunity"]["debug"]["Out"] || {};
var loader_AjaxLoader = function(cb,p,r) {
	this.cB = cb;
	this.params = p;
	this.post = p != null;
	this.req = r;
};
$hxClasses["loader.AjaxLoader"] = loader_AjaxLoader;
loader_AjaxLoader.__name__ = "loader.AjaxLoader";
loader_AjaxLoader.load = function(url,params,cB) {
	var req = new haxe_http_HttpJs(url);
	if(params != null) {
		var _g = 0;
		var _g1 = Reflect.fields(params);
		while(_g < _g1.length) {
			var k = _g1[_g];
			++_g;
			req.addParameter(k,Reflect.field(params,k));
		}
	}
	req.addHeader("Access-Control-Allow-Methods","PUT, GET, POST, DELETE, OPTIONS");
	req.addHeader("Access-Control-Allow-Origin","*");
	var loader = new loader_AjaxLoader(cB);
	req.onData = $bind(loader,loader._onData);
	req.onError = function(err) {
		haxe_Log.trace(err,{ fileName : "src/loader/AjaxLoader.hx", lineNumber : 34, className : "loader.AjaxLoader", methodName : "load"});
	};
	haxe_Log.trace("POST? " + Std.string(params) != null,{ fileName : "src/loader/AjaxLoader.hx", lineNumber : 35, className : "loader.AjaxLoader", methodName : "load"});
	req.withCredentials = true;
	req.request(params != null);
	return req;
};
loader_AjaxLoader.loadData = function(url,params,cB) {
	var loader = loader_AjaxLoader.queue(url,params,cB);
	loader_AjaxLoader.rqs.push(loader.req);
	if(loader_AjaxLoader.rqs.length == 1) {
		loader_AjaxLoader.rqs.shift().request(loader.post);
	}
	return loader.req;
};
loader_AjaxLoader.queue = function(url,params,cB) {
	var req = new haxe_http_HttpJs(url);
	if(params != null) {
		var _g = 0;
		var _g1 = Reflect.fields(params);
		while(_g < _g1.length) {
			var k = _g1[_g];
			++_g;
			req.addParameter(k,Reflect.field(params,k));
		}
	}
	req.addHeader("Access-Control-Allow-Methods","PUT, GET, POST, DELETE, OPTIONS");
	req.addHeader("Access-Control-Allow-Origin","*");
	var loader = new loader_AjaxLoader(cB,params,req);
	loader.url = url;
	req.onData = $bind(loader,loader._onQueueData);
	req.onError = function(err) {
		haxe_Log.trace(err,{ fileName : "src/loader/AjaxLoader.hx", lineNumber : 119, className : "loader.AjaxLoader", methodName : "queue"});
		me_cunity_debug_Out.dumpObject(req,{ fileName : "src/loader/AjaxLoader.hx", lineNumber : 119, className : "loader.AjaxLoader", methodName : "queue"});
	};
	haxe_Log.trace("POST? " + Std.string(params) != null,{ fileName : "src/loader/AjaxLoader.hx", lineNumber : 120, className : "loader.AjaxLoader", methodName : "queue"});
	req.withCredentials = true;
	return loader;
};
loader_AjaxLoader.prototype = {
	cB: null
	,params: null
	,post: null
	,req: null
	,url: null
	,_onData: function(response) {
		if(response.length > 0) {
			var dataObj = JSON.parse(response);
			if(dataObj.error != "") {
				haxe_Log.trace(dataObj.error,{ fileName : "src/loader/AjaxLoader.hx", lineNumber : 62, className : "loader.AjaxLoader", methodName : "_onData"});
				dataObj.data = { error : dataObj.error, rows : []};
			}
			if(this.cB != null) {
				this.cB(dataObj.data);
			}
		}
	}
	,_onError: function(err) {
	}
	,_onQueueData: function(response) {
		if(response.length > 0) {
			var dataObj = JSON.parse(response);
			if(dataObj.error != "") {
				haxe_Log.trace(dataObj.error,{ fileName : "src/loader/AjaxLoader.hx", lineNumber : 84, className : "loader.AjaxLoader", methodName : "_onQueueData"});
				dataObj.data = { error : dataObj.error, rows : []};
			}
			if(this.cB != null) {
				this.cB(dataObj.data);
			}
			if(loader_AjaxLoader.rqs.length > 0) {
				loader_AjaxLoader.rqs.shift().request(this.post);
			}
		}
	}
	,__class__: loader_AjaxLoader
};
var view_DashBoard = function(props) {
	this.renderCount = 0;
	this.rendered = false;
	this.mounted = false;
	this.state = { hasError : false, mounted : false};
	React_Component.call(this,props);
	if(props.match.url == "/DashBoard") {
		props.history.push("/DashBoard/Setup/DBSync");
	}
};
$hxClasses["view.DashBoard"] = view_DashBoard;
view_DashBoard.__name__ = "view.DashBoard";
view_DashBoard.mapDispatchToProps = function(dispatch) {
	return { setThemeColor : function() {
		dispatch(redux_Action.map(action_AppAction.Config(action_ConfigAction.SetTheme("violet"))));
	}};
};
view_DashBoard.mapStateToProps = function(aState) {
	var uState = aState.userState;
	return { appConfig : aState.config, redirectAfterLogin : aState.locationStore.redirectAfterLogin, userState : uState};
};
view_DashBoard.__super__ = React_Component;
view_DashBoard.prototype = $extend(React_Component.prototype,{
	mounted: null
	,rendered: null
	,renderCount: null
	,componentDidMount: function() {
		this.mounted = true;
	}
	,componentDidCatch: function(error,info) {
		if(this.mounted) {
			this.setState({ hasError : true});
		}
		haxe_Log.trace(error,{ fileName : "src/view/DashBoard.hx", lineNumber : 75, className : "view.DashBoard", methodName : "componentDidCatch"});
		haxe_Log.trace(info,{ fileName : "src/view/DashBoard.hx", lineNumber : 76, className : "view.DashBoard", methodName : "componentDidCatch"});
	}
	,componentWillUnmount: function() {
		haxe_Log.trace("leaving...",{ fileName : "src/view/DashBoard.hx", lineNumber : 81, className : "view.DashBoard", methodName : "componentWillUnmount"});
	}
	,render: function() {
		if(this.state.hasError) {
			var tmp = react_ReactType.fromString("h1");
			var c = js_Boot.getClass(this);
			var tmp1 = c.__name__;
			return React.createElement(tmp,{ },"Fehler in ",tmp1,".");
		}
		haxe_Log.trace(Reflect.fields(this.props),{ fileName : "src/view/DashBoard.hx", lineNumber : 122, className : "view.DashBoard", methodName : "render"});
		haxe_Log.trace(Reflect.fields(this.state),{ fileName : "src/view/DashBoard.hx", lineNumber : 123, className : "view.DashBoard", methodName : "render"});
		var tmp = react_ReactType.fromComp(React_Fragment);
		var tmp1 = react_ReactType.fromString("div");
		var tmp2 = react_ReactType.fromComp(bulma_$components_Tabs);
		var tmp3 = React.createElement(react_ReactType.fromComp(view_shared_TabLink),Object.assign({ },this.props,{ to : "/DashBoard/Roles"}),"Benutzer");
		var tmp4 = React.createElement(react_ReactType.fromComp(view_shared_TabLink),Object.assign({ },this.props,{ to : "/DashBoard/Settings"}),"Meine Einstellungen");
		var tmp5 = React.createElement(react_ReactType.fromComp(view_shared_TabLink),Object.assign({ },this.props,{ to : "/DashBoard/Setup"}),"Setup");
		var tmp6 = React.createElement(tmp1,{ className : "tabNav2"},React.createElement(tmp2,{ className : "is-boxed"},tmp3,tmp4,tmp5));
		var tmp1 = react_ReactType.fromString("div");
		var tmp2 = React.createElement(react_ReactType.fromComp(react_router_Route),Object.assign({ },this.props,{ path : "/DashBoard/Roles/:section?/:action?/:id?", component : react_ReactType.fromComp(view_dashboard_Roles)}));
		var tmp3 = React.createElement(react_ReactType.fromComp(react_router_Route),Object.assign({ },this.props,{ path : "/DashBoard/Settings/:section?/:action?/:id?", component : react_ReactType.fromComp(view_dashboard_Settings)}));
		var tmp4 = react_ReactType.fromComp(react_router_Route);
		var tmp5 = Object.assign({ },this.props,{ path : "/DashBoard/Setup/:section?/:action?", component : react_ReactType.fromComp(view_dashboard_Setup)});
		var tmp7 = React.createElement(tmp1,{ className : "tabContent2"},tmp2,tmp3,React.createElement(tmp4,tmp5));
		var tmp1 = React.createElement(view_StatusBar._renderWrapper,this.props);
		return React.createElement(tmp,{ },tmp6,tmp7,tmp1);
	}
	,internalRedirect: function(path) {
		if(path == null) {
			path = "/DashBoard/Settings";
		}
		this.props.history.push(path);
		return null;
	}
	,setState: null
	,__class__: view_DashBoard
});
var view_dashboard_DB = function(props) {
	React_Component.call(this,props);
	haxe_Log.trace("" + App.devIP + " action:" + props.match.params.action,{ fileName : "src/view/dashboard/DB.hx", lineNumber : 57, className : "view.dashboard.DB", methodName : "new"});
	this.dataDisplay = null;
	this.state = { formApi : new view_shared_io_FormApi(this), hasError : false, sideMenu : props.sideMenu};
};
$hxClasses["view.dashboard.DB"] = view_dashboard_DB;
view_dashboard_DB.__name__ = "view.dashboard.DB";
view_dashboard_DB.mapStateToProps = function(aState) {
	return { userState : aState.userState};
};
view_dashboard_DB.__super__ = React_Component;
view_dashboard_DB.prototype = $extend(React_Component.prototype,{
	dataDisplay: null
	,dataAccess: null
	,createFieldList: function(ev) {
		var _gthis = this;
		haxe_Log.trace("hi :)",{ fileName : "src/view/dashboard/DB.hx", lineNumber : 84, className : "view.dashboard.DB", methodName : "createFieldList"});
		this.state.formApi.requests.push(haxe_ds_Either.Left(view_shared_io_Loader.load("" + Std.string(App.config.api),{ id : this.props.userState.dbUser.id, jwt : this.props.userState.dbUser.jwt, classPath : "tools.DB", action : "createFieldList", update : "1"},function(data) {
			haxe_Log.trace(data == null ? "null" : haxe_ds_StringMap.stringify(data.h),{ fileName : "src/view/dashboard/DB.hx", lineNumber : 96, className : "view.dashboard.DB", methodName : "createFieldList"});
			if(Object.prototype.hasOwnProperty.call(data.h,"error")) {
				haxe_Log.trace(data.h["error"],{ fileName : "src/view/dashboard/DB.hx", lineNumber : 100, className : "view.dashboard.DB", methodName : "createFieldList"});
				return;
			}
			_gthis.setState({ data : data});
		})));
		haxe_Log.trace(this.props.history,{ fileName : "src/view/dashboard/DB.hx", lineNumber : 106, className : "view.dashboard.DB", methodName : "createFieldList"});
		haxe_Log.trace(this.props.match,{ fileName : "src/view/dashboard/DB.hx", lineNumber : 107, className : "view.dashboard.DB", methodName : "createFieldList"});
	}
	,setView: function() {
		this.createOrUpdateView();
	}
	,getView: function() {
		var _gthis = this;
		var pro = new Promise(function(resolve,reject) {
			if(!_gthis.props.userState.dbUser.online) {
				haxe_Log.trace("LoginError",{ fileName : "src/view/dashboard/DB.hx", lineNumber : 119, className : "view.dashboard.DB", methodName : "getView"});
				var _g = new haxe_ds_StringMap();
				_g.h["LoginError"] = "Du musst dich neu anmelden!";
				reject(shared_DbDataTools.create(_g));
			}
			var bl = loader_BinaryLoader.dbQuery("" + Std.string(App.config.api),{ devIP : App.devIP, dbUser : _gthis.props.userState.dbUser, data : { ux_class_path : "model.deals.DealsModel"}, classPath : "view.Forms", action : "getView"},function(res) {
				haxe_Log.trace(res,{ fileName : "src/view/dashboard/DB.hx", lineNumber : 135, className : "view.dashboard.DB", methodName : "getView"});
				resolve(haxe_Unserializer.run(res.dataRows[0].h["hx_serial"]));
			});
		});
		pro.then(function(viewData) {
			haxe_Log.trace(viewData == null ? "null" : haxe_ds_StringMap.stringify(viewData.h),{ fileName : "src/view/dashboard/DB.hx", lineNumber : 142, className : "view.dashboard.DB", methodName : "getView"});
		},function(whatever) {
			haxe_Log.trace(whatever,{ fileName : "src/view/dashboard/DB.hx", lineNumber : 144, className : "view.dashboard.DB", methodName : "getView"});
		});
	}
	,createOrUpdateView: function() {
		var _gthis = this;
		App.store.dispatch(redux_Action.map(action_AppAction.Status(action_StatusAction.Update({ className : "", text : "update model.deals.DealsModel"}))));
		var pro = new Promise(function(resolve,reject) {
			if(!_gthis.props.userState.dbUser.online) {
				haxe_Log.trace("LoginError",{ fileName : "src/view/dashboard/DB.hx", lineNumber : 158, className : "view.dashboard.DB", methodName : "createOrUpdateView"});
				var _g = new haxe_ds_StringMap();
				_g.h["LoginError"] = "Du musst dich neu anmelden!";
				reject(shared_DbDataTools.create(_g));
			}
			var bl = loader_BinaryLoader.dbQuery("" + Std.string(App.config.api),{ devIP : App.devIP, dbUser : _gthis.props.userState.dbUser, classPath : "view.Forms", data : { ux_class_path : "model.deals.DealsModel", hx_serial : haxe_Serializer.run(model_deals_DealsModel.dataAccess.h["open"].view)}, action : "setView"},function(res) {
				haxe_Log.trace(res,{ fileName : "src/view/dashboard/DB.hx", lineNumber : 174, className : "view.dashboard.DB", methodName : "createOrUpdateView"});
			});
		});
		pro.then(function(jsonData) {
			haxe_Log.trace(jsonData,{ fileName : "src/view/dashboard/DB.hx", lineNumber : 180, className : "view.dashboard.DB", methodName : "createOrUpdateView"});
		},function(whatever) {
			haxe_Log.trace(whatever,{ fileName : "src/view/dashboard/DB.hx", lineNumber : 182, className : "view.dashboard.DB", methodName : "createOrUpdateView"});
		});
	}
	,'delete': function(ev) {
		haxe_Log.trace(this.state.selectedRows.length,{ fileName : "src/view/dashboard/DB.hx", lineNumber : 194, className : "view.dashboard.DB", methodName : "delete"});
		var data = this.state.formApi.selectedRowsMap(this.state);
	}
	,editTableFields: function(ev) {
		haxe_Log.trace(this.state.selectedRows.length,{ fileName : "src/view/dashboard/DB.hx", lineNumber : 201, className : "view.dashboard.DB", methodName : "editTableFields"});
		var data = this.state.formApi.selectedRowsMap(this.state);
		var view = haxe_ds_StringMap.createCopy(this.dataAccess.h["editTableFields"].view.h);
		haxe_Log.trace(this.dataAccess.h["editTableFields"].view.h["table_name"],{ fileName : "src/view/dashboard/DB.hx", lineNumber : 204, className : "view.dashboard.DB", methodName : "editTableFields"});
		haxe_Log.trace(data[0].h["id"] + "<",{ fileName : "src/view/dashboard/DB.hx", lineNumber : 205, className : "view.dashboard.DB", methodName : "editTableFields"});
	}
	,initStateFromDataTable: function(dt) {
		var iS = { };
		var _g = 0;
		while(_g < dt.length) {
			var dR = dt[_g];
			++_g;
			var rS = { };
			var h = dR.h;
			var k_h = h;
			var k_keys = Object.keys(h);
			var k_length = k_keys.length;
			var k_current = 0;
			while(k_current < k_length) {
				var k = k_keys[k_current++];
				haxe_Log.trace(k,{ fileName : "src/view/dashboard/DB.hx", lineNumber : 231, className : "view.dashboard.DB", methodName : "initStateFromDataTable"});
				if(this.dataDisplay.h["fieldsList"].columns.h[k].cellFormat == view_dashboard_model_DBFormsModel.formatBool) {
					rS[k] = dR.h[k] == "Y";
				} else {
					rS[k] = dR.h[k];
				}
			}
			iS[dR.h["id"]] = rS;
		}
		haxe_Log.trace(iS,{ fileName : "src/view/dashboard/DB.hx", lineNumber : 241, className : "view.dashboard.DB", methodName : "initStateFromDataTable"});
		return iS;
	}
	,saveTableFields: function(vA) {
		haxe_Log.trace(vA,{ fileName : "src/view/dashboard/DB.hx", lineNumber : 247, className : "view.dashboard.DB", methodName : "saveTableFields"});
	}
	,showFieldList: function(_) {
		this.state.formApi.requests.push(null);
	}
	,componentDidMount: function() {
		haxe_Log.trace("Ok",{ fileName : "src/view/dashboard/DB.hx", lineNumber : 316, className : "view.dashboard.DB", methodName : "componentDidMount"});
		var _g = new haxe_ds_StringMap();
		var _g1 = new haxe_ds_StringMap();
		_g1.h["selectedRows"] = null;
		var _g2 = new haxe_ds_StringMap();
		_g2.h["table_name"] = { label : "Tabelle", disabled : true};
		_g2.h["field_name"] = { label : "Feldname", disabled : true};
		_g2.h["field_type"] = { label : "Datentyp", type : "Select"};
		_g2.h["element"] = { label : "Eingabefeld", type : "Select"};
		_g2.h["disabled"] = { label : "Readonly", type : "Checkbox"};
		_g2.h["required"] = { label : "Required", type : "Checkbox"};
		_g2.h["use_as_index"] = { label : "Index", type : "Checkbox"};
		_g2.h["any"] = { label : "Eigenschaften", disabled : true, type : "Hidden"};
		_g2.h["id"] = { primary : true, type : "Hidden"};
		_g.h["editTableFields"] = { source : _g1, view : _g2};
		_g.h["saveTableFields"] = { source : null, view : null};
		this.dataAccess = _g;
	}
	,renderResults: function() {
		if(this.state.dataTable != null) {
			switch(this.props.match.params.action) {
			case "editForm":
				return null;
			case "getView":
				var tmp = react_ReactType.fromString("div");
				var tmp1 = react_ReactType.fromString("div");
				var tmp2 = react_ReactType.fromString("pre");
				var tmp3 = this.state.data.toString();
				return React.createElement(tmp,{ className : ""},React.createElement(tmp1,{ },React.createElement(tmp2,{ },tmp3)));
			case "showFieldList":
				haxe_Log.trace(Std.string(this.state.dataTable[29].h["id"]) + "<<<",{ fileName : "src/view/dashboard/DB.hx", lineNumber : 357, className : "view.dashboard.DB", methodName : "renderResults"});
				return React.createElement(react_ReactType.fromComp(view_table_Table),Object.assign({ },this.props,{ id : "fieldsList", data : this.state.dataTable, dataState : this.dataDisplay.h["fieldsList"], className : "is-striped is-hoverable", fullWidth : true}));
			default:
				return null;
			}
		}
		return null;
	}
	,render: function() {
		if(this.state.values != null) {
			haxe_Log.trace(this.state.values == null ? "null" : haxe_ds_StringMap.stringify(this.state.values.h),{ fileName : "src/view/dashboard/DB.hx", lineNumber : 374, className : "view.dashboard.DB", methodName : "render"});
		}
		haxe_Log.trace(this.props.match.params.section,{ fileName : "src/view/dashboard/DB.hx", lineNumber : 375, className : "view.dashboard.DB", methodName : "render"});
		var tmp = this.state.formApi;
		var tmp1 = react_ReactType.fromString("form");
		var tmp2 = React.createElement(react_ReactType.fromString("div"),{ className : "caption"},"DB");
		var tmp3 = this.renderResults();
		return tmp.render(React.createElement(tmp1,{ className : "tabComponentForm"},tmp2,tmp3));
	}
	,updateMenu: function(viewClassPath) {
		var sideMenu = this.state.sideMenu;
		var _g = 0;
		var _g1 = sideMenu.menuBlocks.h["DB"].items;
		while(_g < _g1.length) {
			var mI = _g1[_g];
			++_g;
			var _g2 = mI.action;
			if(_g2 != null) {
				switch(_g2) {
				case "editTableFields":
					mI.disabled = this.state.selectedRows.length == 0;
					break;
				case "save":
					mI.disabled = this.state.clean;
					break;
				default:
				}
			}
		}
		return sideMenu;
	}
	,setState: null
	,__class__: view_dashboard_DB
});
var view_dashboard_DBSync = function(props) {
	React_Component.call(this,props);
	this.dataDisplay = view_dashboard_model_DBSyncModel.dataDisplay;
	this.dataAccess = view_dashboard_model_DBSyncModel.dataAccess(props.match.params.action);
	this.formFields = view_dashboard_model_DBSyncModel.formFields(props.match.params.action);
	haxe_Log.trace("..." + Std.string(Reflect.fields(props)),{ fileName : "src/view/dashboard/DBSync.hx", lineNumber : 79, className : "view.dashboard.DBSync", methodName : "new"});
	this.state = App.initEState({ loading : false, dataTable : [], formBuilder : new view_shared_FormBuilder(this), actualState : { edited_by : props.userState.dbUser.id, mandator : props.userState.dbUser.mandator}, initialState : { edited_by : props.userState.dbUser.id, mandator : props.userState.dbUser.mandator}, values : new haxe_ds_StringMap()},this);
};
$hxClasses["view.dashboard.DBSync"] = view_dashboard_DBSync;
view_dashboard_DBSync.__name__ = "view.dashboard.DBSync";
view_dashboard_DBSync._instance = null;
view_dashboard_DBSync.mapStateToProps = function(aState) {
	return { userState : aState.userState};
};
view_dashboard_DBSync.mapDispatchToProps = function(dispatch) {
	return { load : function(param) {
		return dispatch(redux_Action.map(action_async_CRUD.update(param)));
	}};
};
view_dashboard_DBSync.__super__ = React_Component;
view_dashboard_DBSync.prototype = $extend(React_Component.prototype,{
	dataAccess: null
	,dataDisplay: null
	,formApi: null
	,formBuilder: null
	,formFields: null
	,fieldNames: null
	,baseForm: null
	,contact: null
	,dbData: null
	,dbMetaData: null
	,createFieldList: function(ev) {
		haxe_Log.trace("hi :)",{ fileName : "src/view/dashboard/DBSync.hx", lineNumber : 108, className : "view.dashboard.DBSync", methodName : "createFieldList"});
	}
	,editTableFields: function(ev) {
		haxe_Log.trace(this.state.selectedRows.length,{ fileName : "src/view/dashboard/DBSync.hx", lineNumber : 117, className : "view.dashboard.DBSync", methodName : "editTableFields"});
	}
	,initStateFromDataTable: function(dt) {
		var iS = { };
		var _g = 0;
		while(_g < dt.length) {
			var dR = dt[_g];
			++_g;
			var rS = { };
			var h = dR.h;
			var k_h = h;
			var k_keys = Object.keys(h);
			var k_length = k_keys.length;
			var k_current = 0;
			while(k_current < k_length) {
				var k = k_keys[k_current++];
				haxe_Log.trace(k,{ fileName : "src/view/dashboard/DBSync.hx", lineNumber : 128, className : "view.dashboard.DBSync", methodName : "initStateFromDataTable"});
				if(this.dataDisplay.h["fieldsList"].columns.h[k].cellFormat == view_dashboard_model_DBSyncModel.formatBool) {
					rS[k] = dR.h[k] == "Y";
				} else {
					rS[k] = dR.h[k];
				}
			}
			iS[dR.h["id"]] = rS;
		}
		haxe_Log.trace(iS,{ fileName : "src/view/dashboard/DBSync.hx", lineNumber : 138, className : "view.dashboard.DBSync", methodName : "initStateFromDataTable"});
		return iS;
	}
	,saveTableFields: function(vA) {
		haxe_Log.trace(vA,{ fileName : "src/view/dashboard/DBSync.hx", lineNumber : 144, className : "view.dashboard.DBSync", methodName : "saveTableFields"});
	}
	,importAccounts2: function(_) {
		haxe_Log.trace(this.props.userState.dbUser.first_name,{ fileName : "src/view/dashboard/DBSync.hx", lineNumber : 173, className : "view.dashboard.DBSync", methodName : "importAccounts2"});
		this.setState({ loading : true});
		this.doSyncAll2({ classPath : "admin.SyncExternalAccounts", action : "importContacts", extDB : true, filter : { mandator : "1"}, limit : 1000, offset : 0, table : "accounts", dbUser : this.props.userState.dbUser, devIP : App.devIP, maxImport : 4000});
	}
	,doSyncAll2: function(dbQueryParam) {
		var _gthis = this;
		var p = this.props.load(dbQueryParam);
		p.then(function(data) {
			if(data.dataInfo.h["offset"] == null) {
				return App.store.dispatch(redux_Action.map(action_AppAction.Status(action_StatusAction.Update({ className : "error", text : "Fehler 0  Aktualisiert"}))));
			}
			var offset = Std.parseInt(data.dataInfo.h["offset"]);
			App.store.dispatch(redux_Action.map(action_AppAction.Status(action_StatusAction.Update({ className : " ", text : "" + offset + " von " + Std.string(data.dataInfo.h["maxImport"]) + " aktualisiert"}))));
			haxe_Log.trace("" + offset + " < " + Std.string(data.dataInfo.h["maxImport"]),{ fileName : "src/view/dashboard/DBSync.hx", lineNumber : 211, className : "view.dashboard.DBSync", methodName : "doSyncAll2"});
			if(offset < data.dataInfo.h["maxImport"]) {
				haxe_Log.trace("next loop:" + (data.dataInfo == null ? "null" : haxe_ds_StringMap.stringify(data.dataInfo.h)),{ fileName : "src/view/dashboard/DBSync.hx", lineNumber : 214, className : "view.dashboard.DBSync", methodName : "doSyncAll2"});
				return _gthis.doSyncAll2(data.dataInfo);
			} else {
				_gthis.setState({ loading : false});
				return App.store.dispatch(redux_Action.map(action_AppAction.Status(action_StatusAction.Update({ className : " ", text : "" + offset + " von " + Std.string(data.dataInfo.h["maxImport"]) + " aktualisiert"}))));
			}
		});
		return p;
	}
	,importContacts2: function(_) {
		haxe_Log.trace(this.props.userState.dbUser.first_name,{ fileName : "src/view/dashboard/DBSync.hx", lineNumber : 234, className : "view.dashboard.DBSync", methodName : "importContacts2"});
		App.store.dispatch(action_async_LivePBXSync.importContacts({ devIP : App.devIP, limit : 4000, maxImport : 4000, userState : this.props.userState, offset : 0, classPath : "admin.SyncExternalContacts", action : "importContacts"}));
	}
	,importAllBookingRequests2: function(_) {
		haxe_Log.trace(this.props.userState.dbUser.first_name,{ fileName : "src/view/dashboard/DBSync.hx", lineNumber : 248, className : "view.dashboard.DBSync", methodName : "importAllBookingRequests2"});
		App.store.dispatch(action_async_LivePBXSync.importContacts({ limit : 50000, maxImport : 50000, userState : this.props.userState, offset : 100000, table : "bank_transfers", classPath : "admin.SyncExternalBookings", action : "importContacts"}));
	}
	,importBookingRequests2: function() {
		App.store.dispatch(redux_Action.map(action_async_LivePBXSync.importBookingRequests({ limit : 25000, offset : 0, classPath : "admin.SyncExternalBookings", action : "syncBookingRequests", userState : this.props.userState})));
	}
	,checkBookingRequests: function() {
		var _gthis = this;
		App.store.dispatch(redux_Action.map(action_AppAction.Status(action_StatusAction.Update({ className : "", text : "Aktualisiere Buchungsanforderungen"}))));
		var pro = action_async_LivePBXSync.check({ limit : 1000, userState : this.props.userState, offset : 0, classPath : "data.SyncExternal", action : "bookingRequestsCount"});
		pro.then(function(props) {
			haxe_Log.trace(props,{ fileName : "src/view/dashboard/DBSync.hx", lineNumber : 288, className : "view.dashboard.DBSync", methodName : "checkBookingRequests"});
			var _gthis1 = _gthis;
			var _g = new haxe_ds_StringMap();
			_g.h["action"] = "bookingRequestsCount";
			_g.h["buchungsAnforderungenCount"] = props.dataInfo.h["buchungsAnforderungenCount"];
			_g.h["bookingRequestsCount"] = props.dataInfo.h["bookingRequestsCount"];
			_gthis1.setState({ data : _g});
			haxe_Log.trace(_gthis.state.data == null ? "null" : haxe_ds_StringMap.stringify(_gthis.state.data.h),{ fileName : "src/view/dashboard/DBSync.hx", lineNumber : 294, className : "view.dashboard.DBSync", methodName : "checkBookingRequests"});
		},function(whatever) {
			haxe_Log.trace(whatever,{ fileName : "src/view/dashboard/DBSync.hx", lineNumber : 296, className : "view.dashboard.DBSync", methodName : "checkBookingRequests"});
		});
	}
	,checkAccounts: function() {
		var _gthis = this;
		App.store.dispatch(redux_Action.map(action_AppAction.Status(action_StatusAction.Update({ className : "", text : "Aktualisiere Konten"}))));
		var pro = action_async_LivePBXSync.check({ limit : 1000, userState : this.props.userState, offset : 0, classPath : "data.SyncExternal", action : "accountsCount"});
		pro.then(function(props) {
			haxe_Log.trace(props,{ fileName : "src/view/dashboard/DBSync.hx", lineNumber : 316, className : "view.dashboard.DBSync", methodName : "checkAccounts"});
			var _gthis1 = _gthis;
			var _g = new haxe_ds_StringMap();
			_g.h["action"] = "accountsCount";
			_g.h["pay_sourceCount"] = props.dataInfo.h["pay_sourceCount"];
			_g.h["accountsCount"] = props.dataInfo.h["accountsCount"];
			_gthis1.setState({ data : _g});
		},function(whatever) {
			haxe_Log.trace(whatever,{ fileName : "src/view/dashboard/DBSync.hx", lineNumber : 323, className : "view.dashboard.DBSync", methodName : "checkAccounts"});
		});
	}
	,checkContacts: function() {
		var _gthis = this;
		App.store.dispatch(redux_Action.map(action_AppAction.Status(action_StatusAction.Update({ className : "", text : "Aktualisiere Kontakte"}))));
		var pro = action_async_LivePBXSync.check({ limit : 1000, userState : this.props.userState, offset : 0, classPath : "data.SyncExternal", action : "clientsCount"});
		pro.then(function(props) {
			haxe_Log.trace(props,{ fileName : "src/view/dashboard/DBSync.hx", lineNumber : 343, className : "view.dashboard.DBSync", methodName : "checkContacts"});
			var _gthis1 = _gthis;
			var _g = new haxe_ds_StringMap();
			_g.h["action"] = "contactsCount";
			_g.h["clientsCount"] = props.dataInfo.h["clientsCount"];
			_g.h["contactsCount"] = props.dataInfo.h["contactsCount"];
			_gthis1.setState({ data : _g});
		},function(whatever) {
			haxe_Log.trace(whatever,{ fileName : "src/view/dashboard/DBSync.hx", lineNumber : 350, className : "view.dashboard.DBSync", methodName : "checkContacts"});
		});
	}
	,checkDeals: function() {
		var _gthis = this;
		App.store.dispatch(redux_Action.map(action_AppAction.Status(action_StatusAction.Update({ className : "", text : "Aktualisiere Spenden"}))));
		var pro = action_async_LivePBXSync.check({ limit : 1000, userState : this.props.userState, offset : 0, classPath : "data.SyncExternal", action : "dealsCount"});
		pro.then(function(props) {
			haxe_Log.trace(props,{ fileName : "src/view/dashboard/DBSync.hx", lineNumber : 370, className : "view.dashboard.DBSync", methodName : "checkDeals"});
			var _gthis1 = _gthis;
			var _g = new haxe_ds_StringMap();
			_g.h["action"] = "dealsCount";
			_g.h["pay_planCount"] = props.dataInfo.h["pay_planCount"];
			_g.h["dealsCount"] = props.dataInfo.h["dealsCount"];
			_gthis1.setState({ data : _g});
		},function(whatever) {
			haxe_Log.trace(whatever,{ fileName : "src/view/dashboard/DBSync.hx", lineNumber : 377, className : "view.dashboard.DBSync", methodName : "checkDeals"});
			App.store.dispatch(redux_Action.map(action_AppAction.User(action_UserAction.LoginError({ dbUser : _gthis.props.userState.dbUser, lastError : "Du musst dich neu anmelden!"}))));
		});
	}
	,checkAll: function() {
		App.store.dispatch(redux_Action.map(action_AppAction.Status(action_StatusAction.Update({ className : " ", text : "Synchronisiere Kontakte, Spenden + Konten"}))));
		var pro = App.store.dispatch(action_async_LivePBXSync.checkAll({ limit : 1000, userState : this.props.userState, offset : 0, classPath : "admin.SyncExternal", action : "checkAll"}));
		pro.then(function(props) {
			haxe_Log.trace(props,{ fileName : "src/view/dashboard/DBSync.hx", lineNumber : 404, className : "view.dashboard.DBSync", methodName : "checkAll"});
		},function(whatever) {
			haxe_Log.trace(whatever,{ fileName : "src/view/dashboard/DBSync.hx", lineNumber : 406, className : "view.dashboard.DBSync", methodName : "checkAll"});
		});
	}
	,displaySummary: function() {
	}
	,importDeals2: function() {
		App.store.dispatch(redux_Action.map(action_AppAction.Status(action_StatusAction.Update({ className : " ", text : "Importiere Spenden"}))));
		App.store.dispatch(redux_Action.map(action_async_LivePBXSync.importDeals({ limit : 1000, offset : 0, onlyNew : true, classPath : "admin.SyncExternalDeals", action : "importAll", userState : this.props.userState})));
	}
	,syncDeals2: function() {
		App.store.dispatch(redux_Action.map(action_AppAction.Status(action_StatusAction.Update({ className : " ", text : "Aktualisiere Spenden"}))));
		App.store.dispatch(redux_Action.map(action_async_LivePBXSync.importDeals({ limit : 1000, offset : 0, classPath : "admin.SyncExternalDeals", action : "importAll", userState : this.props.userState})));
	}
	,syncUserDetails2: function(_) {
		var _gthis = this;
		haxe_Log.trace(App.config.api,{ fileName : "src/view/dashboard/DBSync.hx", lineNumber : 447, className : "view.dashboard.DBSync", methodName : "syncUserDetails2"});
		haxe_Log.trace(this.props.userState.dbUser,{ fileName : "src/view/dashboard/DBSync.hx", lineNumber : 448, className : "view.dashboard.DBSync", methodName : "syncUserDetails2"});
		loader_BinaryLoader.create("" + Std.string(App.config.api),{ id : this.props.userState.dbUser.id, jwt : this.props.userState.dbUser.jwt, fields : "id,table_name,field_name,disabled,element,required,use_as_index", classPath : "admin.SyncExternal", action : "syncUserDetails", devIP : App.devIP, dbUser : this.props.userState.dbUser},function(data) {
			haxe_Log.trace(data,{ fileName : "src/view/dashboard/DBSync.hx", lineNumber : 464, className : "view.dashboard.DBSync", methodName : "syncUserDetails2"});
			haxe_Log.trace(data.dataRows.length,{ fileName : "src/view/dashboard/DBSync.hx", lineNumber : 466, className : "view.dashboard.DBSync", methodName : "syncUserDetails2"});
			if(data.dataRows.length > 0) {
				_gthis.setState({ dataTable : data.dataRows});
			}
			App.store.dispatch(redux_Action.map(action_AppAction.Status(action_StatusAction.Update({ className : "", text : "aktualisiert: " + Std.string(data.dataInfo.h["updated"]) + " Benutzer"}))));
		});
	}
	,proxy_showUserList: function(_) {
		var _gthis = this;
		haxe_Log.trace(App.config.api,{ fileName : "src/view/dashboard/DBSync.hx", lineNumber : 481, className : "view.dashboard.DBSync", methodName : "proxy_showUserList"});
		loader_BinaryLoader.create("https://pitverwaltung.de/sync/proxy.php",{ id : this.props.userState.dbUser.id, jwt : this.props.userState.dbUser.jwt, fields : "id,table_name,field_name,disabled,element,required,use_as_index", classPath : "admin.SyncExternal", action : "syncUserDetails", target : "syncUsers.php", devIP : App.devIP},function(data) {
			haxe_Log.trace(data.dataRows.length,{ fileName : "src/view/dashboard/DBSync.hx", lineNumber : 499, className : "view.dashboard.DBSync", methodName : "proxy_showUserList"});
			if(data.dataRows.length > 0) {
				_gthis.setState({ dataTable : data.dataRows});
			}
		});
	}
	,componentDidMount: function() {
		if(this.props.userState != null) {
			haxe_Log.trace("yeah: " + this.props.userState.dbUser.first_name,{ fileName : "src/view/dashboard/DBSync.hx", lineNumber : 516, className : "view.dashboard.DBSync", methodName : "componentDidMount"});
		}
	}
	,go: function(aState) {
		haxe_Log.trace(Reflect.fields(aState),{ fileName : "src/view/dashboard/DBSync.hx", lineNumber : 521, className : "view.dashboard.DBSync", methodName : "go"});
		var dbaProps_action = this.props.match.params.action;
		var dbaProps_classPath = "data.Contacts";
		var dbaProps_dataSource = null;
		var dbaProps_table = "contacts";
		var dbaProps_userState = this.props.userState;
		switch(this.props.match.params.action) {
		case "delete":case "get":
			break;
		case "insert":
			var _g = 0;
			var _g1 = this.fieldNames;
			while(_g < _g1.length) {
				var f = _g1[_g];
				++_g;
				haxe_Log.trace("" + f + " =>" + Std.string(Reflect.field(aState,f)) + "<=",{ fileName : "src/view/dashboard/DBSync.hx", lineNumber : 535, className : "view.dashboard.DBSync", methodName : "go"});
				if(Reflect.field(aState,f) == "") {
					Reflect.deleteField(aState,f);
				}
			}
			Reflect.deleteField(aState,"id");
			Reflect.deleteField(aState,"creation_date");
			var _g = new haxe_ds_StringMap();
			var _g1 = new haxe_ds_StringMap();
			_g1.h["data"] = aState;
			var value = Reflect.fields(aState).join(",");
			_g1.h["fields"] = value;
			_g.h["contacts"] = _g1;
			dbaProps_dataSource = _g;
			break;
		}
	}
	,render: function() {
		haxe_Log.trace(this.props.match.params.section,{ fileName : "src/view/dashboard/DBSync.hx", lineNumber : 555, className : "view.dashboard.DBSync", methodName : "render"});
		var tmp = this.state.formApi;
		var tmp1 = react_ReactType.fromComp(React_Fragment);
		var tmp2 = react_ReactType.fromString("form");
		var tmp3 = this.renderResults();
		var tmp4 = React.createElement(tmp2,{ className : "tabComponentForm"},tmp3);
		return tmp.render(React.createElement(tmp1,{ },tmp4));
	}
	,renderResults: function() {
		if(this.state.data != null) {
			haxe_Log.trace(Std.string(this.state.data.h["action"]) + ":",{ fileName : "src/view/dashboard/DBSync.hx", lineNumber : 567, className : "view.dashboard.DBSync", methodName : "renderResults"});
		}
		haxe_Log.trace(this.state.loading,{ fileName : "src/view/dashboard/DBSync.hx", lineNumber : 568, className : "view.dashboard.DBSync", methodName : "renderResults"});
		if(this.state.data == null) {
			return React.createElement(react_ReactType.fromString("div"),{ className : "flex0 cCenter"},this.state.formApi.renderWait());
		}
		haxe_Log.trace("###########loading:" + Std.string(this.state.loading),{ fileName : "src/view/dashboard/DBSync.hx", lineNumber : 571, className : "view.dashboard.DBSync", methodName : "renderResults"});
		var _g = this.state.data.h["action"];
		if(_g == null) {
			return null;
		} else {
			switch(_g) {
			case "accountsCount":
				if(this.state.data.h["accountsCount"] == null) {
					return this.state.formApi.renderWait();
				} else {
					var tmp = react_ReactType.fromString("div");
					var tmp1 = react_ReactType.fromString("ul");
					var tmp2 = React.createElement(react_ReactType.fromString("li"),{ },React.createElement(react_ReactType.fromString("h3"),{ },"Konten"));
					var tmp3 = react_ReactType.fromString("li");
					var tmp4 = React.createElement(react_ReactType.fromString("div"),{ },"Live System:");
					var tmp5 = this.state.data.h["pay_sourceCount"];
					var tmp6 = React.createElement(tmp3,{ },tmp4,React.createElement(react_ReactType.fromString("div"),{ className : "tRight tableNums"},tmp5));
					var tmp3 = react_ReactType.fromString("li");
					var tmp4 = React.createElement(react_ReactType.fromString("div"),{ },"Neues System:");
					var tmp5 = this.state.data.h["accountsCount"];
					return React.createElement(tmp,{ className : "flex0 cCenter"},React.createElement(tmp1,{ },tmp2,tmp6,React.createElement(tmp3,{ },tmp4,React.createElement(react_ReactType.fromString("div"),{ className : "tRight tableNums"},tmp5))));
				}
				break;
			case "bookingRequestsCount":
				if(this.state.data.h["bookingRequestsCount"] == null) {
					return this.state.formApi.renderWait();
				} else {
					var tmp = react_ReactType.fromString("div");
					var tmp1 = react_ReactType.fromString("ul");
					var tmp2 = React.createElement(react_ReactType.fromString("li"),{ },React.createElement(react_ReactType.fromString("h3"),{ },"BuchungsAnforderungen"));
					var tmp3 = react_ReactType.fromString("li");
					var tmp4 = React.createElement(react_ReactType.fromString("div"),{ },"Live System:");
					var tmp5 = this.state.data.h["buchungsAnforderungenCount"];
					var tmp6 = React.createElement(tmp3,{ },tmp4,React.createElement(react_ReactType.fromString("div"),{ className : "tRight tableNums"},tmp5));
					var tmp3 = react_ReactType.fromString("li");
					var tmp4 = React.createElement(react_ReactType.fromString("div"),{ },"Neues System:");
					var tmp5 = this.state.data.h["bookingRequestsCount"];
					return React.createElement(tmp,{ className : "flex0 cCenter"},React.createElement(tmp1,{ },tmp2,tmp6,React.createElement(tmp3,{ },tmp4,React.createElement(react_ReactType.fromString("div"),{ className : "tRight tableNums"},tmp5))));
				}
				break;
			case "contactsCount":
				if(this.state.data.h["contactsCount"] == null) {
					return this.state.formApi.renderWait();
				} else {
					var tmp = react_ReactType.fromString("div");
					var tmp1 = react_ReactType.fromString("ul");
					var tmp2 = React.createElement(react_ReactType.fromString("li"),{ },React.createElement(react_ReactType.fromString("h3"),{ },"Kontakte"));
					var tmp3 = react_ReactType.fromString("li");
					var tmp4 = React.createElement(react_ReactType.fromString("div"),{ },"Live System:");
					var tmp5 = this.state.data.h["clientsCount"];
					var tmp6 = React.createElement(tmp3,{ },tmp4,React.createElement(react_ReactType.fromString("div"),{ className : "tRight tableNums"},tmp5));
					var tmp3 = react_ReactType.fromString("li");
					var tmp4 = React.createElement(react_ReactType.fromString("div"),{ },"Neues System:");
					var tmp5 = this.state.data.h["contactsCount"];
					return React.createElement(tmp,{ className : "flex0 cCenter"},React.createElement(tmp1,{ },tmp2,tmp6,React.createElement(tmp3,{ },tmp4,React.createElement(react_ReactType.fromString("div"),{ className : "tRight tableNums"},tmp5))));
				}
				break;
			case "dealsCount":
				if(this.state.data.h["dealsCount"] == null) {
					return this.state.formApi.renderWait();
				} else {
					var tmp = react_ReactType.fromString("div");
					var tmp1 = react_ReactType.fromString("ul");
					var tmp2 = React.createElement(react_ReactType.fromString("li"),{ },React.createElement(react_ReactType.fromString("h3"),{ },"Spenden"));
					var tmp3 = react_ReactType.fromString("li");
					var tmp4 = React.createElement(react_ReactType.fromString("div"),{ },"Live System:");
					var tmp5 = this.state.data.h["pay_planCount"];
					var tmp6 = React.createElement(tmp3,{ },tmp4,React.createElement(react_ReactType.fromString("div"),{ className : "tRight tableNums"},tmp5));
					var tmp3 = react_ReactType.fromString("li");
					var tmp4 = React.createElement(react_ReactType.fromString("div"),{ },"Neues System:");
					var tmp5 = this.state.data.h["dealsCount"];
					return React.createElement(tmp,{ className : "flex0 cCenter"},React.createElement(tmp1,{ },tmp2,tmp6,React.createElement(tmp3,{ },tmp4,React.createElement(react_ReactType.fromString("div"),{ className : "tRight tableNums"},tmp5))));
				}
				break;
			case "importClientList":
				haxe_Log.trace(this.state.actualState,{ fileName : "src/view/dashboard/DBSync.hx", lineNumber : 575, className : "view.dashboard.DBSync", methodName : "renderResults"});
				if(this.state.actualState == null) {
					return this.state.formApi.renderWait();
				} else {
					return this.state.formBuilder.renderForm({ mHandlers : this.state.mHandlers, fields : this.formFields, model : "importClientList", title : "Stammdaten Import"},this.state.actualState);
				}
				break;
			default:
				return null;
			}
		}
	}
	,updateMenu: function(viewClassPath) {
		var sideMenu = this.state.sideMenu;
		haxe_Log.trace(sideMenu.section,{ fileName : "src/view/dashboard/DBSync.hx", lineNumber : 633, className : "view.dashboard.DBSync", methodName : "updateMenu"});
		var _g = 0;
		var _g1 = sideMenu.menuBlocks.h["DBSync"].items;
		while(_g < _g1.length) {
			var mI = _g1[_g];
			++_g;
			var _g2 = mI.action;
			if(_g2 != null) {
				switch(_g2) {
				case "editTableFields":
					mI.disabled = this.state.selectedRows.length == 0;
					break;
				case "save":
					mI.disabled = this.state.clean;
					break;
				default:
				}
			}
		}
		return sideMenu;
	}
	,setState: null
	,__class__: view_dashboard_DBSync
});
var view_dashboard_Roles = function(props) {
	React_Component.call(this,props);
	this.state = { clean : true, hasError : false, mounted : false, loading : true, sideMenu : view_shared_io_FormApi.initSideMenu2(this,[{ dataClassPath : "roles.User", label : "Benutzer", section : "Users", items : view_shared_io_Users.menuItems},{ dataClassPath : "settings.Bookmarks", label : "Benutzergruppen", section : "Bookmarks", items : []},{ dataClassPath : "roles.Permissions", label : "Rechte", section : "permissions", items : []}],{ section : "Users", sameWidth : true})};
	new view_shared_io_FormApi(this,this.state.sideMenu);
	haxe_Log.trace(Reflect.fields(props),{ fileName : "src/view/dashboard/Roles.hx", lineNumber : 69, className : "view.dashboard.Roles", methodName : "new"});
};
$hxClasses["view.dashboard.Roles"] = view_dashboard_Roles;
view_dashboard_Roles.__name__ = "view.dashboard.Roles";
view_dashboard_Roles.mapStateToProps = function(aState) {
	return function(aState) {
		var uState = aState.userState;
		haxe_Log.trace(uState,{ fileName : "src/view/dashboard/Roles.hx", lineNumber : 133, className : "view.dashboard.Roles", methodName : "mapStateToProps"});
		return { userState : uState};
	};
};
view_dashboard_Roles.__super__ = React_Component;
view_dashboard_Roles.prototype = $extend(React_Component.prototype,{
	createUsers: function(ev) {
	}
	,editUsers: function(ev) {
	}
	,deleteUsers: function(ev) {
	}
	,createUserGroups: function(ev) {
	}
	,editUserGroups: function(ev) {
	}
	,deleteUserGroups: function(ev) {
	}
	,createRoles: function(ev) {
	}
	,editRoles: function(ev) {
	}
	,deleteRoles: function(ev) {
	}
	,importExternalUsers: function(ev) {
		haxe_Log.trace(ev.currentTarget,{ fileName : "src/view/dashboard/Roles.hx", lineNumber : 113, className : "view.dashboard.Roles", methodName : "importExternalUsers"});
		this.props.formApi.requests.push(haxe_ds_Either.Left(loader_AjaxLoader.load("" + Std.string(App.config.api),{ id : this.props.userState.dbUser.id, jwt : this.props.userState.dbUser.jwt, first_name : this.props.userState.dbUser.first_name, classPath : "admin.CreateUsers", action : "importExternal"},function(data) {
			haxe_Log.trace(data,{ fileName : "src/view/dashboard/Roles.hx", lineNumber : 124, className : "view.dashboard.Roles", methodName : "importExternalUsers"});
		})));
	}
	,componentDidMount: function() {
		haxe_Log.trace(this.state.loading,{ fileName : "src/view/dashboard/Roles.hx", lineNumber : 143, className : "view.dashboard.Roles", methodName : "componentDidMount"});
	}
	,render: function() {
		var sM = this.state.sideMenu;
		if(sM.menuBlocks != null) {
			var h = sM.menuBlocks.h;
			var inlStringMapKeyIterator_h = h;
			var inlStringMapKeyIterator_keys = Object.keys(h);
			var inlStringMapKeyIterator_length = inlStringMapKeyIterator_keys.length;
			var inlStringMapKeyIterator_current = 0;
			haxe_Log.trace(inlStringMapKeyIterator_keys[inlStringMapKeyIterator_current++] + ":" + this.props.match.params.section,{ fileName : "src/view/dashboard/Roles.hx", lineNumber : 168, className : "view.dashboard.Roles", methodName : "render"});
		}
		var tmp = react_ReactType.fromString("div");
		var tmp1 = this.renderContent();
		var tmp2 = view_shared_Menu._renderWrapper;
		var tmp3 = Object.assign({ },sM,{ className : "menu"});
		return React.createElement(tmp,{ className : "columns"},tmp1,React.createElement(tmp2,tmp3));
	}
	,renderContent: function() {
		haxe_Log.trace(this.props.match.params.action,{ fileName : "src/view/dashboard/Roles.hx", lineNumber : 180, className : "view.dashboard.Roles", methodName : "renderContent"});
		if(this.props.match.params.action == "userList") {
			return React.createElement(react_ReactType.fromComp(view_shared_io_Users),Object.assign({ },this.props,{ fullWidth : true}));
		} else {
			return React.createElement(react_ReactType.fromString("form"),{ className : "tabComponentForm"});
		}
	}
	,setState: null
	,__class__: view_dashboard_Roles
});
var view_dashboard_Settings = function(props) {
	React_Component.call(this,props);
	this.state = { clean : true, hasError : false, mounted : false, loading : true, sideMenu : view_shared_io_FormApi.initSideMenu2(this,[{ dataClassPath : "auth.User", label : "UserDaten", section : "user", items : view_shared_io_User.menuItems},{ dataClassPath : "settings.Bookmarks", label : "Lesezeichen", section : "bookmarks", items : view_shared_io_Bookmarks.menuItems},{ dataClassPath : "settings.Design", label : "Design", section : "design", items : view_shared_io_Design.menuItems}],{ section : "bookmarks", sameWidth : true})};
	if(props.match.params.section != null) {
		haxe_Log.trace(props.match.params.section,{ fileName : "src/view/dashboard/Settings.hx", lineNumber : 81, className : "view.dashboard.Settings", methodName : "new"});
	}
	haxe_Log.trace("" + props.match.params.section + " " + props.match.params.action,{ fileName : "src/view/dashboard/Settings.hx", lineNumber : 86, className : "view.dashboard.Settings", methodName : "new"});
	haxe_Log.trace(Reflect.fields(props),{ fileName : "src/view/dashboard/Settings.hx", lineNumber : 87, className : "view.dashboard.Settings", methodName : "new"});
};
$hxClasses["view.dashboard.Settings"] = view_dashboard_Settings;
view_dashboard_Settings.__name__ = "view.dashboard.Settings";
view_dashboard_Settings.__super__ = React_Component;
view_dashboard_Settings.prototype = $extend(React_Component.prototype,{
	componentDidCatch: function(error,info) {
		haxe_Log.trace(Reflect.fields(this.state),{ fileName : "src/view/dashboard/Settings.hx", lineNumber : 37, className : "view.dashboard.Settings", methodName : "componentDidCatch"});
		if(this.state.mounted) {
			this.setState({ hasError : true});
		}
		haxe_Log.trace(error,{ fileName : "src/view/dashboard/Settings.hx", lineNumber : 40, className : "view.dashboard.Settings", methodName : "componentDidCatch"});
		haxe_Log.trace(info,{ fileName : "src/view/dashboard/Settings.hx", lineNumber : 41, className : "view.dashboard.Settings", methodName : "componentDidCatch"});
	}
	,componentDidMount: function() {
		haxe_Log.trace(Reflect.fields(this.state),{ fileName : "src/view/dashboard/Settings.hx", lineNumber : 93, className : "view.dashboard.Settings", methodName : "componentDidMount"});
		haxe_Log.trace(this.state.loading,{ fileName : "src/view/dashboard/Settings.hx", lineNumber : 94, className : "view.dashboard.Settings", methodName : "componentDidMount"});
		haxe_Log.trace(Reflect.fields(this.props),{ fileName : "src/view/dashboard/Settings.hx", lineNumber : 95, className : "view.dashboard.Settings", methodName : "componentDidMount"});
		haxe_Log.trace(this.props.match.params.section,{ fileName : "src/view/dashboard/Settings.hx", lineNumber : 96, className : "view.dashboard.Settings", methodName : "componentDidMount"});
	}
	,render: function() {
		var _g = this.props.match.params.section;
		if(_g == null) {
			return React.createElement(view_shared_io_Bookmarks._renderWrapper,Object.assign({ },this.props,{ sideMenu : this.state.sideMenu, fullWidth : true}));
		} else {
			switch(_g) {
			case "Bookmarks":
				return React.createElement(view_shared_io_Bookmarks._renderWrapper,Object.assign({ },this.props,{ sideMenu : this.state.sideMenu, fullWidth : true}));
			case "User":
				return React.createElement(react_ReactType.fromComp(view_shared_io_User),Object.assign({ },this.props,{ sideMenu : this.state.sideMenu, fullWidth : true}));
			default:
				return null;
			}
		}
	}
	,setState: null
	,__class__: view_dashboard_Settings
});
var view_dashboard_Setup = function(props) {
	haxe_Log.trace(props.userState,{ fileName : "src/view/dashboard/Setup.hx", lineNumber : 41, className : "view.dashboard.Setup", methodName : "new"});
	React_Component.call(this,props);
	haxe_Log.trace(Reflect.fields(props),{ fileName : "src/view/dashboard/Setup.hx", lineNumber : 43, className : "view.dashboard.Setup", methodName : "new"});
	haxe_Log.trace(props.match.params.section,{ fileName : "src/view/dashboard/Setup.hx", lineNumber : 44, className : "view.dashboard.Setup", methodName : "new"});
	this.state = App.initEState({ sideMenu : view_shared_io_FormApi.initSideMenu2(this,[{ dataClassPath : "admin.SyncExternal", label : "DB Abgleich", section : "DBSync", items : view_dashboard_DBSync.menuItems},{ dataClassPath : "tools.DB", label : "DB Design", section : "DB", items : view_dashboard_DB.menuItems}],{ section : props.match.params.section == null ? "DBSync" : props.match.params.section, sameWidth : true})},this);
	haxe_Log.trace(Reflect.fields(props),{ fileName : "src/view/dashboard/Setup.hx", lineNumber : 73, className : "view.dashboard.Setup", methodName : "new"});
};
$hxClasses["view.dashboard.Setup"] = view_dashboard_Setup;
view_dashboard_Setup.__name__ = "view.dashboard.Setup";
view_dashboard_Setup.__super__ = React_Component;
view_dashboard_Setup.prototype = $extend(React_Component.prototype,{
	componentDidCatch: function(error,info) {
		haxe_Log.trace(info,{ fileName : "src/view/dashboard/Setup.hx", lineNumber : 77, className : "view.dashboard.Setup", methodName : "componentDidCatch"});
		if(this.state.mounted) {
			this.setState({ hasError : true});
		}
		haxe_Log.trace(error,{ fileName : "src/view/dashboard/Setup.hx", lineNumber : 81, className : "view.dashboard.Setup", methodName : "componentDidCatch"});
	}
	,componentDidMount: function() {
		this.setState({ mounted : true});
		if(this.props.match.params.section == null) {
			var basePath = this.props.match.url;
			this.props.history.push("" + basePath + "/DB");
			haxe_Log.trace(this.props.history.location.pathname,{ fileName : "src/view/dashboard/Setup.hx", lineNumber : 92, className : "view.dashboard.Setup", methodName : "componentDidMount"});
			haxe_Log.trace("setting section to:DB",{ fileName : "src/view/dashboard/Setup.hx", lineNumber : 93, className : "view.dashboard.Setup", methodName : "componentDidMount"});
		}
		haxe_Log.trace("" + 1,{ fileName : "src/view/dashboard/Setup.hx", lineNumber : 95, className : "view.dashboard.Setup", methodName : "componentDidMount"});
	}
	,render: function() {
		haxe_Log.trace(this.props.match.params.section,{ fileName : "src/view/dashboard/Setup.hx", lineNumber : 118, className : "view.dashboard.Setup", methodName : "render"});
		switch(this.props.match.params.section) {
		case "DB":
			return React.createElement(view_dashboard_DB._renderWrapper,Object.assign({ },this.props,{ fullWidth : true, sideMenu : this.state.sideMenu}));
		case "DBSync":
			return React.createElement(view_dashboard_DBSync._renderWrapper,Object.assign({ },this.props,{ fullWidth : true, sideMenu : this.state.sideMenu}));
		default:
			return null;
		}
	}
	,syncUserDetails: function() {
		haxe_Log.trace("ooo",{ fileName : "src/view/dashboard/Setup.hx", lineNumber : 136, className : "view.dashboard.Setup", methodName : "syncUserDetails"});
	}
	,setState: null
	,__class__: view_dashboard_Setup
});
var view_dashboard_model_DBFormsModel = function() { };
$hxClasses["view.dashboard.model.DBFormsModel"] = view_dashboard_model_DBFormsModel;
view_dashboard_model_DBFormsModel.__name__ = "view.dashboard.model.DBFormsModel";
view_dashboard_model_DBFormsModel.formatBool = function(v) {
	if(v) {
		return "Y";
	} else {
		return "N";
	}
};
view_dashboard_model_DBFormsModel.formatElementSelection = function(v) {
	if(v) {
		return "Y";
	} else {
		return "N";
	}
};
view_dashboard_model_DBFormsModel.dbMetaToState = function(dbMeta) {
	var sData = [];
	var _g = 0;
	while(_g < dbMeta.length) {
		var row = dbMeta[_g];
		++_g;
		var rM = new haxe_ds_StringMap();
		var h = row.h;
		var k_h = h;
		var k_keys = Object.keys(h);
		var k_length = k_keys.length;
		var k_current = 0;
		while(k_current < k_length) {
			var k = k_keys[k_current++];
			if(row.h[k].format_display != null) {
				var v = App.sprintf(row.h[k].format_display,row.h[k]);
				rM.h[k] = v;
			} else {
				var v1 = row.h[k];
				rM.h[k] = v1;
			}
		}
		sData.push(rM);
	}
	return sData;
};
var view_dashboard_model_DBSyncModel = function() { };
$hxClasses["view.dashboard.model.DBSyncModel"] = view_dashboard_model_DBSyncModel;
view_dashboard_model_DBSyncModel.__name__ = "view.dashboard.model.DBSyncModel";
view_dashboard_model_DBSyncModel.formatBool = function(v) {
	if(v) {
		return "Y";
	} else {
		return "N";
	}
};
view_dashboard_model_DBSyncModel.formatElementSelection = function(v) {
	if(v) {
		return "Y";
	} else {
		return "N";
	}
};
view_dashboard_model_DBSyncModel.formatPhone = function(p) {
	haxe_Log.trace(p,{ fileName : "src/view/dashboard/model/DBSyncModel.hx", lineNumber : 17, className : "view.dashboard.model.DBSyncModel", methodName : "formatPhone"});
	if(p) {
		return p.login;
	} else {
		return "";
	}
};
view_dashboard_model_DBSyncModel.dataSource = function(action) {
	switch(action) {
	case "importClientList":
		var _g = new haxe_ds_StringMap();
		var _g1 = new haxe_ds_StringMap();
		_g1.h["alias"] = "co";
		_g1.h["fields"] = "";
		_g1.h["jCond"] = "contact=co.id";
		_g.h["contacts"] = _g1;
		var _g1 = new haxe_ds_StringMap();
		_g1.h["alias"] = "da";
		_g1.h["fields"] = null;
		_g1.h["jCond"] = "contact=co.id";
		_g.h["deals"] = _g1;
		var _g1 = new haxe_ds_StringMap();
		_g1.h["alias"] = "ac";
		_g1.h["fields"] = "";
		_g.h["accounts"] = _g1;
		return _g;
	case "loadClientData":
		var _g = new haxe_ds_StringMap();
		var _g1 = new haxe_ds_StringMap();
		_g1.h["alias"] = "co";
		_g1.h["fields"] = "";
		_g1.h["jCond"] = "contact=co.id";
		_g.h["contacts"] = _g1;
		var _g1 = new haxe_ds_StringMap();
		_g1.h["alias"] = "da";
		_g1.h["fields"] = null;
		_g1.h["jCond"] = "contact=co.id";
		_g.h["deals"] = _g1;
		var _g1 = new haxe_ds_StringMap();
		_g1.h["alias"] = "ac";
		_g1.h["fields"] = "";
		_g.h["accounts"] = _g1;
		return _g;
	default:
		return null;
	}
};
view_dashboard_model_DBSyncModel.formFields = function(action) {
	switch(action) {
	case "editTableFields":
		var _g = new haxe_ds_StringMap();
		_g.h["table_name"] = { label : "Tabelle", disabled : true};
		_g.h["field_name"] = { label : "Feldname", disabled : true};
		_g.h["field_type"] = { label : "Datentyp", type : "Select"};
		_g.h["element"] = { label : "Eingabefeld", type : "Select"};
		_g.h["disabled"] = { label : "Readonly", type : "Checkbox"};
		_g.h["required"] = { label : "Required", type : "Checkbox"};
		_g.h["use_as_index"] = { label : "Index", type : "Checkbox"};
		_g.h["any"] = { label : "Eigenschaften", disabled : true, type : "Hidden"};
		_g.h["id"] = { type : "Hidden"};
		return _g;
	case "importClientList":
		var _g = new haxe_ds_StringMap();
		_g.h["import_contacts"] = { label : "Kontakte", type : "Checkbox", preset : true};
		_g.h["contacts_limit"] = { label : "Anzahl", type : "Input"};
		_g.h["import_deals"] = { label : "Aufträge", type : "Checkbox", preset : true};
		_g.h["import_accounts"] = { label : "Kontent", type : "Checkbox", preset : true};
		return _g;
	default:
		return null;
	}
};
view_dashboard_model_DBSyncModel.dataAccess = function(action) {
	switch(action) {
	case "editTableFields":
		var _g = new haxe_ds_StringMap();
		var _g1 = new haxe_ds_StringMap();
		_g1.h["selectedRows"] = null;
		var _g2 = new haxe_ds_StringMap();
		_g2.h["table_name"] = { label : "Tabelle", disabled : true};
		_g2.h["field_name"] = { label : "Feldname", disabled : true};
		_g2.h["field_type"] = { label : "Datentyp", type : "Select"};
		_g2.h["element"] = { label : "Eingabefeld", type : "Select"};
		_g2.h["disabled"] = { label : "Readonly", type : "Checkbox"};
		_g2.h["required"] = { label : "Required", type : "Checkbox"};
		_g2.h["use_as_index"] = { label : "Index", type : "Checkbox"};
		_g2.h["any"] = { label : "Eigenschaften", disabled : true, type : "Hidden"};
		_g2.h["id"] = { type : "Hidden"};
		_g.h["" + action] = { source : _g1, view : _g2};
		return _g;
	case "importClientList":
		var _g = new haxe_ds_StringMap();
		var _g1 = new haxe_ds_StringMap();
		_g1.h["selectedRows"] = null;
		var _g2 = new haxe_ds_StringMap();
		_g2.h["import_contacts"] = { label : "Kontakte", type : "Checkbox", preset : true};
		_g2.h["contacts_limit"] = { label : "Anzahl", type : "Input"};
		_g2.h["import_deals"] = { label : "Aufträge", type : "Checkbox", preset : true};
		_g2.h["import_accounts"] = { label : "Kontent", type : "Checkbox", preset : true};
		_g.h["" + action] = { source : _g1, view : _g2};
		return _g;
	case "saveTableFields":
		var _g = new haxe_ds_StringMap();
		_g.h["" + action] = { source : null, view : null};
		return _g;
	default:
		return null;
	}
};
var view_shared_io_Bookmarks = function(props) {
	React_Component.call(this,props);
	var sideMenu = this.updateMenu("bookmarks");
	this.state = { clean : true, hasError : false, mounted : false, loading : true, sideMenu : sideMenu};
};
$hxClasses["view.shared.io.Bookmarks"] = view_shared_io_Bookmarks;
view_shared_io_Bookmarks.__name__ = "view.shared.io.Bookmarks";
view_shared_io_Bookmarks.__super__ = React_Component;
view_shared_io_Bookmarks.prototype = $extend(React_Component.prototype,{
	componentDidCatch: function(error,info) {
		if(this.state.mounted) {
			this.setState({ hasError : true});
		}
		haxe_Log.trace(error,{ fileName : "src/view/shared/io/Bookmarks.hx", lineNumber : 39, className : "view.shared.io.Bookmarks", methodName : "componentDidCatch"});
		haxe_Log.trace(info,{ fileName : "src/view/shared/io/Bookmarks.hx", lineNumber : 40, className : "view.shared.io.Bookmarks", methodName : "componentDidCatch"});
	}
	,add: function(ev) {
	}
	,'delete': function(ev) {
	}
	,edit: function(ev) {
		var _gthis = this;
		haxe_Log.trace("hi :)",{ fileName : "src/view/shared/io/Bookmarks.hx", lineNumber : 55, className : "view.shared.io.Bookmarks", methodName : "edit"});
		this.props.formApi.requests.push(haxe_ds_Either.Left(loader_AjaxLoader.load("" + Std.string(App.config.api),{ id : this.props.userState.dbUser.id, jwt : this.props.userState.dbUser.jwt, classPath : "auth.User", action : "update", filter : "id|" + this.props.userState.dbUser.id, dataSource : haxe_Serializer.run(null)},function(data) {
			if(data.rows == null) {
				return;
			}
			haxe_Log.trace(data.rows.length,{ fileName : "src/view/shared/io/Bookmarks.hx", lineNumber : 70, className : "view.shared.io.Bookmarks", methodName : "edit"});
			var dataRows = data.rows;
			haxe_Log.trace(Reflect.fields(dataRows[0]),{ fileName : "src/view/shared/io/Bookmarks.hx", lineNumber : 72, className : "view.shared.io.Bookmarks", methodName : "edit"});
			haxe_Log.trace(dataRows[0].active,{ fileName : "src/view/shared/io/Bookmarks.hx", lineNumber : 73, className : "view.shared.io.Bookmarks", methodName : "edit"});
			var _gthis1 = _gthis;
			var _g = new haxe_ds_StringMap();
			_g.h["accountData"] = dataRows;
			_gthis1.setState({ data : _g, loading : false});
		})));
		this.setState({ dataClassPath : "auth.User.edit"});
	}
	,save: function(ev) {
	}
	,no: function(ev) {
	}
	,render: function() {
		haxe_Log.trace(this.state,{ fileName : "src/view/shared/io/Bookmarks.hx", lineNumber : 116, className : "view.shared.io.Bookmarks", methodName : "render"});
		haxe_Log.trace(this.props.match.params,{ fileName : "src/view/shared/io/Bookmarks.hx", lineNumber : 119, className : "view.shared.io.Bookmarks", methodName : "render"});
		return React.createElement(react_ReactType.fromString("div"),{ className : "tabComponentForm"},"dummy");
	}
	,updateMenu: function(viewClassPath) {
		if(this.state == null) {
			haxe_Log.trace(this.state,{ fileName : "src/view/shared/io/Bookmarks.hx", lineNumber : 139, className : "view.shared.io.Bookmarks", methodName : "updateMenu"});
			return null;
		}
		var sideMenu = this.state.sideMenu;
		sideMenu.menuBlocks.h["bookmarks"].isActive = true;
		sideMenu.menuBlocks.h["bookmarks"].label = "Lesezeichen";
		var _g = 0;
		var _g1 = sideMenu.menuBlocks.h["bookmarks"].items;
		while(_g < _g1.length) {
			var mI = _g1[_g];
			++_g;
			var _g2 = mI.action;
			if(_g2 != null) {
				switch(_g2) {
				case "save":
					mI.disabled = this.state.clean;
					break;
				case "update":
					mI.disabled = this.state.selectedRows.length == 0;
					break;
				default:
				}
			}
		}
		return sideMenu;
	}
	,getRow: function(row) {
		return { one : row.one, two : row.two, three : row.three};
	}
	,setState: null
	,__class__: view_shared_io_Bookmarks
});
var view_shared_io_Design = function(props) {
	React_Component.call(this,props);
	this.state = { clean : true, hasError : false, mounted : false, loading : true, sideMenu : { }};
	haxe_Log.trace(this.props,{ fileName : "src/view/shared/io/Design.hx", lineNumber : 88, className : "view.shared.io.Design", methodName : "new"});
};
$hxClasses["view.shared.io.Design"] = view_shared_io_Design;
view_shared_io_Design.__name__ = "view.shared.io.Design";
view_shared_io_Design.__super__ = React_Component;
view_shared_io_Design.prototype = $extend(React_Component.prototype,{
	edit: function(ev) {
		var _gthis = this;
		haxe_Log.trace("hi :)",{ fileName : "src/view/shared/io/Design.hx", lineNumber : 31, className : "view.shared.io.Design", methodName : "edit"});
		this.props.formApi.requests.push(haxe_ds_Either.Left(loader_AjaxLoader.load("" + Std.string(App.config.api),{ id : this.props.userState.dbUser.id, jwt : this.props.userState.dbUser.jwt, classPath : "auth.User", action : "update", filter : "id|" + this.props.userState.dbUser.id},function(data) {
			if(data.rows == null) {
				return;
			}
			haxe_Log.trace(data.rows.length,{ fileName : "src/view/shared/io/Design.hx", lineNumber : 46, className : "view.shared.io.Design", methodName : "edit"});
			var dataRows = data.rows;
			haxe_Log.trace(Reflect.fields(dataRows[0]),{ fileName : "src/view/shared/io/Design.hx", lineNumber : 48, className : "view.shared.io.Design", methodName : "edit"});
			haxe_Log.trace(dataRows[0].active,{ fileName : "src/view/shared/io/Design.hx", lineNumber : 49, className : "view.shared.io.Design", methodName : "edit"});
			var _gthis1 = _gthis;
			var _g = new haxe_ds_StringMap();
			_g.h["accountData"] = dataRows;
			_gthis1.setState({ data : _g, loading : false});
		})));
		this.setState({ dataClassPath : "auth.User.edit"});
	}
	,render: function() {
		return React.createElement(react_ReactType.fromString("div"),{ });
	}
	,setState: null
	,__class__: view_shared_io_Design
});
var view_shared_io_Loader = function(cb,p,r) {
	this.cB = cb;
	this.params = p;
	this.post = p != null;
	this.req = r;
};
$hxClasses["view.shared.io.Loader"] = view_shared_io_Loader;
view_shared_io_Loader.__name__ = "view.shared.io.Loader";
view_shared_io_Loader.load = function(url,params,cB) {
	var req = new haxe_http_HttpJs(url);
	if(params != null) {
		var _g = 0;
		var _g1 = Reflect.fields(params);
		while(_g < _g1.length) {
			var k = _g1[_g];
			++_g;
			req.addParameter(k,Reflect.field(params,k));
		}
	}
	req.addHeader("Access-Control-Allow-Methods","PUT, GET, POST, DELETE, OPTIONS");
	req.addHeader("Access-Control-Allow-Origin","*");
	var loader = new view_shared_io_Loader(cB,params,req);
	req.onData = $bind(loader,loader._onData);
	req.onError = function(err) {
		haxe_Log.trace(err,{ fileName : "src/view/shared/io/Loader.hx", lineNumber : 35, className : "view.shared.io.Loader", methodName : "load"});
	};
	haxe_Log.trace("POST? " + Std.string(params) != null,{ fileName : "src/view/shared/io/Loader.hx", lineNumber : 36, className : "view.shared.io.Loader", methodName : "load"});
	req.withCredentials = true;
	req.request(params != null);
	return req;
};
view_shared_io_Loader.loadData = function(url,params,cB) {
	var loader = view_shared_io_Loader.queue(url,params,cB);
	view_shared_io_Loader.rqs.push(loader.req);
	if(view_shared_io_Loader.rqs.length == 1) {
		view_shared_io_Loader.rqs.shift().request(loader.post);
	}
	return loader.req;
};
view_shared_io_Loader.queue = function(url,params,cB) {
	var req = new haxe_http_HttpJs(url);
	if(params != null) {
		var _g = 0;
		var _g1 = Reflect.fields(params);
		while(_g < _g1.length) {
			var k = _g1[_g];
			++_g;
			req.addParameter(k,Reflect.field(params,k));
		}
	}
	req.addHeader("Access-Control-Allow-Methods","PUT, GET, POST, DELETE, OPTIONS");
	req.addHeader("Access-Control-Allow-Origin","*");
	var loader = new view_shared_io_Loader(cB,params,req);
	loader.url = url;
	req.onData = $bind(loader,loader._onQueueData);
	req.onError = function(err) {
		haxe_Log.trace(err,{ fileName : "src/view/shared/io/Loader.hx", lineNumber : 134, className : "view.shared.io.Loader", methodName : "queue"});
	};
	haxe_Log.trace("POST? " + Std.string(params) != null,{ fileName : "src/view/shared/io/Loader.hx", lineNumber : 135, className : "view.shared.io.Loader", methodName : "queue"});
	req.withCredentials = true;
	return loader;
};
view_shared_io_Loader.prototype = {
	cB: null
	,params: null
	,post: null
	,req: null
	,url: null
	,_onData: function(response) {
		if(response.length > 0) {
			haxe_Log.trace(response,{ fileName : "src/view/shared/io/Loader.hx", lineNumber : 60, className : "view.shared.io.Loader", methodName : "_onData"});
			var dataObj = null;
			try {
				dataObj = haxe_Unserializer.run(response);
			} catch( _g ) {
				haxe_NativeStackTrace.lastError = _g;
				var ex = haxe_Exception.caught(_g).unwrap();
				haxe_Log.trace(ex,{ fileName : "src/view/shared/io/Loader.hx", lineNumber : 67, className : "view.shared.io.Loader", methodName : "_onData"});
				return;
			}
			if(Object.prototype.hasOwnProperty.call(dataObj.h,"ERROR")) {
				haxe_Log.trace(dataObj.h["ERROR"],{ fileName : "src/view/shared/io/Loader.hx", lineNumber : 72, className : "view.shared.io.Loader", methodName : "_onData"});
				return;
			}
			if(this.cB != null) {
				this.cB(dataObj);
			}
		}
	}
	,_onError: function(err) {
		haxe_Log.trace(err,{ fileName : "src/view/shared/io/Loader.hx", lineNumber : 82, className : "view.shared.io.Loader", methodName : "_onError"});
	}
	,_onQueueData: function(response) {
		haxe_Log.trace(response,{ fileName : "src/view/shared/io/Loader.hx", lineNumber : 87, className : "view.shared.io.Loader", methodName : "_onQueueData"});
		if(response.length > 0) {
			var dataObj = null;
			try {
				dataObj = haxe_Unserializer.run(response);
				haxe_Log.trace(dataObj,{ fileName : "src/view/shared/io/Loader.hx", lineNumber : 93, className : "view.shared.io.Loader", methodName : "_onQueueData"});
			} catch( _g ) {
				haxe_NativeStackTrace.lastError = _g;
				var ex = haxe_Exception.caught(_g).unwrap();
				haxe_Log.trace(ex,{ fileName : "src/view/shared/io/Loader.hx", lineNumber : 97, className : "view.shared.io.Loader", methodName : "_onQueueData"});
				return;
			}
			if(response.indexOf("ERROR") > -1) {
				haxe_Log.trace(response,{ fileName : "src/view/shared/io/Loader.hx", lineNumber : 102, className : "view.shared.io.Loader", methodName : "_onQueueData"});
			} else if(this.cB != null) {
				this.cB(dataObj);
			}
			if(view_shared_io_Loader.rqs.length > 0) {
				view_shared_io_Loader.rqs.shift().request(this.post);
			}
		}
	}
	,__class__: view_shared_io_Loader
};
var view_shared_io_User = function(props) {
	React_Component.call(this,props);
	var _g = new haxe_ds_StringMap();
	var _g1 = new haxe_ds_StringMap();
	var _g2 = new haxe_ds_StringMap();
	_g2.h["fields"] = "id,change_pass_required,password";
	_g1.h["users"] = _g2;
	var _g2 = new haxe_ds_StringMap();
	_g2.h["id"] = { type : "Hidden"};
	_g2.h["pass"] = { type : "Password"};
	_g2.h["new_pass"] = { type : "Password"};
	_g.h["changePassword"] = { source : _g1, view : _g2};
	var _g1 = new haxe_ds_StringMap();
	var _g2 = new haxe_ds_StringMap();
	_g2.h["alias"] = "us";
	_g2.h["fields"] = "id,last_login,change_pass_required,password";
	_g1.h["users"] = _g2;
	var _g2 = new haxe_ds_StringMap();
	_g2.h["alias"] = "co";
	_g2.h["fields"] = "first_name,last_name,email";
	_g2.h["jCond"] = "contact=co.id";
	_g1.h["contacts"] = _g2;
	var _g2 = new haxe_ds_StringMap();
	_g2.h["id"] = { label : "UserID", disabled : true, type : "Hidden"};
	_g2.h["pass"] = { label : "Passwort", type : "Hidden"};
	_g2.h["first_name"] = { label : "Vorname"};
	_g2.h["last_name"] = { label : "Name"};
	_g2.h["email"] = { label : "Email"};
	var value = { label : "Letze Anmeldung", disabled : true, displayFormat : view_shared_io_FormApi.localDate()};
	_g2.h["last_login"] = value;
	_g.h["update"] = { source : _g1, view : _g2};
	_g.h["save"] = { source : null, view : null};
	this.dataAccess = _g;
};
$hxClasses["view.shared.io.User"] = view_shared_io_User;
view_shared_io_User.__name__ = "view.shared.io.User";
view_shared_io_User._instance = null;
view_shared_io_User.__super__ = React_Component;
view_shared_io_User.prototype = $extend(React_Component.prototype,{
	dataAccess: null
	,autoFocus: null
	,dataDisplay: null
	,componentDidMount: function() {
		haxe_Log.trace(this.props,{ fileName : "src/view/shared/io/User.hx", lineNumber : 107, className : "view.shared.io.User", methodName : "componentDidMount"});
	}
	,componentDidUpdate: function(prevProps,prevState) {
		haxe_Log.trace(App.store.getState().userState.dbUser.first_name,{ fileName : "src/view/shared/io/User.hx", lineNumber : 115, className : "view.shared.io.User", methodName : "componentDidUpdate"});
		if(this.autoFocus != null) {
			react_ReactRef.get_current(this.autoFocus).focus();
		}
	}
	,changePassword: function(ev) {
		haxe_Log.trace(this.state.values == null ? "null" : haxe_ds_StringMap.stringify(this.state.values.h),{ fileName : "src/view/shared/io/User.hx", lineNumber : 123, className : "view.shared.io.User", methodName : "changePassword"});
		haxe_Log.trace(this.props.match.params.action,{ fileName : "src/view/shared/io/User.hx", lineNumber : 124, className : "view.shared.io.User", methodName : "changePassword"});
		if(this.props.match.params.action != "changePassword") {
			this.updateMenu("changePassword");
			this.props.history.push(this.props.location.pathname + ("/user/changePassword/" + this.props.userState.dbUser.id));
			this.setState({ action : "changePassword"});
			return;
		} else if(!(this.state.values.h["pass"].length > 7 && this.state.values.h["new_pass"].length > 7)) {
			var _g = new haxe_ds_StringMap();
			_g.h["changePassword"] = "Die Passwörter müssen mindestens 8 Zeichen habe!";
			this.setState({ errors : _g});
			return;
		}
		if(this.state.values.h["new_pass"] != this.state.values.h["new_pass_confirm"]) {
			var _g = new haxe_ds_StringMap();
			_g.h["changePassword"] = "Die Passwörter stimmen nicht überein!";
			this.setState({ errors : _g});
			return;
		}
		if(this.state.values.h["new_pass"] == this.state.values.h["pass"] && this.state.values.h["new_pass"] != "" && this.state.values.h["new_pass"] != null) {
			var _g = new haxe_ds_StringMap();
			_g.h["changePassword"] = "Das Passwort muss geändert werden!";
			this.setState({ errors : _g});
			return;
		}
		haxe_Log.trace(App.store.getState().userState,{ fileName : "src/view/shared/io/User.hx", lineNumber : 140, className : "view.shared.io.User", methodName : "changePassword"});
	}
	,edit: function(ev) {
		var _gthis = this;
		haxe_Log.trace("hi :)",{ fileName : "src/view/shared/io/User.hx", lineNumber : 146, className : "view.shared.io.User", methodName : "edit"});
		this.props.formApi.requests.push(haxe_ds_Either.Left(view_shared_io_Loader.loadData("" + Std.string(App.config.api),{ id : this.props.userState.dbUser.id, jwt : this.props.userState.dbUser.jwt, classPath : "auth.User", action : "update", filter : "id|" + this.props.userState.dbUser.id, dataSource : haxe_Serializer.run(this.dataAccess.h["update"].source)},function(data) {
			haxe_Log.trace(data,{ fileName : "src/view/shared/io/User.hx", lineNumber : 159, className : "view.shared.io.User", methodName : "edit"});
			if(data == null) {
				return;
			}
			if(Object.prototype.hasOwnProperty.call(data[0].h,"ERROR")) {
				haxe_Log.trace(data[0].h["ERROR"],{ fileName : "src/view/shared/io/User.hx", lineNumber : 164, className : "view.shared.io.User", methodName : "edit"});
				return;
			}
			_gthis.setState({ fields : _gthis.dataAccess.h["update"].view, values : _gthis.props.formApi.createStateValues(data[0],_gthis.dataAccess.h["update"].view), loading : false});
		})));
	}
	,save: function(evt) {
		evt.preventDefault();
		haxe_Log.trace(this.state.data == null ? "null" : haxe_ds_StringMap.stringify(this.state.data.h),{ fileName : "src/view/shared/io/User.hx", lineNumber : 181, className : "view.shared.io.User", methodName : "save"});
		haxe_Log.trace(this.state.values == null ? "null" : haxe_ds_StringMap.stringify(this.state.values.h),{ fileName : "src/view/shared/io/User.hx", lineNumber : 182, className : "view.shared.io.User", methodName : "save"});
		var skeys = [];
		var h = this.dataAccess.h["update"].view.h;
		var k_h = h;
		var k_keys = Object.keys(h);
		var k_length = k_keys.length;
		var k_current = 0;
		while(k_current < k_length) {
			var k = k_keys[k_current++];
			if(!this.dataAccess.h["update"].view.h[k].disabled) {
				skeys.push(k);
			}
		}
		var tmp = haxe_Log.trace;
		var tmp1 = view_shared_io_FormApi.filterMap(this.state.values,skeys);
		tmp(tmp1 == null ? "null" : haxe_ds_StringMap.stringify(tmp1.h),{ fileName : "src/view/shared/io/User.hx", lineNumber : 193, className : "view.shared.io.User", methodName : "save"});
		haxe_Log.trace(skeys.toString(),{ fileName : "src/view/shared/io/User.hx", lineNumber : 194, className : "view.shared.io.User", methodName : "save"});
		var tmp = this.dataAccess.h["update"].source;
		haxe_Log.trace(tmp == null ? "null" : haxe_ds_StringMap.stringify(tmp.h),{ fileName : "src/view/shared/io/User.hx", lineNumber : 195, className : "view.shared.io.User", methodName : "save"});
		this.props.formApi.requests.push(haxe_ds_Either.Left(view_shared_io_Loader.load("" + Std.string(App.config.api),{ id : this.props.userState.dbUser.id, jwt : this.props.userState.dbUser.jwt, classPath : "auth.User", action : "save", filter : "id|" + this.props.userState.dbUser.id, dataSource : haxe_Serializer.run(this.dataAccess.h["update"].source)},function(data) {
			haxe_Log.trace(data,{ fileName : "src/view/shared/io/User.hx", lineNumber : 209, className : "view.shared.io.User", methodName : "save"});
		})));
	}
	,updateMenu: function(viewClassPath) {
		var sideMenu = this.state.sideMenu;
		sideMenu.menuBlocks.h["users"].isActive = true;
		var _g = 0;
		var _g1 = sideMenu.menuBlocks.h["users"].items;
		while(_g < _g1.length) {
			var mI = _g1[_g];
			++_g;
			var _g2 = mI.action;
			if(_g2 != null) {
				switch(_g2) {
				case "editTableFields":
					mI.disabled = this.state.selectedRows.length == 0;
					break;
				case "save":
					mI.disabled = this.state.clean;
					break;
				default:
				}
			}
		}
		return sideMenu;
	}
	,renderContent: function() {
		haxe_Log.trace(this.props.match.params.action,{ fileName : "src/view/shared/io/User.hx", lineNumber : 238, className : "view.shared.io.User", methodName : "renderContent"});
		switch(this.props.match.params.action) {
		case "changePassword":
			var tmp = react_ReactType.fromComp(React_Fragment);
			var tmp1 = this.renderErrors("changePassword");
			var tmp2 = react_ReactType.fromString("div");
			var tmp3 = React.createElement(react_ReactType.fromString("label"),{ className : "required"},"Aktuelles Passwort");
			var tmp4 = React.createElement(tmp2,{ className : "formField"},tmp3,React.createElement(react_ReactType.fromString("input"),{ ref : this.autoFocus, name : "pass", type : "password", onChange : this.state.handleChange, autoFocus : "true"}));
			var tmp2 = react_ReactType.fromString("div");
			var tmp3 = React.createElement(react_ReactType.fromString("label"),{ className : "required"},"Neues Passwort");
			var tmp5 = React.createElement(tmp2,{ className : "formField"},tmp3,React.createElement(react_ReactType.fromString("input"),{ name : "new_pass", type : "password", onChange : this.state.handleChange}));
			var tmp2 = react_ReactType.fromString("div");
			var tmp3 = React.createElement(react_ReactType.fromString("label"),{ className : "required"},"Neues Passwort bestätigen");
			var tmp6 = React.createElement(tmp2,{ className : "formField"},tmp3,React.createElement(react_ReactType.fromString("input"),{ name : "new_pass_confirm", type : "password", onChange : this.state.handleChange}));
			return React.createElement(tmp,{ },tmp1,tmp4,tmp5,tmp6);
		case "edit":
			return this.props.formApi.renderElements(this.state);
		default:
			return null;
		}
	}
	,renderErrors: function(name) {
		haxe_Log.trace(name + ":" + Std.string(Object.prototype.hasOwnProperty.call(this.state.errors.h,name)),{ fileName : "src/view/shared/io/User.hx", lineNumber : 268, className : "view.shared.io.User", methodName : "renderErrors"});
		if(Object.prototype.hasOwnProperty.call(this.state.errors.h,name)) {
			var tmp = this.state.errors.h[name];
			return React.createElement(react_ReactType.fromString("div"),{ className : "formField"},tmp);
		}
		return null;
	}
	,render: function() {
		if(this.state.values != null) {
			haxe_Log.trace(this.state.values == null ? "null" : haxe_ds_StringMap.stringify(this.state.values.h),{ fileName : "src/view/shared/io/User.hx", lineNumber : 281, className : "view.shared.io.User", methodName : "render"});
		}
		var tmp = react_ReactType.fromString("div");
		var tmp1 = react_ReactType.fromString("form");
		var tmp2 = this.renderContent();
		return React.createElement(tmp,{ className : "tabComponentForm"},React.createElement(tmp1,{ className : "form60"},tmp2));
	}
	,setState: null
	,__class__: view_shared_io_User
});
var view_shared_io_Users = function(props) {
	React_Component.call(this,props);
	haxe_Log.trace(this.props,{ fileName : "src/view/shared/io/Users.hx", lineNumber : 47, className : "view.shared.io.Users", methodName : "new"});
};
$hxClasses["view.shared.io.Users"] = view_shared_io_Users;
view_shared_io_Users.__name__ = "view.shared.io.Users";
view_shared_io_Users.__super__ = React_Component;
view_shared_io_Users.prototype = $extend(React_Component.prototype,{
	dataDisplay: null
	,dataAccess: null
	,render: function() {
		return React.createElement(react_ReactType.fromString("div"),{ });
	}
	,renderResults: function() {
		if(this.state.dataTable != null) {
			if(this.props.match.params.action == "userList") {
				return React.createElement(react_ReactType.fromComp(view_table_Table),Object.assign({ },this.props,{ id : "userList", data : this.state.dataTable == null ? null : this.state.dataTable, dataState : this.dataDisplay.h["userList"], className : "is-striped is-hoverable", fullWidth : true}));
			} else {
				return null;
			}
		}
		return null;
	}
	,setState: null
	,__class__: view_shared_io_Users
});
loader_AjaxLoader.rqs = [];
view_DashBoard.displayName = "DashBoard";
view_DashBoard.__fileName__ = "src/view/DashBoard.hx";
view_DashBoard._renderWrapper = (redux_react_ReactRedux.connect(view_DashBoard.mapStateToProps,view_DashBoard.mapDispatchToProps))(react_ReactTypeOf.fromComp(view_DashBoard));
view_DashBoard.__jsxStatic = view_DashBoard._renderWrapper;
view_dashboard_DB.menuItems = [{ label : "getView", action : "getView"},{ label : "setView", action : "setView"},{ label : "Formulare", action : "listForms"},{ label : "Bearbeiten", action : "edit"},{ label : "Speichern", action : "save"},{ label : "Löschen", action : "delete"}];
view_dashboard_DB.displayName = "DB";
view_dashboard_DB.__fileName__ = "src/view/dashboard/DB.hx";
view_dashboard_DB._renderWrapper = (redux_react_ReactRedux.connect(view_dashboard_DB.mapStateToProps))(react_ReactTypeOf.fromComp(view_dashboard_DB));
view_dashboard_DB.__jsxStatic = view_dashboard_DB._renderWrapper;
view_dashboard_DBSync.menuItems = [{ label : "BuchungsAnforderungen ", action : "checkBookingRequests"},{ label : "Kontakt Daten ", action : "checkContacts"},{ label : "Spenden Daten ", action : "checkDeals"},{ label : "Konto Daten ", action : "checkAccounts"}];
view_dashboard_DBSync.displayName = "DBSync";
view_dashboard_DBSync.__fileName__ = "src/view/dashboard/DBSync.hx";
view_dashboard_DBSync._renderWrapper = (redux_react_ReactRedux.connect(view_dashboard_DBSync.mapStateToProps,view_dashboard_DBSync.mapDispatchToProps))(react_ReactTypeOf.fromComp(view_dashboard_DBSync));
view_dashboard_DBSync.__jsxStatic = view_dashboard_DBSync._renderWrapper;
view_dashboard_Roles.displayName = "Roles";
view_dashboard_Roles.__fileName__ = "src/view/dashboard/Roles.hx";
view_dashboard_Roles._renderWrapper = (redux_react_ReactRedux.connect(view_dashboard_Roles.mapStateToProps))(react_ReactTypeOf.fromComp(view_dashboard_Roles));
view_dashboard_Roles.__jsxStatic = view_dashboard_Roles._renderWrapper;
view_dashboard_Settings.displayName = "Settings";
view_dashboard_Settings.__fileName__ = "src/view/dashboard/Settings.hx";
view_dashboard_Setup.displayName = "Setup";
view_dashboard_Setup.__fileName__ = "src/view/dashboard/Setup.hx";
view_dashboard_model_DBFormsModel.fieldsListColumns = new haxe_ds_StringMap();
view_dashboard_model_DBFormsModel.dataDisplay = new haxe_ds_StringMap();
view_dashboard_model_DBSyncModel.clientListColumns = (function($this) {
	var $r;
	var _g = new haxe_ds_StringMap();
	_g.h["client_id"] = { label : "ID", show : true};
	_g.h["first_name"] = { label : "Vorname", editable : true};
	_g.h["last_name"] = { label : "Name", editable : true};
	_g.h["phone"] = { label : "Telefon"};
	$r = _g;
	return $r;
}(this));
view_dashboard_model_DBSyncModel.userListColumns = (function($this) {
	var $r;
	var _g = new haxe_ds_StringMap();
	_g.h["user_id"] = { label : "ID", show : true};
	_g.h["user"] = { label : "User", editable : false};
	_g.h["full_name"] = { label : "Name", editable : true, flexGrow : 1};
	_g.h["phone_login"] = { label : "Nebenstelle", editable : true, className : "tRight"};
	_g.h["user_group"] = { label : "Gruppe", editable : true};
	$r = _g;
	return $r;
}(this));
view_dashboard_model_DBSyncModel.dataDisplay = (function($this) {
	var $r;
	var _g = new haxe_ds_StringMap();
	_g.h["userList"] = { altGroupPos : 0, columns : view_dashboard_model_DBSyncModel.userListColumns};
	_g.h["clientList"] = { altGroupPos : 0, columns : view_dashboard_model_DBSyncModel.clientListColumns};
	$r = _g;
	return $r;
}(this));
view_shared_io_Bookmarks.menuItems = [{ label : "Neu", action : "insert"},{ label : "Bearbeiten", action : "update"},{ label : "Speichern", action : "save"},{ label : "Löschen", action : "delete"}];
view_shared_io_Bookmarks.displayName = "Bookmarks";
view_shared_io_Bookmarks.__fileName__ = "src/view/shared/io/Bookmarks.hx";
view_shared_io_Bookmarks._renderWrapper = (redux_react_ReactRedux.connect())(react_ReactTypeOf.fromComp(view_shared_io_Bookmarks));
view_shared_io_Bookmarks.__jsxStatic = view_shared_io_Bookmarks._renderWrapper;
view_shared_io_Design.menuItems = [{ label : "Neu", action : "insert"},{ label : "Bearbeiten", action : "update"},{ label : "Speichern", action : "save"},{ label : "Löschen", action : "delete"}];
view_shared_io_Design.displayName = "Design";
view_shared_io_Design.__fileName__ = "src/view/shared/io/Design.hx";
view_shared_io_Loader.rqs = [];
view_shared_io_User.menuItems = [{ label : "Neu", action : "insert"},{ label : "Bearbeiten", action : "update"},{ label : "Speichern", action : "save"},{ label : "Löschen", action : "delete"}];
view_shared_io_User.displayName = "User";
view_shared_io_User.__fileName__ = "src/view/shared/io/User.hx";
view_shared_io_Users.menuItems = [{ label : "Liste", action : "get"},{ label : "Neu", action : "insert"},{ label : "Bearbeiten", action : "update"},{ label : "Speichern", action : "save"},{ label : "Löschen", action : "delete"}];
view_shared_io_Users.displayName = "Users";
view_shared_io_Users.__fileName__ = "src/view/shared/io/Users.hx";
if ($global.__REACT_HOT_LOADER__)
  [view_DashBoard,view_dashboard_DB,view_dashboard_DBSync,view_dashboard_Roles,view_dashboard_Settings,view_dashboard_Setup,view_shared_io_Bookmarks,view_shared_io_Design,view_shared_io_User,view_shared_io_Users].map(function(c) {
    __REACT_HOT_LOADER__.register(c,c.displayName,c.__fileName__);
  });
$s.view_DashBoard = view_DashBoard; 
})(typeof exports != "undefined" ? exports : typeof window != "undefined" ? window : typeof self != "undefined" ? self : this, typeof window != "undefined" ? window : typeof global != "undefined" ? global : typeof self != "undefined" ? self : this);
