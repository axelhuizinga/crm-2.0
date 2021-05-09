package view.accounting.returndebit;

import js.lib.Reflect;
import model.accounting.AccountsModel;
import model.contacts.ContactsModel;
import model.deals.DealsModel;
import view.shared.io.LiveData;
import action.AppAction;
import action.DataAction;
import action.DataAction.SelectType;
import action.async.LiveDataAccess;
import haxe.Exception;
import model.ORM;
import js.html.Element;
import js.html.FormElement;
import hxbit.Serializer;
import js.lib.Error;
import js.html.Event;
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
import react.Fragment;
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
		{
			id:'returnDebitFile',
			label:'Auswahl',action:'importReturnDebit', disabled: true,
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
					trace(Files._instance.state.sideMenu.instance.enableItem('returnDebitFile'));
					Files._instance.setState({
						action:'ReturnDebitsFileSelected',data:['hint'=>'Zum Upload ausgewählt:${val}']
					});
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
		},
		{id:'close',label:'Schließen',action:'close', disabled:true},		
		//{label:'Speichern + Schließen',action:'update', then:'close'},
		{id:'update',label:'Speichern',action:'update', disabled:true},
		{id:'reset',label:'Zurücksetzen',action:'reset', disabled:true},
	];	

	var dataAccess:DataAccess;	
	var dataDisplay:Map<String,DataState>;
	var formDataAccess:Map<String,DataAccess>;
	var formDataDisplay:Map<String,Map<String,DataState>>;
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
		ormRefs = new Map();
		dataAccess = ReturnDebitModel.dataAccess;
		dataDisplay = ReturnDebitModel.dataGridDisplay;
		formDataAccess = new Map();
		for(model in ['deals','contacts','accounts']){
			formDataAccess[model] = switch(model){
				case 'deals':
					DealsModel.dataAccess;
				case 'contacts':
					ContactsModel.dataAccess;
				case 'accounts':
					AccountsModel.dataAccess;
				default:
					null;
			}
		}
		
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

		if(props.match.params.id!=null){
			var baseUrl:String = props.match.path.split(':section')[0];
			trace('redirecting to ${baseUrl}Files/${props.match.params.action}');
			props.history.push('${baseUrl}Files/${props.match.params.action}');
		}
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
		if(_instance!=null)
		trace(Reflect.fields(_instance.props).join('|'));
		
		return {
			//userState:aState.userState
			//dummy:aState.dataStore.returnDebitsData.toString()
		};
	}

	static function mapDispatchToProps(dispatch:Dispatch) {
        return {
			storeData:function(id:String, action:DataAction)
			{
				dispatch(LiveDataAccess.storeData(id, action));
			},
			select:function(id:Int = -1,data:IntMap<Map<String,Dynamic>>,me:Files, ?selectType:SelectType)
			{
				if(true) trace('select:$id selectType:${selectType}');
				if(id>-1 && BaseForm.ormsModified(me)){
					BaseForm.warn('Änderungen speichern oder zurücksetzen');
					return;
				}
				//trace(data);
				//_instance.state.selectedData = dispatch(LiveDataAccess.sSelect({id:id,data:data,match:me.props.match,selectType: selectType}));
				var sData:IntMap<Map<String,Dynamic>> = LiveData.select({id:id,data:data,match:me.props.match,selectType: selectType});

				if(sData.keys().hasNext()){
					trace(me.state.sideMenu.instance.enableItem('close'));
					//me.state.selectedData = d;
					//trace(Files._instance.state.selectedData);
					if(sData.keys().next()==id){
						trace('yes:$id');
						me.ormRefs = new Map();
						//Object requires fields: userState, match, location, histo
						LiveData.create({
							history: me.props.history,
							id:id,
							location: me.props.location,
							match:me.props.match,
							model:'deals',
							parentComponent: me,
							userState: App.store.getState().userState
						},me);
					}
				}
				trace(App.store.getState().dataStore.returnDebitsData.toString());
			}						
        }
	}	

	public function close() {
		trace(Reflect.fields(state).join('|'));
		trace(Reflect.fields(App.store.getState().dataStore).join('|'));
		return;
		if(state.selectedData.keys().hasNext()){
			trace(666);
			var p:Promise<Dynamic> = App.store.dispatch(LiveDataAccess.sSelect({id:-1,data:new IntMap(),match:props.match,selectType: SelectType.UnselectAll}));
			if(p!=null)
			p.then(function(d:Dynamic) {
				trace(d);
			});
			//trace(state.selectedData.keys().hasNext());
		}
		
	}
	/**
	 * var p:Promise<Dynamic> = App.store.dispatch(CRUD.update(dbQ));
					p.then(function(d:Dynamic){
						trace(d);
						get();
					});
	 */
	override public function componentDidMount():Void 
	{	
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
		trace(state.action);
	}

	/**
	 * Upload selected ReturnDebits File
	 * @param _ 
	 */
	public function importReturnDebit(_):Void
	{
		var iPromise:Promise<Dynamic> = new Promise(function(resolve, reject){
			var finput = cast  Browser.document.getElementById('returnDebitFile');
			trace(state.action + '::' + finput.files[0]);
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
			trace(Files._instance.state.sideMenu.instance.enableItem('returnDebitFile',false));
			xhr.send(fd);
			setState({action:'importReturnDebit',loading:true});
		});
		
		iPromise.then(function (r:Dynamic) {
			//trace(r);
			var rD:{rlData:Array<Dynamic>} = Json.parse(r);
			if(rD.rlData != null)
				trace(rD.rlData.length);
			//trace(rD);
			var dT:Array<Map<String, Dynamic>> = new Array();			
			for(dR in rD.rlData)
				dT.push(Utils.dynToMap(dR));
			setState({action:'showImportedReturnDebit',dataTable:dT,loading:false});
			trace(dT.length);
			//state.loading = false;
			var baseUrl:String = props.match.path.split(':section')[0];			
			//props.history.push('${baseUrl}List');
			App.store.dispatch(Status(Update( 
				{	
					text:dT.count() + ' Rücklastschriften Importiert'
				}
			)));
			
		}, function (r:Dynamic) {//rejected callback
			trace(r);
			App.store.dispatch(Status(Update( 
				{	className:'',
					text:(r.error==null?'':r.error)
				}
			)));
		});
		
	}

	public function registerORM(refModel:String,orm:ORM) {
		if(ormRefs.exists(refModel)){
			ormRefs.get(refModel).orms.set(orm.id,orm);
			trace(refModel);
			//setState({ormRefs:ormRefs});
			//setState({loading:false, actualState:deal, initialData: copy(deal)});
			//setState(copy(state,{ormRefs:ormRefs}));
			//state.ormRefs = ormRefs;
			//trace(Reflect.fields(state));
			//setState({ormRefs:ormRefs});
		}
		else{
			ormRefs.set(refModel, {
				orms:[orm.id=>orm], compRef:this});
			trace('OrmRef $refModel created!');
		}
		setState({ormRefs:ormRefs});
	}

	function showSelectedAccounts(?ev:Event) {
		//trace('---' + Type.typeof(ormRefs['accounts'].compRef));
		//trace('---' + ormRefs['accounts'].compRef.state.dataGrid.state.selectedRows);
		var sRows:IntMap<Bool> = ormRefs['accounts'].compRef.state.dataGrid.state.selectedRows;
		for(k in sRows.keys()){
			ormRefs['accounts'].compRef.props.loadData(k,ormRefs['accounts'].compRef);
		}
	}

	function showSelectedDeal(id:Int) {
		//trace(state.sideMenu);

	}

	function relForm(model:String):ReactFragment {
		return (ormRefs.exists(model)? untyped ormRefs[model].compRef.renderForm(): null);
	}

	function relData(?dGrid:ReactFragment):ReactFragment {
//<></>
		var FormView:FormView = null;/*LiveData.create({
			classPath:'data.Deals',
			action:'get',
			filter:{id:id,mandator:1},
			resolveMessage:{
				success:'Spende ${id} wurde geladen',
				failure:'Spende ${id} konnte nicht geladen werden'
			},
			table:'deals',
			dbUser:param.userState.dbUser,
			devIP:App.devIP
		}, this);*/
		var FormsView:ReactFragment = [
			for(model in ['deals','contacts','accounts']){
				if(ormRefs.exists(model))
				for(orm in ormRefs[model].orms.array()) {
					orm.formBuilder.renderForm({
						//mHandlers:state.mHandlers,
						fields:
							[for(k in formDataAccess[model]['open'].view.keys())
								k => formDataAccess[model]['open'].view[k]]						
						,
						model:model,
						ref:null,					
						title: switch (model){
							case 'accounts':
								'Konto';
							case 'contacts':
								'Kontakt';
							case 'deals':
								'Spende';	
							default:
								model;														
						}
					},orm);
				}				
			}
		];
		return jsx('<Fragment key="relData">
			$dGrid
			${FormsView}
			</Fragment>');

		/*return jsx('<Fragment key="relData">
		$dGrid
		${(props.match.params.id!=null?<$DealForm formRef=${dealsFormRef} parentComponent=${this} id=${props.match.params.id} key="importedReturnDebitDeal"  model="deals" filter=${{mandator:'1'}}></$DealForm>:null)}
		${for(model in ['contacts','deals','accounts'])relForm(model)}
		</Fragment>');*/
	}

	override function render():ReactFragment
	{
		//trace(props.match.params.section + '/' + props.match.params.action);		
		//trace(state.action + ':' + Std.string(state.dataTable != null));
		//trace('${state.action} ###########loading:' + state.loading);
		if(state.loading)
			return state.formApi.renderWait();
		return state.formApi.render(switch(state.action)
		{
			case 'showImportedReturnDebit':
				//(state.dataTable == null? state.formApi.renderWait():
				relData(jsx('<Grid id="importedReturnDebit" data=${state.dataTable}
				${...props} dataState=${dataDisplay["rDebitList"]} key="importedReturnDebitList" 
				parentComponent=${this} className="is-striped is-hoverable" />			
				'));			

			default:
				if(state.data != null && state.data.exists('hint')){
					jsx('<div className="hint" key="loadReturnDebitsFile" ><h3>${state.data.get('hint')}</h3></div>');
				}
				else{
					null;
				}				
		});
		return null;
	}	
}