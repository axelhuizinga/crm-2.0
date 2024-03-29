package view.data.qc;

import js.html.NodeList;
import action.async.LivePBXSync;
import js.html.ButtonElement;
import data.DataState;
import model.deals.DealsModel;
import model.accounting.AccountsModel;
import model.ORM;
import haxe.Exception;
import react.ReactNode.ReactNodeOf;
import view.data.contacts.Accounts;
import view.data.contacts.Deals;
import haxe.ds.StringMap;
import haxe.Timer;
import react.ReactDOM;
import react.ReactUtil;
import db.DbRelation;
import db.DbQuery;
import db.DBAccessProps;
import action.async.CRUD;
import haxe.CallStack;
import me.cunity.debug.Out;
import haxe.rtti.Rtti;
import js.html.DOMStringMap;
import haxe.Json;
import js.lib.Promise;
import haxe.ds.IntMap;
import action.AppAction;
import action.DataAction;
import action.async.DBAccess;
import bulma_components.Button;
import js.html.HTMLOptionsCollection;
import js.html.HTMLPropertiesCollection;
import me.cunity.debug.Out.DebugOutput;
import js.html.Document;
import js.Browser;
import js.html.Window;
import js.html.HTMLFormControlsCollection;
import js.html.FormElement;
import js.html.HTMLCollection;
import js.html.SelectElement;
import haxe.macro.Type.Ref;
import js.html.InputElement;
import react.React;
import js.html.Element;
import js.html.Event;
import js.html.FormElement;
import react.router.RouterMatch;
import state.AppState;
import haxe.Constraints.Function;
import react.ReactComponent;
import react.ReactEvent;
import react.ReactRef;
import react.ReactMacro.jsx;
import react.ReactUtil.copy;
import redux.Redux.Dispatch;
import shared.DbData;
import shared.DBMetaData;
import view.shared.FormBuilder;
import view.shared.FormField;
import state.FormState;
import model.qc.QCModel;
import view.shared.MItem;
import view.shared.MenuProps;
import view.shared.io.BaseForm;
import view.shared.io.FormApi;
import view.shared.io.DataFormProps;
import view.shared.io.DataAccess;
import loader.BinaryLoader;
import view.table.Table;
import model.Contact;

using  shared.Utils;
using Lambda;
using StringTools;

/**
 * 
 */
@:connect
class Edit extends ReactComponentOf<DataFormProps,FormState>
{
	public static var menuItems:Array<MItem> = [
		{label:'Schließen',action:'close'},		
		//{label:'Speichern + Schließen',action:'update', then:'close'},
		{label:'Speichern',action:'qc_save'},		
		{label:'Zurücksetzen',action:'loadQC'},
		//{label:'Einmalspende',action:'uncheckPeriod'},
		{label:'QC OK',action:'qc_ok'},
		
		{label:'QC NEGATIV',action:'qc_bad'},
		{separator: true},		
		//{label: 'ID',formField: { name: 'id'}},
		//{label:'Spenden Bearbeiten',action:'showSelectedDeals', disabled:true, section: 'Edit', classPath:'view.data.contacts.Deals'},	
		//{label:'Konten Bearbeiten',action:'listAccounts', disabled:true, section: 'Edit', classPath:'view.data.contacts.Accounts'},
		//{label:'Verlauf',action:'listHistory', section: 'Edit', classPath:'view.data.contacts.History'}
	];	
	public static var classPath = Type.getClassName(Edit);
	static var _c:Int;

	var dataAccess:DataAccess;	
	var dataDisplay:Map<String,DataState>;
	var dealsAreOpen:Bool;
	var formApi:FormApi;
	var formBuilder:FormBuilder;
	var formFields:DataDisplay;
	var dealsFormRef:ReactRef<FormElement>;
	var formRef:ReactRef<FormElement>;
	var fieldNames:Array<String>;
	var ormRefs:Map<String,ORMComps>;
	var accountsFormRef:ReactRef<FormElement>;
	var historyFormRef:ReactRef<FormElement>;
	var baseForm:BaseForm;
	var contact:Contact;
	var dbData: shared.DbData;
	var dbMetaData:shared.DBMetaData;
	var modals:Map<String,Bool>;	
	var mounted:Bool = false;
	var _trace:Bool = false;
	var dealDataAccess:DataAccess;
	var dealFieldNames:Array<String>;
	var qcData:Map<String,Dynamic>;
	var accountDataAccess:DataAccess;
	var accountFieldNames:Array<String>;
	var accountDataDisplay:Map<String,DataState>;

