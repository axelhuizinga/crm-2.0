(function ($hx_exports, $global) { "use-strict";
var $s = $global.$hx_scope, $_;
var haxe_Log = $s.g, React_Component = $s.a, $hxClasses = $s.b, redux_Action = $s.c, action_AppAction = $s.d, action_ConfigAction = $s.e, $extend = $s.f, react_ReactType = $s.h, React_Fragment = $s.l, bulma_$components_Tabs = $s.m, view_shared_TabLink = $s.n, shared_Utils = $s.bm, React = $s.j, react_router_Switch = $s.bn, react_router_Route = $s.o, App = $s.ag, Reflect = $s.k, EReg = $s.cb, haxe_ds_StringMap = $s.ak, view_shared_io_BaseForm = $s.cc, haxe_ds__$StringMap_StringMapKeyIterator = $s.cd, view_shared_io_FormApi = $s.p, action_async_CRUD = $s.bb, Std = $s.ae, react_ReactUtil = $s.ci, action_StatusAction = $s.bc, view_shared_Format = $s.co, model_Deal = $s.cl, StringTools = $s.cj, view_table_Table = $s.aa, redux_react_ReactRedux = $s.ai, react_ReactTypeOf = $s.aj, haxe_ds_IntMap = $s.bo, action_async_LiveDataAccess = $s.bp, haxe_NativeStackTrace = $s.an, haxe_Exception = $s.ao, me_cunity_debug_Out = $s.af, haxe_CallStack = $s.ca, $bind = $s.ad, haxe_Serializer = $s.ap, haxe_Unserializer = $s.am, view_grid_Grid = $s.cm, js_Boot = $s.i, Lambda = $s.ck, view_StatusBar = $s.bi;
$hx_exports["me"] = $hx_exports["me"] || {};
$hx_exports["me"]["cunity"] = $hx_exports["me"]["cunity"] || {};
$hx_exports["me"]["cunity"]["debug"] = $hx_exports["me"]["cunity"]["debug"] || {};
$hx_exports["me"]["cunity"]["debug"]["Out"] = $hx_exports["me"]["cunity"]["debug"]["Out"] || {};
var model_accounting_ReturnDebitModel = function() { };
$hxClasses["model.accounting.ReturnDebitModel"] = model_accounting_ReturnDebitModel;
model_accounting_ReturnDebitModel.__name__ = "model.accounting.ReturnDebitModel";
var view_Accounting = function(props,context) {
	this.mounted = false;
	haxe_Log.trace(context,{ fileName : "src/view/Accounting.hx", lineNumber : 41, className : "view.Accounting", methodName : "new"});
	React_Component.call(this,props);
	if(props.match.url == "/Accounting" && props.match.isExact) {
		haxe_Log.trace("pushing2: /Accounting/Imports/Files",{ fileName : "src/view/Accounting.hx", lineNumber : 47, className : "view.Accounting", methodName : "new"});
		props.history.push("/Accounting/Imports/List");
	}
};
$hxClasses["view.Accounting"] = view_Accounting;
view_Accounting.__name__ = "view.Accounting";
view_Accounting.mapDispatchToProps = function(dispatch) {
	return { onTodoClick : function(id) {
		return dispatch(redux_Action.map(action_AppAction.Config(action_ConfigAction.SetTheme("orange"))));
	}};
};
view_Accounting.mapStateToProps = function() {
	return function(aState) {
		var uState = aState.userState;
		return { appConfig : aState.config, userState : aState.userState, redirectAfterLogin : aState.locationStore.redirectAfterLogin};
	};
};
view_Accounting.__super__ = React_Component;
view_Accounting.prototype = $extend(React_Component.prototype,{
	mounted: null
	,componentDidMount: function() {
		this.mounted = true;
	}
	,componentDidCatch: function(error,info) {
		haxe_Log.trace(error,{ fileName : "src/view/Accounting.hx", lineNumber : 69, className : "view.Accounting", methodName : "componentDidCatch"});
	}
	,render: function() {
		var tmp = react_ReactType.fromComp(React_Fragment);
		var tmp1 = react_ReactType.fromString("div");
		var tmp2 = react_ReactType.fromComp(bulma_$components_Tabs);
		var tmp3 = react_ReactType.fromComp(view_shared_TabLink);
		var tmp4 = this.props;
		var tmp5 = this.props.location.key;
		var tmp6 = this.props.location.hash;
		var tmp7 = shared_Utils.extend(this.props.location.state,{ contact : this.props.location.hash});
		var tmp8 = React.createElement(tmp3,Object.assign({ },tmp4,{ to : { key : tmp5, hash : tmp6, pathname : "/Accounting/Bookings", search : "", state : tmp7}}),"Buchungen");
		var tmp3 = React.createElement(react_ReactType.fromComp(view_shared_TabLink),Object.assign({ },this.props,{ to : "/Accounting/Imports"}),"Lastschriften");
		var tmp4 = React.createElement(tmp1,{ className : "tabNav2"},React.createElement(tmp2,{ className : "is-boxed"},tmp8,tmp3));
		var tmp1 = react_ReactType.fromString("div");
		var tmp2 = react_ReactType.fromComp(react_router_Switch);
		var tmp3 = React.createElement(react_ReactType.fromComp(react_router_Route),Object.assign({ },this.props,{ path : "/Accounting/Bookings/:section?/:action?/:id?", component : react_ReactType.fromComp(view_accounting_Bookings)}));
		var tmp5 = React.createElement(react_ReactType.fromComp(react_router_Route),Object.assign({ },this.props,{ path : "/Accounting/Imports/:section?/:action?/:id?", component : react_ReactType.fromComp(view_accounting_Imports)}));
		var tmp6 = React.createElement(tmp1,{ className : "tabContent2"},React.createElement(tmp2,{ },tmp3,tmp5));
		var tmp1 = React.createElement(view_StatusBar._renderWrapper,this.props);
		return React.createElement(tmp,{ },tmp4,tmp6,tmp1);
	}
	,__class__: view_Accounting
});
var view_accounting_Bookings = function(props) {
	React_Component.call(this,props);
	if(props.match.params.section == null) {
		if(this._trace) {
			haxe_Log.trace("reme",{ fileName : "src/view/accounting/Bookings.hx", lineNumber : 51, className : "view.accounting.Bookings", methodName : "new"});
		}
		var baseUrl = props.match.path.split(":section")[0];
		props.history.push("" + baseUrl + "Create");
	}
	this.state = App.initEState({ loading : false},this);
	haxe_Log.trace(Reflect.fields(props),{ fileName : "src/view/accounting/Bookings.hx", lineNumber : 59, className : "view.accounting.Bookings", methodName : "new"});
};
$hxClasses["view.accounting.Bookings"] = view_accounting_Bookings;
view_accounting_Bookings.__name__ = "view.accounting.Bookings";
view_accounting_Bookings._instance = null;
view_accounting_Bookings.mapStateToProps = function(aState) {
	return function(aState) {
		var uState = aState.userState;
		haxe_Log.trace(uState,{ fileName : "src/view/accounting/Bookings.hx", lineNumber : 66, className : "view.accounting.Bookings", methodName : "mapStateToProps"});
		return { userState : uState};
	};
};
view_accounting_Bookings.__super__ = React_Component;
view_accounting_Bookings.prototype = $extend(React_Component.prototype,{
	_trace: null
	,dataDisplay: null
	,formApi: null
	,fieldNames: null
	,dbData: null
	,dbMetaData: null
	,componentDidMount: function() {
		haxe_Log.trace(this.props.match.params.action,{ fileName : "src/view/accounting/Bookings.hx", lineNumber : 75, className : "view.accounting.Bookings", methodName : "componentDidMount"});
		this.state.formApi.doAction();
	}
	,render: function() {
		haxe_Log.trace(this.props.match.params.section,{ fileName : "src/view/accounting/Bookings.hx", lineNumber : 99, className : "view.accounting.Bookings", methodName : "render"});
		if(this.props.match.params.section == "Create") {
			return React.createElement(view_accounting_booking_Create._renderWrapper,Object.assign({ },this.props,{ fullWidth : true, sideMenu : this.state.sideMenu}));
		} else {
			return null;
		}
	}
	,setState: null
	,__class__: view_accounting_Bookings
});
var view_accounting_Imports = function(props) {
	React_Component.call(this,props);
	this._trace = true;
	this.state = App.initEState({ dataTable : [], loading : false, importData : new haxe_ds_IntMap(), selectedRows : [], values : new haxe_ds_StringMap()},this);
	if(props.match.params.section == null) {
		var baseUrl = props.match.path.split(":section")[0];
		if(this._trace) {
			haxe_Log.trace("reme2" + baseUrl + "Files/",{ fileName : "src/view/accounting/Imports.hx", lineNumber : 89, className : "view.accounting.Imports", methodName : "new"});
		}
		props.history.push("" + baseUrl + "Files/");
	}
};
$hxClasses["view.accounting.Imports"] = view_accounting_Imports;
view_accounting_Imports.__name__ = "view.accounting.Imports";
view_accounting_Imports._instance = null;
view_accounting_Imports.mapStateToProps = function(aState) {
	return { userState : aState.userState};
};
view_accounting_Imports.mapDispatchToProps = function(dispatch) {
	return { select : function(id,data,match,selectType) {
		if(id == null) {
			id = -1;
		}
		haxe_Log.trace("select:" + id + " selectType:" + selectType,{ fileName : "src/view/accounting/Imports.hx", lineNumber : 111, className : "view.accounting.Imports", methodName : "mapDispatchToProps"});
		haxe_Log.trace(data,{ fileName : "src/view/accounting/Imports.hx", lineNumber : 112, className : "view.accounting.Imports", methodName : "mapDispatchToProps"});
		dispatch(redux_Action.map(action_async_LiveDataAccess.sSelect({ id : id, data : data, match : match, selectType : selectType})));
	}};
};
view_accounting_Imports.__super__ = React_Component;
view_accounting_Imports.prototype = $extend(React_Component.prototype,{
	_trace: null
	,dataAccess: null
	,dataDisplay: null
	,formApi: null
	,formBuilder: null
	,formFields: null
	,fieldNames: null
	,baseForm: null
	,contact: null
	,dbData: null
	,dbMetaData: null
	,componentDidCatch: function(error,info) {
		try {
			this.setState({ hasError : true});
		} catch( _g ) {
			haxe_NativeStackTrace.lastError = _g;
			var ex = haxe_Exception.caught(_g).unwrap();
			if(this._trace) {
				haxe_Log.trace(ex,{ fileName : "src/view/accounting/Imports.hx", lineNumber : 125, className : "view.accounting.Imports", methodName : "componentDidCatch"});
			}
		}
		if(this._trace) {
			haxe_Log.trace(error,{ fileName : "src/view/accounting/Imports.hx", lineNumber : 127, className : "view.accounting.Imports", methodName : "componentDidCatch"});
		}
		me_cunity_debug_Out.dumpStack(haxe_CallStack.callStack(),{ fileName : "src/view/accounting/Imports.hx", lineNumber : 128, className : "view.accounting.Imports", methodName : "componentDidCatch"});
	}
	,render: function() {
		haxe_Log.trace(this.props.match.params.action + ":" + this.props.match.params.section,{ fileName : "src/view/accounting/Imports.hx", lineNumber : 133, className : "view.accounting.Imports", methodName : "render"});
		haxe_Log.trace(this.state.loading,{ fileName : "src/view/accounting/Imports.hx", lineNumber : 134, className : "view.accounting.Imports", methodName : "render"});
		if(this.state.loading) {
			return this.state.formApi.renderWait();
		}
		haxe_Log.trace("###########loading:" + Std.string(this.state.sideMenu),{ fileName : "src/view/accounting/Imports.hx", lineNumber : 137, className : "view.accounting.Imports", methodName : "render"});
		switch(this.props.match.params.section) {
		case "Files":
			return React.createElement(view_accounting_imports_Files._renderWrapper,Object.assign({ },this.props,{ parentComponent : this, formApi : this.state.formApi, fullWidth : true}));
		case "List":
			haxe_Log.trace("render List",{ fileName : "src/view/accounting/Imports.hx", lineNumber : 141, className : "view.accounting.Imports", methodName : "render"});
			return React.createElement(view_accounting_imports_List._renderWrapper,Object.assign({ },this.props,{ limit : 100, parentComponent : this, formApi : this.state.formApi, fullWidth : true}));
		default:
			return null;
		}
	}
	,setState: null
	,__class__: view_accounting_Imports
});
var view_accounting_booking_Create = function(props) {
	this.mounted = false;
	React_Component.call(this,props);
	haxe_Log.trace(props.match.params,{ fileName : "src/view/accounting/booking/Create.hx", lineNumber : 89, className : "view.accounting.booking.Create", methodName : "new"});
	haxe_Log.trace(Reflect.fields(props),{ fileName : "src/view/accounting/booking/Create.hx", lineNumber : 91, className : "view.accounting.booking.Create", methodName : "new"});
	if(props.match.params.id == null && new EReg("open(/)*$","").match(props.match.params.action)) {
		haxe_Log.trace("nothing selected - redirect",{ fileName : "src/view/accounting/booking/Create.hx", lineNumber : 96, className : "view.accounting.booking.Create", methodName : "new"});
		var baseUrl = props.match.path.split(":section")[0];
		props.history.push("" + baseUrl + "List/get");
		return;
	}
	this.dataAccess = model_accounting_ReturnDebitModel.dataAccess;
	this.fieldNames = view_shared_io_BaseForm.initFieldNames(new haxe_ds__$StringMap_StringMapKeyIterator(this.dataAccess.h["open"].view.h));
	this.dataDisplay = model_accounting_ReturnDebitModel.dataDisplay;
	this.state = App.initEState({ actualState : null, initialData : null, loading : false, mHandlers : view_accounting_booking_Create.menuItems, selectedRows : [], sideMenu : view_shared_io_FormApi.initSideMenu(this,{ dataClassPath : "data.Bookings", label : "Buchungen", section : "Create", items : view_accounting_booking_Create.menuItems},{ section : props.match.params.section == null ? "Create" : props.match.params.section, sameWidth : true}), values : new haxe_ds_StringMap()},this);
	haxe_Log.trace(this.state.initialData,{ fileName : "src/view/accounting/booking/Create.hx", lineNumber : 130, className : "view.accounting.booking.Create", methodName : "new"});
	haxe_Log.trace(this.state.loading,{ fileName : "src/view/accounting/booking/Create.hx", lineNumber : 134, className : "view.accounting.booking.Create", methodName : "new"});
};
$hxClasses["view.accounting.booking.Create"] = view_accounting_booking_Create;
view_accounting_booking_Create.__name__ = "view.accounting.booking.Create";
view_accounting_booking_Create.mapDispatchToProps = function(dispatch) {
	haxe_Log.trace("here we should be ready to load",{ fileName : "src/view/accounting/booking/Create.hx", lineNumber : 138, className : "view.accounting.booking.Create", methodName : "mapDispatchToProps"});
	return { load : function(param) {
		return dispatch(redux_Action.map(action_async_CRUD.read(param)));
	}};
};
view_accounting_booking_Create.mapStateToProps = function(aState) {
	return { userState : aState.userState};
};
view_accounting_booking_Create.__super__ = React_Component;
view_accounting_booking_Create.prototype = $extend(React_Component.prototype,{
	dataAccess: null
	,dataDisplay: null
	,formApi: null
	,formBuilder: null
	,formFields: null
	,formRef: null
	,fieldNames: null
	,baseForm: null
	,deal: null
	,dbData: null
	,dbMetaData: null
	,mounted: null
	,componentDidMount: function() {
		this.dataAccess = model_accounting_ReturnDebitModel.dataAccess;
		haxe_Log.trace(this.props.match.params.action,{ fileName : "src/view/accounting/booking/Create.hx", lineNumber : 154, className : "view.accounting.booking.Create", methodName : "componentDidMount"});
		this.state.formApi.doAction("get");
	}
	,'delete': function(ev) {
		haxe_Log.trace(this.state.selectedRows.length,{ fileName : "src/view/accounting/booking/Create.hx", lineNumber : 160, className : "view.accounting.booking.Create", methodName : "delete"});
		var data = this.state.formApi.selectedRowsMap(this.state);
	}
	,get: function(ev) {
		var _gthis = this;
		haxe_Log.trace("hi " + Std.string(ev),{ fileName : "src/view/accounting/booking/Create.hx", lineNumber : 166, className : "view.accounting.booking.Create", methodName : "get"});
		var offset = 0;
		if(ev != null && ev.page != null) {
			offset = this.props.limit * ev.page | 0;
		}
		haxe_Log.trace(this.props.userState,{ fileName : "src/view/accounting/booking/Create.hx", lineNumber : 172, className : "view.accounting.booking.Create", methodName : "get"});
		var p = this.props.load({ classPath : "data.DebitReturnStatements", action : "get", filter : this.props.match.params.id != null ? { id : this.props.match.params.id, mandator : "1"} : { mandator : "1", processed : "false"}, limit : this.props.limit, offset : offset > 0 ? offset : 0, table : "debit_return_statements", resolveMessage : { success : "Rücklastschriften wurde geladen", failure : "Rücklastschriften konnten nicht geladen werden"}, dbUser : this.props.userState.dbUser, devIP : App.devIP});
		p.then(function(data) {
			haxe_Log.trace(data.dataRows.length,{ fileName : "src/view/accounting/booking/Create.hx", lineNumber : 190, className : "view.accounting.booking.Create", methodName : "get"});
			_gthis.setState({ loading : false, dataTable : data.dataRows});
		});
	}
	,edit: function(ev) {
		haxe_Log.trace(this.state.selectedRows.length,{ fileName : "src/view/accounting/booking/Create.hx", lineNumber : 197, className : "view.accounting.booking.Create", methodName : "edit"});
	}
	,update: function() {
		if(this.state.actualState != null) {
			haxe_Log.trace(this.state.actualState.fieldsModified.length,{ fileName : "src/view/accounting/booking/Create.hx", lineNumber : 204, className : "view.accounting.booking.Create", methodName : "update"});
		}
		if(this.state.actualState == null || this.state.actualState.fieldsModified.length == 0) {
			return;
		}
		var data2save = this.state.actualState.allModified();
		var doc = window.document;
		var aState = react_ReactUtil.copy(this.state.actualState);
		var dbQ = { classPath : "data.Deals", action : "update", data : data2save, filter : { id : this.state.actualState.id, mandator : 1}, resolveMessage : { success : "Spende " + this.state.actualState.id + " wurde aktualisiert", failure : "Spende " + this.state.actualState.id + " konnte nicht aktualisiert werden"}, table : "deals", dbUser : this.props.userState.dbUser, devIP : App.devIP};
		haxe_Log.trace("" + this.props.match.params.action + ": " + Std.string(this.state.initialData.id) + " :: creation_date: " + Std.string(aState.creation_date) + " " + Std.string(this.state.initialData.creation_date),{ fileName : "src/view/accounting/booking/Create.hx", lineNumber : 234, className : "view.accounting.booking.Create", methodName : "update"});
		if(this.state.actualState != null) {
			haxe_Log.trace(Std.string(this.state.actualState.modified()) + (":" + Std.string(this.state.actualState.fieldsModified)),{ fileName : "src/view/accounting/booking/Create.hx", lineNumber : 237, className : "view.accounting.booking.Create", methodName : "update"});
		}
		haxe_Log.trace(this.state.actualState.id,{ fileName : "src/view/accounting/booking/Create.hx", lineNumber : 240, className : "view.accounting.booking.Create", methodName : "update"});
		if(!this.state.actualState.modified()) {
			App.store.dispatch(redux_Action.map(action_AppAction.Status(action_StatusAction.Update({ className : "", text : "Spende wurde nicht geändert"}))));
			haxe_Log.trace("nothing modified",{ fileName : "src/view/accounting/booking/Create.hx", lineNumber : 249, className : "view.accounting.booking.Create", methodName : "update"});
			return;
		}
		haxe_Log.trace(this.state.actualState.allModified(),{ fileName : "src/view/accounting/booking/Create.hx", lineNumber : 252, className : "view.accounting.booking.Create", methodName : "update"});
		App.store.dispatch(redux_Action.map(action_async_CRUD.update(dbQ)));
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
				haxe_Log.trace(k,{ fileName : "src/view/accounting/booking/Create.hx", lineNumber : 265, className : "view.accounting.booking.Create", methodName : "initStateFromDataTable"});
				if(this.dataDisplay.h["fieldsList"].columns.h[k].cellFormat == view_shared_Format.formatBool) {
					rS[k] = dR.h[k] == "Y";
				} else {
					rS[k] = dR.h[k];
				}
			}
			iS[dR.h["id"]] = rS;
		}
		haxe_Log.trace(iS,{ fileName : "src/view/accounting/booking/Create.hx", lineNumber : 275, className : "view.accounting.booking.Create", methodName : "initStateFromDataTable"});
		return iS;
	}
	,loadDealData: function(id) {
		var _gthis = this;
		haxe_Log.trace("loading:" + id,{ fileName : "src/view/accounting/booking/Create.hx", lineNumber : 281, className : "view.accounting.booking.Create", methodName : "loadDealData"});
		if(id == null) {
			return;
		}
		var p = this.props.load({ classPath : "data.Deals", action : "get", filter : { id : id, mandator : 1}, resolveMessage : { success : "Aktion " + id + " wurde geladen", failure : "Aktion " + id + " konnte nicht geladen werden"}, table : "deals", dbUser : this.props.userState.dbUser, devIP : App.devIP});
		p.then(function(data) {
			haxe_Log.trace(data.dataRows.length,{ fileName : "src/view/accounting/booking/Create.hx", lineNumber : 299, className : "view.accounting.booking.Create", methodName : "loadDealData"});
			if(data.dataRows.length == 1) {
				var data1 = data.dataRows[0];
				haxe_Log.trace(data1 == null ? "null" : haxe_ds_StringMap.stringify(data1.h),{ fileName : "src/view/accounting/booking/Create.hx", lineNumber : 303, className : "view.accounting.booking.Create", methodName : "loadDealData"});
				var deal = new model_Deal(data1);
				haxe_Log.trace(deal.id,{ fileName : "src/view/accounting/booking/Create.hx", lineNumber : 306, className : "view.accounting.booking.Create", methodName : "loadDealData"});
				_gthis.setState({ loading : false, actualState : deal, initialData : react_ReactUtil.copy(deal)});
				haxe_Log.trace(_gthis.state.actualState.id + ":" + _gthis.state.actualState.fieldsInitalized.join(","),{ fileName : "src/view/accounting/booking/Create.hx", lineNumber : 308, className : "view.accounting.booking.Create", methodName : "loadDealData"});
				haxe_Log.trace(_gthis.props.location.pathname + ":" + _gthis.state.actualState.amount,{ fileName : "src/view/accounting/booking/Create.hx", lineNumber : 310, className : "view.accounting.booking.Create", methodName : "loadDealData"});
				var _gthis1 = _gthis.props.history;
				var tmp = StringTools.replace(_gthis.props.location.pathname,"open","update");
				_gthis1.replace(tmp);
			}
		});
	}
	,renderResults: function() {
		haxe_Log.trace(this.props.match.params.section + ":" + Std.string(this.state.dataTable != null),{ fileName : "src/view/accounting/booking/Create.hx", lineNumber : 318, className : "view.accounting.booking.Create", methodName : "renderResults"});
		haxe_Log.trace(Std.string(this.state.loading) + ":" + this.props.match.params.action,{ fileName : "src/view/accounting/booking/Create.hx", lineNumber : 320, className : "view.accounting.booking.Create", methodName : "renderResults"});
		if(this.state.loading) {
			return this.state.formApi.renderWait();
		}
		haxe_Log.trace("###########loading:" + Std.string(this.state.loading),{ fileName : "src/view/accounting/booking/Create.hx", lineNumber : 323, className : "view.accounting.booking.Create", methodName : "renderResults"});
		switch(this.props.match.params.action) {
		case "delete":
			return null;
		case "insert":
			haxe_Log.trace(this.dataDisplay.h["fieldsList"],{ fileName : "src/view/accounting/booking/Create.hx", lineNumber : 349, className : "view.accounting.booking.Create", methodName : "renderResults"});
			haxe_Log.trace(Std.string(this.state.dataTable[29].h["id"]) + "<<<",{ fileName : "src/view/accounting/booking/Create.hx", lineNumber : 350, className : "view.accounting.booking.Create", methodName : "renderResults"});
			return React.createElement(react_ReactType.fromComp(view_table_Table),Object.assign({ },this.props,{ id : "fieldsList", data : this.state.dataTable, dataState : this.dataDisplay.h["fieldsList"], className : "is-striped is-hoverable", fullWidth : true}));
		case "open":case "update":
			haxe_Log.trace(this.state.actualState,{ fileName : "src/view/accounting/booking/Create.hx", lineNumber : 333, className : "view.accounting.booking.Create", methodName : "renderResults"});
			if(this.state.actualState == null) {
				return this.state.formApi.renderWait();
			} else {
				var tmp = this.state.formBuilder;
				var tmp1 = this.state.mHandlers;
				var _g = new haxe_ds_StringMap();
				var h = this.dataAccess.h["open"].view.h;
				var k_h = h;
				var k_keys = Object.keys(h);
				var k_length = k_keys.length;
				var k_current = 0;
				while(k_current < k_length) {
					var k = k_keys[k_current++];
					_g.h[k] = this.dataAccess.h["open"].view.h[k];
				}
				return tmp.renderForm({ mHandlers : tmp1, fields : _g, model : "deal", title : "Bearbeite Aktion"},this.state.actualState);
			}
			break;
		default:
			return null;
		}
	}
	,render: function() {
		haxe_Log.trace(this.props.match.params.section,{ fileName : "src/view/accounting/booking/Create.hx", lineNumber : 367, className : "view.accounting.booking.Create", methodName : "render"});
		var tmp = this.state.formApi;
		var tmp1 = react_ReactType.fromComp(React_Fragment);
		var tmp2 = react_ReactType.fromString("form");
		var tmp3 = this.renderResults();
		var tmp4 = React.createElement(tmp2,{ className : "tabComponentForm"},tmp3);
		return tmp.render(React.createElement(tmp1,{ },tmp4));
	}
	,updateMenu: function(viewClassPath) {
		var sideMenu = this.state.sideMenu;
		haxe_Log.trace(sideMenu.section,{ fileName : "src/view/accounting/booking/Create.hx", lineNumber : 379, className : "view.accounting.booking.Create", methodName : "updateMenu"});
		var _g = 0;
		var _g1 = sideMenu.menuBlocks.h["Contact"].items;
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
	,__class__: view_accounting_booking_Create
});
var view_accounting_imports_Files = function(props) {
	React_Component.call(this,props);
	view_accounting_imports_Files._instance = this;
	this.dataDisplay = model_accounting_ReturnDebitModel.dataGridDisplay;
	view_accounting_imports_Files.menuItems[0].handler = $bind(this,this.importReturnDebit);
	view_accounting_imports_Files.menuItems[0].formField.id = App._app.state.userState.dbUser.id;
	view_accounting_imports_Files.menuItems[0].formField.jwt = App._app.state.userState.dbUser.jwt;
	haxe_Log.trace(view_accounting_imports_Files.menuItems[0].formField,{ fileName : "src/view/accounting/imports/Files.hx", lineNumber : 112, className : "view.accounting.imports.Files", methodName : "new"});
	var _g = new haxe_ds_StringMap();
	_g.h["hint"] = "Datei zum Hochladen auswählen";
	this.state = App.initEState({ data : _g, action : props.match.params.action == null ? "importReturnDebit" : props.match.params.action, sideMenu : view_shared_io_FormApi.initSideMenu2(this,[{ dataClassPath : "admin.ImportCamt", label : "Liste", section : "List", items : view_accounting_imports_List.menuItems},{ dataClassPath : "admin.ImportCamt", label : "Dateien", section : "Files", items : view_accounting_imports_Files.menuItems}],{ section : props.match.params.section == null ? "Files" : props.match.params.section, sameWidth : true})},this);
	haxe_Log.trace(props.match.path,{ fileName : "src/view/accounting/imports/Files.hx", lineNumber : 138, className : "view.accounting.imports.Files", methodName : "new"});
};
$hxClasses["view.accounting.imports.Files"] = view_accounting_imports_Files;
view_accounting_imports_Files.__name__ = "view.accounting.imports.Files";
view_accounting_imports_Files._instance = null;
view_accounting_imports_Files.mapStateToProps = function(aState) {
	return { userState : aState.userState};
};
view_accounting_imports_Files.mapDispatchToProps = function(dispatch) {
	return { storeData : function(id,action) {
		dispatch(redux_Action.map(action_async_LiveDataAccess.storeData(id,action)));
	}, select : function(id,data,me,selectType) {
		if(id == null) {
			id = -1;
		}
		haxe_Log.trace("select:" + id + " selectType:" + selectType,{ fileName : "src/view/accounting/imports/Files.hx", lineNumber : 156, className : "view.accounting.imports.Files", methodName : "mapDispatchToProps"});
		haxe_Log.trace(data,{ fileName : "src/view/accounting/imports/Files.hx", lineNumber : 157, className : "view.accounting.imports.Files", methodName : "mapDispatchToProps"});
		dispatch(redux_Action.map(action_async_LiveDataAccess.sSelect({ id : id, data : data, match : me.props.match, selectType : selectType})));
	}};
};
view_accounting_imports_Files.__super__ = React_Component;
view_accounting_imports_Files.prototype = $extend(React_Component.prototype,{
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
	,componentDidMount: function() {
		this.dataAccess = model_accounting_ReturnDebitModel.dataAccess;
		haxe_Log.trace(this.props.match.params.action,{ fileName : "src/view/accounting/imports/Files.hx", lineNumber : 166, className : "view.accounting.imports.Files", methodName : "componentDidMount"});
		this.state.formApi.doAction();
	}
	,'delete': function(ev) {
		haxe_Log.trace(this.state.selectedRows.length,{ fileName : "src/view/accounting/imports/Files.hx", lineNumber : 172, className : "view.accounting.imports.Files", methodName : "delete"});
		var data = this.state.formApi.selectedRowsMap(this.state);
		haxe_Log.trace(data,{ fileName : "src/view/accounting/imports/Files.hx", lineNumber : 174, className : "view.accounting.imports.Files", methodName : "delete"});
	}
	,importReturnDebit: function(_) {
		var _gthis = this;
		var iPromise = new Promise(function(resolve,reject) {
			var finput = window.document.getElementById("returnDebitFile");
			haxe_Log.trace(_gthis.props.userState.dbUser.first_name + "::" + finput.files[0],{ fileName : "src/view/accounting/imports/Files.hx", lineNumber : 181, className : "view.accounting.imports.Files", methodName : "importReturnDebit"});
			var uFile = js_Boot.__cast(finput.files[0] , Blob);
			haxe_Log.trace(uFile,{ fileName : "src/view/accounting/imports/Files.hx", lineNumber : 184, className : "view.accounting.imports.Files", methodName : "importReturnDebit"});
			var fd = new FormData();
			fd.append("devIP",App.devIP);
			fd.append("id",Std.string(App._app.state.userState.dbUser.id));
			fd.append("jwt",Std.string(App._app.state.userState.dbUser.jwt));
			fd.append("mandator",Std.string(App.mandator));
			fd.append("action","returnDebitFile");
			fd.append("returnDebitFile",uFile,finput.value);
			var xhr = new XMLHttpRequest();
			xhr.open("POST","" + Std.string(App.config.api),true);
			xhr.onerror = function(e) {
				haxe_Log.trace(e,{ fileName : "src/view/accounting/imports/Files.hx", lineNumber : 196, className : "view.accounting.imports.Files", methodName : "importReturnDebit"});
				haxe_Log.trace(e.type,{ fileName : "src/view/accounting/imports/Files.hx", lineNumber : 197, className : "view.accounting.imports.Files", methodName : "importReturnDebit"});
				reject({ error : e});
			};
			xhr.withCredentials = true;
			xhr.onload = function(e) {
				haxe_Log.trace(xhr.status,{ fileName : "src/view/accounting/imports/Files.hx", lineNumber : 202, className : "view.accounting.imports.Files", methodName : "importReturnDebit"});
				if(xhr.status != 200) {
					haxe_Log.trace(xhr.statusText,{ fileName : "src/view/accounting/imports/Files.hx", lineNumber : 204, className : "view.accounting.imports.Files", methodName : "importReturnDebit"});
					reject({ error : xhr.statusText});
				}
				haxe_Log.trace(xhr.response.length,{ fileName : "src/view/accounting/imports/Files.hx", lineNumber : 207, className : "view.accounting.imports.Files", methodName : "importReturnDebit"});
				resolve(xhr.response);
			};
			xhr.send(fd);
			_gthis.setState({ action : "importReturnDebit", loading : true});
		});
		iPromise.then(function(r) {
			haxe_Log.trace(r,{ fileName : "src/view/accounting/imports/Files.hx", lineNumber : 216, className : "view.accounting.imports.Files", methodName : "importReturnDebit"});
			var rD = JSON.parse(r);
			var dd = JSON.parse(r);
			haxe_Log.trace(rD,{ fileName : "src/view/accounting/imports/Files.hx", lineNumber : 219, className : "view.accounting.imports.Files", methodName : "importReturnDebit"});
			var dT = [];
			var _g = 0;
			var _g1 = dd.rlData;
			while(_g < _g1.length) {
				var dR = _g1[_g];
				++_g;
				dT.push(shared_Utils.dynToMap(dR));
			}
			_gthis.setState({ action : "showImportedReturnDebit", dataTable : dT, loading : false});
			haxe_Log.trace(dT,{ fileName : "src/view/accounting/imports/Files.hx", lineNumber : 224, className : "view.accounting.imports.Files", methodName : "importReturnDebit"});
			_gthis.state.loading = false;
			var baseUrl = _gthis.props.match.path.split(":section")[0];
			App.store.dispatch(redux_Action.map(action_AppAction.Status(action_StatusAction.Update({ text : Lambda.count(dT) + " Rücklastschriften Importiert"}))));
		},function(r) {
			haxe_Log.trace(r,{ fileName : "src/view/accounting/imports/Files.hx", lineNumber : 235, className : "view.accounting.imports.Files", methodName : "importReturnDebit"});
			App.store.dispatch(redux_Action.map(action_AppAction.Status(action_StatusAction.Update({ className : "", text : r.error == null ? "" : r.error}))));
		});
	}
	,render: function() {
		haxe_Log.trace(this.props.match.params.section,{ fileName : "src/view/accounting/imports/Files.hx", lineNumber : 249, className : "view.accounting.imports.Files", methodName : "render"});
		var tmp = this.state.formApi;
		var tmp1 = react_ReactType.fromString("form");
		var tmp2 = this.renderResults();
		return tmp.render(React.createElement(tmp1,{ className : "tabComponentForm"},tmp2));
	}
	,renderResults: function() {
		haxe_Log.trace(this.state.action + ":" + Std.string(this.state.dataTable != null),{ fileName : "src/view/accounting/imports/Files.hx", lineNumber : 260, className : "view.accounting.imports.Files", methodName : "renderResults"});
		haxe_Log.trace(this.dataDisplay.h["rDebitList"],{ fileName : "src/view/accounting/imports/Files.hx", lineNumber : 261, className : "view.accounting.imports.Files", methodName : "renderResults"});
		if(this.state.loading) {
			return this.state.formApi.renderWait();
		}
		haxe_Log.trace("" + this.state.action + " ###########loading:" + Std.string(this.state.loading),{ fileName : "src/view/accounting/imports/Files.hx", lineNumber : 264, className : "view.accounting.imports.Files", methodName : "renderResults"});
		var _g = this.state.action;
		if(_g == null) {
			if(this.state.data != null && Object.prototype.hasOwnProperty.call(this.state.data.h,"hint")) {
				var tmp = react_ReactType.fromString("div");
				var tmp1 = this.state.data.h["hint"];
				return React.createElement(tmp,{ className : "hint"},React.createElement(react_ReactType.fromString("h3"),{ },tmp1));
			} else {
				return null;
			}
		} else if(_g == "showImportedReturnDebit") {
			if(this.state.dataTable == null) {
				return this.state.formApi.renderWait();
			} else {
				return React.createElement(react_ReactType.fromComp(view_grid_Grid),Object.assign({ },this.props,{ id : "importedReturnDebit", data : this.state.dataTable, dataState : this.dataDisplay.h["rDebitList"], parentComponent : this, className : "is-striped is-hoverable", fullWidth : true}));
			}
		} else if(this.state.data != null && Object.prototype.hasOwnProperty.call(this.state.data.h,"hint")) {
			var tmp = react_ReactType.fromString("div");
			var tmp1 = this.state.data.h["hint"];
			return React.createElement(tmp,{ className : "hint"},React.createElement(react_ReactType.fromString("h3"),{ },tmp1));
		} else {
			return null;
		}
	}
	,setState: null
	,__class__: view_accounting_imports_Files
});
var view_accounting_imports_List = function(props) {
	React_Component.call(this,props);
	view_accounting_imports_List._instance = this;
	this.dataDisplay = model_accounting_ReturnDebitModel.dataGridDisplay;
	haxe_Log.trace("..." + Std.string(Reflect.fields(props)),{ fileName : "src/view/accounting/imports/List.hx", lineNumber : 81, className : "view.accounting.imports.List", methodName : "new"});
	this.state = App.initEState({ action : props.match.params.action == null ? "listReturnDebit" : props.match.params.action, loading : true, sideMenu : view_shared_io_FormApi.initSideMenu2(this,[{ dataClassPath : "admin.ImportCamt", label : "Liste", section : "List", items : view_accounting_imports_List.menuItems},{ dataClassPath : "admin.ImportCamt", label : "Dateien", section : "Files", items : view_accounting_imports_Files.menuItems}],{ section : props.match.params.section == null ? "List" : props.match.params.section, sameWidth : true})},this);
	if(props.match.params.action == null) {
		var baseUrl = props.match.path.split(":section")[0];
		haxe_Log.trace("redirecting to " + baseUrl + "List/listReturnDebit",{ fileName : "src/view/accounting/imports/List.hx", lineNumber : 113, className : "view.accounting.imports.List", methodName : "new"});
		props.history.push("" + baseUrl + "List/listReturnDebit");
		this.listReturnDebit(null);
	}
	haxe_Log.trace(props.match.path,{ fileName : "src/view/accounting/imports/List.hx", lineNumber : 117, className : "view.accounting.imports.List", methodName : "new"});
};
$hxClasses["view.accounting.imports.List"] = view_accounting_imports_List;
view_accounting_imports_List.__name__ = "view.accounting.imports.List";
view_accounting_imports_List._instance = null;
view_accounting_imports_List.mapStateToProps = function(aState) {
	return { userState : aState.userState};
};
view_accounting_imports_List.mapDispatchToProps = function(dispatch) {
	return { load : function(param) {
		return dispatch(redux_Action.map(action_async_CRUD.read(param)));
	}, storeData : function(id,action) {
		dispatch(redux_Action.map(action_async_LiveDataAccess.storeData(id,action)));
	}, select : function(id,data,me,selectType) {
		if(id == null) {
			id = -1;
		}
		haxe_Log.trace(data,{ fileName : "src/view/accounting/imports/List.hx", lineNumber : 136, className : "view.accounting.imports.List", methodName : "mapDispatchToProps"});
		haxe_Log.trace("select:" + id + " selectType:" + selectType,{ fileName : "src/view/accounting/imports/List.hx", lineNumber : 137, className : "view.accounting.imports.List", methodName : "mapDispatchToProps"});
		dispatch(redux_Action.map(action_async_LiveDataAccess.sSelect({ id : id, data : data, match : me.props.match, selectType : selectType})));
	}, update : function(param) {
		return dispatch(redux_Action.map(action_async_CRUD.update(param)));
	}};
};
view_accounting_imports_List.__super__ = React_Component;
view_accounting_imports_List.prototype = $extend(React_Component.prototype,{
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
	,componentDidMount: function() {
		this.dataAccess = model_accounting_ReturnDebitModel.dataAccess;
		haxe_Log.trace(this.props.match.params.action,{ fileName : "src/view/accounting/imports/List.hx", lineNumber : 148, className : "view.accounting.imports.List", methodName : "componentDidMount"});
		if(this.props.match.params.action == "listReturnDebit") {
			this.listReturnDebit();
		}
	}
	,listReturnDebit: function(ev) {
		var _gthis = this;
		haxe_Log.trace("hi " + Std.string(ev),{ fileName : "src/view/accounting/imports/List.hx", lineNumber : 156, className : "view.accounting.imports.List", methodName : "listReturnDebit"});
		var offset = 0;
		if(ev != null && ev.page != null) {
			offset = this.props.limit * ev.page | 0;
		}
		haxe_Log.trace(this.props.match.params,{ fileName : "src/view/accounting/imports/List.hx", lineNumber : 162, className : "view.accounting.imports.List", methodName : "listReturnDebit"});
		var p = this.props.load({ classPath : "data.DebitReturnStatements", action : "get", filter : this.props.match.params.id != null ? { id : this.props.match.params.id, mandator : "1"} : { mandator : "1"}, limit : this.props.limit, offset : offset > 0 ? offset : 0, table : "debit_return_statements", resolveMessage : { success : "Lastschriftliste wurde geladen", failure : "Lastschriftliste konnte nicht geladen werden"}, dbUser : this.props.userState.dbUser, devIP : App.devIP});
		p.then(function(data) {
			haxe_Log.trace(data.dataRows.length,{ fileName : "src/view/accounting/imports/List.hx", lineNumber : 180, className : "view.accounting.imports.List", methodName : "listReturnDebit"});
			_gthis.setState({ loading : false, dataTable : data.dataRows, dataCount : Std.parseInt(data.dataInfo.h["count"]), pageCount : Math.ceil(Std.parseInt(data.dataInfo.h["count"]) / _gthis.props.limit)});
		});
	}
	,'delete': function(ev) {
		haxe_Log.trace(this.state.selectedRows.length,{ fileName : "src/view/accounting/imports/List.hx", lineNumber : 193, className : "view.accounting.imports.List", methodName : "delete"});
		var data = this.state.formApi.selectedRowsMap(this.state);
		haxe_Log.trace(data,{ fileName : "src/view/accounting/imports/List.hx", lineNumber : 195, className : "view.accounting.imports.List", methodName : "delete"});
	}
	,processReturnDebitStatements: function(_) {
		haxe_Log.trace(this.state.dataTable,{ fileName : "src/view/accounting/imports/List.hx", lineNumber : 200, className : "view.accounting.imports.List", methodName : "processReturnDebitStatements"});
		var p = this.props.update({ classPath : "data.DebitReturnStatements", action : "insert", mandator : 1, data : haxe_Serializer.run(this.state.dataTable), table : "debit_return_statements", resolveMessage : { success : "Rücklastschriften wurden verarbeitet", failure : "Rücklastschriften konnten nicht verarbeitet werden"}, dbUser : this.props.userState.dbUser, devIP : App.devIP});
		p.then(function(data) {
			haxe_Log.trace(haxe_Unserializer.run(data.dataInfo.h["data"]),{ fileName : "src/view/accounting/imports/List.hx", lineNumber : 219, className : "view.accounting.imports.List", methodName : "processReturnDebitStatements"});
			haxe_Log.trace(shared_Utils.getAllByKey(haxe_Unserializer.run(data.dataInfo.h["data"]),"ba_id"),{ fileName : "src/view/accounting/imports/List.hx", lineNumber : 220, className : "view.accounting.imports.List", methodName : "processReturnDebitStatements"});
		});
	}
	,loadLocal: function() {
		var finput = window.document.getElementById("returnDebitFile");
		haxe_Log.trace(finput.files,{ fileName : "src/view/accounting/imports/List.hx", lineNumber : 229, className : "view.accounting.imports.List", methodName : "loadLocal"});
		haxe_Log.trace(Reflect.fields(finput),{ fileName : "src/view/accounting/imports/List.hx", lineNumber : 230, className : "view.accounting.imports.List", methodName : "loadLocal"});
		console.log(finput.files);
		haxe_Log.trace(finput.value,{ fileName : "src/view/accounting/imports/List.hx", lineNumber : 232, className : "view.accounting.imports.List", methodName : "loadLocal"});
	}
	,render: function() {
		haxe_Log.trace(this.props.match.params.section,{ fileName : "src/view/accounting/imports/List.hx", lineNumber : 238, className : "view.accounting.imports.List", methodName : "render"});
		var tmp = this.state.formApi;
		var tmp1 = react_ReactType.fromComp(React_Fragment);
		var tmp2 = react_ReactType.fromString("form");
		var tmp3 = this.renderResults();
		var tmp4 = React.createElement(tmp2,{ className : "tabComponentForm"},tmp3);
		return tmp.render(React.createElement(tmp1,{ },tmp4));
	}
	,renderResults: function() {
		haxe_Log.trace(this.props.match.params.action + ":" + Std.string(this.state.dataTable != null),{ fileName : "src/view/accounting/imports/List.hx", lineNumber : 249, className : "view.accounting.imports.List", methodName : "renderResults"});
		if(this.state.loading) {
			return this.state.formApi.renderWait();
		}
		haxe_Log.trace("###########loading:" + Std.string(this.state.loading) + " state.action:" + this.state.action,{ fileName : "src/view/accounting/imports/List.hx", lineNumber : 252, className : "view.accounting.imports.List", methodName : "renderResults"});
		var _g = this.state.action;
		if(_g == null) {
			if(this.state.data == null) {
				return null;
			} else {
				var tmp = this.state.data.h["hint"];
				return React.createElement(react_ReactType.fromString("div"),{ className : "hint"},tmp);
			}
		} else if(_g == "listReturnDebit") {
			return React.createElement(react_ReactType.fromComp(view_grid_Grid),Object.assign({ },this.props,{ id : "contactList", data : this.state.dataTable, dataState : this.dataDisplay.h["rDebitList"], parentComponent : this, className : "is-striped is-hoverable", fullWidth : true}));
		} else if(this.state.data == null) {
			return null;
		} else {
			var tmp = this.state.data.h["hint"];
			return React.createElement(react_ReactType.fromString("div"),{ className : "hint"},tmp);
		}
	}
	,setState: null
	,__class__: view_accounting_imports_List
});
model_accounting_ReturnDebitModel.dataAccess = (function($this) {
	var $r;
	var _g = new haxe_ds_StringMap();
	{
		var _g1 = new haxe_ds_StringMap();
		var _g2 = new haxe_ds_StringMap();
		_g2.h["filter"] = "id";
		_g1.h["debit_return_statements"] = _g2;
		var _g2 = new haxe_ds_StringMap();
		_g2.h["id"] = { type : "Hidden"};
		_g2.h["edited_by"] = { type : "Hidden"};
		_g2.h["mandator"] = { type : "Hidden"};
		_g2.h["merged"] = { type : "Hidden"};
		_g.h["open"] = { source : _g1, view : _g2};
	}
	$r = _g;
	return $r;
}(this));
model_accounting_ReturnDebitModel.gridColumns = (function($this) {
	var $r;
	var _g = new haxe_ds_StringMap();
	_g.h["id"] = { label : "VertragsID", flexGrow : 0, className : "tRight tableNums"};
	_g.h["sepa_code"] = { label : "Sepa Code", flexGrow : 0, className : "tRight"};
	_g.h["iban"] = { label : "Iban", className : "tableNums"};
	_g.h["ba_id"] = { label : "Buchungsanforderung ID", flexGrow : 1};
	_g.h["amount"] = { label : "Betrag", className : "euro", headerClassName : "tRight"};
	$r = _g;
	return $r;
}(this));
model_accounting_ReturnDebitModel.listColumns = (function($this) {
	var $r;
	var _g = new haxe_ds_StringMap();
	_g.h["id"] = { label : "VertragsID", flexGrow : 0, className : "tRight tableNums"};
	_g.h["sepa_code"] = { label : "Sepa Code", flexGrow : 0, className : "tRight"};
	_g.h["iban"] = { label : "Iban"};
	_g.h["ba_id"] = { label : "Buchungsanforderung ID", flexGrow : 1};
	_g.h["amount"] = { label : "Betrag", className : "euro", headerClassName : "tRight"};
	$r = _g;
	return $r;
}(this));
model_accounting_ReturnDebitModel.dataDisplay = (function($this) {
	var $r;
	var _g = new haxe_ds_StringMap();
	_g.h["rDebitList"] = { columns : model_accounting_ReturnDebitModel.listColumns};
	$r = _g;
	return $r;
}(this));
model_accounting_ReturnDebitModel.dataGridDisplay = (function($this) {
	var $r;
	var _g = new haxe_ds_StringMap();
	_g.h["rDebitList"] = { columns : model_accounting_ReturnDebitModel.gridColumns};
	$r = _g;
	return $r;
}(this));
view_Accounting.displayName = "Accounting";
view_Accounting.__fileName__ = "src/view/Accounting.hx";
view_Accounting._renderWrapper = (redux_react_ReactRedux.connect(view_Accounting.mapStateToProps,view_Accounting.mapDispatchToProps))(react_ReactTypeOf.fromComp(view_Accounting));
view_Accounting.__jsxStatic = view_Accounting._renderWrapper;
view_accounting_Bookings.displayName = "Bookings";
view_accounting_Bookings.__fileName__ = "src/view/accounting/Bookings.hx";
view_accounting_Bookings._renderWrapper = (redux_react_ReactRedux.connect(view_accounting_Bookings.mapStateToProps))(react_ReactTypeOf.fromComp(view_accounting_Bookings));
view_accounting_Bookings.__jsxStatic = view_accounting_Bookings._renderWrapper;
view_accounting_Imports.displayName = "Imports";
view_accounting_Imports.__fileName__ = "src/view/accounting/Imports.hx";
view_accounting_Imports._renderWrapper = (redux_react_ReactRedux.connect(view_accounting_Imports.mapStateToProps,view_accounting_Imports.mapDispatchToProps))(react_ReactTypeOf.fromComp(view_accounting_Imports));
view_accounting_Imports.__jsxStatic = view_accounting_Imports._renderWrapper;
view_accounting_booking_Create.menuItems = [{ label : "Anzeigen", action : "get"},{ label : "Download", action : "download"},{ label : "Bearbeiten", action : "edit"}];
view_accounting_booking_Create.displayName = "Create";
view_accounting_booking_Create.__fileName__ = "src/view/accounting/booking/Create.hx";
view_accounting_booking_Create._renderWrapper = (redux_react_ReactRedux.connect(view_accounting_booking_Create.mapStateToProps,view_accounting_booking_Create.mapDispatchToProps))(react_ReactTypeOf.fromComp(view_accounting_booking_Create));
view_accounting_booking_Create.__jsxStatic = view_accounting_booking_Create._renderWrapper;
view_accounting_imports_Files.menuItems = [{ label : "Rücklastschriften", action : "importReturnDebit", formField : { name : "returnDebitFile", submit : "Importieren", type : "Upload", handleChange : function(evt) {
	var finput = window.document.getElementById("returnDebitFile");
	haxe_Log.trace(finput.value,{ fileName : "src/view/accounting/imports/Files.hx", lineNumber : 68, className : "view.accounting.imports.Files", methodName : "menuItems"});
	var val = finput.value == "" ? "" : finput.value.split("\\").pop();
	var tmp = view_accounting_imports_Files._instance;
	var _g = new haxe_ds_StringMap();
	_g.h["hint"] = "Zum Upload ausgewählt:" + val;
	tmp.setState({ data : _g});
}}, handler : function(_) {
	var finput = window.document.getElementById("returnDebitFile");
	haxe_Log.trace(finput.files,{ fileName : "src/view/accounting/imports/Files.hx", lineNumber : 78, className : "view.accounting.imports.Files", methodName : "menuItems"});
	haxe_Log.trace(Reflect.fields(finput),{ fileName : "src/view/accounting/imports/Files.hx", lineNumber : 79, className : "view.accounting.imports.Files", methodName : "menuItems"});
	console.log(finput.files["returnDebitFile"]);
	haxe_Log.trace(finput.value,{ fileName : "src/view/accounting/imports/Files.hx", lineNumber : 81, className : "view.accounting.imports.Files", methodName : "menuItems"});
}}];
view_accounting_imports_Files.displayName = "Files";
view_accounting_imports_Files.__fileName__ = "src/view/accounting/imports/Files.hx";
view_accounting_imports_Files._renderWrapper = (redux_react_ReactRedux.connect(view_accounting_imports_Files.mapStateToProps,view_accounting_imports_Files.mapDispatchToProps))(react_ReactTypeOf.fromComp(view_accounting_imports_Files));
view_accounting_imports_Files.__jsxStatic = view_accounting_imports_Files._renderWrapper;
view_accounting_imports_List.menuItems = [];
view_accounting_imports_List.displayName = "List";
view_accounting_imports_List.__fileName__ = "src/view/accounting/imports/List.hx";
view_accounting_imports_List._renderWrapper = (redux_react_ReactRedux.connect(view_accounting_imports_List.mapStateToProps,view_accounting_imports_List.mapDispatchToProps))(react_ReactTypeOf.fromComp(view_accounting_imports_List));
view_accounting_imports_List.__jsxStatic = view_accounting_imports_List._renderWrapper;
if ($global.__REACT_HOT_LOADER__)
  [view_Accounting,view_accounting_Bookings,view_accounting_Imports,view_accounting_booking_Create,view_accounting_imports_Files,view_accounting_imports_List].map(function(c) {
    __REACT_HOT_LOADER__.register(c,c.displayName,c.__fileName__);
  });
$s.view_Accounting = view_Accounting; 
})(typeof exports != "undefined" ? exports : typeof window != "undefined" ? window : typeof self != "undefined" ? self : this, typeof window != "undefined" ? window : typeof global != "undefined" ? global : typeof self != "undefined" ? self : this);
