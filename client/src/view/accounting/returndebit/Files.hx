package view.accounting.returndebit;

import haxe.Exception;
import model.ORM;
import js.html.Element;
import js.html.FormElement;
import hxbit.Serializer;
import js.lib.Error;
import js.html.Event;
import action.DataAction;
import action.DataAction.SelectType;
import action.async.LiveDataAccess;
import shared.Utils;
import model.accounting.ReturnDebitModel;
import haxe.Json;
import js.html.Blob;
import js.Syntax;
import js.html.FormData;
import view.shared.FormInputElement;
import js.Browser;
import js.html.FileReader;
import haxe.Unserializer;
import js.html.XMLHttpRequest;
import shared.DbDataTools;
import action.AppAction;
import redux.Redux.Dispatch;
import redux.thunk.Thunk;
import action.async.CRUD;
import js.lib.Promise;
import db.DBAccessProps;
import action.async.LivePBXSync;
import state.AppState;
import haxe.ds.StringMap;
import haxe.ds.IntMap;
import loader.BinaryLoader;
import me.cunity.debug.Out;
import model.Contact;
import react.ReactComponent;
import react.ReactEvent;
import react.ReactMacro.jsx;
import react.ReactRef;
import react.ReactUtil;
import shared.DbData;
import state.FormState;
import view.accounting.returndebit.AccountForm;
import view.accounting.returndebit.ContactForm;
import view.accounting.returndebit.DealForm;
import view.shared.FormBuilder;
import view.shared.MItem;
import view.shared.MenuProps;
import view.grid.Grid;
import view.shared.io.BaseForm;
import view.shared.io.DataAccess;
import view.shared.io.DataFormProps;
import view.shared.io.FormApi;

using Lambda;
/**
 * ...
 * @author axel@cunity.me
 */
@:connect
class Files extends ReactComponentOf<DataFormProps,FormState>
{

	static var _instance:Files;//

	public static var menuItems:Array<MItem> = [		
		{label:'Auswahl',action:'importReturnDebit',
			formField:{				
				name:'returnDebitFile',
				submit:'Hochladen',
				type:FormInputElement.Upload,
				handleChange: function(evt:Event) {
					//trace(Reflect.fields(evt));
					var finput = cast Browser.document.getElementById('returnDebitFile');
					trace(finput.value);
					//trace(_instance);
					var val = (finput.value == ''?'':finput.value.split('\\').pop());
					Files._instance.setState({action:'ReturnDebitsFileSelected',data:['hint'=>'Zum Upload ausgewählt:${val}']});
				}
			},
			handler: function(_) {				
				var finput = cast Browser.document.getElementById('returnDebitFile');
				//var files = php.Lib.hashOfAssociativeArray(finput.files);
				
				trace(finput.files);
				trace(Reflect.fields(finput));
				js.Syntax.code("console.log({0}[{1}])",finput.files,"returnDebitFile");
				trace(finput.value);
				//trace(finput.files.get('returnDebitFile'));
			}/**/
		}
	];	

	var dataAccess:DataAccess;	
	var dataDisplay:Map<String,DataState>;
	var formApi:FormApi;
	var formBuilder:FormBuilder;
	var formFields:DataView;
	var dealsFormRef:ReactRef<FormElement>;
	var formRef:ReactRef<FormElement>;
	var fieldNames:Array<String>;
	var ormRefs:Map<String,ORMComps>;
	var accountsFormRef:ReactRef<FormElement>;	
	var baseForm:BaseForm;
	var contact:Contact;
	var dbData: shared.DbData;
	var dbMetaData:shared.DBMetaData;	

