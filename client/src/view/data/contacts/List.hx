package view.data.contacts;


import haxe.ds.StringMap;
import haxe.Json;
import js.Cookie;
import js.html.HeadersIterator;
import js.html.Blob;
import js.html.AnchorElement;
import js.html.Window;
import js.html.Element;
import js.html.URL;
import js.html.RequestInit;
import js.html.Response;
import js.html.XMLHttpRequest;
import action.async.LivePBXSync;
import js.html.InputElement;
import loader.ListLoader;
import shared.Utils;
import js.html.DivElement;
import action.AppAction.*;
import data.DataState;
import db.DbRelationProps;
import db.DbRelation;
import redux.Redux.Dispatch;
import js.lib.Promise;
import db.DBAccessProps;
import react.router.RouterMatch;
import js.Browser;
import js.html.NodeList;
import js.html.TableRowElement;
import action.DataAction;
import state.AppState;
import haxe.Constraints.Function;
import haxe.ds.IntMap;
import react.data.ReactDataGrid;
import react.ReactComponent;
import react.ReactEvent;
import react.ReactMacro.jsx;
import react.ReactUtil.copy;
import shared.DBMetaData;
import shared.DbData;
import shared.FindFields;
import view.shared.FormBuilder;
import view.shared.FormField;
import state.FormState;
import model.contacts.ContactsModel;
import view.shared.MItem; 
import view.shared.MenuProps;
import view.shared.io.BaseForm;
import view.shared.io.FormApi;
import view.shared.io.DataFormProps;
import view.shared.io.DataAccess;
import view.grid.Grid;
//import view.table.Table;
import loader.BinaryLoader;
import model.Contact;
using StringTools;

@:connect
class List extends ReactComponentOf<DataFormProps,FormState>
{
	static var menuItems:Array<MItem> = [
		//{label:'Anzeigen',action:'get'},
		{label:'Bearbeiten',action:'update',disabled:true,id:'edit',section: 'Edit'},
		{label:'Neu', action:'insert',section: 'Edit'},		
		{label:'Löschen',action:'delete',disabled:true},
		{label:'Auswahl aufheben',action:'selectionClear',disabled:true},
		{separator: true},		
		{label: 'ID',formField: { name: 'id',findFormat:function(v:String):String {
			trace(v);
			return v;
		}}},
		{label: 'Vorname',formField: { name: 'first_name', matchFormat: FindFields.iLike}},
		{label: 'Nachname',formField: { name: 'last_name', matchFormat: FindFields.iLike}},
		{label: 'Telefon',formField: { name: 'phone_number', findFormat: function(v:String) {
			v =  ~/^0+/.replace(v, '');
			trace(v);
			return v;
		}}},		
		{label: 'Ort',formField: { name: 'city', matchFormat: FindFields.iLike}},
		{label: 'Straße',formField: { name: 'address1', matchFormat: FindFields.iLike}},
		{label: 'IBAN',formField: { name: 'iban', matchFormat: FindFields.iLike, dbTableName: 'accounts', alias:'ac'}},
	];
	static var printItems:Array<MItem> = [
		{className:'formNoLabel', formField: {name:'product', type: Radio, options: ['2'=>'Kinderhilfe','3'=>'Tierhilfe']}},
		{className:'cblock',label:'Mitgliedsnummern (Leerzeichen getrennt)',disabled:false, formField: { name: 'printList'}	},
		{label:'Drucken', action:'printList', disabled:false},		
		{label:'Alle neuen Anschreiben Drucken',action:'printNew'}
	];
	var dataAccess:DataAccess;	
	var dataDisplay:Map<String,DataState>;
	public var formApi:FormApi;
	var formBuilder:FormBuilder;
	var formFields:DataDisplay;
	var fieldNames:Array<String>;
	var baseForm:BaseForm;
	var contact:Contact;
	var dbData: shared.DbData;
	var dbMetaData:shared.DBMetaData;