	public function new(props) 
	{
		super(props);
		ormRefs = new Map();
		_trace = true;
		accountsFormRef = React.createRef();
		dealsFormRef = React.createRef();
		formRef = React.createRef();
		historyFormRef = React.createRef();
		trace(props.match.params);
		//trace('props:' + Reflect.fields(props).join('|'));

		if(props.match.params.id == null){
			if(props.dataStore.qcActData != null && props.dataStore.qcActData.keys().hasNext())
				props.match.params.id = untyped Std.string(props.dataStore.qcActData.keys().next());
		}
			//dataRows[0].lead_id);dataRows[0].	
		if(Reflect.fields(props).has('dataStore') && props.dataStore.qcData != null){
			qcData = props.dataStore.qcData.get(Std.parseInt(props.match.params.id));
			if(qcData != null)
				trace(qcData['lead_id']);			
			//trace(Reflect.fields(qcData).join('|'));
		}	
		//REDIRECT WITHOUT ID OR edit action
		if(props.match.params.id==null && ~/update(\/)*$/.match(props.match.params.action) )
		{
			trace('nothing selected - redirect');
			var baseUrl:String = props.match.path.split(':section')[0];
			props.history.push('${baseUrl}List/get');
			return;
		}		
		dataAccess = QCModel.dataAccess;
		trace(App.pbxUserData.keys().next());
		fieldNames = BaseForm.initFieldNames(dataAccess['open'].view.keys());
		trace(fieldNames.join('|'));
		dataDisplay = QCModel.dataDisplay;
		//DEALS
		dealDataAccess = DealsModel.dataAccess;
		dealFieldNames = BaseForm.initFieldNames(dealDataAccess['open'].view.keys());
		//dealDataDisplay = DealsModel.dataDisplay;
		//ACCOUNTS
		accountDataAccess = AccountsModel.dataAccess;
		accountFieldNames = BaseForm.initFieldNames(accountDataAccess['open'].view.keys());
		accountDataDisplay = AccountsModel.dataDisplay;
		//trace(dataAccess['open']);
		if(props.dataStore.contactsData != null)
			trace(props.dataStore.contactsData.keys().next());
		for(mI in menuItems)
			if(~/qc_*/.match(mI.action))
				mI.handler = doQC;

		state =  App.initEState({
			//dbTable:[],
			actualState:null,
			initialData:null,
			mHandlers:[for(v in menuItems) js.lib.Object.assign({},v)],
			loading:false,
			model:'contacts',
			ormRefs:new Map<String,ReactComponentOf<DataFormProps,FormState>>(),
			relDataComps:new Map<String,ReactComponentOf<DataFormProps,FormState>>(),
			selectedRows:[],
			sideMenu:FormApi.initSideMenu( this,
				{
					dataClassPath:'data.Deals',
					label:'Bearbeiten',
					section: 'Edit',
					items: [for(v in menuItems) js.lib.Object.assign({},v)]
				}					
				,{	
					section: props.match.params.section==null? 'Edit':props.match.params.section, 
					sameWidth: true
				}),	
			/*storeListener:App.store.subscribe(function(){
				trace(App.store.getState().dataStore);
			}),*/
			values:new Map<String,ReactComponentOf<DataFormProps,FormState>>()
		},this);
		if(_c == null){
			_c = 1;
		}
		else{
			_c++;
		}
		trace(_c);		
		//loadQC();
		trace(state.initialData);
		//trace(state.initialData.id);
		//loadQC(Std.parseInt(props.match.params.id));
	}

	public function close() {
		// TODO: CHECK IF MODIFIED + ASK FOR SAVING / DISCARDING
		//var baseUrl:String = props.match.path.split(':section')[0];
		props.history.push('${props.match.path.split(':section')[0]}List/get');
	}

	function showSelectedAccounts(?ev:Event) {
		//trace('---' + Type.typeof(ormRefs['accounts'].compRef));
		trace('---' + ormRefs['accounts'].compRef.state.dataGrid.state.selectedRows);
		var sRows:IntMap<Bool> = ormRefs['accounts'].compRef.state.dataGrid.state.selectedRows;
		for(k in sRows.keys()){
			ormRefs['accounts'].compRef.props.loadData(k,ormRefs['accounts'].compRef);
		}
	}

