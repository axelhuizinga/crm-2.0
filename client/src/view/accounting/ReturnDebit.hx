package view.accounting;
import js.Browser;
import js.html.Window;
import js.html.Document;
import view.shared.FormInputElement;
import view.shared.FormField;
import haxe.Constraints.Function;
import shared.DbParam;
import shared.Utils;
import action.AppAction;
import db.DbQuery.DbQueryParam;
import redux.Redux.Dispatch;
import action.async.CRUD;
import js.lib.Promise;
import action.async.DBAccessProps;
import action.async.LivePBXSync;
import state.AppState;
import haxe.ds.Map;
import loader.BinaryLoader;
import me.cunity.debug.Out;
import model.Contact;
import react.ReactComponent;
import react.ReactEvent;
import react.ReactMacro.jsx;
import react.ReactUtil;
import shared.DbData;
import state.FormState;
import view.shared.FormBuilder;
import view.shared.MItem;
import view.shared.MenuProps;
import view.accounting.model.ReturnDebitModel;
import view.table.Table.DataState;
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
class ReturnDebit extends ReactComponentOf<DataFormProps,FormState>
{

	static var _instance:ReturnDebit;

	public static var menuItems:Array<MItem> = [		
		{label:'Import Rücklastschriften',action:'importReturnDebit',formField:{
			name:'returnDebitFile',
			type:FormInputElement.Upload},
			handler: function(el) {
				trace(Browser.document.getElementById('returnDebitFile'));
			}
		},
		{label:'Speichern', action:'save'},
		{label:'Löschen',action:'delete'}
	];
	var dataAccess:DataAccess;	
	var dataDisplay:Map<String,DataState>;
	var formApi:FormApi;
	var formBuilder:FormBuilder;
	var formFields:DataView;
	//var formRef:ReactRef<FormElement>;
	var fieldNames:Array<String>;
	var baseForm:BaseForm;
	var contact:Contact;
	var dbData: shared.DbData;
	var dbMetaData:shared.DBMetaData;	

	public function new(props) 
	{
		super(props);
		dataDisplay = ReturnDebitModel.dataDisplay;
		dataAccess = ReturnDebitModel.dataAccess(props.match.params.action);
		formFields = ReturnDebitModel.formFields(props.match.params.action);
		trace('...' + Reflect.fields(props));
		state =  App.initEState({
			loading:false,
			dataTable:[],
			formBuilder:new FormBuilder(this),
			actualState:{
				edited_by: props.userState.dbUser.id,
				mandator: props.userState.dbUser.mandator
			},
			initialState:{
				edited_by: props.userState.dbUser.id,
				mandator: props.userState.dbUser.mandator
			},values:new Map<String,Dynamic>()},this);
		trace(state.loading);

	}

	static function mapStateToProps(aState:AppState) 
	{
		return {
			userState:aState.userState
		};
	}

	static function mapDispatchToProps(dispatch:Dispatch) {
        return {
			load: function(param:DbQueryParam) return dispatch(CRUD.update(param))			
        }
	}	
	//,doSyncAll: function(dbQueryParam:DbQueryParam) return dispatch(CRUD.update(dbQueryParam))	
		
	public function createFieldList(ev:ReactEvent):Void
	{
		trace('hi :)');
		return;
		/*props.formApi.requests.push(Loader.load(	
			'${App.config.api}', 
			{
				id:props.userState.id,
				jwt:props.userState.jwt,
				classPath:'tools.DB',
				action:'createFieldList',
				update:'1'
			},
			function(data:Map<String,String>)
			{
				trace(data);
				if (data.exists('error'))
				{
					trace(data['error']);
					return;
				}				 
				setState({data:data});
		}));*/
		trace(props.history);
		trace(props.match);
		//setState({viewClassPath:viewClassPath});
	}
	
	public function editTableFields(ev:ReactEvent):Void
	{
		trace(state.selectedRows.length);				
	}

	function initStateFromDataTable(dt:Array<Map<String,String>>):Dynamic
	{
		var iS:Dynamic = {};
		for(dR in dt)
		{
			var rS:Dynamic = {};
			for(k in dR.keys())
			{
				trace(k);
				if(dataDisplay['fieldsList'].columns[k].cellFormat == ReturnDebitModel.formatBool)
				{
					Reflect.setField(rS,k, dR[k] == 'Y');
				}
				else
					Reflect.setField(rS,k, dR[k]);
			}
			Reflect.setField(iS, dR['id'], rS);			
		}
		trace(iS);
		return iS;
	}
	