	public function new(props) 
	{
		super(props);
		//baseForm =new BaseForm(this);
		dataDisplay = ContactsModel.dataGridDisplay;
		//trace('...' + Reflect.fields(props) + ':' + Std.string(menuItems));
		state =  App.initEState({
			dbTable:[],
			loading:true,
			contactData:new IntMap(),			
			selectedRows:[],
			sideMenu:FormApi.initSideMenuMulti( this,
			[
				{
					alias:'co',
					dataClassPath:'data.Contacts',						
					hasFindForm:true,
					isActive:true,
					label:'Liste',
					section: 'List',
					//items: Utils.copyObjectArray(menuItems)
					items: [for(v in menuItems) js.lib.Object.assign({},v)],
					dbTableName:'contacts',
					dbTableJoins:['ac'=>'ac.contact=co.id']

				},
				{
					hasFindForm:false,
					label:'Anschreiben',
					section: 'List_',
					//items: Utils.copyObjectArray(menuItems)
					items: [for(v in printItems) js.lib.Object.assign({},v)]
				}
			]				
			,{
				orm:cast Contact,
				section: props.match.params.section==null? 'List':props.match.params.section, 
				mBshowActive: true,
				sameWidth: true
			}),
			values:new Map<String,Dynamic>()
		},this);
		trace(Utils.sKeysList(state.relDataComps.keys()));
		if(props.match.params.section==null||props.match.params.action==null)
		{
			//var sData = App.store.getState().dataStore.contactsData;			
			var baseUrl:String = props.match.path.split(':section')[0];
			trace('redirecting to ${baseUrl}List/get');
			props.history.push('${baseUrl}List/get');
			get(null);
		}
		else 
		{
			//
			trace(props.match.params);
		}		
		trace(state.loading);
	}
	
	static function mapStateToProps(aState:AppState) 
	{
		return {
			userState:aState.userState
		};
	}
	
	public function delete(ev:ReactEvent):Void
	{
		trace(state.selectedRows.length);
		var data = state.formApi.selectedRowsMap(state);
	}
	
	//public function get(filter:Dynamic=null):Void
	public function get(dpa:DBAccessProps=null):Void
	{
		var offset:Int = 0;
		if(dpa != null && dpa.page!=null)
		{
			trace(dpa);
			offset = Std.int(props.limit * dpa.page);
			Reflect.deleteField(dpa,'page');
			props.parentComponent.setState({page: dpa.page});
		}		
		
		/*filter = Utils.extend(filter, (props.match.params.id!=null?
			{id:props.match.params.id, mandator:props.userState.dbUser.mandator}:
			{mandator:props.userState.dbUser.mandator})
		);*/
		//trace(props.match.params);

		var p:Promise<DbData> = props.load(
			{
				classPath:'data.Contacts',
				action:'get',
				dbRelations:dpa == null ? null : dpa.dbRelations,
				filter:dpa == null ? null :dpa.filter,
				limit:props.limit,
				offset:offset>0?offset:0,
				table:'contacts',
				resolveMessage:{					
					success:'Kontaktliste wurde geladen',
					failure:'Kontaktliste konnte nicht geladen werden'
				},
				dbUser:props.userState.dbUser,
				devIP: App.devIP
			}
		);
		p.then(function(data:DbData){
			trace(data.dataRows.length); 
			if(data.dataRows.length<5 && data.dataRows.length>0)
			{
				trace(data.dataRows);
			}
			//setState({loading:false, dbTable:data.dataRows}); 
			setState({
				loading:false,
				dbTable:data.dataRows,
				dataCount:Std.parseInt(data.dataInfo['count']),
				pageCount: Math.ceil(Std.parseInt(data.dataInfo['count']) / props.limit)
			});	
			//props.loaded(null);
		});
	}
	
	public function edit(ev:ReactEvent):Void
	{
		trace(state.selectedRows.length);	
		trace(Reflect.fields(ev));
	}

	public function restore() {
		trace(Reflect.fields(props.dataStore));
		if(props.dataStore != null && props.dataStore.contactsDbData != null)
		{
			setState({
			//props.parentComponent.setStateFromChild({props.match.params.id!=null?'id|${props.match.params.id}'
				//rows:dRows,
				dbTable:props.dataStore.contactsDbData.dataRows,
				dataCount:Std.parseInt(props.dataStore.contactsDbData.dataInfo['count']),
				pageCount: Math.ceil(Std.parseInt(props.dataStore.contactsDbData.dataInfo['count']) / props.limit)
			}, function (){
				trace(state.dbTable);
				props.history.push(
					'${props.match.path.split(':section')[0]}List/get/${props.match.params.id!=null?props.match.params.id:''}'
				);
			});			
		}
		else 
		{
			props.history.push(
				'${props.match.path.split(':section')[0]}List/get/${props.match.params.id!=null?props.match.params.id:''}'
			);
			get(null);			
		}
		//props.storeData('Contacts', DataAction.Restore);
	}

