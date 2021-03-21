(function ($hx_exports, $global) { "use-strict";
var $s = $global.$hx_scope, $_;
var haxe_Log = $s.g, Std = $s.ae, React_Component = $s.a, $hxClasses = $s.b, redux_Action = $s.c, redux_thunk_Thunk = $s.bj, action_LocationAction = $s.bk, react_router_ReactRouter = $s.bl, $extend = $s.f, shared_Utils = $s.bm, Reflect = $s.k, react_ReactType = $s.h, React_Fragment = $s.l, bulma_$components_Tabs = $s.m, React = $s.j, view_shared_TabLink = $s.n, react_router_Switch = $s.bn, react_router_Route = $s.o, haxe_ds_StringMap = $s.ak, App = $s.ag, haxe_ds_IntMap = $s.bo, action_async_LiveDataAccess = $s.bp, haxe_NativeStackTrace = $s.an, haxe_Exception = $s.ao, me_cunity_debug_Out = $s.af, haxe_CallStack = $s.ca, EReg = $s.cb, view_shared_io_BaseForm = $s.cc, haxe_ds__$StringMap_StringMapKeyIterator = $s.cd, model_deals_DealsModel = $s.bh, DateTools = $s.ce, HxOverrides = $s.cf, view_shared_io_FormApi = $s.p, action_async_CRUD = $s.bb, Type = $s.cg, react_ReactRef = $s.al, js_Boot = $s.i, model_ORM = $s.ch, react_ReactUtil = $s.ci, StringTools = $s.cj, Lambda = $s.ck, model_Deal = $s.cl, view_grid_Grid = $s.cm, $bind = $s.ad, redux_react_ReactRedux = $s.ai, react_ReactTypeOf = $s.aj, hxbit_Serializer = $s.cn, action_AppAction = $s.d, action_StatusAction = $s.bc, view_shared_Format = $s.co, view_table_Table = $s.aa, view_shared_FormBuilder = $s.ba, action_async_DBAccess = $s.cp, view_StatusBar = $s.bi;
$hx_exports["me"] = $hx_exports["me"] || {};
$hx_exports["me"]["cunity"] = $hx_exports["me"]["cunity"] || {};
$hx_exports["me"]["cunity"]["debug"] = $hx_exports["me"]["cunity"]["debug"] || {};
$hx_exports["me"]["cunity"]["debug"]["Out"] = $hx_exports["me"]["cunity"]["debug"]["Out"] || {};
var action_async_LocationAccess = function() { };
$hxClasses["action.async.LocationAccess"] = action_async_LocationAccess;
action_async_LocationAccess.__name__ = "action.async.LocationAccess";
action_async_LocationAccess.redirect = function(routes,to,props) {
	if(props == null) {
		return redux_thunk_Thunk.Action(function(dispatch,getState) {
			haxe_Log.trace("Redirecting to " + to,{ fileName : "src/action/async/LocationAccess.hx", lineNumber : 19, className : "action.async.LocationAccess", methodName : "redirect"});
			return dispatch(redux_Action.map(action_LocationAction.LocationChange({ pathname : to, search : "", hash : "", key : null, state : null})));
		});
	}
	return redux_thunk_Thunk.Action(function(dispatch,getState) {
		haxe_Log.trace(props.location.pathname,{ fileName : "src/action/async/LocationAccess.hx", lineNumber : 30, className : "action.async.LocationAccess", methodName : "redirect"});
		haxe_Log.trace(to,{ fileName : "src/action/async/LocationAccess.hx", lineNumber : 31, className : "action.async.LocationAccess", methodName : "redirect"});
		var match = null;
		var _g = 0;
		while(_g < routes.length) {
			var route = routes[_g];
			++_g;
			match = react_router_ReactRouter.matchPath(props.location.pathname,{ path : route, exact : true, strict : false});
			haxe_Log.trace("" + route + " => " + Std.string(match),{ fileName : "src/action/async/LocationAccess.hx", lineNumber : 41, className : "action.async.LocationAccess", methodName : "redirect"});
			if(match != null) {
				return null;
			}
		}
		haxe_Log.trace("history.push(" + to + ")",{ fileName : "src/action/async/LocationAccess.hx", lineNumber : 47, className : "action.async.LocationAccess", methodName : "redirect"});
		props.history.push(to);
		return null;
	});
};
var model_Account = function(data) {
	model_ORM.call(this,data);
};
$hxClasses["model.Account"] = model_Account;
model_Account.__name__ = "model.Account";
model_Account.__super__ = model_ORM;
model_Account.prototype = $extend(model_ORM.prototype,{
	contact: null
	,set_contact: function(contact) {
		if(this.initialized("contact")) {
			this.modified("contact");
		}
		this.contact = contact;
		return contact;
	}
	,bank_name: null
	,set_bank_name: function(bank_name) {
		if(this.initialized("bank_name")) {
			this.modified("bank_name");
		}
		this.bank_name = bank_name;
		return bank_name;
	}
	,bic: null
	,set_bic: function(bic) {
		if(this.initialized("bic")) {
			this.modified("bic");
		}
		this.bic = bic;
		return bic;
	}
	,account: null
	,set_account: function(account) {
		if(this.initialized("account")) {
			this.modified("account");
		}
		this.account = account;
		return account;
	}
	,iban: null
	,set_iban: function(iban) {
		if(this.initialized("iban")) {
			this.modified("iban");
		}
		this.iban = iban;
		return iban;
	}
	,account_holder: null
	,set_account_holder: function(account_holder) {
		if(this.initialized("account_holder")) {
			this.modified("account_holder");
		}
		this.account_holder = account_holder;
		return account_holder;
	}
	,sign_date: null
	,set_sign_date: function(sign_date) {
		if(this.initialized("sign_date")) {
			this.modified("sign_date");
		}
		this.sign_date = sign_date;
		return sign_date;
	}
	,status: null
	,set_status: function(status) {
		if(this.initialized("status")) {
			this.modified("status");
		}
		this.status = status;
		return status;
	}
	,creation_date: null
	,set_creation_date: function(creation_date) {
		if(this.initialized("creation_date")) {
			this.modified("creation_date");
		}
		this.creation_date = creation_date;
		return creation_date;
	}
	,edited_by: null
	,set_edited_by: function(edited_by) {
		if(this.initialized("edited_by")) {
			this.modified("edited_by");
		}
		this.edited_by = edited_by;
		return edited_by;
	}
	,last_updated: null
	,set_last_updated: function(last_updated) {
		if(this.initialized("last_updated")) {
			this.modified("last_updated");
		}
		this.last_updated = last_updated;
		return last_updated;
	}
	,mandator: null
	,set_mandator: function(mandator) {
		if(this.initialized("mandator")) {
			this.modified("mandator");
		}
		this.mandator = mandator;
		return mandator;
	}
	,__class__: model_Account
	,__properties__: {set_mandator:"set_mandator",set_last_updated:"set_last_updated",set_edited_by:"set_edited_by",set_creation_date:"set_creation_date",set_status:"set_status",set_sign_date:"set_sign_date",set_account_holder:"set_account_holder",set_iban:"set_iban",set_account:"set_account",set_bic:"set_bic",set_bank_name:"set_bank_name",set_contact:"set_contact"}
});
var model_Contact = function(data) {
	model_ORM.call(this,data);
};
$hxClasses["model.Contact"] = model_Contact;
model_Contact.__name__ = "model.Contact";
model_Contact.__super__ = model_ORM;
model_Contact.prototype = $extend(model_ORM.prototype,{
	mandator: null
	,set_mandator: function(mandator) {
		if(this.initialized("mandator")) {
			this.modified("mandator");
		}
		this.mandator = mandator;
		return mandator;
	}
	,creation_date: null
	,set_creation_date: function(creation_date) {
		if(this.initialized("creation_date")) {
			this.modified("creation_date");
		}
		this.creation_date = creation_date;
		return creation_date;
	}
	,status: null
	,set_status: function(status) {
		if(this.initialized("status")) {
			this.modified("status");
		}
		this.status = status;
		return status;
	}
	,use_email: null
	,set_use_email: function(use_email) {
		if(this.initialized("use_email")) {
			this.modified("use_email");
		}
		this.use_email = use_email;
		return use_email;
	}
	,company_name: null
	,set_company_name: function(company_name) {
		if(this.initialized("company_name")) {
			this.modified("company_name");
		}
		this.company_name = company_name;
		return company_name;
	}
	,care_of: null
	,set_care_of: function(care_of) {
		if(this.initialized("care_of")) {
			this.modified("care_of");
		}
		this.care_of = care_of;
		return care_of;
	}
	,phone_code: null
	,set_phone_code: function(phone_code) {
		if(this.initialized("phone_code")) {
			this.modified("phone_code");
		}
		this.phone_code = phone_code;
		return phone_code;
	}
	,phone_number: null
	,set_phone_number: function(phone_number) {
		if(this.initialized("phone_number")) {
			this.modified("phone_number");
		}
		this.phone_number = phone_number;
		return phone_number;
	}
	,fax: null
	,set_fax: function(fax) {
		if(this.initialized("fax")) {
			this.modified("fax");
		}
		this.fax = fax;
		return fax;
	}
	,title: null
	,set_title: function(title) {
		if(this.initialized("title")) {
			this.modified("title");
		}
		this.title = title;
		return title;
	}
	,first_name: null
	,set_first_name: function(first_name) {
		if(this.initialized("first_name")) {
			this.modified("first_name");
		}
		this.first_name = first_name;
		return first_name;
	}
	,last_name: null
	,set_last_name: function(last_name) {
		if(this.initialized("last_name")) {
			this.modified("last_name");
		}
		this.last_name = last_name;
		return last_name;
	}
	,address: null
	,set_address: function(address) {
		if(this.initialized("address")) {
			this.modified("address");
		}
		this.address = address;
		return address;
	}
	,address_2: null
	,set_address_2: function(address_2) {
		if(this.initialized("address_2")) {
			this.modified("address_2");
		}
		this.address_2 = address_2;
		return address_2;
	}
	,city: null
	,set_city: function(city) {
		if(this.initialized("city")) {
			this.modified("city");
		}
		this.city = city;
		return city;
	}
	,postal_code: null
	,set_postal_code: function(postal_code) {
		if(this.initialized("postal_code")) {
			this.modified("postal_code");
		}
		this.postal_code = postal_code;
		return postal_code;
	}
	,country_code: null
	,set_country_code: function(country_code) {
		if(this.initialized("country_code")) {
			this.modified("country_code");
		}
		this.country_code = country_code;
		return country_code;
	}
	,gender: null
	,set_gender: function(gender) {
		if(this.initialized("gender")) {
			this.modified("gender");
		}
		this.gender = gender;
		return gender;
	}
	,date_of_birth: null
	,set_date_of_birth: function(date_of_birth) {
		if(this.initialized("date_of_birth")) {
			this.modified("date_of_birth");
		}
		this.date_of_birth = date_of_birth;
		return date_of_birth;
	}
	,mobile: null
	,set_mobile: function(mobile) {
		if(this.initialized("mobile")) {
			this.modified("mobile");
		}
		this.mobile = mobile;
		return mobile;
	}
	,email: null
	,set_email: function(email) {
		if(this.initialized("email")) {
			this.modified("email");
		}
		this.email = email;
		return email;
	}
	,comments: null
	,set_comments: function(comments) {
		if(this.initialized("comments")) {
			this.modified("comments");
		}
		this.comments = comments;
		return comments;
	}
	,edited_by: null
	,set_edited_by: function(edited_by) {
		if(this.initialized("edited_by")) {
			this.modified("edited_by");
		}
		this.edited_by = edited_by;
		return edited_by;
	}
	,merged: null
	,set_merged: function(merged) {
		if(this.initialized("merged")) {
			this.modified("merged");
		}
		this.merged = merged;
		return merged;
	}
	,last_updated: null
	,set_last_updated: function(last_updated) {
		if(this.initialized("last_updated")) {
			this.modified("last_updated");
		}
		this.last_updated = last_updated;
		return last_updated;
	}
	,owner: null
	,set_owner: function(owner) {
		if(this.initialized("owner")) {
			this.modified("owner");
		}
		this.owner = owner;
		return owner;
	}
	,__class__: model_Contact
	,__properties__: {set_owner:"set_owner",set_last_updated:"set_last_updated",set_merged:"set_merged",set_edited_by:"set_edited_by",set_comments:"set_comments",set_email:"set_email",set_mobile:"set_mobile",set_date_of_birth:"set_date_of_birth",set_gender:"set_gender",set_country_code:"set_country_code",set_postal_code:"set_postal_code",set_city:"set_city",set_address_2:"set_address_2",set_address:"set_address",set_last_name:"set_last_name",set_first_name:"set_first_name",set_title:"set_title",set_fax:"set_fax",set_phone_number:"set_phone_number",set_phone_code:"set_phone_code",set_care_of:"set_care_of",set_company_name:"set_company_name",set_use_email:"set_use_email",set_status:"set_status",set_creation_date:"set_creation_date",set_mandator:"set_mandator"}
});
var model_accounting_AccountsModel = function() { };
$hxClasses["model.accounting.AccountsModel"] = model_accounting_AccountsModel;
model_accounting_AccountsModel.__name__ = "model.accounting.AccountsModel";
var model_contacts_ContactsModel = function() { };
$hxClasses["model.contacts.ContactsModel"] = model_contacts_ContactsModel;
model_contacts_ContactsModel.__name__ = "model.contacts.ContactsModel";
var view_Data = function(props) {
	this.renderCount = 0;
	this.rendered = false;
	this.mounted = false;
	this.state = { hasError : false, mounted : false};
	if(this._trace) {
		haxe_Log.trace("location.pathname:" + Std.string(props.history.location.pathname) + " match.url: " + Std.string(props.match.url) + " userState:" + Std.string(props.user),{ fileName : "src/view/Data.hx", lineNumber : 59, className : "view.Data", methodName : "new"});
	}
	React_Component.call(this,props);
	view_Data._strace = this._trace = true;
	if(this._trace) {
		haxe_Log.trace(props.match,{ fileName : "src/view/Data.hx", lineNumber : 62, className : "view.Data", methodName : "new"});
	}
	if(this._trace) {
		haxe_Log.trace(props.store,{ fileName : "src/view/Data.hx", lineNumber : 63, className : "view.Data", methodName : "new"});
	}
	if(props.match.url == "/Data" && props.match.isExact) {
		if(this._trace) {
			haxe_Log.trace("pushing2: /Data/Contacts/List/get",{ fileName : "src/view/Data.hx", lineNumber : 66, className : "view.Data", methodName : "new"});
		}
		props.history.push("/Data/Contacts/List/get");
	}
};
$hxClasses["view.Data"] = view_Data;
view_Data.__name__ = "view.Data";
view_Data._strace = null;
view_Data.mapDispatchToProps = function(dispatch) {
	return { redirect : function(path,props) {
		return dispatch(redux_Action.map(action_async_LocationAccess.redirect(["/Data/Contacts/:section?/:action?/:id?","/Data/Deals/:section?/:action?/:id?","/Data/Accounts/:section?/:action?/:id?"],path,props)));
	}};
};
view_Data.__super__ = React_Component;
view_Data.prototype = $extend(React_Component.prototype,{
	mounted: null
	,rendered: null
	,renderCount: null
	,_trace: null
	,componentDidMount: function() {
		this.mounted = true;
	}
	,componentDidCatch: function(error,info) {
		if(this.mounted) {
			this.setState({ hasError : true});
		}
		if(this._trace) {
			haxe_Log.trace(error,{ fileName : "src/view/Data.hx", lineNumber : 89, className : "view.Data", methodName : "componentDidCatch"});
		}
		if(this._trace) {
			haxe_Log.trace(info,{ fileName : "src/view/Data.hx", lineNumber : 90, className : "view.Data", methodName : "componentDidCatch"});
		}
	}
	,shouldComponentUpdate: function(nextProps,nextState) {
		if(this._trace) {
			haxe_Log.trace("propsChanged:" + Std.string(nextProps != this.props),{ fileName : "src/view/Data.hx", lineNumber : 95, className : "view.Data", methodName : "shouldComponentUpdate"});
		}
		if(nextProps != this.props) {
			shared_Utils.compare(this.props,nextProps);
		}
		if(this._trace) {
			haxe_Log.trace("stateChanged:" + Std.string(nextState != this.state),{ fileName : "src/view/Data.hx", lineNumber : 97, className : "view.Data", methodName : "shouldComponentUpdate"});
		}
		if(nextState != this.state || nextProps != this.props) {
			return true;
		}
		return nextProps != this.props;
	}
	,render: function() {
		if(this._trace) {
			haxe_Log.trace(Reflect.fields(this.props),{ fileName : "src/view/Data.hx", lineNumber : 139, className : "view.Data", methodName : "render"});
		}
		if(this._trace) {
			haxe_Log.trace(Reflect.fields(this.state),{ fileName : "src/view/Data.hx", lineNumber : 140, className : "view.Data", methodName : "render"});
		}
		var tmp = react_ReactType.fromComp(React_Fragment);
		var tmp1 = react_ReactType.fromString("div");
		var tmp2 = react_ReactType.fromComp(bulma_$components_Tabs);
		var tmp3 = React.createElement(react_ReactType.fromComp(view_shared_TabLink),Object.assign({ },this.props,{ to : "/Data/Contacts"}),"Kontakte");
		var tmp4 = react_ReactType.fromComp(view_shared_TabLink);
		var tmp5 = this.props;
		var tmp6 = this.props.location.key;
		var tmp7 = shared_Utils.extend(this.props.location.state,{ contact : this.props.location.hash});
		var tmp8 = React.createElement(tmp4,Object.assign({ },tmp5,{ to : { key : tmp6, hash : "", pathname : "/Data/Deals", search : "", state : tmp7}}),"Spenden");
		var tmp4 = react_ReactType.fromComp(view_shared_TabLink);
		var tmp5 = this.props;
		var tmp6 = this.props.location.key;
		var tmp7 = this.props.location.hash;
		var tmp9 = shared_Utils.extend(this.props.location.state,{ contact : this.props.location.hash});
		var tmp10 = React.createElement(tmp4,Object.assign({ },tmp5,{ to : { key : tmp6, hash : tmp7, pathname : "/Data/Accounts", search : "", state : tmp9}}),"Konten");
		var tmp4 = React.createElement(react_ReactType.fromComp(view_shared_TabLink),Object.assign({ },this.props,{ to : "/Data/QC"}),"QC");
		var tmp5 = React.createElement(tmp1,{ className : "tabNav2"},React.createElement(tmp2,{ className : "is-boxed"},tmp3,tmp8,tmp10,tmp4));
		var tmp1 = react_ReactType.fromString("div");
		var tmp2 = react_ReactType.fromComp(react_router_Switch);
		var tmp3 = React.createElement(react_ReactType.fromComp(react_router_Route),Object.assign({ },this.props,{ path : "/Data/Contacts/:section?/:action?/:id?", component : react_ReactType.fromComp(view_data_Contacts)}));
		var tmp4 = React.createElement(react_ReactType.fromComp(react_router_Route),Object.assign({ },this.props,{ path : "/Data/Deals/:section?/:action?/:id?", component : react_ReactType.fromComp(view_data_Deals)}));
		var tmp6 = React.createElement(react_ReactType.fromComp(react_router_Route),Object.assign({ },this.props,{ path : "/Data/Accounts/:section?/:action?/:id?", component : react_ReactType.fromComp(view_data_Accounts)}));
		var tmp7 = React.createElement(react_ReactType.fromComp(react_router_Route),Object.assign({ },this.props,{ path : "/Data/QC/:section?/:action?/:id?", component : react_ReactType.fromComp(view_data_QC)}));
		var tmp8 = React.createElement(tmp1,{ className : "tabContent2"},React.createElement(tmp2,{ },tmp3,tmp4,tmp6,tmp7));
		var tmp1 = React.createElement(view_StatusBar._renderWrapper,this.props);
		return React.createElement(tmp,{ },tmp5,tmp8,tmp1);
	}
	,renderComponent: function(props) {
		if(this._trace) {
			haxe_Log.trace(props.location,{ fileName : "src/view/Data.hx", lineNumber : 178, className : "view.Data", methodName : "renderComponent"});
		}
		if(this._trace) {
			haxe_Log.trace(props.match,{ fileName : "src/view/Data.hx", lineNumber : 179, className : "view.Data", methodName : "renderComponent"});
		}
		return null;
	}
	,internalRedirect: function(path) {
		if(path == null) {
			path = "/Data/Contacts/List/get";
		}
		if(this._trace) {
			haxe_Log.trace("" + this.props.location.pathname + " " + path,{ fileName : "src/view/Data.hx", lineNumber : 185, className : "view.Data", methodName : "internalRedirect"});
		}
		if(this.props.location.pathname != path) {
			if(path != this.props.location.pathname) {
				this.props.redirect(path,this.props);
			}
		}
	}
	,setState: null
	,__class__: view_Data
});
var view_data_Accounts = function(props) {
	React_Component.call(this,props);
	view_data_Accounts._strace = true;
	haxe_Log.trace(Reflect.fields(props),{ fileName : "src/view/data/Accounts.hx", lineNumber : 51, className : "view.data.Accounts", methodName : "new"});
	haxe_Log.trace(props.match.params.section,{ fileName : "src/view/data/Accounts.hx", lineNumber : 52, className : "view.data.Accounts", methodName : "new"});
	this.state = { clean : true, hasError : false, mounted : false, loading : true, sideMenu : view_shared_io_FormApi.initSideMenu2(this,[{ dataClassPath : "data.Contacts", label : "Konten", section : "List", items : view_data_accounts_List.menuItems},{ dataClassPath : "contact.Deals", label : "Aufträge", section : "Edit", items : view_data_accounts_Edit.menuItems}],{ section : props.match.params.section == null ? "DBSync" : props.match.params.section, sameWidth : true})};
	haxe_Log.trace(Reflect.fields(props),{ fileName : "src/view/data/Accounts.hx", lineNumber : 79, className : "view.data.Accounts", methodName : "new"});
};
$hxClasses["view.data.Accounts"] = view_data_Accounts;
view_data_Accounts.__name__ = "view.data.Accounts";
view_data_Accounts._strace = null;
view_data_Accounts.mapDispatchToProps = function(dispatch) {
	if(view_data_Accounts._strace) {
		haxe_Log.trace("ok",{ fileName : "src/view/data/Accounts.hx", lineNumber : 84, className : "view.data.Accounts", methodName : "mapDispatchToProps"});
	}
	return { select : function(id,data,component,selectType) {
		if(id == null) {
			id = -1;
		}
		if(view_data_Accounts._strace) {
			haxe_Log.trace("select:" + id + " selectType:" + selectType,{ fileName : "src/view/data/Accounts.hx", lineNumber : 89, className : "view.data.Accounts", methodName : "mapDispatchToProps"});
		}
		dispatch(redux_Action.map(action_async_LiveDataAccess.select({ id : id, data : data, match : component.props.match, selectType : selectType})));
	}};
};
view_data_Accounts.__super__ = React_Component;
view_data_Accounts.prototype = $extend(React_Component.prototype,{
	_trace: null
	,componentDidCatch: function(error,info) {
		if(this.state.mounted) {
			this.setState({ hasError : true});
		}
		haxe_Log.trace(error,{ fileName : "src/view/data/Accounts.hx", lineNumber : 100, className : "view.data.Accounts", methodName : "componentDidCatch"});
	}
	,componentDidMount: function() {
		this.setState({ mounted : true});
		if(this.props.match.params.section == null) {
			var basePath = this.props.match.url;
			this.props.history.push("" + basePath + "/List");
			haxe_Log.trace(this.props.history.location.pathname,{ fileName : "src/view/data/Accounts.hx", lineNumber : 111, className : "view.data.Accounts", methodName : "componentDidMount"});
			haxe_Log.trace("setting section to:List",{ fileName : "src/view/data/Accounts.hx", lineNumber : 112, className : "view.data.Accounts", methodName : "componentDidMount"});
		}
		haxe_Log.trace("" + 1,{ fileName : "src/view/data/Accounts.hx", lineNumber : 114, className : "view.data.Accounts", methodName : "componentDidMount"});
	}
	,render: function() {
		haxe_Log.trace(this.props.match.params.section,{ fileName : "src/view/data/Accounts.hx", lineNumber : 137, className : "view.data.Accounts", methodName : "render"});
		switch(this.props.match.params.section) {
		case "Edit":
			return React.createElement(react_ReactType.fromComp(view_data_accounts_Edit),Object.assign({ },this.props,{ fullWidth : true, sideMenu : this.state.sideMenu}));
		case "List":
			return React.createElement(view_data_accounts_List._renderWrapper,Object.assign({ },this.props,{ limit : 100, fullWidth : true, sideMenu : this.state.sideMenu}));
		default:
			return null;
		}
	}
	,setState: null
	,__class__: view_data_Accounts
});
var view_data_Contacts = function(props) {
	React_Component.call(this,props);
	view_data_Contacts._strace = this._trace = true;
	this.dataAccess = model_contacts_ContactsModel.dataAccess;
	this.dataDisplay = model_contacts_ContactsModel.dataDisplay;
	if(this._trace) {
		haxe_Log.trace("..." + Std.string(Reflect.fields(props)),{ fileName : "src/view/data/Contacts.hx", lineNumber : 74, className : "view.data.Contacts", methodName : "new"});
	}
	if(this._trace) {
		haxe_Log.trace(props.match.params,{ fileName : "src/view/data/Contacts.hx", lineNumber : 75, className : "view.data.Contacts", methodName : "new"});
	}
	this.state = App.initEState({ dataTable : [], loading : false, contactData : new haxe_ds_IntMap(), selectedRows : [], values : new haxe_ds_StringMap()},this);
	if(props.match.params.section == null) {
		if(this._trace) {
			haxe_Log.trace("reme",{ fileName : "src/view/data/Contacts.hx", lineNumber : 82, className : "view.data.Contacts", methodName : "new"});
		}
		var baseUrl = props.match.path.split(":section")[0];
		if(props.dataStore.contactData.iterator().hasNext()) {
			if(this._trace) {
				haxe_Log.trace(shared_Utils.keysList(props.dataStore.contactData.keys()),{ fileName : "src/view/data/Contacts.hx", lineNumber : 86, className : "view.data.Contacts", methodName : "new"});
			}
		}
		props.history.push("" + baseUrl + "List");
	}
};
$hxClasses["view.data.Contacts"] = view_data_Contacts;
view_data_Contacts.__name__ = "view.data.Contacts";
view_data_Contacts._strace = null;
view_data_Contacts.initialState = null;
view_data_Contacts.mapDispatchToProps = function(dispatch) {
	if(view_data_Contacts._strace) {
		haxe_Log.trace("ok",{ fileName : "src/view/data/Contacts.hx", lineNumber : 113, className : "view.data.Contacts", methodName : "mapDispatchToProps"});
	}
	return { select : function(id,data,component,selectType) {
		if(id == null) {
			id = -1;
		}
		if(view_data_Contacts._strace) {
			haxe_Log.trace("select:" + id + " selectType:" + selectType,{ fileName : "src/view/data/Contacts.hx", lineNumber : 118, className : "view.data.Contacts", methodName : "mapDispatchToProps"});
		}
		dispatch(redux_Action.map(action_async_LiveDataAccess.select({ id : id, data : data, match : component.props.match, selectType : selectType})));
	}};
};
view_data_Contacts.mapStateToProps = function(aState) {
	if(view_data_Contacts._strace) {
		haxe_Log.trace(Reflect.fields(aState),{ fileName : "src/view/data/Contacts.hx", lineNumber : 128, className : "view.data.Contacts", methodName : "mapStateToProps"});
	}
	var bState = { dataStore : aState.dataStore, userState : aState.userState};
	return bState;
};
view_data_Contacts.__super__ = React_Component;
view_data_Contacts.prototype = $extend(React_Component.prototype,{
	dataDisplay: null
	,dataAccess: null
	,dbData: null
	,dbMetaData: null
	,_trace: null
	,componentDidCatch: function(error,info) {
		try {
			this.setState({ hasError : true});
		} catch( _g ) {
			haxe_NativeStackTrace.lastError = _g;
			var ex = haxe_Exception.caught(_g).unwrap();
			if(this._trace) {
				haxe_Log.trace(ex,{ fileName : "src/view/data/Contacts.hx", lineNumber : 105, className : "view.data.Contacts", methodName : "componentDidCatch"});
			}
		}
		if(this._trace) {
			haxe_Log.trace(error,{ fileName : "src/view/data/Contacts.hx", lineNumber : 107, className : "view.data.Contacts", methodName : "componentDidCatch"});
		}
		me_cunity_debug_Out.dumpStack(haxe_CallStack.callStack(),{ fileName : "src/view/data/Contacts.hx", lineNumber : 108, className : "view.data.Contacts", methodName : "componentDidCatch"});
	}
	,componentDidMount: function() {
		if(this._trace) {
			haxe_Log.trace(this.props.location.pathname,{ fileName : "src/view/data/Contacts.hx", lineNumber : 146, className : "view.data.Contacts", methodName : "componentDidMount"});
		}
	}
	,render: function() {
		if(this._trace) {
			haxe_Log.trace(this.state.sideMenu,{ fileName : "src/view/data/Contacts.hx", lineNumber : 156, className : "view.data.Contacts", methodName : "render"});
		}
		if(this._trace) {
			haxe_Log.trace(this.props.match.params.section,{ fileName : "src/view/data/Contacts.hx", lineNumber : 157, className : "view.data.Contacts", methodName : "render"});
		}
		if(this._trace) {
			haxe_Log.trace(this.props.match.params.action,{ fileName : "src/view/data/Contacts.hx", lineNumber : 158, className : "view.data.Contacts", methodName : "render"});
		}
		switch(this.props.match.params.section) {
		case "Edit":
			return React.createElement(view_data_contacts_Edit._renderWrapper,Object.assign({ },this.props,{ parentComponent : this, formApi : this.state.formApi, fullWidth : true, sideMenu : this.state.sideMenu}));
		case "List":
			return React.createElement(view_data_contacts_List._renderWrapper,Object.assign({ },this.props,{ limit : 100, parentComponent : this, formApi : this.state.formApi, fullWidth : true, sideMenu : this.state.sideMenu}));
		default:
			return null;
		}
	}
	,setStateFromChild: function(cState) {
		this.setState(cState);
	}
	,importClientList: function(_) {
		haxe_Log.trace("setState loading true => " + Std.string(this.state.loading),{ fileName : "src/view/data/Contacts.hx", lineNumber : 205, className : "view.data.Contacts", methodName : "importClientList"});
		this.setState({ loading : true});
	}
	,setState: null
	,__class__: view_data_Contacts
});
var view_data_Deals = function(props) {
	React_Component.call(this,props);
	view_data_Deals._trace = true;
	haxe_Log.trace(Reflect.fields(props),{ fileName : "src/view/data/Deals.hx", lineNumber : 50, className : "view.data.Deals", methodName : "new"});
	haxe_Log.trace(props.match.params.section,{ fileName : "src/view/data/Deals.hx", lineNumber : 51, className : "view.data.Deals", methodName : "new"});
	if(props.match.params.section == null) {
		if(view_data_Deals._trace) {
			haxe_Log.trace("reme",{ fileName : "src/view/data/Deals.hx", lineNumber : 55, className : "view.data.Deals", methodName : "new"});
		}
		var baseUrl = props.match.path.split(":section")[0];
		if(props.dataStore.dealData.iterator().hasNext()) {
			if(view_data_Deals._trace) {
				haxe_Log.trace(shared_Utils.keysList(props.dataStore.dealData.keys()),{ fileName : "src/view/data/Deals.hx", lineNumber : 59, className : "view.data.Deals", methodName : "new"});
			}
		}
		props.history.push("" + baseUrl + "List/");
	}
	this.state = { clean : true, hasError : false, mounted : false, loading : true, sideMenu : view_shared_io_FormApi.initSideMenu2(this,[{ dataClassPath : "data.deals.List", label : "Spenden", section : "List", items : view_data_deals_List.menuItems},{ dataClassPath : "data.deals.Edit", label : "Spenden", section : "Edit", items : view_data_deals_Edit.menuItems}],{ section : props.match.params.section == null ? "List" : props.match.params.section, sameWidth : true})};
	haxe_Log.trace(Reflect.fields(props),{ fileName : "src/view/data/Deals.hx", lineNumber : 91, className : "view.data.Deals", methodName : "new"});
};
$hxClasses["view.data.Deals"] = view_data_Deals;
view_data_Deals.__name__ = "view.data.Deals";
view_data_Deals._trace = null;
view_data_Deals.mapStateToProps = function(aState) {
	var bState = { dataStore : aState.dataStore, userState : aState.userState};
	if(view_data_Deals._trace) {
		haxe_Log.trace(bState.dataStore.dealData,{ fileName : "src/view/data/Deals.hx", lineNumber : 101, className : "view.data.Deals", methodName : "mapStateToProps"});
	}
	return bState;
};
view_data_Deals.mapDispatchToProps = function(dispatch) {
	if(view_data_Deals._trace) {
		haxe_Log.trace("ok",{ fileName : "src/view/data/Deals.hx", lineNumber : 107, className : "view.data.Deals", methodName : "mapDispatchToProps"});
	}
	return { storeData : function(id,action) {
		dispatch(redux_Action.map(action_async_LiveDataAccess.storeData(id,action)));
	}, select : function(id,data,component,selectType) {
		if(id == null) {
			id = -1;
		}
		if(view_data_Deals._trace) {
			haxe_Log.trace("select:" + id + " selectType:" + selectType,{ fileName : "src/view/data/Deals.hx", lineNumber : 115, className : "view.data.Deals", methodName : "mapDispatchToProps"});
		}
		haxe_Log.trace(data,{ fileName : "src/view/data/Deals.hx", lineNumber : 116, className : "view.data.Deals", methodName : "mapDispatchToProps"});
		dispatch(redux_Action.map(action_async_LiveDataAccess.select({ id : id, data : data, match : component.props.match, selectType : selectType})));
	}};
};
view_data_Deals.__super__ = React_Component;
view_data_Deals.prototype = $extend(React_Component.prototype,{
	componentDidCatch: function(error,info) {
		if(this.state.mounted) {
			this.setState({ hasError : true});
		}
		haxe_Log.trace(error,{ fileName : "src/view/data/Deals.hx", lineNumber : 127, className : "view.data.Deals", methodName : "componentDidCatch"});
	}
	,componentDidMount: function() {
	}
	,render: function() {
		haxe_Log.trace(this.props.match.params.section,{ fileName : "src/view/data/Deals.hx", lineNumber : 147, className : "view.data.Deals", methodName : "render"});
		if(view_data_Deals._trace) {
			haxe_Log.trace(this.props.match.params.action,{ fileName : "src/view/data/Deals.hx", lineNumber : 148, className : "view.data.Deals", methodName : "render"});
		}
		switch(this.props.match.params.section) {
		case "Edit":
			return React.createElement(view_data_deals_Edit._renderWrapper,Object.assign({ },this.props,{ fullWidth : true, parentComponent : this, formApi : this.state.formApi, sideMenu : this.state.sideMenu}));
		case "List":
			return React.createElement(view_data_deals_List._renderWrapper,Object.assign({ },this.props,{ limit : 100, parentComponent : this, formApi : this.state.formApi, fullWidth : true, sideMenu : this.state.sideMenu}));
		default:
			return null;
		}
	}
	,setState: null
	,__class__: view_data_Deals
});
var view_data_QC = function(props) {
	React_Component.call(this,props);
	this.dataAccess = model_contacts_ContactsModel.dataAccess;
	this.dataDisplay = model_contacts_ContactsModel.dataDisplay;
	haxe_Log.trace("..." + Std.string(Reflect.fields(props)),{ fileName : "src/view/data/QC.hx", lineNumber : 73, className : "view.data.QC", methodName : "new"});
	haxe_Log.trace(props.match.params,{ fileName : "src/view/data/QC.hx", lineNumber : 74, className : "view.data.QC", methodName : "new"});
	if(props.match.params.section == null) {
		haxe_Log.trace("reme",{ fileName : "src/view/data/QC.hx", lineNumber : 78, className : "view.data.QC", methodName : "new"});
		var baseUrl = props.match.path.split(":section")[0];
		props.history.push("" + baseUrl + "List/get");
	}
	this.state = App.initEState({ dataTable : [], loading : false, contactData : new haxe_ds_IntMap(), selectedRows : [], values : new haxe_ds_StringMap()},this);
};
$hxClasses["view.data.QC"] = view_data_QC;
view_data_QC.__name__ = "view.data.QC";
view_data_QC.initialState = null;
view_data_QC.mapDispatchToProps = function(dispatch) {
	haxe_Log.trace("ok",{ fileName : "src/view/data/QC.hx", lineNumber : 105, className : "view.data.QC", methodName : "mapDispatchToProps"});
	return { storeData : function(id,action) {
		dispatch(redux_Action.map(action_async_LiveDataAccess.storeData(id,action)));
	}, select : function(id,data,match,selectType) {
		if(id == null) {
			id = -1;
		}
		haxe_Log.trace("select:" + id + " selectType:" + selectType,{ fileName : "src/view/data/QC.hx", lineNumber : 113, className : "view.data.QC", methodName : "mapDispatchToProps"});
		dispatch(redux_Action.map(action_async_LiveDataAccess.select({ id : id, data : data, match : match, selectType : selectType})));
	}};
};
view_data_QC.mapStateToProps = function(aState) {
	haxe_Log.trace(Reflect.fields(aState),{ fileName : "src/view/data/QC.hx", lineNumber : 134, className : "view.data.QC", methodName : "mapStateToProps"});
	if(aState.dataStore.contactData != null) {
		haxe_Log.trace(aState.dataStore.contactData.keys().next(),{ fileName : "src/view/data/QC.hx", lineNumber : 136, className : "view.data.QC", methodName : "mapStateToProps"});
	}
	if(aState.dataStore.contactsDbData != null) {
		var tmp = aState.dataStore.contactsDbData.dataRows[0];
		haxe_Log.trace(tmp == null ? "null" : haxe_ds_StringMap.stringify(tmp.h),{ fileName : "src/view/data/QC.hx", lineNumber : 138, className : "view.data.QC", methodName : "mapStateToProps"});
	} else {
		haxe_Log.trace(aState.dataStore,{ fileName : "src/view/data/QC.hx", lineNumber : 141, className : "view.data.QC", methodName : "mapStateToProps"});
		haxe_Log.trace(Reflect.fields(aState.dataStore),{ fileName : "src/view/data/QC.hx", lineNumber : 142, className : "view.data.QC", methodName : "mapStateToProps"});
	}
	haxe_Log.trace(App.store.getState().dataStore.contactsDbData,{ fileName : "src/view/data/QC.hx", lineNumber : 144, className : "view.data.QC", methodName : "mapStateToProps"});
	var bState = { dataStore : aState.dataStore, userState : aState.userState};
	haxe_Log.trace(bState.dataStore.contactData,{ fileName : "src/view/data/QC.hx", lineNumber : 151, className : "view.data.QC", methodName : "mapStateToProps"});
	return bState;
};
view_data_QC.__super__ = React_Component;
view_data_QC.prototype = $extend(React_Component.prototype,{
	dataDisplay: null
	,dataAccess: null
	,dbData: null
	,dbMetaData: null
	,componentDidCatch: function(error,info) {
		try {
			this.setState({ hasError : true});
		} catch( _g ) {
			haxe_NativeStackTrace.lastError = _g;
			var ex = haxe_Exception.caught(_g).unwrap();
			haxe_Log.trace(ex,{ fileName : "src/view/data/QC.hx", lineNumber : 97, className : "view.data.QC", methodName : "componentDidCatch"});
		}
		haxe_Log.trace(error,{ fileName : "src/view/data/QC.hx", lineNumber : 99, className : "view.data.QC", methodName : "componentDidCatch"});
		me_cunity_debug_Out.dumpStack(haxe_CallStack.callStack(),{ fileName : "src/view/data/QC.hx", lineNumber : 100, className : "view.data.QC", methodName : "componentDidCatch"});
	}
	,componentDidMount: function() {
		haxe_Log.trace(this.props.location.pathname,{ fileName : "src/view/data/QC.hx", lineNumber : 157, className : "view.data.QC", methodName : "componentDidMount"});
	}
	,render: function() {
		haxe_Log.trace(this.props.match.params.section,{ fileName : "src/view/data/QC.hx", lineNumber : 167, className : "view.data.QC", methodName : "render"});
		haxe_Log.trace(this.props.match.params.action,{ fileName : "src/view/data/QC.hx", lineNumber : 168, className : "view.data.QC", methodName : "render"});
		switch(this.props.match.params.section) {
		case "Edit":
			return React.createElement(view_data_contacts_Edit._renderWrapper,Object.assign({ },this.props,{ parentComponent : this, formApi : this.state.formApi, fullWidth : true, sideMenu : this.state.sideMenu}));
		case "List":
			return React.createElement(view_data_contacts_List._renderWrapper,Object.assign({ },this.props,{ limit : 100, parentComponent : this, formApi : this.state.formApi, fullWidth : true, sideMenu : this.state.sideMenu}));
		default:
			return null;
		}
	}
	,setStateFromChild: function(cState) {
		this.setState(cState);
	}
	,setState: null
	,__class__: view_data_QC
});
var view_data_accounts_Edit = function(props) {
	React_Component.call(this,props);
	haxe_Log.trace(props.match.params,{ fileName : "src/view/data/accounts/Edit.hx", lineNumber : 70, className : "view.data.accounts.Edit", methodName : "new"});
	this.dataAccess = model_accounting_AccountsModel.dataAccess;
	this.initialState = null;
	if(props.match.params.id == null && new EReg("update(/)*$","").match(props.match.params.action)) {
		haxe_Log.trace("nothing selected - redirect",{ fileName : "src/view/data/accounts/Edit.hx", lineNumber : 81, className : "view.data.accounts.Edit", methodName : "new"});
		var baseUrl = props.match.path.split(":section")[0];
		props.history.push("" + baseUrl + "List/get");
		return;
	}
	this.fieldNames = [];
	var h = this.dataAccess.h["open"].view.h;
	var k_h = h;
	var k_keys = Object.keys(h);
	var k_length = k_keys.length;
	var k_current = 0;
	while(k_current < k_length) {
		var k = k_keys[k_current++];
		this.fieldNames.push(k);
	}
	this.dataDisplay = model_accounting_AccountsModel.dataDisplay;
	haxe_Log.trace("..." + Std.string(Reflect.fields(props)),{ fileName : "src/view/data/accounts/Edit.hx", lineNumber : 92, className : "view.data.accounts.Edit", methodName : "new"});
	this.formRef = React.createRef();
	this.state = App.initEState({ dataTable : [], formBuilder : new view_shared_FormBuilder(this), initialState : this.initialState, loading : false, selectedRows : [], sideMenu : view_shared_io_FormApi.initSideMenu(this,{ dataClassPath : "data.Accounts", label : "Bearbeiten", section : "Edit", items : view_data_accounts_Edit.menuItems},{ section : props.match.params.section == null ? "Edit" : props.match.params.section, sameWidth : true}), values : new haxe_ds_StringMap()},this);
};
$hxClasses["view.data.accounts.Edit"] = view_data_accounts_Edit;
view_data_accounts_Edit.__name__ = "view.data.accounts.Edit";
view_data_accounts_Edit.mapStateToProps = function(aState) {
	haxe_Log.trace(aState,{ fileName : "src/view/data/accounts/Edit.hx", lineNumber : 265, className : "view.data.accounts.Edit", methodName : "mapStateToProps"});
	return { userState : aState.userState};
};
view_data_accounts_Edit.__super__ = React_Component;
view_data_accounts_Edit.prototype = $extend(React_Component.prototype,{
	dataDisplay: null
	,dataAccess: null
	,dbData: null
	,dbMetaData: null
	,formRef: null
	,fieldNames: null
	,actualState: null
	,initialState: null
	,loadContactData: function(id) {
		haxe_Log.trace("loading:" + id,{ fileName : "src/view/data/accounts/Edit.hx", lineNumber : 146, className : "view.data.accounts.Edit", methodName : "loadContactData"});
		return null;
	}
	,update: function() {
		if(this.state.actualState != null) {
			haxe_Log.trace("length:" + this.state.actualState.fieldsModified.length + ":" + this.state.actualState.fieldsModified.join("|"),{ fileName : "src/view/data/accounts/Edit.hx", lineNumber : 168, className : "view.data.accounts.Edit", methodName : "update"});
		}
		if(this.state.actualState == null || this.state.actualState.fieldsModified.length == 0) {
			return;
		}
		var data2save = this.state.actualState.allModified();
		var doc = window.document;
		var aState = react_ReactUtil.copy(this.state.actualState);
		var dbaProps_action = "update";
		var dbaProps_classPath = "data.Accounts";
		var dbaProps_dataSource = null;
		var dbaProps_userState = this.props.userState;
		var dbQ = { classPath : "data.Accounts", action : "update", data : data2save, filter : { id : this.state.actualState.id, mandator : 1}, resolveMessage : { success : "Konto " + this.state.actualState.id + " wurde aktualisiert", failure : "Konto " + this.state.actualState.id + " konnte nicht aktualisiert werden"}, table : "accounts", dbUser : this.props.userState.dbUser, devIP : App.devIP};
		haxe_Log.trace(this.props.match.params.action,{ fileName : "src/view/data/accounts/Edit.hx", lineNumber : 198, className : "view.data.accounts.Edit", methodName : "update"});
		switch(this.props.match.params.action) {
		case "delete":case "get":
			var _g = new haxe_ds_StringMap();
			var _g1 = new haxe_ds_StringMap();
			_g1.h["filter"] = { id : this.state.initialData.id};
			_g.h["contacts"] = _g1;
			dbaProps_dataSource = _g;
			break;
		case "insert":
			var _g = 0;
			var _g1 = this.fieldNames;
			while(_g < _g1.length) {
				var f = _g1[_g];
				++_g;
				haxe_Log.trace("" + f + " =>" + Std.string(Reflect.field(aState,f)) + "<=",{ fileName : "src/view/data/accounts/Edit.hx", lineNumber : 205, className : "view.data.accounts.Edit", methodName : "update"});
				if(Reflect.field(aState,f) == "") {
					Reflect.deleteField(aState,f);
				}
			}
			break;
		case "update":
			haxe_Log.trace("" + Std.string(this.state.initialData.id) + " :: creation_date: " + Std.string(aState.creation_date) + " " + Std.string(this.state.initialData.creation_date),{ fileName : "src/view/data/accounts/Edit.hx", lineNumber : 225, className : "view.data.accounts.Edit", methodName : "update"});
			if(this.state.actualState != null) {
				haxe_Log.trace(Std.string(this.state.actualState.modified()) + (":" + Std.string(this.state.actualState.fieldsModified)),{ fileName : "src/view/data/accounts/Edit.hx", lineNumber : 229, className : "view.data.accounts.Edit", methodName : "update"});
			}
			haxe_Log.trace(this.state.actualState.id,{ fileName : "src/view/data/accounts/Edit.hx", lineNumber : 241, className : "view.data.accounts.Edit", methodName : "update"});
			if(!this.state.actualState.modified()) {
				haxe_Log.trace("nothing modified",{ fileName : "src/view/data/accounts/Edit.hx", lineNumber : 245, className : "view.data.accounts.Edit", methodName : "update"});
				return;
			}
			haxe_Log.trace(this.state.actualState.allModified(),{ fileName : "src/view/data/accounts/Edit.hx", lineNumber : 248, className : "view.data.accounts.Edit", methodName : "update"});
			var _g = new haxe_ds_StringMap();
			var _g1 = new haxe_ds_StringMap();
			var value = this.state.actualState.allModified();
			_g1.h["data"] = value;
			_g1.h["filter"] = { id : this.state.actualState.id};
			_g.h["contacts"] = _g1;
			dbaProps_dataSource = _g;
			haxe_Log.trace(dbaProps_dataSource.h["contacts"].h["filter"],{ fileName : "src/view/data/accounts/Edit.hx", lineNumber : 255, className : "view.data.accounts.Edit", methodName : "update"});
			break;
		}
		App.store.dispatch(redux_Action.map(action_async_CRUD.update(dbQ)));
	}
	,'delete': function(ev) {
		haxe_Log.trace(this.state.selectedRows.length,{ fileName : "src/view/data/accounts/Edit.hx", lineNumber : 273, className : "view.data.accounts.Edit", methodName : "delete"});
		var data = this.state.formApi.selectedRowsMap(this.state);
	}
	,componentDidMount: function() {
		var _gthis = this;
		window.addEventListener("beforeunload",$bind(this,this.sessionStore));
		var sessAccounts = window.sessionStorage.getItem("contacts");
		if(sessAccounts != null) {
			haxe_Log.trace(JSON.parse(sessAccounts),{ fileName : "src/view/data/accounts/Edit.hx", lineNumber : 283, className : "view.data.accounts.Edit", methodName : "componentDidMount"});
			this.actualState = JSON.parse(sessAccounts);
			haxe_Log.trace(this.actualState,{ fileName : "src/view/data/accounts/Edit.hx", lineNumber : 285, className : "view.data.accounts.Edit", methodName : "componentDidMount"});
			this.forceUpdate();
		} else if(this.actualState == null) {
			this.actualState = react_ReactUtil.copy(this.initialState);
			this.actualState = view_shared_io_Observer.run(this.actualState,function(newState) {
				_gthis.actualState = newState;
				haxe_Log.trace(_gthis.actualState,{ fileName : "src/view/data/accounts/Edit.hx", lineNumber : 307, className : "view.data.accounts.Edit", methodName : "componentDidMount"});
			});
		}
		if(react_ReactRef.get_current(this.formRef) != null) {
			react_ReactRef.get_current(this.formRef).addEventListener("keyup",$bind(this,this.handleChange));
			react_ReactRef.get_current(this.formRef).addEventListener("mouseup",function(ev) {
				haxe_Log.trace(ev.target.value,{ fileName : "src/view/data/accounts/Edit.hx", lineNumber : 319, className : "view.data.accounts.Edit", methodName : "componentDidMount"});
			});
		}
		if(this.props.dataStore != null && this.actualState == null) {
			this.actualState = this.loadContactData(this.initialState.id);
			this.setState({ initialState : this.actualState, actualState : this.actualState});
		}
	}
	,shouldComponentUpdate: function(nextProps,nextState) {
		haxe_Log.trace("propsChanged:" + Std.string(nextProps != this.props),{ fileName : "src/view/data/accounts/Edit.hx", lineNumber : 334, className : "view.data.accounts.Edit", methodName : "shouldComponentUpdate"});
		haxe_Log.trace("stateChanged:" + Std.string(nextState != this.state),{ fileName : "src/view/data/accounts/Edit.hx", lineNumber : 335, className : "view.data.accounts.Edit", methodName : "shouldComponentUpdate"});
		if(nextState != this.state) {
			return true;
		}
		return nextProps != this.props;
	}
	,componentWillUnmount: function() {
		return;
	}
	,sessionStore: function() {
		haxe_Log.trace(this.actualState,{ fileName : "src/view/data/accounts/Edit.hx", lineNumber : 353, className : "view.data.accounts.Edit", methodName : "sessionStore"});
		window.sessionStorage.setItem("contacts",JSON.stringify(this.actualState));
		window.removeEventListener("beforeunload",$bind(this,this.sessionStore));
	}
	,doChange: function(name,value) {
		haxe_Log.trace("" + name + ": " + value,{ fileName : "src/view/data/accounts/Edit.hx", lineNumber : 359, className : "view.data.accounts.Edit", methodName : "doChange"});
		if(name != null && name != "") {
			this.actualState[name] = value;
		}
		this.setState({ initialState : this.actualState});
	}
	,handleChange: function(e) {
		var el = e.target;
		if(el.name != "" && el.name != null) {
			haxe_Log.trace(">>" + Std.string(el.name) + "=>" + Std.string(el.value) + "<<",{ fileName : "src/view/data/accounts/Edit.hx", lineNumber : 372, className : "view.data.accounts.Edit", methodName : "handleChange"});
			this.actualState[el.name] = el.value;
			haxe_Log.trace(this.actualState.last_name,{ fileName : "src/view/data/accounts/Edit.hx", lineNumber : 375, className : "view.data.accounts.Edit", methodName : "handleChange"});
		}
	}
	,mHandlers: function(event) {
		event.preventDefault();
		haxe_Log.trace(this.state.initialState.id,{ fileName : "src/view/data/accounts/Edit.hx", lineNumber : 390, className : "view.data.accounts.Edit", methodName : "mHandlers"});
		var doc = window.document;
		var formElement = js_Boot.__cast(doc.querySelector("form[name=\"contact\"]") , HTMLFormElement);
		var elements = formElement.elements;
		var h = this.dataAccess.h["update"].view.h;
		var k_h = h;
		var k_keys = Object.keys(h);
		var k_length = k_keys.length;
		var k_current = 0;
		while(k_current < k_length) {
			var k = k_keys[k_current++];
			if(k == "id") {
				continue;
			}
			try {
				var item = elements.namedItem(k);
				var o = this.actualState;
				var field = item.name;
				var value;
				switch(item.type) {
				case "checkbox":
					value = item.checked ? 1 : 0;
					break;
				case "select-multiple":case "select-one":
					var sOpts = item.selectedOptions;
					if(sOpts.length > 1) {
						var _g = [];
						var _g1 = 0;
						var _g2 = sOpts.length;
						while(_g1 < _g2) {
							var o1 = _g1++;
							_g.push(sOpts[o1].value);
						}
						value = _g.join("|");
					} else {
						value = item.value;
					}
					break;
				default:
					value = item.value;
				}
				o[field] = value;
			} catch( _g3 ) {
				haxe_NativeStackTrace.lastError = _g3;
				var ex = haxe_Exception.caught(_g3).unwrap();
				haxe_Log.trace(ex,{ fileName : "src/view/data/accounts/Edit.hx", lineNumber : 425, className : "view.data.accounts.Edit", methodName : "mHandlers"});
			}
		}
		haxe_Log.trace(this.actualState,{ fileName : "src/view/data/accounts/Edit.hx", lineNumber : 429, className : "view.data.accounts.Edit", methodName : "mHandlers"});
		this.go(this.actualState);
	}
	,go: function(aState) {
		haxe_Log.trace(Reflect.fields(aState),{ fileName : "src/view/data/accounts/Edit.hx", lineNumber : 436, className : "view.data.accounts.Edit", methodName : "go"});
		var dbaProps = { action : this.props.match.params.action, classPath : "data.Accounts", dataSource : null, table : "contacts", userState : this.props.userState};
		switch(this.props.match.params.action) {
		case "delete":case "get":
			var _g = new haxe_ds_StringMap();
			var _g1 = new haxe_ds_StringMap();
			_g1.h["filter"] = "id|" + Std.string(this.state.initialState.id);
			_g.h["contacts"] = _g1;
			dbaProps.dataSource = _g;
			break;
		case "insert":
			var _g = 0;
			var _g1 = this.fieldNames;
			while(_g < _g1.length) {
				var f = _g1[_g];
				++_g;
				haxe_Log.trace("" + f + " =>" + Std.string(Reflect.field(aState,f)) + "<=",{ fileName : "src/view/data/accounts/Edit.hx", lineNumber : 450, className : "view.data.accounts.Edit", methodName : "go"});
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
			dbaProps.dataSource = _g;
			break;
		case "update":
			var _g = 0;
			var _g1 = this.fieldNames;
			while(_g < _g1.length) {
				var f = _g1[_g];
				++_g;
				if(Reflect.field(aState,f) == "") {
					Reflect.deleteField(aState,f);
				}
			}
			var _g = new haxe_ds_StringMap();
			var _g1 = new haxe_ds_StringMap();
			_g1.h["data"] = aState;
			_g1.h["filter"] = "id|" + Std.string(this.state.initialState.id);
			_g.h["contacts"] = _g1;
			dbaProps.dataSource = _g;
			break;
		}
		App.store.dispatch(redux_Action.map(action_async_DBAccess.execute(dbaProps)));
	}
	,renderResults: function() {
		switch(this.props.match.params.action) {
		case "insert":
			haxe_Log.trace(this.actualState,{ fileName : "src/view/data/accounts/Edit.hx", lineNumber : 514, className : "view.data.accounts.Edit", methodName : "renderResults"});
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
			return tmp.renderForm({ mHandlers : tmp1, fields : _g, model : "contact", formRef : this.formRef, title : "Kontakt - Neue Stammdaten"},this.actualState);
		case "update":
			haxe_Log.trace(this.actualState,{ fileName : "src/view/data/accounts/Edit.hx", lineNumber : 498, className : "view.data.accounts.Edit", methodName : "renderResults"});
			if(this.actualState == null) {
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
				return tmp.renderForm({ mHandlers : tmp1, fields : _g, model : "contact", formRef : this.formRef, title : "Stammdaten"},this.actualState);
			}
			break;
		default:
			return null;
		}
	}
	,render: function() {
		haxe_Log.trace(this.props.match.params.action,{ fileName : "src/view/data/accounts/Edit.hx", lineNumber : 531, className : "view.data.accounts.Edit", methodName : "render"});
		switch(this.props.match.params.action) {
		case "insert":
			return this.state.formApi.render(this.renderResults());
		case "update":
			return this.state.formApi.render(this.renderResults());
		default:
			return this.state.formApi.render(this.renderResults());
		}
	}
	,updateMenu: function(viewClassPath) {
		var sideMenu = this.state.sideMenu;
		haxe_Log.trace(sideMenu.section,{ fileName : "src/view/data/accounts/Edit.hx", lineNumber : 554, className : "view.data.accounts.Edit", methodName : "updateMenu"});
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
	,__class__: view_data_accounts_Edit
});
var view_data_accounts_List = function(props) {
	React_Component.call(this,props);
	this.dataDisplay = model_accounting_AccountsModel.dataGridDisplay;
	haxe_Log.trace("..." + Std.string(Reflect.fields(props)),{ fileName : "src/view/data/accounts/List.hx", lineNumber : 50, className : "view.data.accounts.List", methodName : "new"});
	this.state = App.initEState({ dataTable : [], loading : false, accountsData : new haxe_ds_IntMap(), selectedRows : [], sideMenu : view_shared_io_FormApi.initSideMenu(this,{ dataClassPath : "data.Accounts", label : "Liste", section : "List", items : view_data_accounts_List.menuItems},{ section : props.match.params.section == null ? "List" : props.match.params.section, sameWidth : true}), values : new haxe_ds_StringMap()},this);
	haxe_Log.trace(this.state.loading,{ fileName : "src/view/data/accounts/List.hx", lineNumber : 70, className : "view.data.accounts.List", methodName : "new"});
	if(props.match.params.action == null) {
		var baseUrl = props.match.path.split(":section")[0];
		haxe_Log.trace("redirecting to " + baseUrl + "List/get",{ fileName : "src/view/data/accounts/List.hx", lineNumber : 75, className : "view.data.accounts.List", methodName : "new"});
		props.history.push("" + baseUrl + "List/get");
		this.get(null);
	} else {
		haxe_Log.trace(props.match.params,{ fileName : "src/view/data/accounts/List.hx", lineNumber : 82, className : "view.data.accounts.List", methodName : "new"});
	}
	haxe_Log.trace(this.state.loading,{ fileName : "src/view/data/accounts/List.hx", lineNumber : 84, className : "view.data.accounts.List", methodName : "new"});
};
$hxClasses["view.data.accounts.List"] = view_data_accounts_List;
view_data_accounts_List.__name__ = "view.data.accounts.List";
view_data_accounts_List.mapDispatchToProps = function(dispatch) {
	return { load : function(param) {
		return dispatch(redux_Action.map(action_async_CRUD.read(param)));
	}};
};
view_data_accounts_List.mapStateToProps = function(aState) {
	haxe_Log.trace(aState.userState,{ fileName : "src/view/data/accounts/List.hx", lineNumber : 96, className : "view.data.accounts.List", methodName : "mapStateToProps"});
	return { userState : aState.userState};
};
view_data_accounts_List.__super__ = React_Component;
view_data_accounts_List.prototype = $extend(React_Component.prototype,{
	baseForm: null
	,dataDisplay: null
	,dataAccess: null
	,dbData: null
	,dbMetaData: null
	,'delete': function(ev) {
		haxe_Log.trace(this.state.selectedRows.length,{ fileName : "src/view/data/accounts/List.hx", lineNumber : 104, className : "view.data.accounts.List", methodName : "delete"});
		var data = this.state.formApi.selectedRowsMap(this.state);
	}
	,get: function(ev) {
		var _gthis = this;
		haxe_Log.trace("hi :)",{ fileName : "src/view/data/accounts/List.hx", lineNumber : 110, className : "view.data.accounts.List", methodName : "get"});
		var offset = 0;
		this.state.loading = true;
		if(ev != null && ev.page != null) {
			offset = this.props.limit * ev.page | 0;
		}
		haxe_Log.trace(this.props.userState,{ fileName : "src/view/data/accounts/List.hx", lineNumber : 119, className : "view.data.accounts.List", methodName : "get"});
		var p = this.props.load({ classPath : "data.Accounts", action : "get", filter : this.props.match.params.id != null ? { id : this.props.match.params.id, mandator : "1"} : { mandator : "1"}, limit : this.props.limit, offset : offset > 0 ? offset : 0, table : "accounts", dbUser : this.props.userState.dbUser, devIP : App.devIP});
		p.then(function(data) {
			haxe_Log.trace(data.dataRows.length,{ fileName : "src/view/data/accounts/List.hx", lineNumber : 133, className : "view.data.accounts.List", methodName : "get"});
			if(data.dataRows != null && data.dataRows.length > 0) {
				_gthis.setState({ loading : false, dataTable : data.dataRows, pageCount : Math.ceil(Std.parseInt(data.dataInfo.h["count"]) / _gthis.props.limit)});
			}
		});
	}
	,edit: function(ev) {
		haxe_Log.trace(ev,{ fileName : "src/view/data/accounts/List.hx", lineNumber : 141, className : "view.data.accounts.List", methodName : "edit"});
		haxe_Log.trace(this.state.selectedRows.length,{ fileName : "src/view/data/accounts/List.hx", lineNumber : 142, className : "view.data.accounts.List", methodName : "edit"});
		var selected = window.document.querySelector(".gridItem.selected");
		if(selected != null) {
			haxe_Log.trace(selected.dataset.id,{ fileName : "src/view/data/accounts/List.hx", lineNumber : 145, className : "view.data.accounts.List", methodName : "edit"});
		}
		var baseUrl = this.props.match.path.split(":section")[0];
		this.props.history.push("" + baseUrl + "Edit/update/" + selected.dataset.id);
	}
	,componentDidMount: function() {
		var _g = new haxe_ds_StringMap();
		var _g1 = new haxe_ds_StringMap();
		var value = new haxe_ds_StringMap();
		_g1.h["contacts"] = value;
		var value = { source : _g1, view : new haxe_ds_StringMap()};
		_g.h["get"] = value;
		this.dataAccess = _g;
		if(this.props.match.params.action != null) {
			var fun = Reflect.field(this,this.props.match.params.action);
			if(Reflect.isFunction(fun)) {
				fun.apply(this,null);
			}
		} else {
			this.setState({ loading : false});
		}
	}
	,renderResults: function() {
		haxe_Log.trace(this.props.match.params.section + ":" + Std.string(this.state.dataTable != null),{ fileName : "src/view/data/accounts/List.hx", lineNumber : 176, className : "view.data.accounts.List", methodName : "renderResults"});
		haxe_Log.trace(this.state.loading,{ fileName : "src/view/data/accounts/List.hx", lineNumber : 178, className : "view.data.accounts.List", methodName : "renderResults"});
		if(this.state.loading || this.state.dataTable == null || this.state.dataTable.length == 0) {
			return this.state.formApi.renderWait();
		}
		haxe_Log.trace("###########loading:" + Std.string(this.state.loading),{ fileName : "src/view/data/accounts/List.hx", lineNumber : 181, className : "view.data.accounts.List", methodName : "renderResults"});
		switch(this.props.match.params.action) {
		case "delete":
			return null;
		case "get":
			return React.createElement(react_ReactType.fromComp(view_grid_Grid),Object.assign({ },this.props,{ id : "accountsList", data : this.state.dataTable, dataState : this.dataDisplay.h["accountsList"], parentComponent : this, className : "is-striped is-hoverable", fullWidth : true}));
		default:
			return null;
		}
	}
	,render: function() {
		haxe_Log.trace(this.props.match.params.section,{ fileName : "src/view/data/accounts/List.hx", lineNumber : 220, className : "view.data.accounts.List", methodName : "render"});
		var tmp = this.state.formApi;
		var tmp1 = react_ReactType.fromComp(React_Fragment);
		var tmp2 = react_ReactType.fromString("form");
		var tmp3 = this.renderResults();
		var tmp4 = React.createElement(tmp2,{ className : "tabComponentForm"},tmp3);
		return tmp.render(React.createElement(tmp1,{ },tmp4));
	}
	,updateMenu: function(viewClassPath) {
		var sideMenu = this.state.sideMenu;
		haxe_Log.trace(sideMenu.section,{ fileName : "src/view/data/accounts/List.hx", lineNumber : 232, className : "view.data.accounts.List", methodName : "updateMenu"});
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
	,__class__: view_data_accounts_List
});
var view_data_contacts_Accounts = function(props) {
	React_Component.call(this,props);
	this.dataDisplay = model_accounting_AccountsModel.dataGridDisplay;
	haxe_Log.trace("..." + Std.string(Reflect.fields(props)),{ fileName : "src/view/data/contacts/Accounts.hx", lineNumber : 48, className : "view.data.contacts.Accounts", methodName : "new"});
	this.state = App.initEState({ actualStates : new haxe_ds_IntMap(), dataTable : [], loading : true, model : "accounts", accountsData : new haxe_ds_IntMap(), selectedRows : [], sideMenu : null, values : new haxe_ds_StringMap()},this);
	haxe_Log.trace(this.state.loading,{ fileName : "src/view/data/contacts/Accounts.hx", lineNumber : 59, className : "view.data.contacts.Accounts", methodName : "new"});
	var c = js_Boot.getClass(this);
	props.parentComponent.state.relDataComps.set(c.__name__,this);
};
$hxClasses["view.data.contacts.Accounts"] = view_data_contacts_Accounts;
view_data_contacts_Accounts.__name__ = "view.data.contacts.Accounts";
view_data_contacts_Accounts.mapDispatchToProps = function(dispatch) {
	return { load : function(param) {
		return dispatch(redux_Action.map(action_async_CRUD.read(param)));
	}, loadData : function(id,me) {
		if(id == null) {
			id = -1;
		}
		return me.loadData(id);
	}, save : function(me) {
		return me.update();
	}, select : function(id,me,pComp,sType) {
		if(id == null) {
			id = -1;
		}
		var tmp = haxe_Log.trace;
		var c = js_Boot.getClass(me);
		var tmp1 = "select:" + id + " me:" + c.__name__ + " SelectType:" + sType + " parentComponent:";
		var c = js_Boot.getClass(pComp.props.parentComponent);
		tmp(tmp1 + c.__name__,{ fileName : "src/view/data/contacts/Accounts.hx", lineNumber : 71, className : "view.data.contacts.Accounts", methodName : "mapDispatchToProps"});
	}};
};
view_data_contacts_Accounts.mapStateToProps = function(aState) {
	haxe_Log.trace(Reflect.fields(aState),{ fileName : "src/view/data/contacts/Accounts.hx", lineNumber : 81, className : "view.data.contacts.Accounts", methodName : "mapStateToProps"});
	return { userState : aState.userState};
};
view_data_contacts_Accounts.__super__ = React_Component;
view_data_contacts_Accounts.prototype = $extend(React_Component.prototype,{
	dataDisplay: null
	,dataAccess: null
	,dbData: null
	,dbMetaData: null
	,'delete': function(ev) {
		haxe_Log.trace(this.state.selectedRows.length,{ fileName : "src/view/data/contacts/Accounts.hx", lineNumber : 89, className : "view.data.contacts.Accounts", methodName : "delete"});
		var data = this.state.formApi.selectedRowsMap(this.state);
	}
	,get: function() {
		var _gthis = this;
		haxe_Log.trace(this.props.filter,{ fileName : "src/view/data/contacts/Accounts.hx", lineNumber : 96, className : "view.data.contacts.Accounts", methodName : "get"});
		var offset = 0;
		me_cunity_debug_Out.dumpObject(this.props.userState,{ fileName : "src/view/data/contacts/Accounts.hx", lineNumber : 100, className : "view.data.contacts.Accounts", methodName : "get"});
		var p = this.props.load({ classPath : "data.Accounts", action : "get", filter : this.props.filter != null ? this.props.filter : { mandator : "1"}, limit : this.props.limit, offset : offset > 0 ? offset : 0, table : this.state.model, resolveMessage : { success : "Kontenliste wurde geladen", failure : "Kontenliste konnte nicht geladen werden"}, dbUser : this.props.userState.dbUser, devIP : App.devIP});
		p.then(function(data) {
			haxe_Log.trace(data.dataRows.length,{ fileName : "src/view/data/contacts/Accounts.hx", lineNumber : 118, className : "view.data.contacts.Accounts", methodName : "get"});
			_gthis.setState({ loading : false, dataTable : data.dataRows});
		});
	}
	,edit: function(ev) {
		haxe_Log.trace(this.state.selectedRows.length,{ fileName : "src/view/data/contacts/Accounts.hx", lineNumber : 125, className : "view.data.contacts.Accounts", methodName : "edit"});
	}
	,componentDidMount: function() {
		var _g = new haxe_ds_StringMap();
		var _g1 = new haxe_ds_StringMap();
		var value = new haxe_ds_StringMap();
		_g1.h["contacts"] = value;
		var value = { source : _g1, view : new haxe_ds_StringMap()};
		_g.h["get"] = value;
		this.dataAccess = _g;
		haxe_Log.trace("ok",{ fileName : "src/view/data/contacts/Accounts.hx", lineNumber : 138, className : "view.data.contacts.Accounts", methodName : "componentDidMount"});
		this.props.parentComponent.registerOrmRef(this);
		this.get();
	}
	,loadData: function(id) {
		var _gthis = this;
		haxe_Log.trace("loading:" + id,{ fileName : "src/view/data/contacts/Accounts.hx", lineNumber : 145, className : "view.data.contacts.Accounts", methodName : "loadData"});
		if(id == null) {
			return;
		}
		var p = this.props.load({ classPath : "data.Accounts", action : "get", filter : { id : id, mandator : 1}, resolveMessage : { success : "Konto " + id + " wurde geladen", failure : "Konto " + id + " konnte nicht geladen werden"}, table : "accounts", dbUser : this.props.userState.dbUser, devIP : App.devIP});
		p.then(function(data) {
			haxe_Log.trace(data.dataRows.length,{ fileName : "src/view/data/contacts/Accounts.hx", lineNumber : 163, className : "view.data.contacts.Accounts", methodName : "loadData"});
			if(data.dataRows.length == 1) {
				var data1 = data.dataRows[0];
				var account = new model_Account(data1);
				haxe_Log.trace(account.id,{ fileName : "src/view/data/contacts/Accounts.hx", lineNumber : 170, className : "view.data.contacts.Accounts", methodName : "loadData"});
				_gthis.state.actualStates.h[account.id] = account;
				_gthis.state.loading = false;
				account.state.actualState = account;
				haxe_Log.trace(Std.string(account.state.actualState.id) + ":" + Std.string(account.state.actualState.fieldsInitalized.join(",")),{ fileName : "src/view/data/contacts/Accounts.hx", lineNumber : 174, className : "view.data.contacts.Accounts", methodName : "loadData"});
				_gthis.props.parentComponent.registerORM("accounts",account);
			}
		});
	}
	,renderResults: function() {
		haxe_Log.trace(Std.string(this.state.loading) + ":" + this.props.action,{ fileName : "src/view/data/contacts/Accounts.hx", lineNumber : 183, className : "view.data.contacts.Accounts", methodName : "renderResults"});
		if(this.state.loading || this.state.dataTable == null || this.state.dataTable.length == 0) {
			return this.state.formApi.renderWait();
		}
		haxe_Log.trace("###########loading:" + this.props.action,{ fileName : "src/view/data/contacts/Accounts.hx", lineNumber : 186, className : "view.data.contacts.Accounts", methodName : "renderResults"});
		var _g = this.props.action;
		if(_g == null) {
			return null;
		} else {
			switch(_g) {
			case "delete":
				return null;
			case "get":
				haxe_Log.trace(this.state.dataTable,{ fileName : "src/view/data/contacts/Accounts.hx", lineNumber : 190, className : "view.data.contacts.Accounts", methodName : "renderResults"});
				return React.createElement(react_ReactType.fromComp(view_grid_Grid),Object.assign({ },this.props,{ id : "accountsList", data : this.state.dataTable, dataState : this.dataDisplay.h["accountsList"], parentComponent : this, className : "is-striped is-hoverable", fullWidth : true}));
			case "insert":
				haxe_Log.trace(this.dataDisplay.h["accountsList"],{ fileName : "src/view/data/contacts/Accounts.hx", lineNumber : 204, className : "view.data.contacts.Accounts", methodName : "renderResults"});
				haxe_Log.trace(Std.string(this.state.dataTable[29].h["id"]) + "<<<",{ fileName : "src/view/data/contacts/Accounts.hx", lineNumber : 205, className : "view.data.contacts.Accounts", methodName : "renderResults"});
				return React.createElement(react_ReactType.fromComp(view_grid_Grid),Object.assign({ },this.props,{ id : "accountsList", data : this.state.dataTable, dataState : this.dataDisplay.h["accountsList"], className : "is-striped is-hoverable", fullWidth : true}));
			case "update":
				return React.createElement(react_ReactType.fromComp(view_grid_Grid),Object.assign({ },this.props,{ id : "accountsList", data : this.state.dataTable, dataState : this.dataDisplay.h["accountsList"], className : "is-striped is-hoverable", fullWidth : true}));
			default:
				return null;
			}
		}
	}
	,render: function() {
		haxe_Log.trace(this.props.action,{ fileName : "src/view/data/contacts/Accounts.hx", lineNumber : 222, className : "view.data.contacts.Accounts", methodName : "render"});
		var tmp = react_ReactType.fromString("div");
		var tmp1 = react_ReactType.fromString("form");
		var tmp2 = this.renderResults();
		return React.createElement(tmp,{ className : "t_caption"},"Konten",React.createElement(tmp1,{ className : "tabComponentForm", name : "accountsList"},tmp2));
	}
	,select: function(mEvOrID) {
		haxe_Log.trace(Reflect.fields(this.props),{ fileName : "src/view/data/contacts/Accounts.hx", lineNumber : 235, className : "view.data.contacts.Accounts", methodName : "select"});
		haxe_Log.trace(mEvOrID,{ fileName : "src/view/data/contacts/Accounts.hx", lineNumber : 236, className : "view.data.contacts.Accounts", methodName : "select"});
	}
	,update: function() {
		var _gthis = this;
		var changed = 0;
		try {
			var it = this.state.actualStates.iterator();
			while(it.hasNext()) {
				var account = it.next();
				if(account.fieldsModified.length > 0) {
					++changed;
					var data2save = account.allModified();
					var dbQ = { classPath : "data.Accounts", action : "update", data : data2save, filter : { id : account.id, mandator : 1}, resolveMessage : { success : "Konto " + account.id + " wurde aktualisiert", failure : "Konto " + account.id + " konnte nicht aktualisiert werden"}, table : "accounts", dbUser : this.props.userState.dbUser, devIP : App.devIP};
					var p = App.store.dispatch(redux_Action.map(action_async_CRUD.update(dbQ)));
					p.then(function(d) {
						haxe_Log.trace(d,{ fileName : "src/view/data/contacts/Accounts.hx", lineNumber : 265, className : "view.data.contacts.Accounts", methodName : "update"});
						_gthis.get();
					});
				}
			}
		} catch( _g ) {
			var ex = haxe_Exception.caught(_g);
			haxe_Log.trace($bind(ex,ex.details),{ fileName : "src/view/data/contacts/Accounts.hx", lineNumber : 272, className : "view.data.contacts.Accounts", methodName : "update"});
		}
	}
	,updateMenu: function(viewClassPath) {
		var sideMenu = this.state.sideMenu;
		haxe_Log.trace(sideMenu.section,{ fileName : "src/view/data/contacts/Accounts.hx", lineNumber : 279, className : "view.data.contacts.Accounts", methodName : "updateMenu"});
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
	,__class__: view_data_contacts_Accounts
});
var view_data_contacts_Deals = function(props) {
	React_Component.call(this,props);
	this.dataAccess = model_deals_DealsModel.dataAccess;
	this.fieldNames = view_shared_io_BaseForm.initFieldNames(new haxe_ds__$StringMap_StringMapKeyIterator(this.dataAccess.h["open"].view.h));
	this.dataDisplay = model_deals_DealsModel.dataGridDisplay;
	haxe_Log.trace("..." + Std.string(Reflect.fields(props)),{ fileName : "src/view/data/contacts/Deals.hx", lineNumber : 64, className : "view.data.contacts.Deals", methodName : "new"});
	this.state = App.initEState({ actualStates : new haxe_ds_IntMap(), dataTable : [], loading : false, dealsData : new haxe_ds_IntMap(), model : "deals", selectedRows : [], sideMenu : null, values : new haxe_ds_StringMap()},this);
	var c = js_Boot.getClass(this);
	props.parentComponent.state.relDataComps.set(c.__name__,this);
	haxe_Log.trace(this.state.loading,{ fileName : "src/view/data/contacts/Deals.hx", lineNumber : 76, className : "view.data.contacts.Deals", methodName : "new"});
};
$hxClasses["view.data.contacts.Deals"] = view_data_contacts_Deals;
view_data_contacts_Deals.__name__ = "view.data.contacts.Deals";
view_data_contacts_Deals.mapDispatchToProps = function(dispatch) {
	return { load : function(param) {
		return dispatch(redux_Action.map(action_async_CRUD.read(param)));
	}, loadData : function(id,me) {
		if(id == null) {
			id = -1;
		}
		return me.loadData(id);
	}, save : function(me) {
		return me.update();
	}, select : function(id,data,me,sType) {
		if(id == null) {
			id = -1;
		}
		var c = js_Boot.getClass(me);
		haxe_Log.trace("select:" + id + " me:" + c.__name__ + " SelectType:" + sType,{ fileName : "src/view/data/contacts/Deals.hx", lineNumber : 87, className : "view.data.contacts.Deals", methodName : "mapDispatchToProps"});
	}};
};
view_data_contacts_Deals.mapStateToProps = function(aState) {
	haxe_Log.trace(Reflect.fields(aState),{ fileName : "src/view/data/contacts/Deals.hx", lineNumber : 97, className : "view.data.contacts.Deals", methodName : "mapStateToProps"});
	return { userState : aState.userState};
};
view_data_contacts_Deals.__super__ = React_Component;
view_data_contacts_Deals.prototype = $extend(React_Component.prototype,{
	dataAccess: null
	,dataDisplay: null
	,deal: null
	,formFields: null
	,fieldNames: null
	,dbData: null
	,dbMetaData: null
	,'delete': function(ev) {
		haxe_Log.trace(this.state.selectedRows.length,{ fileName : "src/view/data/contacts/Deals.hx", lineNumber : 105, className : "view.data.contacts.Deals", methodName : "delete"});
		var data = this.state.formApi.selectedRowsMap(this.state);
	}
	,get: function() {
		var _gthis = this;
		var offset = 0;
		haxe_Log.trace(this.props.filter,{ fileName : "src/view/data/contacts/Deals.hx", lineNumber : 116, className : "view.data.contacts.Deals", methodName : "get"});
		this.state.loading = true;
		var p = this.props.load({ classPath : "data.Deals", action : "get", filter : this.props.filter != null ? this.props.filter : { mandator : "1"}, limit : this.props.limit, offset : offset > 0 ? offset : 0, table : this.state.model, resolveMessage : { success : "Spendenliste wurde geladen", failure : "Spendenliste konnte nicht geladen werden"}, dbUser : this.props.userState.dbUser, devIP : App.devIP});
		p.then(function(data) {
			haxe_Log.trace(data.dataRows.length,{ fileName : "src/view/data/contacts/Deals.hx", lineNumber : 137, className : "view.data.contacts.Deals", methodName : "get"});
			if(data.dataRows.length > 0) {
				var tmp = data.dataRows[0];
				haxe_Log.trace(tmp == null ? "null" : haxe_ds_StringMap.stringify(tmp.h),{ fileName : "src/view/data/contacts/Deals.hx", lineNumber : 139, className : "view.data.contacts.Deals", methodName : "get"});
			}
			_gthis.setState({ loading : false, dataTable : data.dataRows, dataCount : Std.parseInt(data.dataInfo.h["count"]), pageCount : Math.ceil(Std.parseInt(data.dataInfo.h["count"]) / _gthis.props.limit)});
		});
	}
	,edit: function(ev) {
		haxe_Log.trace(this.state.selectedRows.length,{ fileName : "src/view/data/contacts/Deals.hx", lineNumber : 152, className : "view.data.contacts.Deals", methodName : "edit"});
	}
	,componentDidMount: function() {
		var _g = new haxe_ds_StringMap();
		var _g1 = new haxe_ds_StringMap();
		var value = new haxe_ds_StringMap();
		_g1.h["deals"] = value;
		var value = { source : _g1, view : new haxe_ds_StringMap()};
		_g.h["get"] = value;
		this.dataAccess = _g;
		haxe_Log.trace(this.props.action,{ fileName : "src/view/data/contacts/Deals.hx", lineNumber : 185, className : "view.data.contacts.Deals", methodName : "componentDidMount"});
		if(this.props.userState.dbUser != null) {
			haxe_Log.trace("yeah: " + this.props.userState.dbUser.first_name,{ fileName : "src/view/data/contacts/Deals.hx", lineNumber : 187, className : "view.data.contacts.Deals", methodName : "componentDidMount"});
		}
		this.props.parentComponent.registerOrmRef(this);
		this.get();
	}
	,loadData: function(id) {
		var _gthis = this;
		haxe_Log.trace("loading:" + id,{ fileName : "src/view/data/contacts/Deals.hx", lineNumber : 196, className : "view.data.contacts.Deals", methodName : "loadData"});
		if(id == null) {
			return;
		}
		var p = this.props.load({ classPath : "data.Deals", action : "get", filter : { id : id, mandator : 1}, resolveMessage : { success : "Spende " + id + " wurde geladen", failure : "Spende " + id + " konnte nicht geladen werden"}, table : "deals", dbUser : this.props.userState.dbUser, devIP : App.devIP});
		p.then(function(data) {
			haxe_Log.trace(data.dataRows.length,{ fileName : "src/view/data/contacts/Deals.hx", lineNumber : 214, className : "view.data.contacts.Deals", methodName : "loadData"});
			if(data.dataRows.length == 1) {
				var data1 = data.dataRows[0];
				haxe_Log.trace(data1 == null ? "null" : haxe_ds_StringMap.stringify(data1.h),{ fileName : "src/view/data/contacts/Deals.hx", lineNumber : 218, className : "view.data.contacts.Deals", methodName : "loadData"});
				_gthis.deal = new model_Deal(data1);
				haxe_Log.trace(_gthis.deal.id,{ fileName : "src/view/data/contacts/Deals.hx", lineNumber : 221, className : "view.data.contacts.Deals", methodName : "loadData"});
				_gthis.deal.state.actualState = _gthis.deal;
				_gthis.state.actualStates.h[_gthis.deal.id] = _gthis.deal;
				haxe_Log.trace(Std.string(_gthis.deal.state.actualState.id) + ":" + Std.string(_gthis.deal.state.actualState.fieldsInitalized.join(",")),{ fileName : "src/view/data/contacts/Deals.hx", lineNumber : 226, className : "view.data.contacts.Deals", methodName : "loadData"});
				_gthis.props.parentComponent.registerORM("deals",_gthis.deal);
			}
		});
	}
	,renderForm: function() {
		haxe_Log.trace(Std.string(this.state.loading) + ":" + Std.string(this.props.parentComponent.props.match.params.action),{ fileName : "src/view/data/contacts/Deals.hx", lineNumber : 242, className : "view.data.contacts.Deals", methodName : "renderForm"});
		if(this.state.loading) {
			return this.state.formApi.renderWait();
		}
		haxe_Log.trace("###########loading:" + Std.string(this.state.loading),{ fileName : "src/view/data/contacts/Deals.hx", lineNumber : 245, className : "view.data.contacts.Deals", methodName : "renderForm"});
		switch(this.props.parentComponent.props.match.params.action) {
		case "open2":case "update2":
			haxe_Log.trace(this.state.actualState,{ fileName : "src/view/data/contacts/Deals.hx", lineNumber : 250, className : "view.data.contacts.Deals", methodName : "renderForm"});
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
				return tmp.renderForm({ mHandlers : tmp1, fields : _g, model : "deal", title : "Bearbeite Spende"},this.state.actualState);
			}
			break;
		default:
			haxe_Log.trace(">>>" + Std.string(this.props.parentComponent.props.match.params.action) + "<<<",{ fileName : "src/view/data/contacts/Deals.hx", lineNumber : 265, className : "view.data.contacts.Deals", methodName : "renderForm"});
			return null;
		}
	}
	,renderResults: function() {
		if(this.state.loading || this.state.dataTable == null || this.state.dataTable.length == 0) {
			return this.state.formApi.renderWait();
		}
		haxe_Log.trace(this.props.action,{ fileName : "src/view/data/contacts/Deals.hx", lineNumber : 279, className : "view.data.contacts.Deals", methodName : "renderResults"});
		var _g = this.props.action;
		if(_g == null) {
			return null;
		} else {
			switch(_g) {
			case "delete":
				return null;
			case "get":
				var tmp = react_ReactType.fromComp(React_Fragment);
				var tmp1 = React.createElement(react_ReactType.fromComp(view_grid_Grid),Object.assign({ },this.props,{ id : "dealsList", data : this.state.dataTable, dataState : this.dataDisplay.h["dealsList"], parentComponent : this, className : "is-striped is-hoverable", fullWidth : true}));
				var tmp2 = this.renderForm();
				return React.createElement(tmp,{ },tmp1,tmp2);
			default:
				return null;
			}
		}
	}
	,render: function() {
		var tmp = react_ReactType.fromString("div");
		var tmp1 = react_ReactType.fromString("form");
		var tmp2 = { key : "dealsList", ref : this.props.formRef, className : "tabComponentForm formField", name : "dealsList"};
		var tmp3 = this.renderResults();
		return React.createElement(tmp,{ className : "t_caption"},"Spenden",React.createElement(tmp1,tmp2,tmp3));
	}
	,update: function() {
		var _gthis = this;
		var changed = 0;
		try {
			var it = this.state.actualStates.iterator();
			while(it.hasNext()) {
				var deal = it.next();
				if(deal.fieldsModified.length > 0) {
					++changed;
					var data2save = deal.allModified();
					var dbQ = { classPath : "data.Deals", action : "update", data : data2save, filter : { id : deal.id, mandator : 1}, resolveMessage : { success : "Spende " + deal.id + " wurde aktualisiert", failure : "Spende " + deal.id + " konnte nicht aktualisiert werden"}, table : "deals", dbUser : this.props.userState.dbUser, devIP : App.devIP};
					var p = App.store.dispatch(redux_Action.map(action_async_CRUD.update(dbQ)));
					p.then(function(d) {
						haxe_Log.trace(d,{ fileName : "src/view/data/contacts/Deals.hx", lineNumber : 340, className : "view.data.contacts.Deals", methodName : "update"});
						_gthis.get();
					});
				}
			}
		} catch( _g ) {
			var ex = haxe_Exception.caught(_g);
			haxe_Log.trace($bind(ex,ex.details),{ fileName : "src/view/data/contacts/Deals.hx", lineNumber : 347, className : "view.data.contacts.Deals", methodName : "update"});
		}
		if(changed == 0) {
			haxe_Log.trace("nothing to save",{ fileName : "src/view/data/contacts/Deals.hx", lineNumber : 350, className : "view.data.contacts.Deals", methodName : "update"});
		}
	}
	,setState: null
	,__class__: view_data_contacts_Deals
});
var view_data_contacts_Edit = function(props) {
	this._trace = false;
	this.mounted = false;
	React_Component.call(this,props);
	this.ormRefs = new haxe_ds_StringMap();
	this._trace = true;
	this.accountsFormRef = React.createRef();
	this.dealsFormRef = React.createRef();
	this.formRef = React.createRef();
	this.historyFormRef = React.createRef();
	haxe_Log.trace(props.match.params,{ fileName : "src/view/data/contacts/Edit.hx", lineNumber : 126, className : "view.data.contacts.Edit", methodName : "new"});
	if(props.match.params.id == null && new EReg("open(/)*$","").match(props.match.params.action)) {
		haxe_Log.trace("nothing selected - redirect",{ fileName : "src/view/data/contacts/Edit.hx", lineNumber : 130, className : "view.data.contacts.Edit", methodName : "new"});
		var baseUrl = props.match.path.split(":section")[0];
		props.history.push("" + baseUrl + "List/get");
		return;
	}
	this.dataAccess = model_contacts_ContactsModel.dataAccess;
	this.fieldNames = view_shared_io_BaseForm.initFieldNames(new haxe_ds__$StringMap_StringMapKeyIterator(this.dataAccess.h["open"].view.h));
	this.dataDisplay = model_contacts_ContactsModel.dataDisplay;
	this.dealDataAccess = model_deals_DealsModel.dataAccess;
	this.dealFieldNames = view_shared_io_BaseForm.initFieldNames(new haxe_ds__$StringMap_StringMapKeyIterator(this.dealDataAccess.h["open"].view.h));
	this.dealDataDisplay = model_deals_DealsModel.dataDisplay;
	this.accountDataAccess = model_accounting_AccountsModel.dataAccess;
	this.accountFieldNames = view_shared_io_BaseForm.initFieldNames(new haxe_ds__$StringMap_StringMapKeyIterator(this.accountDataAccess.h["open"].view.h));
	this.accountDataDisplay = model_accounting_AccountsModel.dataDisplay;
	if(props.dataStore.contactData != null) {
		haxe_Log.trace(props.dataStore.contactData.keys().next(),{ fileName : "src/view/data/contacts/Edit.hx", lineNumber : 148, className : "view.data.contacts.Edit", methodName : "new"});
	}
	this.state = App.initEState({ actualState : null, initialData : null, mHandlers : view_data_contacts_Edit.menuItems, loading : false, model : "contacts", ormRefs : new haxe_ds_StringMap(), relDataComps : new haxe_ds_StringMap(), selectedRows : [], sideMenu : view_shared_io_FormApi.initSideMenu(this,{ dataClassPath : "data.Contacts", label : "Bearbeiten", section : "Edit", items : view_data_contacts_Edit.menuItems},{ section : props.match.params.section == null ? "Edit" : props.match.params.section, sameWidth : true}), values : new haxe_ds_StringMap()},this);
	haxe_Log.trace(this.state.initialData,{ fileName : "src/view/data/contacts/Edit.hx", lineNumber : 178, className : "view.data.contacts.Edit", methodName : "new"});
};
$hxClasses["view.data.contacts.Edit"] = view_data_contacts_Edit;
view_data_contacts_Edit.__name__ = "view.data.contacts.Edit";
view_data_contacts_Edit.mapDispatchToProps = function(dispatch) {
	haxe_Log.trace("here we should be ready to load",{ fileName : "src/view/data/contacts/Edit.hx", lineNumber : 575, className : "view.data.contacts.Edit", methodName : "mapDispatchToProps"});
	return { load : function(param) {
		return dispatch(redux_Action.map(action_async_CRUD.read(param)));
	}};
};
view_data_contacts_Edit.mapStateToProps = function(aState) {
	return { userState : aState.userState};
};
view_data_contacts_Edit.__super__ = React_Component;
view_data_contacts_Edit.prototype = $extend(React_Component.prototype,{
	dataAccess: null
	,dataDisplay: null
	,dealsAreOpen: null
	,formApi: null
	,formBuilder: null
	,formFields: null
	,dealsFormRef: null
	,formRef: null
	,fieldNames: null
	,ormRefs: null
	,accountsFormRef: null
	,historyFormRef: null
	,baseForm: null
	,contact: null
	,dbData: null
	,dbMetaData: null
	,modals: null
	,mounted: null
	,_trace: null
	,dealDataAccess: null
	,dealFieldNames: null
	,dealDataDisplay: null
	,accountDataAccess: null
	,accountFieldNames: null
	,accountDataDisplay: null
	,close: function() {
		this.props.history.push("" + this.props.match.path.split(":section")[0] + "List/get");
	}
	,showSelectedAccounts: function(ev) {
		haxe_Log.trace("---" + Std.string(this.ormRefs.h["accounts"].compRef.state.dataGrid.state.selectedRows),{ fileName : "src/view/data/contacts/Edit.hx", lineNumber : 191, className : "view.data.contacts.Edit", methodName : "showSelectedAccounts"});
		var sRows = this.ormRefs.h["accounts"].compRef.state.dataGrid.state.selectedRows;
		var k = sRows.keys();
		while(k.hasNext()) {
			var k1 = k.next();
			this.ormRefs.h["accounts"].compRef.props.loadData(k1,this.ormRefs.h["accounts"].compRef);
		}
	}
	,showSelectedDeals: function(ev) {
		haxe_Log.trace("---" + Std.string(Type.typeof(this.state.relDataComps)),{ fileName : "src/view/data/contacts/Edit.hx", lineNumber : 204, className : "view.data.contacts.Edit", methodName : "showSelectedDeals"});
		var h = this.state.relDataComps.h;
		var inlStringMapKeyIterator_h = h;
		var inlStringMapKeyIterator_keys = Object.keys(h);
		var inlStringMapKeyIterator_length = inlStringMapKeyIterator_keys.length;
		var inlStringMapKeyIterator_current = 0;
		haxe_Log.trace("---" + Std.string(inlStringMapKeyIterator_current < inlStringMapKeyIterator_length),{ fileName : "src/view/data/contacts/Edit.hx", lineNumber : 206, className : "view.data.contacts.Edit", methodName : "showSelectedDeals"});
		var sRows = this.ormRefs.h["deals"].compRef.state.dataGrid.state.selectedRows;
		var k = sRows.keys();
		while(k.hasNext()) {
			var k1 = k.next();
			this.ormRefs.h["deals"].compRef.props.loadData(k1,this.ormRefs.h["deals"].compRef);
		}
		haxe_Log.trace(react_ReactRef.get_current(this.dealsFormRef),{ fileName : "src/view/data/contacts/Edit.hx", lineNumber : 213, className : "view.data.contacts.Edit", methodName : "showSelectedDeals"});
		haxe_Log.trace(react_ReactRef.get_current(this.dealsFormRef).querySelectorAll(".selected").length,{ fileName : "src/view/data/contacts/Edit.hx", lineNumber : 214, className : "view.data.contacts.Edit", methodName : "showSelectedDeals"});
		if(ev != null) {
			var targetEl = js_Boot.__cast(ev.target , HTMLElement);
			haxe_Log.trace(Std.string(targetEl.dataset.id),{ fileName : "src/view/data/contacts/Edit.hx", lineNumber : 217, className : "view.data.contacts.Edit", methodName : "showSelectedDeals"});
		}
	}
	,loadContactData: function(id) {
		var _gthis = this;
		haxe_Log.trace("loading:" + id,{ fileName : "src/view/data/contacts/Edit.hx", lineNumber : 230, className : "view.data.contacts.Edit", methodName : "loadContactData"});
		if(id == null) {
			return;
		}
		var p = this.props.load({ classPath : "data.Contacts", action : "get", filter : { id : id, mandator : 1}, resolveMessage : { success : "Kontakt " + id + " wurde geladen", failure : "Kontakt " + id + " konnte nicht geladen werden"}, table : "contacts", dbUser : this.props.userState.dbUser, devIP : App.devIP});
		p.then(function(data) {
			haxe_Log.trace(data.dataRows.length,{ fileName : "src/view/data/contacts/Edit.hx", lineNumber : 248, className : "view.data.contacts.Edit", methodName : "loadContactData"});
			if(data.dataRows.length == 1) {
				var data1 = data.dataRows[0];
				haxe_Log.trace(data1 == null ? "null" : haxe_ds_StringMap.stringify(data1.h),{ fileName : "src/view/data/contacts/Edit.hx", lineNumber : 252, className : "view.data.contacts.Edit", methodName : "loadContactData"});
				var contact = new model_Contact(data1);
				if(_gthis.mounted) {
					_gthis.setState({ loading : false, actualState : contact, initialData : react_ReactUtil.copy(contact)});
				}
				haxe_Log.trace("" + Std.string(_gthis.mounted) + " " + contact.id,{ fileName : "src/view/data/contacts/Edit.hx", lineNumber : 258, className : "view.data.contacts.Edit", methodName : "loadContactData"});
				haxe_Log.trace(_gthis.state.actualState.id + ":" + _gthis.state.actualState.fieldsInitalized.join(","),{ fileName : "src/view/data/contacts/Edit.hx", lineNumber : 259, className : "view.data.contacts.Edit", methodName : "loadContactData"});
				haxe_Log.trace(_gthis.props.location.pathname + ":" + _gthis.state.actualState.date_of_birth,{ fileName : "src/view/data/contacts/Edit.hx", lineNumber : 261, className : "view.data.contacts.Edit", methodName : "loadContactData"});
				var _gthis1 = _gthis.props.history;
				var tmp = StringTools.replace(_gthis.props.location.pathname,"open","update");
				_gthis1.replace(tmp);
			}
		});
	}
	,'delete': function(ev) {
		haxe_Log.trace(this.state.selectedRows.length,{ fileName : "src/view/data/contacts/Edit.hx", lineNumber : 269, className : "view.data.contacts.Edit", methodName : "delete"});
		var data = this.state.formApi.selectedRowsMap(this.state);
	}
	,update2: function() {
		var data2save = this.state.actualState.allModified();
	}
	,componentDidCatch: function(error,info) {
		try {
			this.setState({ hasError : true});
		} catch( _g ) {
			haxe_NativeStackTrace.lastError = _g;
			var ex = haxe_Exception.caught(_g).unwrap();
			if(this._trace) {
				haxe_Log.trace(ex,{ fileName : "src/view/data/contacts/Edit.hx", lineNumber : 286, className : "view.data.contacts.Edit", methodName : "componentDidCatch"});
			}
		}
		if(this._trace) {
			haxe_Log.trace(error,{ fileName : "src/view/data/contacts/Edit.hx", lineNumber : 288, className : "view.data.contacts.Edit", methodName : "componentDidCatch"});
		}
		me_cunity_debug_Out.dumpStack(haxe_CallStack.callStack(),{ fileName : "src/view/data/contacts/Edit.hx", lineNumber : 289, className : "view.data.contacts.Edit", methodName : "componentDidCatch"});
	}
	,componentDidMount: function() {
		haxe_Log.trace("mounted:" + Std.string(this.mounted),{ fileName : "src/view/data/contacts/Edit.hx", lineNumber : 294, className : "view.data.contacts.Edit", methodName : "componentDidMount"});
		this.mounted = true;
		haxe_Log.trace(this.props.children,{ fileName : "src/view/data/contacts/Edit.hx", lineNumber : 296, className : "view.data.contacts.Edit", methodName : "componentDidMount"});
		this.loadContactData(Std.parseInt(this.props.match.params.id));
		haxe_Log.trace(this.props.children,{ fileName : "src/view/data/contacts/Edit.hx", lineNumber : 298, className : "view.data.contacts.Edit", methodName : "componentDidMount"});
	}
	,componentWillUnmount: function() {
		return;
	}
	,registerRelDataComp: function(rDC) {
	}
	,registerOrmRef: function(ref) {
		haxe_Log.trace(Type.typeof(ref),{ fileName : "src/view/data/contacts/Edit.hx", lineNumber : 324, className : "view.data.contacts.Edit", methodName : "registerOrmRef"});
		var _g = Type.typeof(ref);
		switch(_g._hx_index) {
		case 0:
			break;
		case 4:
			haxe_Log.trace(Reflect.fields(ref),{ fileName : "src/view/data/contacts/Edit.hx", lineNumber : 329, className : "view.data.contacts.Edit", methodName : "registerOrmRef"});
			haxe_Log.trace(js_Boot.getClass(ref),{ fileName : "src/view/data/contacts/Edit.hx", lineNumber : 330, className : "view.data.contacts.Edit", methodName : "registerOrmRef"});
			haxe_Log.trace(ref.props,{ fileName : "src/view/data/contacts/Edit.hx", lineNumber : 331, className : "view.data.contacts.Edit", methodName : "registerOrmRef"});
			haxe_Log.trace(ref.state,{ fileName : "src/view/data/contacts/Edit.hx", lineNumber : 332, className : "view.data.contacts.Edit", methodName : "registerOrmRef"});
			haxe_Log.trace(ref.state.model,{ fileName : "src/view/data/contacts/Edit.hx", lineNumber : 333, className : "view.data.contacts.Edit", methodName : "registerOrmRef"});
			var tmp = ref.props != null && ref.props.model != null;
			break;
		case 6:
			var func = _g.c;
			var cL = js_Boot.getClass(ref);
			if(cL != null) {
				haxe_Log.trace(cL.__name__,{ fileName : "src/view/data/contacts/Edit.hx", lineNumber : 342, className : "view.data.contacts.Edit", methodName : "registerOrmRef"});
				try {
					haxe_Log.trace(Reflect.fields(ref.props),{ fileName : "src/view/data/contacts/Edit.hx", lineNumber : 344, className : "view.data.contacts.Edit", methodName : "registerOrmRef"});
					haxe_Log.trace(Reflect.fields(ref.state),{ fileName : "src/view/data/contacts/Edit.hx", lineNumber : 345, className : "view.data.contacts.Edit", methodName : "registerOrmRef"});
					haxe_Log.trace(ref.state.model,{ fileName : "src/view/data/contacts/Edit.hx", lineNumber : 346, className : "view.data.contacts.Edit", methodName : "registerOrmRef"});
					if(ref.props != null && ref.props.model != null) {
						var this1 = this.ormRefs;
						var k = ref.props.model;
						var v = { compRef : ref, orms : new haxe_ds_IntMap()};
						this1.h[k] = v;
					}
				} catch( _g ) {
					var ex = haxe_Exception.caught(_g);
					haxe_Log.trace(ex,{ fileName : "src/view/data/contacts/Edit.hx", lineNumber : 355, className : "view.data.contacts.Edit", methodName : "registerOrmRef"});
				}
			}
			break;
		default:
			haxe_Log.trace(ref,{ fileName : "src/view/data/contacts/Edit.hx", lineNumber : 359, className : "view.data.contacts.Edit", methodName : "registerOrmRef"});
		}
	}
	,registerORM: function(refModel,orm) {
		if(Object.prototype.hasOwnProperty.call(this.ormRefs.h,refModel)) {
			this.ormRefs.h[refModel].orms.h[orm.id] = orm;
			haxe_Log.trace(refModel,{ fileName : "src/view/data/contacts/Edit.hx", lineNumber : 366, className : "view.data.contacts.Edit", methodName : "registerORM"});
			this.setState({ ormRefs : this.ormRefs});
			haxe_Log.trace(Reflect.fields(this.state),{ fileName : "src/view/data/contacts/Edit.hx", lineNumber : 370, className : "view.data.contacts.Edit", methodName : "registerORM"});
		} else {
			haxe_Log.trace("OrmRef " + refModel + " not found!",{ fileName : "src/view/data/contacts/Edit.hx", lineNumber : 374, className : "view.data.contacts.Edit", methodName : "registerORM"});
		}
	}
	,update: function() {
		var _gthis = this;
		var h = this.state.relDataComps.h;
		var _g_h = h;
		var _g_keys = Object.keys(h);
		var _g_length = _g_keys.length;
		var _g_current = 0;
		while(_g_current < _g_length) {
			var key = _g_keys[_g_current++];
			var _g1_key = key;
			var _g1_value = _g_h[key];
			var k = _g1_key;
			var v = _g1_value;
			haxe_Log.trace("" + k + "=>" + Std.string(v.props.save),{ fileName : "src/view/data/contacts/Edit.hx", lineNumber : 381, className : "view.data.contacts.Edit", methodName : "update"});
			v.props.save(v);
		}
		if(this.state.actualState != null) {
			haxe_Log.trace("length:" + this.state.actualState.fieldsModified.length + ":" + this.state.actualState.fieldsModified.join("|"),{ fileName : "src/view/data/contacts/Edit.hx", lineNumber : 385, className : "view.data.contacts.Edit", methodName : "update"});
		}
		if(this.state.actualState == null || this.state.actualState.fieldsModified.length == 0) {
			return;
		}
		var data2save = this.state.actualState.allModified();
		var doc = window.document;
		var formElement = js_Boot.__cast(doc.querySelector("form[name=\"contact\"]") , HTMLFormElement);
		var elements = formElement.elements;
		var aState = react_ReactUtil.copy(this.state.actualState);
		var dbQ = { classPath : "data.Contacts", action : "update", data : data2save, filter : { id : this.state.actualState.id, mandator : 1}, resolveMessage : { success : "Kontakt " + this.state.actualState.id + " wurde aktualisiert", failure : "Kontakt " + this.state.actualState.id + " konnte nicht aktualisiert werden"}, table : "contacts", dbUser : this.props.userState.dbUser, devIP : App.devIP};
		haxe_Log.trace(this.props.match.params.action,{ fileName : "src/view/data/contacts/Edit.hx", lineNumber : 407, className : "view.data.contacts.Edit", methodName : "update"});
		switch(this.props.match.params.action) {
		case "delete":case "get":
			var _g = new haxe_ds_StringMap();
			var _g1 = new haxe_ds_StringMap();
			_g1.h["filter"] = { id : this.state.initialData.id};
			_g.h["contacts"] = _g1;
			dbQ.dataSource = _g;
			break;
		case "insert":
			var _g = 0;
			var _g1 = this.fieldNames;
			while(_g < _g1.length) {
				var f = _g1[_g];
				++_g;
				haxe_Log.trace("" + f + " =>" + Std.string(Reflect.field(aState,f)) + "<=",{ fileName : "src/view/data/contacts/Edit.hx", lineNumber : 414, className : "view.data.contacts.Edit", methodName : "update"});
				if(Reflect.field(aState,f) == "") {
					Reflect.deleteField(aState,f);
				}
			}
			break;
		case "update":
			haxe_Log.trace("" + Std.string(this.state.initialData.id) + " :: creation_date: " + Std.string(aState.creation_date) + " " + Std.string(this.state.initialData.creation_date),{ fileName : "src/view/data/contacts/Edit.hx", lineNumber : 426, className : "view.data.contacts.Edit", methodName : "update"});
			if(this.state.actualState != null) {
				haxe_Log.trace(Std.string(this.state.actualState.modified()) + (":" + Std.string(this.state.actualState.fieldsModified)),{ fileName : "src/view/data/contacts/Edit.hx", lineNumber : 430, className : "view.data.contacts.Edit", methodName : "update"});
			}
			haxe_Log.trace(this.state.actualState.id,{ fileName : "src/view/data/contacts/Edit.hx", lineNumber : 432, className : "view.data.contacts.Edit", methodName : "update"});
			if(!this.state.actualState.modified()) {
				haxe_Log.trace("nothing modified",{ fileName : "src/view/data/contacts/Edit.hx", lineNumber : 436, className : "view.data.contacts.Edit", methodName : "update"});
				return;
			}
			haxe_Log.trace(this.state.actualState.allModified(),{ fileName : "src/view/data/contacts/Edit.hx", lineNumber : 439, className : "view.data.contacts.Edit", methodName : "update"});
			break;
		}
		var p = App.store.dispatch(redux_Action.map(action_async_CRUD.update(dbQ)));
		p.then(function(d) {
			haxe_Log.trace(d,{ fileName : "src/view/data/contacts/Edit.hx", lineNumber : 452, className : "view.data.contacts.Edit", methodName : "update"});
			_gthis.loadContactData(_gthis.state.actualState.id);
		});
	}
	,renderResults: function() {
		switch(this.props.match.params.action) {
		case "insert":
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
			return tmp.renderForm({ mHandlers : tmp1, fields : _g, model : "contact", ref : null, title : "Kontakt - Neue Stammdaten"},this.state.actualState);
		case "open":case "update":
			if(this.state.actualState == null) {
				return this.state.formApi.renderWait();
			} else {
				var tmp = react_ReactType.fromComp(React_Fragment);
				var tmp1 = this.state.formBuilder;
				var tmp2 = this.state.mHandlers;
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
				var tmp3 = tmp1.renderForm({ mHandlers : tmp2, fields : _g, model : "contact", ref : null, title : "Stammdaten"},this.state.actualState);
				var tmp1 = this.relData();
				var tmp2 = this.relDataLists();
				return React.createElement(tmp,{ },tmp3,tmp1,tmp2);
			}
			break;
		default:
			return null;
		}
	}
	,relData: function() {
		var _g = [];
		var model = "deals";
		if(Object.prototype.hasOwnProperty.call(this.ormRefs.h,model)) {
			var _g1 = 0;
			var _g2 = Lambda.array(this.ormRefs.h[model].orms);
			while(_g1 < _g2.length) {
				var orm = _g2[_g1];
				++_g1;
				var orm1 = orm.formBuilder;
				var tmp;
				if(model == "deals") {
					var _g3 = new haxe_ds_StringMap();
					var h = this.dealDataAccess.h["open"].view.h;
					var k_h = h;
					var k_keys = Object.keys(h);
					var k_length = k_keys.length;
					var k_current = 0;
					while(k_current < k_length) {
						var k = k_keys[k_current++];
						_g3.h[k] = this.dealDataAccess.h["open"].view.h[k];
					}
					tmp = _g3;
				} else {
					var _g4 = new haxe_ds_StringMap();
					var h1 = this.accountDataAccess.h["open"].view.h;
					var k_h1 = h1;
					var k_keys1 = Object.keys(h1);
					var k_length1 = k_keys1.length;
					var k_current1 = 0;
					while(k_current1 < k_length1) {
						var k1 = k_keys1[k_current1++];
						_g4.h[k1] = this.accountDataAccess.h["open"].view.h[k1];
					}
					tmp = _g4;
				}
				_g.push(orm1.renderForm({ fields : tmp, model : model, ref : null, title : model == "deals" ? "Spenden" : "Konten"},orm));
			}
		}
		var model = "accounts";
		if(Object.prototype.hasOwnProperty.call(this.ormRefs.h,model)) {
			var _g1 = 0;
			var _g2 = Lambda.array(this.ormRefs.h[model].orms);
			while(_g1 < _g2.length) {
				var orm = _g2[_g1];
				++_g1;
				var orm1 = orm.formBuilder;
				var tmp;
				if(model == "deals") {
					var _g3 = new haxe_ds_StringMap();
					var h = this.dealDataAccess.h["open"].view.h;
					var k_h = h;
					var k_keys = Object.keys(h);
					var k_length = k_keys.length;
					var k_current = 0;
					while(k_current < k_length) {
						var k = k_keys[k_current++];
						_g3.h[k] = this.dealDataAccess.h["open"].view.h[k];
					}
					tmp = _g3;
				} else {
					var _g4 = new haxe_ds_StringMap();
					var h1 = this.accountDataAccess.h["open"].view.h;
					var k_h1 = h1;
					var k_keys1 = Object.keys(h1);
					var k_length1 = k_keys1.length;
					var k_current1 = 0;
					while(k_current1 < k_length1) {
						var k1 = k_keys1[k_current1++];
						_g4.h[k1] = this.accountDataAccess.h["open"].view.h[k1];
					}
					tmp = _g4;
				}
				_g.push(orm1.renderForm({ fields : tmp, model : model, ref : null, title : model == "deals" ? "Spenden" : "Konten"},orm));
			}
		}
		return _g;
	}
	,relDataLists: function() {
		var tmp = react_ReactType.fromComp(React_Fragment);
		var tmp1 = React.createElement(view_data_contacts_Deals._renderWrapper,{ key : "deals", formRef : this.dealsFormRef, parentComponent : this, model : "deals", action : "get", onDoubleClick : $bind(this,this.showSelectedDeals), filter : { contact : this.props.match.params.id, mandator : "1"}});
		var tmp2 = React.createElement(view_data_contacts_Accounts._renderWrapper,{ key : "accounts", formRef : this.accountsFormRef, parentComponent : this, model : "accounts", action : "get", onDoubleClick : $bind(this,this.showSelectedAccounts), filter : { contact : this.props.match.params.id, mandator : "1"}});
		return React.createElement(tmp,{ },tmp1,tmp2);
	}
	,render: function() {
		haxe_Log.trace(this.props.match.params.action,{ fileName : "src/view/data/contacts/Edit.hx", lineNumber : 544, className : "view.data.contacts.Edit", methodName : "render"});
		if(this.state.initialData == null) {
			return null;
		}
		switch(this.props.match.params.action) {
		case "insert":
			return this.state.formApi.render(this.renderResults());
		case "open":
			return this.state.formApi.render(this.renderResults());
		default:
			return this.state.formApi.render(this.renderResults());
		}
	}
	,select: function(id,data,match) {
		haxe_Log.trace(id,{ fileName : "src/view/data/contacts/Edit.hx", lineNumber : 571, className : "view.data.contacts.Edit", methodName : "select"});
	}
	,setState: null
	,__class__: view_data_contacts_Edit
});
var view_data_contacts_List = function(props) {
	React_Component.call(this,props);
	this.dataDisplay = model_contacts_ContactsModel.dataGridDisplay;
	this.state = App.initEState({ dataTable : [], loading : true, contactData : new haxe_ds_IntMap(), selectedRows : [], sideMenu : view_shared_io_FormApi.initSideMenu(this,{ dataClassPath : "data.Contacts", label : "Liste", section : "List", items : view_data_contacts_List.menuItems},{ section : props.match.params.section == null ? "List" : props.match.params.section, sameWidth : true}), values : new haxe_ds_StringMap()},this);
	if(props.match.params.section == null || props.match.params.action == null) {
		var baseUrl = props.match.path.split(":section")[0];
		haxe_Log.trace("redirecting to " + baseUrl + "List/get",{ fileName : "src/view/data/contacts/List.hx", lineNumber : 88, className : "view.data.contacts.List", methodName : "new"});
		props.history.push("" + baseUrl + "List/get");
	} else {
		haxe_Log.trace(props.match.params,{ fileName : "src/view/data/contacts/List.hx", lineNumber : 95, className : "view.data.contacts.List", methodName : "new"});
	}
	haxe_Log.trace(this.state.loading,{ fileName : "src/view/data/contacts/List.hx", lineNumber : 97, className : "view.data.contacts.List", methodName : "new"});
};
$hxClasses["view.data.contacts.List"] = view_data_contacts_List;
view_data_contacts_List.__name__ = "view.data.contacts.List";
view_data_contacts_List.mapStateToProps = function(aState) {
	return { userState : aState.userState};
};
view_data_contacts_List.mapDispatchToProps = function(dispatch) {
	return { load : function(param) {
		return dispatch(redux_Action.map(action_async_CRUD.read(param)));
	}};
};
view_data_contacts_List.__super__ = React_Component;
view_data_contacts_List.prototype = $extend(React_Component.prototype,{
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
	,'delete': function(ev) {
		haxe_Log.trace(this.state.selectedRows.length,{ fileName : "src/view/data/contacts/List.hx", lineNumber : 109, className : "view.data.contacts.List", methodName : "delete"});
		var data = this.state.formApi.selectedRowsMap(this.state);
	}
	,get: function(ev) {
		var _gthis = this;
		haxe_Log.trace("hi " + Std.string(ev),{ fileName : "src/view/data/contacts/List.hx", lineNumber : 115, className : "view.data.contacts.List", methodName : "get"});
		var offset = 0;
		if(ev != null && ev.page != null) {
			offset = this.props.limit * ev.page | 0;
		}
		haxe_Log.trace(this.props.match.params,{ fileName : "src/view/data/contacts/List.hx", lineNumber : 121, className : "view.data.contacts.List", methodName : "get"});
		var p = this.props.load({ classPath : "data.Contacts", action : "get", filter : this.props.match.params.id != null ? { id : this.props.match.params.id, mandator : "1"} : { mandator : "1"}, limit : this.props.limit, offset : offset > 0 ? offset : 0, table : "contacts", resolveMessage : { success : "Kontaktliste wurde geladen", failure : "Kontaktliste konnte nicht geladen werden"}, dbUser : this.props.userState.dbUser, devIP : App.devIP});
		p.then(function(data) {
			haxe_Log.trace(data.dataRows.length,{ fileName : "src/view/data/contacts/List.hx", lineNumber : 139, className : "view.data.contacts.List", methodName : "get"});
			_gthis.setState({ loading : false, dataTable : data.dataRows, dataCount : Std.parseInt(data.dataInfo.h["count"]), pageCount : Math.ceil(Std.parseInt(data.dataInfo.h["count"]) / _gthis.props.limit)});
		});
	}
	,edit: function(ev) {
		haxe_Log.trace(this.state.selectedRows.length,{ fileName : "src/view/data/contacts/List.hx", lineNumber : 152, className : "view.data.contacts.List", methodName : "edit"});
		haxe_Log.trace(Reflect.fields(ev),{ fileName : "src/view/data/contacts/List.hx", lineNumber : 153, className : "view.data.contacts.List", methodName : "edit"});
	}
	,restore: function() {
		var _gthis = this;
		haxe_Log.trace(Reflect.fields(this.props.dataStore),{ fileName : "src/view/data/contacts/List.hx", lineNumber : 157, className : "view.data.contacts.List", methodName : "restore"});
		if(this.props.dataStore != null && this.props.dataStore.contactsDbData != null) {
			this.setState({ dataTable : this.props.dataStore.contactsDbData.dataRows, dataCount : Std.parseInt(this.props.dataStore.contactsDbData.dataInfo.h["count"]), pageCount : Math.ceil(Std.parseInt(this.props.dataStore.contactsDbData.dataInfo.h["count"]) / this.props.limit)},function() {
				haxe_Log.trace(_gthis.state.dataTable,{ fileName : "src/view/data/contacts/List.hx", lineNumber : 167, className : "view.data.contacts.List", methodName : "restore"});
				_gthis.props.history.push("" + _gthis.props.match.path.split(":section")[0] + "List/get/" + (_gthis.props.match.params.id != null ? _gthis.props.match.params.id : ""));
			});
		} else {
			this.props.history.push("" + this.props.match.path.split(":section")[0] + "List/get/" + (this.props.match.params.id != null ? this.props.match.params.id : ""));
			this.get(null);
		}
	}
	,selectionClear: function() {
		var match = react_ReactUtil.copy(this.props.match);
		match.params.action = "get";
		haxe_Log.trace(this.state.dataTable.length,{ fileName : "src/view/data/contacts/List.hx", lineNumber : 188, className : "view.data.contacts.List", methodName : "selectionClear"});
		this.props.select(0,null,match,"UnselectAll");
		var trs = window.document.querySelectorAll(".tabComponentForm tr");
		haxe_Log.trace(trs.length,{ fileName : "src/view/data/contacts/List.hx", lineNumber : 193, className : "view.data.contacts.List", methodName : "selectionClear"});
		var _g = 0;
		var _g1 = trs.length;
		while(_g < _g1) {
			var i = _g++;
			var tre = js_Boot.__cast(trs.item(i) , HTMLTableRowElement);
			if(tre.classList.contains("is-selected")) {
				haxe_Log.trace("unselect:" + tre.dataset.id,{ fileName : "src/view/data/contacts/List.hx", lineNumber : 197, className : "view.data.contacts.List", methodName : "selectionClear"});
				tre.classList.remove("is-selected");
			}
		}
		window.document.querySelector("[class=\"grid-container-inner\"]").scrollTop = 0;
	}
	,componentDidMount: function() {
		var _g = new haxe_ds_StringMap();
		var _g1 = new haxe_ds_StringMap();
		var value = new haxe_ds_StringMap();
		_g1.h["contacts"] = value;
		var value = { source : _g1, view : new haxe_ds_StringMap()};
		_g.h["get"] = value;
		this.dataAccess = _g;
		if(this.props.userState != null) {
			haxe_Log.trace("yeah: " + this.props.userState.dbUser.first_name,{ fileName : "src/view/data/contacts/List.hx", lineNumber : 216, className : "view.data.contacts.List", methodName : "componentDidMount"});
		}
		haxe_Log.trace(this.props.match.params.action,{ fileName : "src/view/data/contacts/List.hx", lineNumber : 217, className : "view.data.contacts.List", methodName : "componentDidMount"});
		this.state.formApi.doAction();
	}
	,renderResults: function() {
		haxe_Log.trace(this.props.match.params.section + (":" + this.props.match.params.action + "::") + Std.string(this.state.dataTable != null),{ fileName : "src/view/data/contacts/List.hx", lineNumber : 224, className : "view.data.contacts.List", methodName : "renderResults"});
		var pState = this.props.parentComponent.state;
		haxe_Log.trace(this.state.dataTable.length,{ fileName : "src/view/data/contacts/List.hx", lineNumber : 227, className : "view.data.contacts.List", methodName : "renderResults"});
		if(this.props.dataStore.contactsDbData != null) {
			var tmp = this.props.dataStore.contactsDbData.dataRows[0];
			haxe_Log.trace(tmp == null ? "null" : haxe_ds_StringMap.stringify(tmp.h),{ fileName : "src/view/data/contacts/List.hx", lineNumber : 229, className : "view.data.contacts.List", methodName : "renderResults"});
		} else {
			haxe_Log.trace(this.props.dataStore.contactsDbData,{ fileName : "src/view/data/contacts/List.hx", lineNumber : 230, className : "view.data.contacts.List", methodName : "renderResults"});
		}
		haxe_Log.trace(this.state.loading,{ fileName : "src/view/data/contacts/List.hx", lineNumber : 231, className : "view.data.contacts.List", methodName : "renderResults"});
		if(this.state.dataTable.length == 0) {
			return this.state.formApi.renderWait();
		}
		if(this.props.match.params.action == "get") {
			return React.createElement(react_ReactType.fromComp(view_grid_Grid),Object.assign({ },this.props,{ id : "contactList", data : this.state.dataTable, dataState : this.dataDisplay.h["contactList"], parentComponent : this, className : "is-striped is-hoverable", fullWidth : true}));
		} else {
			return null;
		}
	}
	,getCellData: function(cP) {
		haxe_Log.trace(cP,{ fileName : "src/view/data/contacts/List.hx", lineNumber : 258, className : "view.data.contacts.List", methodName : "getCellData"});
	}
	,render: function() {
		haxe_Log.trace(this.props.match.params.section,{ fileName : "src/view/data/contacts/List.hx", lineNumber : 265, className : "view.data.contacts.List", methodName : "render"});
		return this.state.formApi.render(this.renderResults());
	}
	,componentWillUnmount: function() {
		haxe_Log.trace("...",{ fileName : "src/view/data/contacts/List.hx", lineNumber : 272, className : "view.data.contacts.List", methodName : "componentWillUnmount"});
	}
	,updateMenu: function(viewClassPath) {
		var sideMenu = this.state.sideMenu;
		haxe_Log.trace(sideMenu.section,{ fileName : "src/view/data/contacts/List.hx", lineNumber : 278, className : "view.data.contacts.List", methodName : "updateMenu"});
		var _g = 0;
		var _g1 = sideMenu.menuBlocks.h["List"].items;
		while(_g < _g1.length) {
			var mI = _g1[_g];
			++_g;
			var _g2 = mI.action;
			if(_g2 != null) {
				switch(_g2) {
				case "delete":case "update":
					mI.disabled = this.state.selectedRows.length == 0;
					break;
				default:
				}
			}
		}
		return sideMenu;
	}
	,setState: null
	,__class__: view_data_contacts_List
});
var view_data_deals_Edit = function(props) {
	this.mounted = false;
	React_Component.call(this,props);
	haxe_Log.trace(props.match.params,{ fileName : "src/view/data/deals/Edit.hx", lineNumber : 95, className : "view.data.deals.Edit", methodName : "new"});
	haxe_Log.trace(Reflect.fields(props),{ fileName : "src/view/data/deals/Edit.hx", lineNumber : 97, className : "view.data.deals.Edit", methodName : "new"});
	if(props.match.params.id == null && new EReg("update(/)*$","").match(props.match.params.action)) {
		haxe_Log.trace("nothing selected - redirect",{ fileName : "src/view/data/deals/Edit.hx", lineNumber : 102, className : "view.data.deals.Edit", methodName : "new"});
		var baseUrl = props.match.path.split(":section")[0];
		props.history.push("" + baseUrl + "List/get");
		return;
	}
	this.dataAccess = model_deals_DealsModel.dataAccess;
	this.fieldNames = view_shared_io_BaseForm.initFieldNames(new haxe_ds__$StringMap_StringMapKeyIterator(this.dataAccess.h["open"].view.h));
	this.dataDisplay = model_deals_DealsModel.dataDisplay;
	if(props.dataStore.dealData != null) {
		haxe_Log.trace(props.dataStore.dealData.keys().next(),{ fileName : "src/view/data/deals/Edit.hx", lineNumber : 112, className : "view.data.deals.Edit", methodName : "new"});
	}
	this.state = App.initEState({ actualState : null, initialData : null, loading : false, mHandlers : view_data_deals_Edit.menuItems, selectedRows : [], sideMenu : view_shared_io_FormApi.initSideMenu(this,{ dataClassPath : "data.Deals", label : "Bearbeiten", section : "Edit", items : view_data_deals_Edit.menuItems},{ section : props.match.params.section == null ? "Edit" : props.match.params.section, sameWidth : true}), values : new haxe_ds_StringMap()},this);
	haxe_Log.trace(this.state.initialData,{ fileName : "src/view/data/deals/Edit.hx", lineNumber : 138, className : "view.data.deals.Edit", methodName : "new"});
	haxe_Log.trace(this.state.loading,{ fileName : "src/view/data/deals/Edit.hx", lineNumber : 142, className : "view.data.deals.Edit", methodName : "new"});
};
$hxClasses["view.data.deals.Edit"] = view_data_deals_Edit;
view_data_deals_Edit.__name__ = "view.data.deals.Edit";
view_data_deals_Edit.mapDispatchToProps = function(dispatch) {
	haxe_Log.trace("here we should be ready to load",{ fileName : "src/view/data/deals/Edit.hx", lineNumber : 146, className : "view.data.deals.Edit", methodName : "mapDispatchToProps"});
	return { load : function(param) {
		return dispatch(redux_Action.map(action_async_CRUD.read(param)));
	}};
};
view_data_deals_Edit.mapStateToProps = function(aState) {
	return { userState : aState.userState};
};
view_data_deals_Edit.__super__ = React_Component;
view_data_deals_Edit.prototype = $extend(React_Component.prototype,{
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
	,close: function() {
		this.props.history.push("" + this.props.match.path.split(":section")[0] + "List/get");
	}
	,'delete': function(ev) {
		haxe_Log.trace(this.state.selectedRows.length,{ fileName : "src/view/data/deals/Edit.hx", lineNumber : 167, className : "view.data.deals.Edit", methodName : "delete"});
		var data = this.state.formApi.selectedRowsMap(this.state);
	}
	,get: function(ev) {
		haxe_Log.trace("hi :)",{ fileName : "src/view/data/deals/Edit.hx", lineNumber : 173, className : "view.data.deals.Edit", methodName : "get"});
		var s = new hxbit_Serializer();
		this.state.formApi.requests.push(null);
	}
	,edit: function(ev) {
		haxe_Log.trace(this.state.selectedRows.length,{ fileName : "src/view/data/deals/Edit.hx", lineNumber : 186, className : "view.data.deals.Edit", methodName : "edit"});
	}
	,update: function() {
		if(this.state.actualState != null) {
			haxe_Log.trace(this.state.actualState.fieldsModified.length,{ fileName : "src/view/data/deals/Edit.hx", lineNumber : 192, className : "view.data.deals.Edit", methodName : "update"});
		}
		if(this.state.actualState == null || this.state.actualState.fieldsModified.length == 0) {
			return;
		}
		var data2save = this.state.actualState.allModified();
		var doc = window.document;
		var aState = react_ReactUtil.copy(this.state.actualState);
		var dbQ = { classPath : "data.Deals", action : "update", data : data2save, filter : { id : this.state.actualState.id, mandator : 1}, resolveMessage : { success : "Spende " + this.state.actualState.id + " wurde aktualisiert", failure : "Spende " + this.state.actualState.id + " konnte nicht aktualisiert werden"}, table : "deals", dbUser : this.props.userState.dbUser, devIP : App.devIP};
		haxe_Log.trace("" + this.props.match.params.action + ": " + Std.string(this.state.initialData.id) + " :: creation_date: " + Std.string(aState.creation_date) + " " + Std.string(this.state.initialData.creation_date),{ fileName : "src/view/data/deals/Edit.hx", lineNumber : 212, className : "view.data.deals.Edit", methodName : "update"});
		if(this.state.actualState != null) {
			haxe_Log.trace(Std.string(this.state.actualState.modified()) + (":" + Std.string(this.state.actualState.fieldsModified)),{ fileName : "src/view/data/deals/Edit.hx", lineNumber : 215, className : "view.data.deals.Edit", methodName : "update"});
		}
		haxe_Log.trace(this.state.actualState.id,{ fileName : "src/view/data/deals/Edit.hx", lineNumber : 218, className : "view.data.deals.Edit", methodName : "update"});
		if(!this.state.actualState.modified()) {
			App.store.dispatch(redux_Action.map(action_AppAction.Status(action_StatusAction.Update({ className : "", text : "Spende wurde nicht geändert"}))));
			haxe_Log.trace("nothing modified",{ fileName : "src/view/data/deals/Edit.hx", lineNumber : 227, className : "view.data.deals.Edit", methodName : "update"});
			return;
		}
		haxe_Log.trace(this.state.actualState.allModified(),{ fileName : "src/view/data/deals/Edit.hx", lineNumber : 230, className : "view.data.deals.Edit", methodName : "update"});
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
				haxe_Log.trace(k,{ fileName : "src/view/data/deals/Edit.hx", lineNumber : 242, className : "view.data.deals.Edit", methodName : "initStateFromDataTable"});
				if(this.dataDisplay.h["fieldsList"].columns.h[k].cellFormat == view_shared_Format.formatBool) {
					rS[k] = dR.h[k] == "Y";
				} else {
					rS[k] = dR.h[k];
				}
			}
			iS[dR.h["id"]] = rS;
		}
		haxe_Log.trace(iS,{ fileName : "src/view/data/deals/Edit.hx", lineNumber : 252, className : "view.data.deals.Edit", methodName : "initStateFromDataTable"});
		return iS;
	}
	,componentDidMount: function() {
		haxe_Log.trace("mounted:" + "true",{ fileName : "src/view/data/deals/Edit.hx", lineNumber : 258, className : "view.data.deals.Edit", methodName : "componentDidMount"});
		this.loadDealData(Std.parseInt(this.props.match.params.id));
	}
	,loadDealData: function(id) {
		var _gthis = this;
		haxe_Log.trace("loading:" + id,{ fileName : "src/view/data/deals/Edit.hx", lineNumber : 288, className : "view.data.deals.Edit", methodName : "loadDealData"});
		if(id == null) {
			return;
		}
		var p = this.props.load({ classPath : "data.Deals", action : "get", filter : { id : id, mandator : 1}, resolveMessage : { success : "Spende " + id + " wurde geladen", failure : "Spende " + id + " konnte nicht geladen werden"}, table : "deals", dbUser : this.props.userState.dbUser, devIP : App.devIP});
		p.then(function(data) {
			haxe_Log.trace(data.dataRows.length,{ fileName : "src/view/data/deals/Edit.hx", lineNumber : 306, className : "view.data.deals.Edit", methodName : "loadDealData"});
			if(data.dataRows.length == 1) {
				var data1 = data.dataRows[0];
				haxe_Log.trace(data1 == null ? "null" : haxe_ds_StringMap.stringify(data1.h),{ fileName : "src/view/data/deals/Edit.hx", lineNumber : 310, className : "view.data.deals.Edit", methodName : "loadDealData"});
				var deal = new model_Deal(data1);
				haxe_Log.trace(deal.id,{ fileName : "src/view/data/deals/Edit.hx", lineNumber : 313, className : "view.data.deals.Edit", methodName : "loadDealData"});
				_gthis.setState({ loading : false, actualState : deal, initialData : react_ReactUtil.copy(deal)});
				haxe_Log.trace(_gthis.state.actualState.id + ":" + _gthis.state.actualState.fieldsInitalized.join(","),{ fileName : "src/view/data/deals/Edit.hx", lineNumber : 315, className : "view.data.deals.Edit", methodName : "loadDealData"});
				haxe_Log.trace(_gthis.props.location.pathname + ":" + _gthis.state.actualState.amount,{ fileName : "src/view/data/deals/Edit.hx", lineNumber : 317, className : "view.data.deals.Edit", methodName : "loadDealData"});
				var _gthis1 = _gthis.props.history;
				var tmp = StringTools.replace(_gthis.props.location.pathname,"open","update");
				_gthis1.replace(tmp);
			}
		});
	}
	,renderResults: function() {
		haxe_Log.trace(this.props.match.params.section + ":" + Std.string(this.state.dataTable != null),{ fileName : "src/view/data/deals/Edit.hx", lineNumber : 325, className : "view.data.deals.Edit", methodName : "renderResults"});
		haxe_Log.trace(Std.string(this.state.loading) + ":" + this.props.match.params.action,{ fileName : "src/view/data/deals/Edit.hx", lineNumber : 327, className : "view.data.deals.Edit", methodName : "renderResults"});
		if(this.state.loading) {
			return this.state.formApi.renderWait();
		}
		haxe_Log.trace("###########loading:" + Std.string(this.state.loading),{ fileName : "src/view/data/deals/Edit.hx", lineNumber : 330, className : "view.data.deals.Edit", methodName : "renderResults"});
		switch(this.props.match.params.action) {
		case "delete":
			return null;
		case "insert":
			haxe_Log.trace(this.dataDisplay.h["fieldsList"],{ fileName : "src/view/data/deals/Edit.hx", lineNumber : 356, className : "view.data.deals.Edit", methodName : "renderResults"});
			haxe_Log.trace(Std.string(this.state.dataTable[29].h["id"]) + "<<<",{ fileName : "src/view/data/deals/Edit.hx", lineNumber : 357, className : "view.data.deals.Edit", methodName : "renderResults"});
			return React.createElement(react_ReactType.fromComp(view_table_Table),Object.assign({ },this.props,{ id : "fieldsList", data : this.state.dataTable, dataState : this.dataDisplay.h["fieldsList"], className : "is-striped is-hoverable", fullWidth : true}));
		case "open":case "update":
			haxe_Log.trace(this.state.actualState,{ fileName : "src/view/data/deals/Edit.hx", lineNumber : 340, className : "view.data.deals.Edit", methodName : "renderResults"});
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
				return tmp.renderForm({ mHandlers : tmp1, fields : _g, model : "deal", title : "Bearbeite Spende"},this.state.actualState);
			}
			break;
		default:
			return null;
		}
	}
	,render: function() {
		haxe_Log.trace(this.props.match.params.section,{ fileName : "src/view/data/deals/Edit.hx", lineNumber : 374, className : "view.data.deals.Edit", methodName : "render"});
		var tmp = this.state.formApi;
		var tmp1 = react_ReactType.fromComp(React_Fragment);
		var tmp2 = react_ReactType.fromString("div");
		var tmp3 = this.renderResults();
		var tmp4 = React.createElement(tmp2,{ className : "tabComponentForm"},tmp3);
		return tmp.render(React.createElement(tmp1,{ },tmp4));
	}
	,updateMenu: function(viewClassPath) {
		var sideMenu = this.state.sideMenu;
		haxe_Log.trace(sideMenu.section,{ fileName : "src/view/data/deals/Edit.hx", lineNumber : 386, className : "view.data.deals.Edit", methodName : "updateMenu"});
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
	,__class__: view_data_deals_Edit
});
var view_data_deals_List = function(props) {
	React_Component.call(this,props);
	this.dataDisplay = model_deals_DealsModel.dataGridDisplay;
	haxe_Log.trace("..." + Std.string(Reflect.fields(props)),{ fileName : "src/view/data/deals/List.hx", lineNumber : 59, className : "view.data.deals.List", methodName : "new"});
	this.state = App.initEState({ dataTable : [], loading : true, dealsData : new haxe_ds_IntMap(), selectedRows : [], sideMenu : view_shared_io_FormApi.initSideMenu(this,{ dataClassPath : "data.Deals", label : "Liste", section : "List", items : view_data_deals_List.menuItems},{ section : props.match.params.section == null ? "List" : props.match.params.section, sameWidth : true}), values : new haxe_ds_StringMap()},this);
	if(props.match.params.action == null) {
		var baseUrl = props.match.path.split(":section")[0];
		haxe_Log.trace("redirecting to " + baseUrl + "List/get",{ fileName : "src/view/data/deals/List.hx", lineNumber : 83, className : "view.data.deals.List", methodName : "new"});
		props.history.push("" + baseUrl + "List/get");
		this.get(null);
	} else {
		haxe_Log.trace(props.match.params,{ fileName : "src/view/data/deals/List.hx", lineNumber : 90, className : "view.data.deals.List", methodName : "new"});
	}
	haxe_Log.trace(this.state.loading,{ fileName : "src/view/data/deals/List.hx", lineNumber : 92, className : "view.data.deals.List", methodName : "new"});
};
$hxClasses["view.data.deals.List"] = view_data_deals_List;
view_data_deals_List.__name__ = "view.data.deals.List";
view_data_deals_List.mapDispatchToProps = function(dispatch) {
	return { load : function(param) {
		return dispatch(redux_Action.map(action_async_CRUD.read(param)));
	}};
};
view_data_deals_List.mapStateToProps = function(aState) {
	return { userState : aState.userState};
};
view_data_deals_List.__super__ = React_Component;
view_data_deals_List.prototype = $extend(React_Component.prototype,{
	dataAccess: null
	,dataDisplay: null
	,formFields: null
	,fieldNames: null
	,baseForm: null
	,dbData: null
	,dbMetaData: null
	,'delete': function(ev) {
		haxe_Log.trace(this.state.selectedRows.length,{ fileName : "src/view/data/deals/List.hx", lineNumber : 110, className : "view.data.deals.List", methodName : "delete"});
		var data = this.state.formApi.selectedRowsMap(this.state);
	}
	,get: function(ev) {
		var _gthis = this;
		haxe_Log.trace("hi " + Std.string(ev),{ fileName : "src/view/data/deals/List.hx", lineNumber : 116, className : "view.data.deals.List", methodName : "get"});
		var offset = 0;
		if(ev != null && ev.page != null) {
			offset = this.props.limit * ev.page | 0;
		}
		var p = this.props.load({ classPath : "data.Deals", action : "get", filter : this.props.match.params.id != null ? { id : this.props.match.params.id, mandator : "1"} : { mandator : "1"}, limit : this.props.limit, offset : offset > 0 ? offset : 0, table : "deals", resolveMessage : { success : "Spendenliste wurde geladen", failure : "Spendenliste konnte nicht geladen werden"}, dbUser : this.props.userState.dbUser, devIP : App.devIP});
		p.then(function(data) {
			haxe_Log.trace(data.dataRows.length,{ fileName : "src/view/data/deals/List.hx", lineNumber : 140, className : "view.data.deals.List", methodName : "get"});
			_gthis.setState({ loading : false, dataTable : data.dataRows, dataCount : Std.parseInt(data.dataInfo.h["count"]), pageCount : Math.ceil(Std.parseInt(data.dataInfo.h["count"]) / _gthis.props.limit)});
		});
	}
	,edit: function(ev) {
		haxe_Log.trace(this.state.selectedRows.length,{ fileName : "src/view/data/deals/List.hx", lineNumber : 153, className : "view.data.deals.List", methodName : "edit"});
	}
	,selectionClear: function() {
		var match = react_ReactUtil.copy(this.props.match);
		match.params.action = "get";
		haxe_Log.trace(this.state.dataTable.length,{ fileName : "src/view/data/deals/List.hx", lineNumber : 159, className : "view.data.deals.List", methodName : "selectionClear"});
		this.props.select(1,null,match,"UnselectAll");
		var trs = window.document.querySelectorAll(".tabComponentForm tr");
		haxe_Log.trace(trs.length,{ fileName : "src/view/data/deals/List.hx", lineNumber : 164, className : "view.data.deals.List", methodName : "selectionClear"});
		var _g = 0;
		var _g1 = trs.length;
		while(_g < _g1) {
			var i = _g++;
			var tre = js_Boot.__cast(trs.item(i) , HTMLTableRowElement);
			if(tre.classList.contains("is-selected")) {
				haxe_Log.trace("unselect:" + tre.dataset.id,{ fileName : "src/view/data/deals/List.hx", lineNumber : 168, className : "view.data.deals.List", methodName : "selectionClear"});
				tre.classList.remove("is-selected");
			}
		}
		window.document.querySelector("[class=\"grid-container-inner\"]").scrollTop = 0;
	}
	,componentDidMount: function() {
		var _g = new haxe_ds_StringMap();
		var _g1 = new haxe_ds_StringMap();
		var value = new haxe_ds_StringMap();
		_g1.h["deals"] = value;
		var value = { source : _g1, view : new haxe_ds_StringMap()};
		_g.h["get"] = value;
		this.dataAccess = _g;
		if(this.props.userState.dbUser != null) {
			haxe_Log.trace("yeah: " + this.props.userState.dbUser.first_name,{ fileName : "src/view/data/deals/List.hx", lineNumber : 187, className : "view.data.deals.List", methodName : "componentDidMount"});
		}
		this.state.formApi.doAction();
	}
	,renderPager: function() {
		return view_shared_io_BaseForm.renderPager(this);
	}
	,renderResults: function() {
		haxe_Log.trace(this.props.match.params.section + ":" + Std.string(this.state.dataTable != null),{ fileName : "src/view/data/deals/List.hx", lineNumber : 198, className : "view.data.deals.List", methodName : "renderResults"});
		haxe_Log.trace(this.dataDisplay.h["dealsList"],{ fileName : "src/view/data/deals/List.hx", lineNumber : 199, className : "view.data.deals.List", methodName : "renderResults"});
		haxe_Log.trace(this.state.loading,{ fileName : "src/view/data/deals/List.hx", lineNumber : 200, className : "view.data.deals.List", methodName : "renderResults"});
		if(this.state.loading || this.state.dataTable == null || this.state.dataTable.length == 0) {
			return this.state.formApi.renderWait();
		}
		haxe_Log.trace("###########loading:" + this.state.dataTable.length,{ fileName : "src/view/data/deals/List.hx", lineNumber : 203, className : "view.data.deals.List", methodName : "renderResults"});
		switch(this.props.match.params.action) {
		case "delete":
			return null;
		case "get":
			return React.createElement(react_ReactType.fromComp(view_grid_Grid),Object.assign({ },this.props,{ id : "dealsList", data : this.state.dataTable, dataState : this.dataDisplay.h["dealsList"], parentComponent : this, className : "is-striped is-hoverable", fullWidth : true}));
		default:
			return null;
		}
	}
	,render: function() {
		haxe_Log.trace(this.props.match.params.section,{ fileName : "src/view/data/deals/List.hx", lineNumber : 223, className : "view.data.deals.List", methodName : "render"});
		return this.state.formApi.render(this.renderResults());
	}
	,updateMenu: function(viewClassPath) {
		var sideMenu = this.state.sideMenu;
		haxe_Log.trace(sideMenu.section,{ fileName : "src/view/data/deals/List.hx", lineNumber : 232, className : "view.data.deals.List", methodName : "updateMenu"});
		var _g = 0;
		var _g1 = sideMenu.menuBlocks.h["List"].items;
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
	,__class__: view_data_deals_List
});
var view_shared_io_Observer = function() { };
$hxClasses["view.shared.io.Observer"] = view_shared_io_Observer;
view_shared_io_Observer.__name__ = "view.shared.io.Observer";
view_shared_io_Observer.handler = null;
view_shared_io_Observer.run = function(obj,cb) {
	view_shared_io_Observer.handler = { get : function(target,property,receiver) {
		haxe_Log.trace(property,{ fileName : "src/view/shared/io/Observer.hx", lineNumber : 13, className : "view.shared.io.Observer", methodName : "run"});
		return Reflect.getProperty(target,property);
	}, set : function(target,property,value,receiver) {
		try {
			if(property == "care_of") {
				haxe_Log.trace("" + (value == null ? "null" : Std.string(value)) + " " + Std.string(Reflect.getProperty(receiver,property)),{ fileName : "src/view/shared/io/Observer.hx", lineNumber : 20, className : "view.shared.io.Observer", methodName : "run"});
				haxe_Log.trace("" + (value == null ? "null" : Std.string(value)) + " " + Std.string(Reflect.getProperty(target,property)),{ fileName : "src/view/shared/io/Observer.hx", lineNumber : 21, className : "view.shared.io.Observer", methodName : "run"});
			}
			target[property] = value;
			return true;
		} catch( _g ) {
			haxe_NativeStackTrace.lastError = _g;
			var e = haxe_Exception.caught(_g).unwrap();
			haxe_Log.trace(e,{ fileName : "src/view/shared/io/Observer.hx", lineNumber : 31, className : "view.shared.io.Observer", methodName : "run"});
			return false;
		}
	}};
	return new Proxy(obj,view_shared_io_Observer.handler);
};
model_Account.__meta__ = { fields : { contact : { dataType : ["bigint"]}, bank_name : { dataType : ["character varying(64)"]}, bic : { dataType : ["character varying(11)"]}, account : { dataType : ["character varying(32)"]}, iban : { dataType : ["character varying(32)"]}, account_holder : { dataType : ["text"]}, sign_date : { dataType : ["date"]}, status : { dataType : ["accounts_state"]}, creation_date : { dataType : ["timestamp with time zone"]}, edited_by : { dataType : ["bigint"]}, last_updated : { dataType : ["timestamp with time zone"]}, mandator : { dataType : ["bigint"]}}};
model_Account.__rtti = "<class path=\"model.Account\" params=\"\">\n\t<extends path=\"model.ORM\"/>\n\t<contact public=\"1\" set=\"accessor\">\n\t\t<x path=\"Int\"/>\n\t\t<meta>\n\t\t\t<m n=\"dataType\"><e>\"bigint\"</e></m>\n\t\t\t<m n=\":isVar\"/>\n\t\t</meta>\n\t</contact>\n\t<set_contact set=\"method\" line=\"29\"><f a=\"contact\">\n\t<x path=\"Int\"/>\n\t<x path=\"Int\"/>\n</f></set_contact>\n\t<bank_name public=\"1\" set=\"accessor\">\n\t\t<c path=\"String\"/>\n\t\t<meta>\n\t\t\t<m n=\"dataType\"><e>\"character varying(64)\"</e></m>\n\t\t\t<m n=\":isVar\"/>\n\t\t</meta>\n\t</bank_name>\n\t<set_bank_name set=\"method\" line=\"39\"><f a=\"bank_name\">\n\t<c path=\"String\"/>\n\t<c path=\"String\"/>\n</f></set_bank_name>\n\t<bic public=\"1\" set=\"accessor\">\n\t\t<c path=\"String\"/>\n\t\t<meta>\n\t\t\t<m n=\"dataType\"><e>\"character varying(11)\"</e></m>\n\t\t\t<m n=\":isVar\"/>\n\t\t</meta>\n\t</bic>\n\t<set_bic set=\"method\" line=\"49\"><f a=\"bic\">\n\t<c path=\"String\"/>\n\t<c path=\"String\"/>\n</f></set_bic>\n\t<account public=\"1\" set=\"accessor\">\n\t\t<c path=\"String\"/>\n\t\t<meta>\n\t\t\t<m n=\"dataType\"><e>\"character varying(32)\"</e></m>\n\t\t\t<m n=\":isVar\"/>\n\t\t</meta>\n\t</account>\n\t<set_account set=\"method\" line=\"59\"><f a=\"account\">\n\t<c path=\"String\"/>\n\t<c path=\"String\"/>\n</f></set_account>\n\t<iban public=\"1\" set=\"accessor\">\n\t\t<c path=\"String\"/>\n\t\t<meta>\n\t\t\t<m n=\"dataType\"><e>\"character varying(32)\"</e></m>\n\t\t\t<m n=\":isVar\"/>\n\t\t</meta>\n\t</iban>\n\t<set_iban set=\"method\" line=\"69\"><f a=\"iban\">\n\t<c path=\"String\"/>\n\t<c path=\"String\"/>\n</f></set_iban>\n\t<account_holder public=\"1\" set=\"accessor\">\n\t\t<c path=\"String\"/>\n\t\t<meta>\n\t\t\t<m n=\"dataType\"><e>\"text\"</e></m>\n\t\t\t<m n=\":isVar\"/>\n\t\t</meta>\n\t</account_holder>\n\t<set_account_holder set=\"method\" line=\"79\"><f a=\"account_holder\">\n\t<c path=\"String\"/>\n\t<c path=\"String\"/>\n</f></set_account_holder>\n\t<sign_date public=\"1\" set=\"accessor\">\n\t\t<c path=\"String\"/>\n\t\t<meta>\n\t\t\t<m n=\"dataType\"><e>\"date\"</e></m>\n\t\t\t<m n=\":isVar\"/>\n\t\t</meta>\n\t</sign_date>\n\t<set_sign_date set=\"method\" line=\"89\"><f a=\"sign_date\">\n\t<c path=\"String\"/>\n\t<c path=\"String\"/>\n</f></set_sign_date>\n\t<status public=\"1\" set=\"accessor\">\n\t\t<c path=\"String\"/>\n\t\t<meta>\n\t\t\t<m n=\"dataType\"><e>\"accounts_state\"</e></m>\n\t\t\t<m n=\":isVar\"/>\n\t\t</meta>\n\t</status>\n\t<set_status set=\"method\" line=\"99\"><f a=\"status\">\n\t<c path=\"String\"/>\n\t<c path=\"String\"/>\n</f></set_status>\n\t<creation_date public=\"1\" set=\"accessor\">\n\t\t<c path=\"String\"/>\n\t\t<meta>\n\t\t\t<m n=\"dataType\"><e>\"timestamp with time zone\"</e></m>\n\t\t\t<m n=\":isVar\"/>\n\t\t</meta>\n\t</creation_date>\n\t<set_creation_date set=\"method\" line=\"109\"><f a=\"creation_date\">\n\t<c path=\"String\"/>\n\t<c path=\"String\"/>\n</f></set_creation_date>\n\t<edited_by public=\"1\" set=\"accessor\">\n\t\t<x path=\"Int\"/>\n\t\t<meta>\n\t\t\t<m n=\"dataType\"><e>\"bigint\"</e></m>\n\t\t\t<m n=\":isVar\"/>\n\t\t</meta>\n\t</edited_by>\n\t<set_edited_by set=\"method\" line=\"119\"><f a=\"edited_by\">\n\t<x path=\"Int\"/>\n\t<x path=\"Int\"/>\n</f></set_edited_by>\n\t<last_updated public=\"1\" set=\"accessor\">\n\t\t<c path=\"String\"/>\n\t\t<meta>\n\t\t\t<m n=\"dataType\"><e>\"timestamp with time zone\"</e></m>\n\t\t\t<m n=\":isVar\"/>\n\t\t</meta>\n\t</last_updated>\n\t<set_last_updated set=\"method\" line=\"129\"><f a=\"last_updated\">\n\t<c path=\"String\"/>\n\t<c path=\"String\"/>\n</f></set_last_updated>\n\t<mandator public=\"1\" set=\"accessor\">\n\t\t<x path=\"Int\"/>\n\t\t<meta>\n\t\t\t<m n=\"dataType\"><e>\"bigint\"</e></m>\n\t\t\t<m n=\":isVar\"/>\n\t\t</meta>\n\t</mandator>\n\t<set_mandator set=\"method\" line=\"139\"><f a=\"mandator\">\n\t<x path=\"Int\"/>\n\t<x path=\"Int\"/>\n</f></set_mandator>\n\t<new public=\"1\" set=\"method\" line=\"21\"><f a=\"data\">\n\t<t path=\"Map\">\n\t\t<c path=\"String\"/>\n\t\t<c path=\"String\"/>\n\t</t>\n\t<x path=\"Void\"/>\n</f></new>\n\t<meta>\n\t\t<m n=\":directlyUsed\"/>\n\t\t<m n=\":build\"><e>react.jsx.JsxStaticMacro.build()</e></m>\n\t\t<m n=\":rtti\"/>\n\t</meta>\n</class>";
model_Contact.__meta__ = { fields : { mandator : { dataType : ["bigint"]}, creation_date : { dataType : ["timestamp(0) without time zone"]}, status : { dataType : ["character varying(64)"]}, use_email : { dataType : ["boolean"]}, company_name : { dataType : ["character varying(64)"]}, care_of : { dataType : ["character varying(100)"]}, phone_code : { dataType : ["character varying(10)"]}, phone_number : { dataType : ["character varying(18)"]}, fax : { dataType : ["character varying(18)"]}, title : { dataType : ["character varying(64)"]}, first_name : { dataType : ["character varying(32)"]}, last_name : { dataType : ["character varying(32)"]}, address : { dataType : ["character varying(64)"]}, address_2 : { dataType : ["character varying(64)"]}, city : { dataType : ["character varying(50)"]}, postal_code : { dataType : ["character varying(10)"]}, country_code : { dataType : ["character varying(3)"]}, gender : { dataType : ["character varying(64)"]}, date_of_birth : { dataType : ["date"]}, mobile : { dataType : ["character varying(19)"]}, email : { dataType : ["character varying(64)"]}, comments : { dataType : ["character varying(4096)"]}, edited_by : { dataType : ["bigint"]}, merged : { dataType : ["bigint[]"]}, last_updated : { dataType : ["timestamp(0) without time zone"]}, owner : { dataType : ["bigint"]}}};
model_Contact.__rtti = "<class path=\"model.Contact\" params=\"\">\n\t<extends path=\"model.ORM\"/>\n\t<mandator public=\"1\" set=\"accessor\">\n\t\t<x path=\"Int\"/>\n\t\t<meta>\n\t\t\t<m n=\"dataType\"><e>\"bigint\"</e></m>\n\t\t\t<m n=\":isVar\"/>\n\t\t</meta>\n\t</mandator>\n\t<set_mandator set=\"method\" line=\"43\"><f a=\"mandator\">\n\t<x path=\"Int\"/>\n\t<x path=\"Int\"/>\n</f></set_mandator>\n\t<creation_date public=\"1\" set=\"accessor\">\n\t\t<c path=\"String\"/>\n\t\t<meta>\n\t\t\t<m n=\"dataType\"><e>\"timestamp(0) without time zone\"</e></m>\n\t\t\t<m n=\":isVar\"/>\n\t\t</meta>\n\t</creation_date>\n\t<set_creation_date set=\"method\" line=\"53\"><f a=\"creation_date\">\n\t<c path=\"String\"/>\n\t<c path=\"String\"/>\n</f></set_creation_date>\n\t<status public=\"1\" set=\"accessor\">\n\t\t<c path=\"String\"/>\n\t\t<meta>\n\t\t\t<m n=\"dataType\"><e>\"character varying(64)\"</e></m>\n\t\t\t<m n=\":isVar\"/>\n\t\t</meta>\n\t</status>\n\t<set_status set=\"method\" line=\"63\"><f a=\"status\">\n\t<c path=\"String\"/>\n\t<c path=\"String\"/>\n</f></set_status>\n\t<use_email public=\"1\" set=\"accessor\">\n\t\t<x path=\"Bool\"/>\n\t\t<meta>\n\t\t\t<m n=\"dataType\"><e>\"boolean\"</e></m>\n\t\t\t<m n=\":isVar\"/>\n\t\t</meta>\n\t</use_email>\n\t<set_use_email set=\"method\" line=\"73\"><f a=\"use_email\">\n\t<x path=\"Bool\"/>\n\t<x path=\"Bool\"/>\n</f></set_use_email>\n\t<company_name public=\"1\" set=\"accessor\">\n\t\t<c path=\"String\"/>\n\t\t<meta>\n\t\t\t<m n=\"dataType\"><e>\"character varying(64)\"</e></m>\n\t\t\t<m n=\":isVar\"/>\n\t\t</meta>\n\t</company_name>\n\t<set_company_name set=\"method\" line=\"83\"><f a=\"company_name\">\n\t<c path=\"String\"/>\n\t<c path=\"String\"/>\n</f></set_company_name>\n\t<care_of public=\"1\" set=\"accessor\">\n\t\t<c path=\"String\"/>\n\t\t<meta>\n\t\t\t<m n=\"dataType\"><e>\"character varying(100)\"</e></m>\n\t\t\t<m n=\":isVar\"/>\n\t\t</meta>\n\t</care_of>\n\t<set_care_of set=\"method\" line=\"93\"><f a=\"care_of\">\n\t<c path=\"String\"/>\n\t<c path=\"String\"/>\n</f></set_care_of>\n\t<phone_code public=\"1\" set=\"accessor\">\n\t\t<c path=\"String\"/>\n\t\t<meta>\n\t\t\t<m n=\"dataType\"><e>\"character varying(10)\"</e></m>\n\t\t\t<m n=\":isVar\"/>\n\t\t</meta>\n\t</phone_code>\n\t<set_phone_code set=\"method\" line=\"103\"><f a=\"phone_code\">\n\t<c path=\"String\"/>\n\t<c path=\"String\"/>\n</f></set_phone_code>\n\t<phone_number public=\"1\" set=\"accessor\">\n\t\t<c path=\"String\"/>\n\t\t<meta>\n\t\t\t<m n=\"dataType\"><e>\"character varying(18)\"</e></m>\n\t\t\t<m n=\":isVar\"/>\n\t\t</meta>\n\t</phone_number>\n\t<set_phone_number set=\"method\" line=\"113\"><f a=\"phone_number\">\n\t<c path=\"String\"/>\n\t<c path=\"String\"/>\n</f></set_phone_number>\n\t<fax public=\"1\" set=\"accessor\">\n\t\t<c path=\"String\"/>\n\t\t<meta>\n\t\t\t<m n=\"dataType\"><e>\"character varying(18)\"</e></m>\n\t\t\t<m n=\":isVar\"/>\n\t\t</meta>\n\t</fax>\n\t<set_fax set=\"method\" line=\"123\"><f a=\"fax\">\n\t<c path=\"String\"/>\n\t<c path=\"String\"/>\n</f></set_fax>\n\t<title public=\"1\" set=\"accessor\">\n\t\t<c path=\"String\"/>\n\t\t<meta>\n\t\t\t<m n=\"dataType\"><e>\"character varying(64)\"</e></m>\n\t\t\t<m n=\":isVar\"/>\n\t\t</meta>\n\t</title>\n\t<set_title set=\"method\" line=\"133\"><f a=\"title\">\n\t<c path=\"String\"/>\n\t<c path=\"String\"/>\n</f></set_title>\n\t<first_name public=\"1\" set=\"accessor\">\n\t\t<c path=\"String\"/>\n\t\t<meta>\n\t\t\t<m n=\"dataType\"><e>\"character varying(32)\"</e></m>\n\t\t\t<m n=\":isVar\"/>\n\t\t</meta>\n\t</first_name>\n\t<set_first_name set=\"method\" line=\"143\"><f a=\"first_name\">\n\t<c path=\"String\"/>\n\t<c path=\"String\"/>\n</f></set_first_name>\n\t<last_name public=\"1\" set=\"accessor\">\n\t\t<c path=\"String\"/>\n\t\t<meta>\n\t\t\t<m n=\"dataType\"><e>\"character varying(32)\"</e></m>\n\t\t\t<m n=\":isVar\"/>\n\t\t</meta>\n\t</last_name>\n\t<set_last_name set=\"method\" line=\"153\"><f a=\"last_name\">\n\t<c path=\"String\"/>\n\t<c path=\"String\"/>\n</f></set_last_name>\n\t<address public=\"1\" set=\"accessor\">\n\t\t<c path=\"String\"/>\n\t\t<meta>\n\t\t\t<m n=\"dataType\"><e>\"character varying(64)\"</e></m>\n\t\t\t<m n=\":isVar\"/>\n\t\t</meta>\n\t</address>\n\t<set_address set=\"method\" line=\"163\"><f a=\"address\">\n\t<c path=\"String\"/>\n\t<c path=\"String\"/>\n</f></set_address>\n\t<address_2 public=\"1\" set=\"accessor\">\n\t\t<c path=\"String\"/>\n\t\t<meta>\n\t\t\t<m n=\"dataType\"><e>\"character varying(64)\"</e></m>\n\t\t\t<m n=\":isVar\"/>\n\t\t</meta>\n\t</address_2>\n\t<set_address_2 set=\"method\" line=\"173\"><f a=\"address_2\">\n\t<c path=\"String\"/>\n\t<c path=\"String\"/>\n</f></set_address_2>\n\t<city public=\"1\" set=\"accessor\">\n\t\t<c path=\"String\"/>\n\t\t<meta>\n\t\t\t<m n=\"dataType\"><e>\"character varying(50)\"</e></m>\n\t\t\t<m n=\":isVar\"/>\n\t\t</meta>\n\t</city>\n\t<set_city set=\"method\" line=\"183\"><f a=\"city\">\n\t<c path=\"String\"/>\n\t<c path=\"String\"/>\n</f></set_city>\n\t<postal_code public=\"1\" set=\"accessor\">\n\t\t<c path=\"String\"/>\n\t\t<meta>\n\t\t\t<m n=\"dataType\"><e>\"character varying(10)\"</e></m>\n\t\t\t<m n=\":isVar\"/>\n\t\t</meta>\n\t</postal_code>\n\t<set_postal_code set=\"method\" line=\"193\"><f a=\"postal_code\">\n\t<c path=\"String\"/>\n\t<c path=\"String\"/>\n</f></set_postal_code>\n\t<country_code public=\"1\" set=\"accessor\">\n\t\t<c path=\"String\"/>\n\t\t<meta>\n\t\t\t<m n=\"dataType\"><e>\"character varying(3)\"</e></m>\n\t\t\t<m n=\":isVar\"/>\n\t\t</meta>\n\t</country_code>\n\t<set_country_code set=\"method\" line=\"203\"><f a=\"country_code\">\n\t<c path=\"String\"/>\n\t<c path=\"String\"/>\n</f></set_country_code>\n\t<gender public=\"1\" set=\"accessor\">\n\t\t<c path=\"String\"/>\n\t\t<meta>\n\t\t\t<m n=\"dataType\"><e>\"character varying(64)\"</e></m>\n\t\t\t<m n=\":isVar\"/>\n\t\t</meta>\n\t</gender>\n\t<set_gender set=\"method\" line=\"213\"><f a=\"gender\">\n\t<c path=\"String\"/>\n\t<c path=\"String\"/>\n</f></set_gender>\n\t<date_of_birth public=\"1\" set=\"accessor\">\n\t\t<c path=\"String\"/>\n\t\t<meta>\n\t\t\t<m n=\"dataType\"><e>\"date\"</e></m>\n\t\t\t<m n=\":isVar\"/>\n\t\t</meta>\n\t</date_of_birth>\n\t<set_date_of_birth set=\"method\" line=\"223\"><f a=\"date_of_birth\">\n\t<c path=\"String\"/>\n\t<c path=\"String\"/>\n</f></set_date_of_birth>\n\t<mobile public=\"1\" set=\"accessor\">\n\t\t<c path=\"String\"/>\n\t\t<meta>\n\t\t\t<m n=\"dataType\"><e>\"character varying(19)\"</e></m>\n\t\t\t<m n=\":isVar\"/>\n\t\t</meta>\n\t</mobile>\n\t<set_mobile set=\"method\" line=\"233\"><f a=\"mobile\">\n\t<c path=\"String\"/>\n\t<c path=\"String\"/>\n</f></set_mobile>\n\t<email public=\"1\" set=\"accessor\">\n\t\t<c path=\"String\"/>\n\t\t<meta>\n\t\t\t<m n=\"dataType\"><e>\"character varying(64)\"</e></m>\n\t\t\t<m n=\":isVar\"/>\n\t\t</meta>\n\t</email>\n\t<set_email set=\"method\" line=\"243\"><f a=\"email\">\n\t<c path=\"String\"/>\n\t<c path=\"String\"/>\n</f></set_email>\n\t<comments public=\"1\" set=\"accessor\">\n\t\t<c path=\"String\"/>\n\t\t<meta>\n\t\t\t<m n=\"dataType\"><e>\"character varying(4096)\"</e></m>\n\t\t\t<m n=\":isVar\"/>\n\t\t</meta>\n\t</comments>\n\t<set_comments set=\"method\" line=\"253\"><f a=\"comments\">\n\t<c path=\"String\"/>\n\t<c path=\"String\"/>\n</f></set_comments>\n\t<edited_by public=\"1\" set=\"accessor\">\n\t\t<x path=\"Int\"/>\n\t\t<meta>\n\t\t\t<m n=\"dataType\"><e>\"bigint\"</e></m>\n\t\t\t<m n=\":isVar\"/>\n\t\t</meta>\n\t</edited_by>\n\t<set_edited_by set=\"method\" line=\"263\"><f a=\"edited_by\">\n\t<x path=\"Int\"/>\n\t<x path=\"Int\"/>\n</f></set_edited_by>\n\t<merged public=\"1\" set=\"accessor\">\n\t\t<c path=\"Array\"><x path=\"Int\"/></c>\n\t\t<meta>\n\t\t\t<m n=\"dataType\"><e>\"bigint[]\"</e></m>\n\t\t\t<m n=\":isVar\"/>\n\t\t</meta>\n\t</merged>\n\t<set_merged set=\"method\" line=\"273\"><f a=\"merged\">\n\t<c path=\"Array\"><x path=\"Int\"/></c>\n\t<c path=\"Array\"><x path=\"Int\"/></c>\n</f></set_merged>\n\t<last_updated public=\"1\" set=\"accessor\">\n\t\t<c path=\"String\"/>\n\t\t<meta>\n\t\t\t<m n=\"dataType\"><e>\"timestamp(0) without time zone\"</e></m>\n\t\t\t<m n=\":isVar\"/>\n\t\t</meta>\n\t</last_updated>\n\t<set_last_updated set=\"method\" line=\"283\"><f a=\"last_updated\">\n\t<c path=\"String\"/>\n\t<c path=\"String\"/>\n</f></set_last_updated>\n\t<owner public=\"1\" set=\"accessor\">\n\t\t<x path=\"Int\"/>\n\t\t<meta>\n\t\t\t<m n=\"dataType\"><e>\"bigint\"</e></m>\n\t\t\t<m n=\":isVar\"/>\n\t\t</meta>\n\t</owner>\n\t<set_owner set=\"method\" line=\"293\"><f a=\"owner\">\n\t<x path=\"Int\"/>\n\t<x path=\"Int\"/>\n</f></set_owner>\n\t<new public=\"1\" set=\"method\" line=\"35\"><f a=\"data\">\n\t<t path=\"Map\">\n\t\t<c path=\"String\"/>\n\t\t<c path=\"String\"/>\n\t</t>\n\t<x path=\"Void\"/>\n</f></new>\n\t<meta>\n\t\t<m n=\":directlyUsed\"/>\n\t\t<m n=\":build\"><e>react.jsx.JsxStaticMacro.build()</e></m>\n\t\t<m n=\":rtti\"/>\n\t</meta>\n</class>";
model_accounting_AccountsModel.dataAccess = (function($this) {
	var $r;
	var _g = new haxe_ds_StringMap();
	{
		var _g1 = new haxe_ds_StringMap();
		var _g2 = new haxe_ds_StringMap();
		_g2.h["filter"] = "id";
		_g1.h["accounts"] = _g2;
		var _g2 = new haxe_ds_StringMap();
		_g2.h["account_holder"] = { label : "Kontoinhaber", type : "Input"};
		_g2.h["creation_date"] = { label : "Erstellt", type : "Hidden", displayFormat : "d.m.Y", disabled : true};
		_g2.h["sign_date"] = { label : "Erteilt", type : "DatePicker", displayFormat : "d.m.Y"};
		_g2.h["bank_name"] = { label : "Bank", type : "Input"};
		_g2.h["iban"] = { label : "IBAN", type : "Input"};
		var _g3 = new haxe_ds_StringMap();
		_g3.h["active"] = "Aktiv";
		_g3.h["passive"] = "Passiv";
		_g3.h["new"] = "Neu";
		_g2.h["status"] = { label : "Status", type : "Select", options : _g3};
		_g2.h["id"] = { type : "Hidden"};
		_g2.h["edited_by"] = { type : "Hidden"};
		_g2.h["mandator"] = { type : "Hidden"};
		_g.h["open"] = { source : _g1, view : _g2};
	}
	$r = _g;
	return $r;
}(this));
model_accounting_AccountsModel.gridColumns = (function($this) {
	var $r;
	var _g = new haxe_ds_StringMap();
	_g.h["id"] = { label : "ID", show : false, useAsIndex : true};
	_g.h["account_holder"] = { flexGrow : 1, label : "Inhaber", cellFormat : function(v) {
		var n = v.split(",");
		n.reverse();
		return n.join(" ");
	}};
	_g.h["sign_date"] = { label : "Erteilt", cellFormat : function(v) {
		if(v != null) {
			return DateTools.format(HxOverrides.strDate(v),"%d.%m.%Y");
		} else {
			return "";
		}
	}};
	_g.h["contact"] = { label : "Kontakt", show : false, useAsIndex : false};
	_g.h["iban"] = { label : "IBAN"};
	_g.h["status"] = { label : "Status", className : "tCenter", cellFormat : function(v) {
		var className = v == "active" ? "active fas fa-heart" : "passive far fa-heart";
		return React.createElement(react_ReactType.fromString("span"),{ className : className});
	}};
	$r = _g;
	return $r;
}(this));
model_accounting_AccountsModel.listColumns = (function($this) {
	var $r;
	var _g = new haxe_ds_StringMap();
	_g.h["id"] = { label : "ID", show : false, useAsIndex : true};
	_g.h["contact"] = { label : "Kontakt", show : false, useAsIndex : false};
	_g.h["bank_name"] = { label : "Bankname"};
	_g.h["iban"] = { label : "IBAN"};
	_g.h["status"] = { label : "Aktiv", className : "tCenter", cellFormat : function(v) {
		var className = v == "active" ? "active fas fa-heart" : "passive far fa-heart";
		return React.createElement(react_ReactType.fromString("span"),{ className : className});
	}};
	$r = _g;
	return $r;
}(this));
model_accounting_AccountsModel.dataDisplay = (function($this) {
	var $r;
	var _g = new haxe_ds_StringMap();
	_g.h["accountsList"] = { columns : model_accounting_AccountsModel.listColumns};
	$r = _g;
	return $r;
}(this));
model_accounting_AccountsModel.dataGridDisplay = (function($this) {
	var $r;
	var _g = new haxe_ds_StringMap();
	_g.h["accountsList"] = { columns : model_accounting_AccountsModel.gridColumns};
	$r = _g;
	return $r;
}(this));
model_contacts_ContactsModel.dataAccess = (function($this) {
	var $r;
	var _g = new haxe_ds_StringMap();
	{
		var _g1 = new haxe_ds_StringMap();
		var _g2 = new haxe_ds_StringMap();
		_g2.h["filter"] = "id";
		_g1.h["contacts"] = _g2;
		var _g2 = new haxe_ds_StringMap();
		var _g3 = new haxe_ds_StringMap();
		_g3.h[""] = "?";
		_g3.h["Herr"] = "Herr";
		_g3.h["Frau"] = "Frau";
		_g3.h["Familie"] = "Familie";
		_g3.h["Firma"] = "Firma";
		_g2.h["title"] = { label : "Anrede", type : "Select", options : _g3};
		_g2.h["title_pro"] = { label : "Titel"};
		_g2.h["first_name"] = { label : "Vorname"};
		_g2.h["last_name"] = { label : "Name"};
		_g2.h["email"] = { label : "Email"};
		_g2.h["phone_code"] = { label : "Landesvorwahl"};
		_g2.h["phone_number"] = { label : "Telefon"};
		_g2.h["mobile"] = { label : "Mobil"};
		_g2.h["fax"] = { label : "Fax"};
		_g2.h["company_name"] = { label : "Firmenname"};
		_g2.h["address"] = { label : "Straße"};
		_g2.h["address_2"] = { label : "Hausnummer"};
		_g2.h["postal_code"] = { label : "PLZ"};
		_g2.h["city"] = { label : "Ort"};
		var _g3 = new haxe_ds_StringMap();
		_g3.h["active"] = "Aktiv";
		_g3.h["passive"] = "Passiv";
		_g3.h["blocked"] = "Gesperrt";
		_g2.h["state"] = { label : "Status", type : "Select", options : _g3};
		_g2.h["country_code"] = { label : "Land"};
		_g2.h["care_of"] = { label : "Adresszusatz"};
		_g2.h["creation_date"] = { label : "Hinzugefügt", type : "DateTimePicker", disabled : true, displayFormat : "d.m.Y H:i:S"};
		_g2.h["date_of_birth"] = { label : "Geburtsdatum", type : "DatePicker", displayFormat : "d.m.Y"};
		var _g3 = new haxe_ds_StringMap();
		_g3.h[""] = "?";
		_g3.h["M"] = "Männlich";
		_g3.h["F"] = "Weiblich";
		_g2.h["gender"] = { label : "Geschlecht", type : "Select", options : _g3};
		_g2.h["comments"] = { label : "Kommentar"};
		_g2.h["use_email"] = { label : "Post per Email", type : "Checkbox"};
		_g2.h["id"] = { type : "Hidden"};
		_g2.h["edited_by"] = { type : "Hidden"};
		_g2.h["mandator"] = { type : "Hidden"};
		_g2.h["merged"] = { type : "Hidden"};
		_g.h["open"] = { source : _g1, view : _g2};
	}
	$r = _g;
	return $r;
}(this));
model_contacts_ContactsModel.gridColumns = (function($this) {
	var $r;
	var _g = new haxe_ds_StringMap();
	_g.h["first_name"] = { label : "Vorname", flexGrow : 0};
	_g.h["last_name"] = { label : "Name", flexGrow : 0};
	_g.h["phone_number"] = { label : "Telefon"};
	_g.h["address"] = { label : "Straße"};
	_g.h["address_2"] = { label : "Hausnummer"};
	_g.h["care_of"] = { label : "Adresszusatz", flexGrow : 1};
	_g.h["postal_code"] = { label : "PLZ"};
	_g.h["city"] = { label : "Ort"};
	_g.h["state"] = { label : "Status", className : "tCenter", cellFormat : function(v) {
		var uState = v == "active" ? "user" : "user-slash";
		return React.createElement(react_ReactType.fromString("span"),{ className : "fa fa-" + uState});
	}};
	_g.h["id"] = { show : false};
	$r = _g;
	return $r;
}(this));
model_contacts_ContactsModel.listColumns = (function($this) {
	var $r;
	var _g = new haxe_ds_StringMap();
	_g.h["first_name"] = { label : "Vorname", flexGrow : 0};
	_g.h["last_name"] = { label : "Name", flexGrow : 0};
	_g.h["phone_number"] = { label : "Telefon"};
	_g.h["address"] = { label : "Straße"};
	_g.h["address_2"] = { label : "Hausnummer"};
	_g.h["care_of"] = { label : "Adresszusatz", flexGrow : 1};
	_g.h["postal_code"] = { label : "PLZ"};
	_g.h["city"] = { label : "Ort"};
	_g.h["state"] = { label : "Status", className : "tCenter", cellFormat : function(v) {
		var uState = v == "active" ? "user" : "user-slash";
		return React.createElement(react_ReactType.fromString("span"),{ className : "fa fa-" + uState});
	}};
	_g.h["id"] = { show : false};
	$r = _g;
	return $r;
}(this));
model_contacts_ContactsModel.dataDisplay = (function($this) {
	var $r;
	var _g = new haxe_ds_StringMap();
	_g.h["contactList"] = { columns : model_contacts_ContactsModel.listColumns};
	$r = _g;
	return $r;
}(this));
model_contacts_ContactsModel.dataGridDisplay = (function($this) {
	var $r;
	var _g = new haxe_ds_StringMap();
	_g.h["contactList"] = { columns : model_contacts_ContactsModel.gridColumns};
	$r = _g;
	return $r;
}(this));
view_Data.displayName = "Data";
view_Data.__fileName__ = "src/view/Data.hx";
view_Data._renderWrapper = (redux_react_ReactRedux.connect(null,view_Data.mapDispatchToProps))(react_ReactTypeOf.fromComp(view_Data));
view_Data.__jsxStatic = view_Data._renderWrapper;
view_data_Accounts.displayName = "Accounts";
view_data_Accounts.__fileName__ = "src/view/data/Accounts.hx";
view_data_Accounts._renderWrapper = (redux_react_ReactRedux.connect(null,view_data_Accounts.mapDispatchToProps))(react_ReactTypeOf.fromComp(view_data_Accounts));
view_data_Accounts.__jsxStatic = view_data_Accounts._renderWrapper;
view_data_Contacts.displayName = "Contacts";
view_data_Contacts.__fileName__ = "src/view/data/Contacts.hx";
view_data_Contacts._renderWrapper = (redux_react_ReactRedux.connect(view_data_Contacts.mapStateToProps,view_data_Contacts.mapDispatchToProps))(react_ReactTypeOf.fromComp(view_data_Contacts));
view_data_Contacts.__jsxStatic = view_data_Contacts._renderWrapper;
view_data_Deals.displayName = "Deals";
view_data_Deals.__fileName__ = "src/view/data/Deals.hx";
view_data_Deals._renderWrapper = (redux_react_ReactRedux.connect(view_data_Deals.mapStateToProps,view_data_Deals.mapDispatchToProps))(react_ReactTypeOf.fromComp(view_data_Deals));
view_data_Deals.__jsxStatic = view_data_Deals._renderWrapper;
view_data_QC.displayName = "QC";
view_data_QC.__fileName__ = "src/view/data/QC.hx";
view_data_QC._renderWrapper = (redux_react_ReactRedux.connect(view_data_QC.mapStateToProps,view_data_QC.mapDispatchToProps))(react_ReactTypeOf.fromComp(view_data_QC));
view_data_QC.__jsxStatic = view_data_QC._renderWrapper;
view_data_accounts_Edit.menuItems = [{ label : "Auswahl", action : "get", section : "List"},{ label : "Bearbeiten", action : "update"},{ label : "Neu", action : "insert"},{ label : "Löschen", action : "delete"}];
view_data_accounts_Edit.displayName = "Edit";
view_data_accounts_Edit.__fileName__ = "src/view/data/accounts/Edit.hx";
view_data_accounts_List.menuItems = [{ label : "Anzeigen", action : "get"},{ label : "Bearbeiten", action : "edit"},{ label : "Neu", action : "insert"},{ label : "Löschen", action : "delete"}];
view_data_accounts_List.displayName = "List";
view_data_accounts_List.__fileName__ = "src/view/data/accounts/List.hx";
view_data_accounts_List._renderWrapper = (redux_react_ReactRedux.connect(view_data_accounts_List.mapStateToProps,view_data_accounts_List.mapDispatchToProps))(react_ReactTypeOf.fromComp(view_data_accounts_List));
view_data_accounts_List.__jsxStatic = view_data_accounts_List._renderWrapper;
view_data_contacts_Accounts.classPath = view_data_contacts_Accounts.__name__;
view_data_contacts_Accounts.displayName = "Accounts";
view_data_contacts_Accounts.__fileName__ = "src/view/data/contacts/Accounts.hx";
view_data_contacts_Accounts._renderWrapper = (redux_react_ReactRedux.connect(view_data_contacts_Accounts.mapStateToProps,view_data_contacts_Accounts.mapDispatchToProps))(react_ReactTypeOf.fromComp(view_data_contacts_Accounts));
view_data_contacts_Accounts.__jsxStatic = view_data_contacts_Accounts._renderWrapper;
view_data_contacts_Deals.classPath = view_data_contacts_Deals.__name__;
view_data_contacts_Deals.displayName = "Deals";
view_data_contacts_Deals.__fileName__ = "src/view/data/contacts/Deals.hx";
view_data_contacts_Deals._renderWrapper = (redux_react_ReactRedux.connect(view_data_contacts_Deals.mapStateToProps,view_data_contacts_Deals.mapDispatchToProps))(react_ReactTypeOf.fromComp(view_data_contacts_Deals));
view_data_contacts_Deals.__jsxStatic = view_data_contacts_Deals._renderWrapper;
view_data_contacts_Edit.menuItems = [{ label : "Schließen", action : "close"},{ label : "Speichern", action : "update"},{ label : "Zurücksetzen", action : "reset"},{ separator : true},{ label : "Spenden Bearbeiten", action : "showSelectedDeals", disabled : true, section : "Edit", classPath : "view.data.contacts.Deals"},{ label : "Konten Bearbeiten", action : "listAccounts", disabled : true, section : "Edit", classPath : "view.data.contacts.Accounts"},{ label : "Verlauf", action : "listHistory", section : "Edit", classPath : "view.data.contacts.History"}];
view_data_contacts_Edit.classPath = view_data_contacts_Edit.__name__;
view_data_contacts_Edit.displayName = "Edit";
view_data_contacts_Edit.__fileName__ = "src/view/data/contacts/Edit.hx";
view_data_contacts_Edit._renderWrapper = (redux_react_ReactRedux.connect(view_data_contacts_Edit.mapStateToProps,view_data_contacts_Edit.mapDispatchToProps))(react_ReactTypeOf.fromComp(view_data_contacts_Edit));
view_data_contacts_Edit.__jsxStatic = view_data_contacts_Edit._renderWrapper;
view_data_contacts_List.menuItems = [{ label : "Bearbeiten", action : "update", section : "Edit"},{ label : "Neu", action : "insert", section : "Edit"},{ label : "Löschen", action : "delete"},{ label : "Auswahl aufheben", action : "selectionClear"}];
view_data_contacts_List.displayName = "List";
view_data_contacts_List.__fileName__ = "src/view/data/contacts/List.hx";
view_data_contacts_List._renderWrapper = (redux_react_ReactRedux.connect(view_data_contacts_List.mapStateToProps,view_data_contacts_List.mapDispatchToProps))(react_ReactTypeOf.fromComp(view_data_contacts_List));
view_data_contacts_List.__jsxStatic = view_data_contacts_List._renderWrapper;
view_data_deals_Edit.menuItems = [{ label : "Schließen", action : "close"},{ label : "Speichern", action : "update"},{ label : "Zurücksetzen", action : "reset", onlySm : false}];
view_data_deals_Edit.displayName = "Edit";
view_data_deals_Edit.__fileName__ = "src/view/data/deals/Edit.hx";
view_data_deals_Edit._renderWrapper = (redux_react_ReactRedux.connect(view_data_deals_Edit.mapStateToProps,view_data_deals_Edit.mapDispatchToProps))(react_ReactTypeOf.fromComp(view_data_deals_Edit));
view_data_deals_Edit.__jsxStatic = view_data_deals_Edit._renderWrapper;
view_data_deals_List.menuItems = [{ label : "Bearbeiten", action : "open", section : "Edit"},{ label : "Löschen", action : "delete"},{ label : "Auswahl aufheben", action : "selectionClear"}];
view_data_deals_List.displayName = "List";
view_data_deals_List.__fileName__ = "src/view/data/deals/List.hx";
view_data_deals_List._renderWrapper = (redux_react_ReactRedux.connect(view_data_deals_List.mapStateToProps,view_data_deals_List.mapDispatchToProps))(react_ReactTypeOf.fromComp(view_data_deals_List));
view_data_deals_List.__jsxStatic = view_data_deals_List._renderWrapper;
if ($global.__REACT_HOT_LOADER__)
  [view_Data,view_data_Accounts,view_data_Contacts,view_data_Deals,view_data_QC,view_data_accounts_Edit,view_data_accounts_List,view_data_contacts_Accounts,view_data_contacts_Deals,view_data_contacts_Edit,view_data_contacts_List,view_data_deals_Edit,view_data_deals_List].map(function(c) {
    __REACT_HOT_LOADER__.register(c,c.displayName,c.__fileName__);
  });
$s.view_Data = view_Data; 
})(typeof exports != "undefined" ? exports : typeof window != "undefined" ? window : typeof self != "undefined" ? self : this, typeof window != "undefined" ? window : typeof global != "undefined" ? global : typeof self != "undefined" ? self : this);