	function showSelectedDeals(?ev:Event) {
		//trace(state.sideMenu);
		//Browser.document.querySelector('#deals').scrollIntoView();
		//trace(Reflect.fields(dealsRef.current));
		//dealsRef.scrollIntoView();
		//trace(ormRefs);
		trace('---' + Type.typeof(state.relDataComps));
		//trace('---' + ormRefs['deals'].compRef.state.dataGrid.state.selectedRows);
		trace('---' + state.relDataComps.keys().hasNext());
		//trace('---' + props.children);
		var sRows:IntMap<Bool> = ormRefs['deals'].compRef.state.dataGrid.state.selectedRows;
		for(k in sRows.keys()){
			ormRefs['deals'].compRef.props.loadData(k,ormRefs['deals'].compRef);
		}
		//dealsFormRef.current.scrollIntoView();
		trace(dealsFormRef.current);
		trace(dealsFormRef.current.querySelectorAll('.selected').length);
		if(ev != null){
			var targetEl:Element = cast(ev.target, Element);
			trace(Std.string(targetEl.dataset.id));
		}
	}

	function loadQC():Void
	{		
		if(qcData == null)
			return;
		trace('loading:${qcData["lead_id"]}');
		var p:Promise<DbData> = props.load(
			{
				classPath:'data.Deals',
				action:'loadQC',
				filter:{lead_id:qcData["lead_id"],entry_list_id:qcData["entry_list_id"],mandator:1},
				resolveMessage:{
					success:'QC ${qcData["lead_id"]} wurde geladen',
					failure:'QC ${qcData["lead_id"]} konnte nicht geladen werden'
				},				
				table:'contacts',
				//table:'vicidial_list',viciBoxDB
				viciBoxDB:true,
				dbUser:props.userState.dbUser,
				devIP:App.devIP
			}
		);
		p.then(function(data:DbData){
			trace(data.dataRows.length); 
			if(data.dataRows.length==1)
			{
				var qcd = data.dataRows[0];
				//trace(data);	//*
				qcd['id'] = qcd['lead_id'];
				trace(qcd);
				if( data.dataInfo.exists('recordings')){
					trace(data.dataInfo.get('recordings'));
					//RESET MENU ITEMS
					state.mHandlers = [for(v in menuItems) js.lib.Object.assign({},v)];
					BaseForm.addRecordings(state,data.dataInfo.get('recordings'));
				}
				var qc:model.QC = new model.QC(qcd);
				//trace(qcd);
				trace(qc.period);
				if(mounted)
					setState({loading:false, actualState:qc, initialData:copy(qc)});
				//state = copy({loading:false, actualState:qc, initialData:qc});
				trace('$mounted ${qc.id} ${qc.lead_id} ${qc.entry_list_id}');
				if(state.actualState != null){
					trace(untyped state.actualState.id + ':' + state.actualState.fieldsInitalized.join(','));
				//setState({initialData:copy(state.actualState)});
					trace(props.location.pathname + ':' + untyped state.actualState.date_of_birth);
				}
				props.history.replace(props.location.pathname.replace('open','update'));
				
			}
		},function(data:DbData){trace(data);});
	}

	function addRecordings1(recs:Array<Map<String,String>>){
		//trace(rec);
		var recItems:Array<MItem> = [];
		for(rec in recs) recItems.push(
		{
			//id:'returnDebitFile',
			label: rec['start_time'],
			formField:{				
				//name:'returnDebitData',				
				//submit:'Importieren',
				src: (rec['location'].contains('85.25.93.167')?
					StringTools.replace(rec['location'],'85.25.93.167','pbx.pitverwaltung.de'):
					rec['location']),
				type:Audio
			}
		});
		state.mHandlers = menuItems.concat(recItems);
		trace(state.mHandlers.toString());
		//{separator: true},		
		//{label: 'ID',formField: { name: 'id'}},
	}
	
	public function delete(ev:ReactEvent):Void
	{
		trace(state.selectedRows.length);
		var data = state.formApi.selectedRowsMap(state);
	}

	override function componentDidCatch(error, info) {
		// Display fallback UI
		//if(state.mounted)
		try{
			this.setState({ hasError: true });
		}
		catch(ex:Dynamic)
		{if(_trace) trace(ex);}
		
		if(_trace) trace(error);
		//Out.dumpStack(CallStack.callStack());
	}		
		
	override public function componentDidMount():Void 
	{	
		trace('$_c mounted:' + mounted);
		mounted = true;
		//trace(props.children);&& _c == 1

		if(props.match.params.id != null ){
			trace(props.match.params);
			loadQC();	
		}
		//trace(props.children);
	}
	