	public function new(props) 
	{
		super(props);
		_instance = this;
		dataDisplay = ReturnDebitModel.dataGridDisplay;
		//dataAccess = ReturnDebitModel.dataAccess(props.match.params.action);
		//formFields = ReturnDebitModel.formFields(props.match.params.action);
		//trace('...' + Reflect.fields(props));
		//baseForm =new BaseForm(this);
		
		menuItems[0].handler = importReturnDebit;
		menuItems[0].formField.id = App._app.state.userState.dbUser.id;
		menuItems[0].formField.jwt = App._app.state.userState.dbUser.jwt;
		trace(menuItems[0].formField);
		state =  App.initEState({
			data:['hint'=>'Rücklastschriften zum Hochladen auswählen'],
			action:(props.match.params.action==null?'importReturnDebit':props.match.params.action),
			sideMenu:FormApi.initSideMenu2( this,			
			[
				{
					dataClassPath:'admin.Debit',
					label:"Liste",
					section: 'List',
					items: List.menuItems
				},
				{
					dataClassPath:'admin.Debit',
					label:"Dateien",
					section: 'Files',
					items: Files.menuItems
				},

			],
			{	
				section: props.match.params.section==null? 'Files':props.match.params.section, 
				sameWidth: true					
			})
		},this);

		trace(props.match.path);
		if(props.match.params.action==null)
		{
			//var sData = App.store.getState().dataStore.contactData;	props.match.params.section==null||		
			var baseUrl:String = props.match.path.split(':section')[0];
			trace('redirecting to ${baseUrl}Files/importReturnDebitFile');
			props.history.push('${baseUrl}Files/importReturnDebitFile');
			//get(null);
		}
	}

	static function mapStateToProps(aState:AppState) 
	{
		return {
			userState:aState.userState
		};
	}

	static function mapDispatchToProps(dispatch:Dispatch) {
        return {
			storeData:function(id:String, action:DataAction)
			{
				dispatch(LiveDataAccess.storeData(id, action));
			},
			select:function(id:Int = -1,data:StringMap<Map<String,Dynamic>>,me:Files, ?selectType:SelectType)
			{
				if(true) trace('select:$id selectType:${selectType}');
				trace(data);
				dispatch(LiveDataAccess.sSelect({id:id,data:data,match:me.props.match,selectType: selectType}));
			}						
        }
	}	

	override public function componentDidMount():Void 
	{	
		dataAccess = ReturnDebitModel.dataAccess;
		trace(props.match.params.action);
		state.formApi.doAction('importReturnDebitFile');
	}
	
	public function delete(ev:ReactEvent):Void
	{
		trace(state.selectedRows.length);
		var data = state.formApi.selectedRowsMap(state);
		trace(data);
	}

	public function importReturnDebitFile() {
		state.action = 'importReturnDebitFile';
	}