	public function selectionClear() {
		var match:RouterMatch = copy(props.match);
		match.params.action = 'get';
		//trace(state.dbTable.length);
		props.parentComponent.props.select(null, null,this, UnselectAll);	
		//this.props.select(this, null,props.parentComponent, UnselectAll);	
		//trace(formRef !=null);

		var trs:NodeList = Browser.document.querySelectorAll('#contactList .gridItem.selected');				
		trace(trs.length);
		for(i in 0...trs.length){
			var tre:DivElement = cast(trs.item(i), DivElement);
			//if(tre.classList.contains('is-selected')){
			//	trace('unselect:${tre.dataset.id}');
				tre.classList.remove('selected');
			//}
		};
		Browser.document.querySelector('[class="formsContainer"]').scrollTop = 0;
		// 	RESET MENU
		/*setState(  App.initEState({
			dbTable:[],
			loading:false,
			contactData:new IntMap(),			
			selectedRows:[],
			sideMenu:FormApi.initSideMenu( this,
				{
					dataClassPath:'data.Contacts',
					hasFindForm:true,
					label:'Liste',
					section: 'List',
					//items: Utils.copyObjectArray(menuItems)
					items: [for(v in menuItems) js.lib.Object.assign({},v)]

				}					
				,{
					section: props.match.params.section==null? 'List':props.match.params.section, 
					sameWidth: true
				}),
			values:new Map<String,Dynamic>()
		},this));*/
		state.sideMenuInstance.enableItems('List',['edit','delete','selectionClear'],false);
	}
		
	override public function componentDidMount():Void 
	{	
		dataAccess = [
			'get' =>{
				source:[
					"contacts" => []
				],
				view:[]
			},
		];			
		//
		if(props.userState != null)
		trace('yeah: ${props.userState.dbUser.first_name}');
		trace(props.match.params.action);
		state.formApi.doAction();

	}
	