	override function shouldComponentUpdate(nextProps:DataFormProps, nextState:FormState) {
		trace('$_c propsChanged:${nextProps!=props} stateChanged:${nextState!=state} returning:' +(nextProps!=props || nextState!=state?'Y':'N') );			
		/*if(nextState!=state)
			trace(nextState.actualState!=null?untyped nextState.actualState.owner:'???');
			//trace(Utils.diff(state,nextState).toString());
			
		if(nextProps!=props)
			trace(Utils.diff(props,nextProps).toString());		
		if(_c>1)
			return false;
		else 
			return nextState!=state;
		//return nextProps!=props;*/
		return nextState!=state || nextProps!=props;
	}

	override public function componentWillUnmount() {
		//state.storeListener();
		return;
		var actData:IntMap<Map<String,Dynamic>> = [state.initialData.id => [
		for(f in Reflect.fields(state.actualState))
			f => Reflect.field(state.actualState,f)		
		]];
		trace(actData);
		App.store.dispatch(DataAction.SelectActContacts(actData));
	}

	public function registerRelDataComp(rDC:ReactComponentOf<DataFormProps,FormState>) {
		
	}

	function registerOrmRef(ref:Dynamic) {
		//trace(Type.typeof(ref));
		switch(Type.typeof(ref)){
			case TNull:
				//do nothing
			case TObject:
				trace(Reflect.fields(ref));					
				trace(Type.getClass(ref));					
				//trace(ref.props);
				//trace(ref.state);
				//trace(ref.state.model);
				if(ref.props !=null && ref.props.model!= null){						
					//ormRefs[ref.props.model] = ref;
					//ormRefs[ref.props.model] = ref.props.formRef.current;
				}
			case TClass(func)://matches component classes, i.e. ReactComponentOf<DataFormProps,FormState>
				//trace(func);
				var cL:Dynamic = Type.getClass(ref);
				if(cL!=null){
					//trace(Type.getClassName(cL));
					try{
						//trace(Reflect.fields(ref.props));
						//trace(Reflect.fields(ref.state));
						//trace(ref.state.model);
						if(ref.props !=null && ref.props.model!= null){						
							ormRefs[ref.props.model] = {
								compRef:ref,
								orms:new IntMap()
							}
						}
					}
					catch(ex:Exception){
						trace(ex);
					}
				}
				default:
				trace(ref);
		}
	};

	public function registerORM(refModel:String,orm:ORM) {
		if(ormRefs.exists(refModel)){
			ormRefs.get(refModel).orms.set(orm.id,orm);
			trace(refModel);
			setState({ormRefs:ormRefs});
			//setState(copy(state,{ormRefs:ormRefs}));
			//state.ormRefs = ormRefs;
			trace(Reflect.fields(state));
			//setState({ormRefs:ormRefs});
		}
		else{
			trace('OrmRef $refModel not found!');
		}
	}

	/*public function uncheckPeriod() {
		var ops:NodeList = Browser.document.querySelectorAll('input[name="period"]');
		for(op in ops){
			cast(op, InputElement).checked = false;
			trace(op);
		}
	}*/
	
	public function update(){
		trace('ok');
	}

	public function doQC(e:Event)
	{
		trace(Reflect.fields(e));
		e.preventDefault();
		var action:String = cast(e.target, ButtonElement).getAttribute('data-action');		
		trace(action);
		
		//if(state.actualState == null || state.actualState.fieldsModified.length==0)
			//return;
		var data2save = state.actualState.allModified();
		/*var doc:Document = Browser.window.document;
		var formElement:FormElement = cast(doc.querySelector('form[name="qc"]'),FormElement);
		var elements:HTMLCollection = formElement.elements;*/
		trace(data2save);
		var aState:Dynamic = copy(state.actualState);
		var dbQ:DBAccessProps = {
			classPath:'data.Deals',
			action: action,
			data:data2save,
			filter:{id:state.actualState.id,mandator:1, entry_list_id: state.initialData.entry_list_id},
			resolveMessage:{
				success:'QC lead ${state.actualState.id} wurde aktualisiert',
				failure:'QC lead ${state.actualState.id} konnte nicht aktualisiert werden'
			},
			viciBoxDB:true,
			dbUser:props.userState.dbUser,
			devIP:App.devIP
		}

		trace('${state.initialData.id} :: creation_date: ${aState.creation_date} ${state.initialData.creation_date}');
		//var initiallyLoaded = App.store.getState().dataStore.contactsData.get(state.initialData.id);
		//trace();
		if(state.actualState != null)
		trace(state.actualState.modified() + ':${state.actualState.fieldsModified}');

		//trace(state.actualState.lead_id);

		var p:Promise<Dynamic> = LivePBXSync.query(dbQ);
		//App.store.dispatch(CRUD.update(dbQ));	
		p.then(function(d:DbData){
			if(d.dataInfo != null && d.dataInfo.exists('count'))
			{
				trace(d.dataInfo['count']);
				App.store.dispatch(Status(Update(
					{
						className:'Edit',
						text:'QC lead gespeichert'
					}
				)));
				if(action == 'qc_ok'||action == 'qc_bad')
					close();
			}
		}, function(d:Dynamic) {
			trace(d);
		});
	}