	public function importReturnDebit(_):Void
	{
		var iPromise:Promise<Dynamic> = new Promise(function(resolve, reject){
			var finput = cast  Browser.document.getElementById('returnDebitFile');
			trace(props.userState.dbUser.first_name + '::' + finput.files[0]);
			//var reader:FileReader = new FileReader();
			var uFile:Blob = cast(finput.files[0], Blob);
			trace(uFile);
			if(uFile==null){
				reject({error:new Error('Keine Datei ausgewählt')});
			}
			var fd:FormData = new FormData();			
			fd.append('devIP',App.devIP);
			fd.append('id',Std.string(App._app.state.userState.dbUser.id));
			fd.append('jwt',Std.string(App._app.state.userState.dbUser.jwt));
			fd.append('mandator',Std.string(App.mandator));

			fd.append('action','returnDebitFile');
			fd.append('returnDebitFile',uFile,finput.value);
			var xhr = new js.html.XMLHttpRequest();
			xhr.open('POST', '${App.config.api}', true);
			xhr.onerror = function(e) {
				trace(e);
				trace(e.type);
				reject({error:e});
			}
			xhr.withCredentials = true;
			xhr.onload = function(e) {
				trace(xhr.status);
				if (xhr.status != 200) {				
					trace(xhr.statusText);
					reject({error:xhr.statusText});
				}
				trace(xhr.response.length);
				resolve(xhr.response);
				//onLoaded(haxe.io.Bytes.ofData(xhr.response));
			}
			xhr.send(fd);
			setState({action:'importReturnDebit',loading:true});
		});
		
		iPromise.then(function (r:Dynamic) {
			trace(r);
			var rD:{rlData:Array<Dynamic>} = Json.parse(r);
			var dT:Array<Map<String, Dynamic>> = new Array();			
			trace(rD);
			for(dR in rD.rlData)
				dT.push(Utils.dynToMap(dR));
			setState({action:'showImportedReturnDebit',dataTable:dT,loading:false});
			trace(dT);
			state.loading = false;
			var baseUrl:String = props.match.path.split(':section')[0];			
			//props.history.push('${baseUrl}List');
			App.store.dispatch(Status(Update( 
				{	
					text:dT.count() + ' Rücklastschriften Importiert'
				}
			)));
			
		}, function (r:Dynamic) {
			trace(r);
			App.store.dispatch(Status(Update( 
				{	className:'',
					text:(r.error==null?'':r.error)
				}
			)));
		});
		
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

	function registerOrmRef(ref:Dynamic) {
		trace(Type.typeof(ref));
		switch(Type.typeof(ref)){
			case TNull:
				//do nothing
			case TObject:
				trace(Reflect.fields(ref));					
				trace(Type.getClass(ref));					
				trace(ref.props);
				trace(ref.state);
				trace(ref.state.model);
				if(ref.props !=null && ref.props.model!= null){						
					//ormRefs[ref.props.model] = ref;
					//ormRefs[ref.props.model] = ref.props.formRef.current;
				}
			case TClass(func)://matches component classes, i.e. ReactComponentOf<DataFormProps,FormState>
				//trace(func);
				var cL:Dynamic = Type.getClass(ref);
				if(cL!=null){
					trace(Type.getClassName(cL));
					try{
						trace(Reflect.fields(ref.props));
						trace(Reflect.fields(ref.state));
						trace(ref.state.model);
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

	function relData():ReactFragment {
		return jsx('
		<>
			<$ContactForm formRef=${dealsFormRef} parentComponent=${this} model="contacts" action="get" key="contact"  filter=${{id:props.match.params.id, mandator:'1'}}></$ContactForm>
			<$DealForm formRef=${dealsFormRef} parentComponent=${this} model="deals" action="get" key="deal"  filter=${{contact:props.match.params.id, mandator:'1'}}></$DealForm>
			<$AccountForm formRef=${accountsFormRef} parentComponent=${this} model="accounts" key="account" action="get" filter=${{contact:props.match.params.id, mandator:'1'}}></$AccountForm>
		</>
		');
		/*return [
			for(model in ['deals','accounts']){
				if(ormRefs.exists(model))
				for(orm in ormRefs[model].orms.array()) {
					${orm.formBuilder.renderForm({
						//mHandlers:state.mHandlers,
						fields:
							if(model=='deals')
								[for(k in dealDataAccess['open'].view.keys())
									k => dealDataAccess['open'].view[k]]
							else 
								[for(k in accountDataAccess['open'].view.keys())
									k => accountDataAccess['open'].view[k]]							
						,
						model:model,
						ref:null,					
						title: (model=='deals'?'Spenden':'Konten')
					},orm)}
				}
				
			}
		];*/
	}

	override function render():ReactFragment
	{
		//if(state.dataTable != null)	trace(state.dataTable[0]);
		//<></>
		trace(props.match.params.section);		
		return state.formApi.render(jsx('
		
			<form className="tabComponentForm"  >
				${renderResults()}
			</form>
		'));		
	}
	
	function renderResults():ReactFragment
	{
		trace(state.action + ':' + Std.string(state.dataTable != null));
		trace(dataDisplay["rDebitList"]);
		if(state.loading)
			return state.formApi.renderWait();
		trace('${state.action} ###########loading:' + state.loading);
		return switch(state.action)
		{
			case 'showImportedReturnDebit':
				(state.dataTable == null? state.formApi.renderWait():
				jsx('<Grid id="importedReturnDebit" data=${state.dataTable}
				${...props} dataState = ${dataDisplay["rDebitList"]} 
				parentComponent=${this} className="is-striped is-hoverable" fullWidth=${true}/>			
				'));	

			/*case 'importClientList':
				//trace(initialState);
				trace(state.actualState);
				/*var fields:Map<String,FormField> = [
					for(k in dataAccess['update'].view.keys()) k => dataAccess['update'].view[k]
				];
				(state.actualState==null ? state.formApi.renderWait():
				state.formBuilder.renderForm({
					mHandlers:state.mHandlers,
					fields:formFields,/*[
						for(k in dataAccess['update'].view.keys()) k => dataAccess['update'].view[k]
					],
					model:'importClientList',
					//ref:formRef,
					title: 'Stammdaten Import' 
				},state.actualState));	
			/*case 'showFieldList2':
				trace(dataDisplay["fieldsList"]);
				trace(state.dataTable[29]['id']+'<<<');
				jsx('
					<Table id="fieldsList" data=${state.dataTable}
					${...props} dataState = ${dataDisplay["fieldsList"]} 
					className="is-striped is-hoverable" fullWidth=${true}/>				
				');	*/

			default:
				if(state.data != null && state.data.exists('hint')){
					jsx('<div className="hint"><h3>${state.data.get('hint')}</h3></div>');
				}
				else{
					null;
				}				
		}
		return null;
	}	
}