	function renderResults():ReactFragment
	{
		//trace(props.match.params.section + ':${props.match.params.action}::' + Std.string(state.dbTable != null));
		//trace(dataDisplay["userList"]);
		var pState:FormState = props.parentComponent.state;
		if(state.dbTable!=null)
		trace(state.dbTable.length);
		if(props.dataStore.contactsDbData != null)
		trace(props.dataStore.contactsDbData.dataRows[0]);
		else trace(props.dataStore.contactsDbData);
		//trace(state.loading);
		if(state.dbTable!=null && state.dbTable.length==0)
			return state.formApi.renderWait();
		//trace('###########loading:' + state.rows[0]);
		return switch(props.match.params.action)
		{//  ${...props}
			case 'get':
				jsx('				
				<Grid id="contactList" data=${state.dbTable} doubleClickAction="update" 
				${...props} dataState = ${dataDisplay["contactList"]} 
				parentComponent=${this} className="is-striped is-hoverable" fullWidth=${true}/>			
				');			
			default:
				null;
		}
		return null;
	}
	
	override function render():ReactFragment
	{
		//if(state.dbTable != null)	trace(state.dbTable[0]);
		trace(props.match.params.section);		
		return state.formApi.render(jsx('
		<>
			<form className="tabComponentForm"  >
				${renderResults()}
			</form>
		</>
		'));		
	}

	function printList() {
		//TODO:MANDATORS HANDLING
		var inputs:NodeList = Browser.document.querySelectorAll('#printList');				
		trace(inputs.length);
		var inp:InputElement = cast(inputs.item(0), InputElement);
		var prods:NodeList = Browser.document.querySelectorAll('[name=product]:checked');
		if(prods.length==0){
			App.store.dispatch(Status(Update(
			{
				text:'Bitte Produkt auswählen!',
			})));
			return;
		}			
		var productOpt:InputElement = cast(prods.item(0), InputElement);
		trace(productOpt.value);
		trace(App.config.api);
		if(inp.value==''){
			//TODO: SHOW HINT
			return;
		}
		var list:String = inp.value;
		App.store.dispatch(Status(Update(
		{
			text:'Erzeugung der Daten zum Download gestarted',
		})));
		//TODO: CREATE GENERIC AJAX LOADER FOR FILES UP+DOWNLOAD
		var api:String = App.config.baseUrl + '/mailing.pl?action=PRINTLIST&list=' + list.urlEncode()
			+ '&product=${productOpt.value}';
		trace(api);
		var reqInit:RequestInit = {credentials: INCLUDE, mode: CORS};
		var p:Promise<Response> = Browser.window.fetch(
			api,reqInit
		);
		
		p.then(function(res:Response){
			//trace(data.dataRows.length); 
			if(true)
			{
				trace(Std.string(res.headers.keys()));

				var entry:Dynamic;
				var headers:HeadersIterator = res.headers.keys();
				var hLoop:Bool = true;
				while (hLoop){
					entry = headers.next();
					if(entry.done){
						trace('done');
						break;
					}
					trace(Std.string(entry));
				}
			}
			res.blob().then(function(bl:Blob){
				var url:String = URL.createObjectURL(bl);
				var a:AnchorElement = Browser.window.document.createAnchorElement();
				a.href = url;
				var fName:String = Cookie.get('fileDownload');
				if(fName!=null)
					a.download = fName;
				else 
					a.download = 'Liste-Anschreiben-' + productOpt.value.replace(' ','_').substr(50) + '.pdf';
				trace(Cookie.get('fileDownload'));
				///trace(Cookie.all().toString());
				a.click();
				App.store.dispatch(Status(Update(
					{
						text:'Download abgeschlossen',
					})));
			});
		});		
	}

	public function printNew() {
		//TODO:MANDATORS HANDLING
		var prods:NodeList = Browser.document.querySelectorAll('[name=product]:checked');
		if(prods.length==0){
			App.store.dispatch(Status(Update(
			{
				text:'Bitte Produkt auswählen!',
			})));
			return;
		}		
		var productOpt:InputElement = cast(prods.item(0), InputElement);
		trace(productOpt.value);
		
		App.store.dispatch(Status(Update(
		{
			text:'Erzeugung der Daten zum Download gestarted',
		})));
		
		var api:String = App.config.baseUrl + '/mailing.pl?action=PRINTNEW' + '&product=${productOpt.value}';
		trace(api);
		var reqInit:RequestInit = {credentials: INCLUDE, mode: CORS};
		var p:Promise<Response> = Browser.window.fetch(
			api,reqInit
		);
		
		p.then(function(res:Response){
			trace(res.status);
			if(res.status == 206){
				trace(res.statusText);
				res.text().then(function(t:Dynamic){
					trace(Reflect.fields(Json.parse(t)).join('|'));
					trace(Json.parse(t));

				});
				App.store.dispatch(Status(Update(
				{
					text:'Keine Neuen Anschreiben!',
				})));				
			}
			else
			res.blob().then(function(bl:Blob){
				var url:String = URL.createObjectURL(bl);
				var a:AnchorElement = Browser.window.document.createAnchorElement();
				a.href = url;
				var fName:String = Cookie.get('fileDownload');
				if(fName!=null)
					a.download = fName;
				else 
					a.download = 'Neue-Anschreiben-' + Date.now().toString().replace(' ','_').replace(':','-') + '.pdf';
				trace(Cookie.get('fileDownload'));
				//trace(Cookie.all().toString());
				a.click();
				App.store.dispatch(Status(Update(
				{
					text:'Download abgeschlossen',
				})));
			});
		},function(error:Dynamic) {
			trace(error);
			App.store.dispatch(Status(Update(
			{
				text:'...'
			})));			
		});		
	}

	function updateMenu(?viewClassPath:String):MenuProps
	{
		var sideMenu = state.sideMenu;
		trace(sideMenu.section);
		for(mI in sideMenu.menuBlocks['List'].items)
		{
			switch(mI.action)
			{
				case 'update'|'delete':
					mI.disabled = state.selectedRows.length==0;
				default:
			}			
		}
		return sideMenu;
	}

	static function mapDispatchToProps(dispatch:Dispatch) {
        return {
            load: function(param:DBAccessProps) return dispatch(ListLoader.load(param)),
			//loaded: function (data:DbData) return dispatch(DataAction.ContactsLoaded(data))
        };
	}

}