	function renderResults():ReactFragment
	{
		//trace(props.match.params.section + '/' + props.match.params.action + ' state.dbTable:' + Std.string(state.actualState != null));
		//trace('###########loading:' + state.loading);
		trace('########### action:' + props.match.params.action);

		return switch(props.match.params.action)
		{
			case 'open'|'update':
				
				//trace(state.actualState.id);
				/*var fields:Map<String,FormField> = [
					for(k in dataAccess['open'].view.keys()) k => dataAccess['open'].view[k]
				];
				${state.formBuilder.renderForm({
					mHandlers:state.mHandlers,
					fields:[
						for(k in dataAccess['open'].view.keys()) k => dataAccess['open'].view[k]
					],
					model:'qc',
					ref:null,					
					title: 'Quality Control' 
				},state.actualState)}
				*/
				(state.actualState==null ? state.formApi.renderWait():
				jsx('<>
				${state.formBuilder.renderForm({
					mHandlers:state.mHandlers,
					fields:[
						for(k in dataAccess['open'].view.keys()) k => dataAccess['open'].view[k]
					],
					model:'qc',
					ref:null,					
					title: 'Daten QC' 
				},state.actualState)}					
				</>
				'));
				//null;${relDataLists()}${relData()}<div className="center"><h3>:)</h3></div>	
			case 'insert':
				//trace(state.actualState);
				state.formBuilder.renderForm({
					mHandlers:state.mHandlers,
					fields:[
						for(k in dataAccess['open'].view.keys()) k => dataAccess['open'].view[k]
					],
					model:'qc',
					ref:null,
					title: 'QC - Neue Daten' 
				},state.actualState);
			default:
				null;
		}
	}
	
	override function render():ReactFragment
	{
		trace(props.match.params.action);		
		if(state==null || state.initialData==null){
			//trace('state: $state');
			trace('stateOrInitialData is null');
			
			return null;
		}
		if(state.hasError){
			return jsx('<div>state.hasError</div>');
		}
		//trace(state.initialData);
		//trace('state.loading: ${state.loading}');	
		
		return switch(props.match.params.action)
		{	
			case 'open':
			 //(state.loading || state.initialData.edited_by==0 ? state.formApi.renderWait():
				state.formApi.render(jsx('
					${renderResults()}
				'));	
			case 'insert':
				state.formApi.render(jsx('
					${renderResults()}
				'));		
			default:
				state.formApi.render(jsx('
					${renderResults()}		
				'));			
		}
	}

	/*public function select(id:Int, 
		?data:StringMap<StringMap<Dynamic>>, 
		?match:RouterMatch) {
		trace(id);
	}*/

	static function mapDispatchToProps(dispatch:Dispatch) {
		trace('here we should be ready to load');
        return {
            load: function(param:DBAccessProps) return dispatch(CRUD.read(param))
        };
	}
		
	static function mapStateToProps(aState:AppState) 
	{
		//trace(aState.dataStore.contactsData);
		trace(Reflect.fields(aState));
		if(aState.dataStore.qcData != null)
		trace(Std.string(aState.dataStore.qcData.keys().next()));
		if(aState.dataStore.contactsDbData != null)
		trace(aState.dataStore.contactsDbData.dataRows[0]);
		else 
		{
			//trace(aState.dataStore);
			trace(Reflect.fields(aState.dataStore));
		}
		trace(App.store.getState().dataStore.contactsDbData);
		var bState =  {
			dataStore:aState.dataStore,
			userState:aState.userState,
			//idLoaded:aState.dataStore.contactsData.keys().next()
		};
		//trace(bState);
		trace(bState.dataStore.contactsData);
		return bState;
	}
	/*static function mapStateToProps(aState:AppState) 
	{
		return {
			userState:aState.userState
		};
	}*/
		
}