	public function saveTableFields(vA:Dynamic):Void
	{
		trace(vA);
		//Out.dumpObject(vA);
		/*dbMetaData = new  DBMetaData();
		dbMetaData.dataFields = dbMetaData.stateToDataParams(vA);
		trace(dbMetaData.dataFields.get(111));
		var s:hxbit.Serializer = new hxbit.Serializer();*/
		
		return;
		props.formApi.requests.push( /*BinaryLoader.insert(
			'${App.config.api}', 
			{
				id:props.userState.id,
				jwt:props.userState.jwt,
				fields:'disabled:disabled,element=:element,required=:required,use_as_index=:use_as_index',
				classPath:'tools.DB',
				action:'saveTableFields',
				dbData:s.serialize(dbData),
				devIP:App.devIP
			},
			function(data:DbData)
			{		
				UserAccess.jwtCheck(data);		
				trace(data);
			}
		)*/null);
	}
	
	public function importAccounts(_):Void
	{
		trace(props.userState.dbUser.first_name);
		setState({loading:true});
		doSyncAll(			
		{
			classPath:'admin.SyncExternalAccounts',
			action:'syncAll',
			extDB: true,
			filter:{mandator:'1'},
			limit:1000,
			offset:0,
			table:'accounts',
			dbUser:props.userState.dbUser,
			devIP:App.devIP,
			maxImport:4000,
			//relations:new Map()
		});
	}

	function doSyncAll(dbQueryParam:DbQueryParam) {
		
		var p:Promise<DbData> = props.load(dbQueryParam);
		p.then(function(data:DbData){
			if(data.dataInfo['offset']==null)
			{
				return App.store.dispatch(Status(Update(
				{
					cssClass:'error',
					text:'Fehler 0 ${data.dataInfo['classPath']} Aktualisiert'}
				)));
			}					
			var offset = Std.parseInt(data.dataInfo['offset']);
			App.store.dispatch(Status(Update(
				{
					cssClass:' ',
					text:'${offset} ${dbQueryParam.classPath} von ${data.dataInfo['maxImport']} aktualisiert'
				}
			)));

			trace('${offset} < ${data.dataInfo['maxImport']}');
			if(offset < data.dataInfo['maxImport']){
				//LOOP UNTIL LIMIT
				trace('next loop:${data.dataInfo}');
				return doSyncAll(cast data.dataInfo);
			}					
			else{
				setState({loading:false});
				return App.store.dispatch(Status(Update(
					{
						cssClass:' ',
						text:'${offset} ${dbQueryParam.classPath} von ${data.dataInfo['maxImport']} aktualisiert'
					}
				)));
			}

		});//*/
		return p;
	}

	
	public function importAll(_):Void
	{
		trace(props.userState.dbUser.first_name);
		App.store.dispatch(action.async.LivePBXSync.syncAll({
			limit:1000,
			maxImport:4000,
			userState:props.userState,
			offset:0,
			classPath:'admin.SyncExternal',
			action:'syncAll'
		}));
	}

	public function importAllBookingRequests(_):Void
	{
		trace(props.userState.dbUser.first_name);
		//var p:Promise<DbData> = cast 
		App.store.dispatch(action.async.LivePBXSync.syncAll({
			limit:50000,
			maxImport:50000,
			userState:props.userState,
			offset:100000,
			table:'bank_transfers',
			classPath:'admin.SyncExternalBookings',
			action:'syncAll'
		}));
		/*p.then(function(dbData:DbData){ 
			trace(dbData.dataErrors.keys().hasNext());
			if(!dbData.dataErrors.empty()){
				
				//App.store.dispatch(LoginExpired({waiting: false, loginTask: Login}));
				trace(dbData);
			}
			else{

				trace('OK');
				//state.userState.dbUser.online = true;
				//App.store.dispatch(LoginComplete({waiting:false}));					
			}
		});*/
	}

	public function importBookingRequests() {
		App.store.dispatch(LivePBXSync.importBookingRequests({
			limit: 25000,
			offset:0,
			classPath: 'admin.SyncExternalBookings',
			action: 'syncBookingRequests',
			userState:props.userState
		}));
	}	

	public function importContacts():Void
		{
			trace(props.userState.dbUser.first_name);
			App.store.dispatch(Status(Update(
				{
					cssClass:' ',
					text:'Importiere Kontakte'})));
			App.store.dispatch(action.async.LivePBXSync.importAll({
				limit:1000,
				//maxImport:4000,
				userState:props.userState,
				offset:0,
				onlyNew: true,
				classPath:'admin.SyncExternalContacts',
				action:'importAll'
			}));
		}	

	public function importDeals() {
		App.store.dispatch(Status(Update(
			{
				cssClass:' ',
				text:'Importiere Abschlüsse'})));		
		App.store.dispatch(LivePBXSync.importDeals({
			limit: 1000,//00,
			offset:0,
			onlyNew:true,
			classPath: 'admin.SyncExternalDeals',
			action: 'importAll',
			userState:props.userState
		}));
	}

	public function syncDeals() {
		App.store.dispatch(Status(Update(
		{
			cssClass:' ',
			text:'Aktualisiere Abschlüsse'
		})));	

		App.store.dispatch(LivePBXSync.importDeals({
			limit: 1000,
			offset:0,
			classPath: 'admin.SyncExternalDeals',
			action: 'importAll',
			userState:props.userState
		}));
	}	

