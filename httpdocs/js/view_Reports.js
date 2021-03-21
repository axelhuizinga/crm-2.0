(function ($hx_exports, $global) { "use-strict";
var $s = $global.$hx_scope, $_;
var haxe_Log = $s.g, React_Component = $s.a, $hxClasses = $s.b, Reflect = $s.k, $extend = $s.f, react_ReactType = $s.h, React_Fragment = $s.l, bulma_$components_Tabs = $s.m, React = $s.j, view_shared_TabLink = $s.n, react_router_Switch = $s.bn, react_router_Route = $s.o, Std = $s.ae, App = $s.ag, haxe_ds_StringMap = $s.ak, haxe_NativeStackTrace = $s.an, haxe_Exception = $s.ao, view_stats_history_Charts = $s.da, redux_react_ReactRedux = $s.ai, react_ReactTypeOf = $s.aj, view_StatusBar = $s.bi;
$hx_exports["me"] = $hx_exports["me"] || {};
$hx_exports["me"]["cunity"] = $hx_exports["me"]["cunity"] || {};
$hx_exports["me"]["cunity"]["debug"] = $hx_exports["me"]["cunity"]["debug"] || {};
$hx_exports["me"]["cunity"]["debug"]["Out"] = $hx_exports["me"]["cunity"]["debug"]["Out"] || {};
var view_Reports = function(props,context) {
	this.mounted = false;
	haxe_Log.trace(context,{ fileName : "src/view/Reports.hx", lineNumber : 31, className : "view.Reports", methodName : "new"});
	React_Component.call(this,props);
	if(props.match.url == "/Reports" && props.match.isExact) {
		haxe_Log.trace("pushing2: /Reports/History",{ fileName : "src/view/Reports.hx", lineNumber : 37, className : "view.Reports", methodName : "new"});
		props.history.push("/Reports/History/Charts/get");
	}
};
$hxClasses["view.Reports"] = view_Reports;
view_Reports.__name__ = "view.Reports";
view_Reports.mapStateToProps = function() {
	return function(aState) {
		haxe_Log.trace(Reflect.fields(aState),{ fileName : "src/view/Reports.hx", lineNumber : 61, className : "view.Reports", methodName : "mapStateToProps"});
		return { appConfig : aState.config, userState : aState.userState};
	};
};
view_Reports.__super__ = React_Component;
view_Reports.prototype = $extend(React_Component.prototype,{
	mounted: null
	,componentDidMount: function() {
		this.mounted = true;
		haxe_Log.trace("Ok",{ fileName : "src/view/Reports.hx", lineNumber : 46, className : "view.Reports", methodName : "componentDidMount"});
	}
	,componentDidCatch: function(error,info) {
		haxe_Log.trace(error,{ fileName : "src/view/Reports.hx", lineNumber : 54, className : "view.Reports", methodName : "componentDidCatch"});
	}
	,render: function() {
		var tmp = react_ReactType.fromComp(React_Fragment);
		var tmp1 = react_ReactType.fromString("div");
		var tmp2 = react_ReactType.fromComp(bulma_$components_Tabs);
		var tmp3 = React.createElement(react_ReactType.fromComp(view_shared_TabLink),Object.assign({ },this.props,{ to : "/Reports/History"}),"Entwicklung");
		var tmp4 = React.createElement(react_ReactType.fromComp(view_shared_TabLink),Object.assign({ },this.props,{ to : "/Reports/Preview"}),"Vorschau");
		var tmp5 = React.createElement(tmp1,{ className : "tabNav2"},React.createElement(tmp2,{ className : "is-boxed"},tmp3,tmp4));
		var tmp1 = react_ReactType.fromString("div");
		var tmp2 = react_ReactType.fromComp(react_router_Switch);
		var tmp3 = React.createElement(react_ReactType.fromComp(react_router_Route),Object.assign({ },this.props,{ path : "/Reports/History/:section?/:action?/:id?", component : react_ReactType.fromComp(view_stats_History)}));
		var tmp4 = React.createElement(react_ReactType.fromComp(react_router_Route),Object.assign({ },this.props,{ path : "/Reports/Preview/:section?/:action?/:id?", component : react_ReactType.fromComp(view_stats_Preview)}));
		var tmp6 = React.createElement(tmp1,{ className : "tabContent2"},React.createElement(tmp2,{ },tmp3,tmp4));
		var tmp1 = React.createElement(view_StatusBar._renderWrapper,this.props);
		return React.createElement(tmp,{ },tmp5,tmp6,tmp1);
	}
	,setState: null
	,__class__: view_Reports
});
var view_stats_History = function(props) {
	React_Component.call(this,props);
	haxe_Log.trace("..." + Std.string(Reflect.fields(props)),{ fileName : "src/view/stats/History.hx", lineNumber : 59, className : "view.stats.History", methodName : "new"});
	haxe_Log.trace(props.match.params,{ fileName : "src/view/stats/History.hx", lineNumber : 60, className : "view.stats.History", methodName : "new"});
	if(props.match.params.section == null) {
		haxe_Log.trace("reme",{ fileName : "src/view/stats/History.hx", lineNumber : 64, className : "view.stats.History", methodName : "new"});
		var baseUrl = props.match.path.split(":section")[0];
		props.history.push("" + baseUrl + "Charts/get");
	}
	this.state = App.initEState({ dataTable : [], loading : false, values : new haxe_ds_StringMap()},this);
};
$hxClasses["view.stats.History"] = view_stats_History;
view_stats_History.__name__ = "view.stats.History";
view_stats_History.mapDispatchToProps = function(dispatch) {
	haxe_Log.trace("ok",{ fileName : "src/view/stats/History.hx", lineNumber : 99, className : "view.stats.History", methodName : "mapDispatchToProps"});
	return { };
};
view_stats_History.mapStateToProps = function(aState) {
	haxe_Log.trace(Reflect.fields(aState),{ fileName : "src/view/stats/History.hx", lineNumber : 108, className : "view.stats.History", methodName : "mapStateToProps"});
	if(aState.dataStore.contactData != null) {
		haxe_Log.trace(aState.dataStore.contactData.keys().next(),{ fileName : "src/view/stats/History.hx", lineNumber : 110, className : "view.stats.History", methodName : "mapStateToProps"});
	}
	if(aState.dataStore.contactsDbData != null) {
		var tmp = aState.dataStore.contactsDbData.dataRows[0];
		haxe_Log.trace(tmp == null ? "null" : haxe_ds_StringMap.stringify(tmp.h),{ fileName : "src/view/stats/History.hx", lineNumber : 112, className : "view.stats.History", methodName : "mapStateToProps"});
	} else {
		haxe_Log.trace(aState.dataStore,{ fileName : "src/view/stats/History.hx", lineNumber : 115, className : "view.stats.History", methodName : "mapStateToProps"});
		haxe_Log.trace(Reflect.fields(aState.dataStore),{ fileName : "src/view/stats/History.hx", lineNumber : 116, className : "view.stats.History", methodName : "mapStateToProps"});
	}
	haxe_Log.trace(App.store.getState().dataStore.contactsDbData,{ fileName : "src/view/stats/History.hx", lineNumber : 118, className : "view.stats.History", methodName : "mapStateToProps"});
	var bState = { dataStore : aState.dataStore, userState : aState.userState};
	haxe_Log.trace(bState.dataStore.contactData,{ fileName : "src/view/stats/History.hx", lineNumber : 125, className : "view.stats.History", methodName : "mapStateToProps"});
	return bState;
};
view_stats_History.__super__ = React_Component;
view_stats_History.prototype = $extend(React_Component.prototype,{
	dataAccess: null
	,dbData: null
	,componentDidCatch: function(error,info) {
		try {
			this.setState({ hasError : true});
		} catch( _g ) {
			haxe_NativeStackTrace.lastError = _g;
			var ex = haxe_Exception.caught(_g).unwrap();
			haxe_Log.trace(ex,{ fileName : "src/view/stats/History.hx", lineNumber : 83, className : "view.stats.History", methodName : "componentDidCatch"});
		}
		haxe_Log.trace(error,{ fileName : "src/view/stats/History.hx", lineNumber : 85, className : "view.stats.History", methodName : "componentDidCatch"});
	}
	,componentDidMount: function() {
		haxe_Log.trace(this.props.location.pathname,{ fileName : "src/view/stats/History.hx", lineNumber : 131, className : "view.stats.History", methodName : "componentDidMount"});
	}
	,render: function() {
		haxe_Log.trace(this.props.match.params.action,{ fileName : "src/view/stats/History.hx", lineNumber : 142, className : "view.stats.History", methodName : "render"});
		if(this.props.match.params.section == "Charts") {
			return React.createElement(react_ReactType.fromComp(view_stats_history_Charts),Object.assign({ },this.props,{ limit : 100, parentComponent : this, formApi : this.state.formApi, fullWidth : true, sideMenu : this.state.sideMenu}));
		} else {
			return null;
		}
	}
	,setState: null
	,__class__: view_stats_History
});
var view_stats_Preview = function(props,context) {
	React_Component.call(this,props,context);
};
$hxClasses["view.stats.Preview"] = view_stats_Preview;
view_stats_Preview.__name__ = "view.stats.Preview";
view_stats_Preview.__super__ = React_Component;
view_stats_Preview.prototype = $extend(React_Component.prototype,{
	render: function() {
		haxe_Log.trace(this.props.match.params.action,{ fileName : "src/view/stats/Preview.hx", lineNumber : 49, className : "view.stats.Preview", methodName : "render"});
		if(this.props.match.params.section == "Charts") {
			return React.createElement(react_ReactType.fromComp(view_stats_history_Charts),Object.assign({ },this.props,{ limit : 100, parentComponent : this, formApi : this.state.formApi, fullWidth : true, sideMenu : this.state.sideMenu}));
		} else {
			return null;
		}
	}
	,setState: null
	,__class__: view_stats_Preview
});
view_Reports.displayName = "Reports";
view_Reports.__fileName__ = "src/view/Reports.hx";
view_Reports._renderWrapper = (redux_react_ReactRedux.connect(view_Reports.mapStateToProps))(react_ReactTypeOf.fromComp(view_Reports));
view_Reports.__jsxStatic = view_Reports._renderWrapper;
view_stats_History.displayName = "History";
view_stats_History.__fileName__ = "src/view/stats/History.hx";
view_stats_History._renderWrapper = (redux_react_ReactRedux.connect(view_stats_History.mapStateToProps,view_stats_History.mapDispatchToProps))(react_ReactTypeOf.fromComp(view_stats_History));
view_stats_History.__jsxStatic = view_stats_History._renderWrapper;
view_stats_Preview.displayName = "Preview";
view_stats_Preview.__fileName__ = "src/view/stats/Preview.hx";
if ($global.__REACT_HOT_LOADER__)
  [view_Reports,view_stats_History,view_stats_Preview].map(function(c) {
    __REACT_HOT_LOADER__.register(c,c.displayName,c.__fileName__);
  });
$s.view_Reports = view_Reports; 
})(typeof exports != "undefined" ? exports : typeof window != "undefined" ? window : typeof self != "undefined" ? self : this, typeof window != "undefined" ? window : typeof global != "undefined" ? global : typeof self != "undefined" ? self : this);