	public function syncUserList(_):Void
	{
		//FormApi.requests.push( 
		trace(App.config.api);
		BinaryLoader.create(
			'${App.config.api}', 
			{
				id:props.userState.dbUser.id,
				jwt:props.userState.dbUser.jwt,
				fields:'id,table_name,field_name,disabled,element,required,use_as_index',
				classPath:'admin.SyncExternal',
				action:'syncUserDetails',
				devIP:App.devIP
			},
			function(data:DbData)
			{
				//UserAccess.jwtCheck(data);
				//trace(data);
				//trace(data.dataRows[data.dataRows.length-2]['phone_data']);
				trace(data.dataRows.length);
				if(data.dataRows.length>0)
				setState({dataTable:data.dataRows});
			}
		);
	}

	public function proxy_showUserList(_):Void
	{
		//FormApi.requests.push( 
		trace(App.config.api);
		BinaryLoader.create(
			//'${App.config.api}', 
			'https://pitverwaltung.de/sync/proxy.php', 
			{
				id:props.userState.dbUser.id,
				jwt:props.userState.dbUser.jwt,
				fields:'id,table_name,field_name,disabled,element,required,use_as_index',
				classPath:'admin.SyncExternal',
				action:'syncUserDetails',
				target: 'syncUsers.php',
				devIP:App.devIP
			},
			function(data:DbData)
			{
				//UserAccess.jwtCheck(data);
				//trace(data);
				//trace(data.dataRows[data.dataRows.length-2]['phone_data']);
				trace(data.dataRows.length);
				if(data.dataRows.length>0)
				setState({dataTable:data.dataRows});
			}
		);
	}

	/*function untilDone(fn:Dispatch, check:DbData->Bool, isDone = false):Dispatch {
		if(isDone) return fn;
		var p = fn();
		return fn.then(function(data:DbData)return untilDone(fn, check, check(data)));
	}*/
	
	override public function componentDidMount():Void 
	{				
		//
		if(props.userState != null)
		trace('yeah: ${props.userState.dbUser.first_name}');
	}

	function go(aState:Dynamic)
	{
		trace(Reflect.fields(aState));
		var dbaProps:DBAccessProps = 
		{
			action:props.match.params.action,
			classPath:'data.Contacts',
			dataSource:null,
			table:'contacts',
			userState:props.userState
		};
		switch (props.match.params.action)
		{
			case 'insert':
				for(f in fieldNames)
				{
					trace('$f =>${Reflect.field(aState,f)}<=');
					if(Reflect.field(aState,f)=='')
						Reflect.deleteField(aState,f);
				}
				Reflect.deleteField(aState,'id');
				Reflect.deleteField(aState,'creation_date');				
				dbaProps.dataSource = [
					"contacts" => [
						"data" => aState,
						"fields" => Reflect.fields(aState).join(',')
					]
				];
			case 'delete'|'get':
			//#
		}
	}

	override function render():ReactFragment
	{
		//if(state.dataTable != null)	trace(state.dataTable[0]);
		trace(props.match.params.section);		
		return state.formApi.render(jsx('
		<>
			<form className="tabComponentForm"  >
				${renderResults()}
			</form>
		</>'));		
	}
	
	function renderResults():ReactFragment
	{
		trace(props.match.params.action + ':' + Std.string(state.dataTable != null));
		trace(state.loading);
		if(state.loading)
			return state.formApi.renderWait();
		trace('###########loading:' + state.loading);
		return switch(props.match.params.action)
		{
			/*case 'showUserList':
				jsx('
					<Table id="fieldsList" data=${state.dataTable}
					${...props} dataState = ${dataDisplay["userList"]} 
					className="is-striped is-hoverable" fullWidth=${true}/>
				');*/
			case 'importClientList':
				//trace(initialState);
				trace(state.actualState);
				/*var fields:Map<String,FormField> = [
					for(k in dataAccess['update'].view.keys()) k => dataAccess['update'].view[k]
				];*/
				(state.actualState==null ? state.formApi.renderWait():
				state.formBuilder.renderForm({
					mHandlers:state.mHandlers,
					fields:formFields,/*[
						for(k in dataAccess['update'].view.keys()) k => dataAccess['update'].view[k]
					],*/
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
			case 'shared.io.DB.editTableFields':
				null;
			default:
				null;
		}
		return null;
	}
	
	
	function updateMenu(?viewClassPath:String):MenuProps
	{
		var sideMenu = state.sideMenu;
		trace(sideMenu.section);
		//sideMenu.menuBlocks['DBSync'].handlerInstance = this;
		for(mI in sideMenu.menuBlocks['DBSync'].items)
		{
			switch(mI.action)
			{
				case 'editTableFields':
					mI.disabled = state.selectedRows.length==0;
				case 'save':
					mI.disabled = state.clean;
				default:

			}			
		}
		return sideMenu;
	}
}