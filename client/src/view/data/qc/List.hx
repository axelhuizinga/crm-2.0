package view.data.qc;
import js.html.IterationCompositeOperation;
import js.html.DivElement;
import js.lib.Promise;
import shared.Utils;
import data.DataState;
import react.router.RouterMatch;
import js.Browser;
import js.html.NodeList;
import js.html.TableRowElement;
import shared.Utils;
import action.DataAction;
import state.AppState;
import haxe.Constraints.Function;
import haxe.ds.IntMap;
import react.data.ReactDataGrid;
import react.ReactComponent;
import react.ReactEvent;
import react.ReactMacro.jsx;
import react.ReactUtil.copy;
import shared.DbData;
import shared.DBMetaData;
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
import loader.BinaryLoader;
import view.grid.Grid;
import model.Contact;

@:connect
class List extends ReactComponentOf<DataFormProps,FormState>
{
	public static var menuItems:Array<MItem> = [
		//{label:'Anzeigen',action:'get'},
		{label:'Bearbeiten',action:'update',section: 'Edit'},
	//	{label:'Neu', action:'insert',section: 'Edit'},		
		{label:'Löschen',action:'delete'},
		{label:'Auswahl aufheben',action:'selectionClear'},
	//	{label:'Auswahl umkehren',action:'selectionInvert'},
	//	{label:'Auswahl alle',action:'selectionAll'},
	];
	
	var dataAccess:DataAccess;
	var dataDisplay:Map<String,DataState>;
	var formApi:FormApi;
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
		dataDisplay = ContactsModel.qcListDisplay;
		trace('...' + Reflect.fields(props));
		state =  App.initEState({
			dbTable:[],
			loading:false,
			contactData:new IntMap(),			
			selectedRows:[],
			sideMenu:FormApi.initSideMenu( this,
				{
					dataClassPath:'data.Deals',
					label:'Liste',
					section: 'List',
					items: menuItems
				}					
				,{	
					section: props.match.params.section==null? 'List':props.match.params.section, 
					sameWidth: true
				}),
			values:new Map<String,Dynamic>()
		},this);
		if(props.match.params.action==null)
		{
			//var sData = App.store.getState().dataStore.contactsData;			
			var baseUrl:String = props.match.path.split(':section')[0];
			trace('redirecting to ${baseUrl}List/get');
			props.history.push('${baseUrl}List/get');
			//get(null);
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
		
		//trace ('never');
		trace (aState.dataStore.qcData.keys().next());
		var ks:Iterator<Int> = aState.dataStore.qcData.keys();
		trace ('aState.dataStore.qcData.keys:' + 
		[ while(ks.hasNext())
			ks.next()
		].join('|')
		);
		//trace ('never');
		return {
			dataStore:aState.dataStore,
			userState:aState.userState
		};
	}
	
	public function delete(ev:ReactEvent):Void
	{
		trace(state.selectedRows.length);
		var data = state.formApi.selectedRowsMap(state);
	}

	public function get(filter:Dynamic=null):Void
	{
		var offset:Int = 0;
		if(filter != null && filter.page!=null)
		{
			trace(filter);
			offset = Std.int(props.limit * filter.page);
			Reflect.deleteField(filter,'page');
		}
		//if(filter == null)
		filter = Utils.extend(filter, (props.match.params.id!=null?
			{id:props.match.params.id, mandator:props.userState.dbUser.mandator}:
			{mandator:props.userState.dbUser.mandator })
		);
		trace('hi $filter');
		BinaryLoader.create(
			'${App.config.api}', 
			{
				id:props.userState.dbUser.id,
				jwt:props.userState.dbUser.jwt,
				classPath:'data.Deals',
				action:'getQC',
				viciBoxDB: true,
				filter:filter,
				dbUser:props.userState.dbUser,
				devIP:App.devIP,
				limit:props.limit,
				offset:offset>0?offset:0,
				order:'last_local_call_time',
				table:'vicidial_list'
			},
			function(data:DbData)
			{			
				//UserAccess.jwtCheck(data);
				trace(data.dataInfo);
				trace(data.dataParams);
				trace(data.dataRows.length);
				if(data.dataRows.length>0) 
				{
					trace(!data.dataErrors.keys().hasNext()?'Y':'N');					
					if(!data.dataErrors.keys().hasNext()){
						// LOAD DATA INTO DATAROWS
						//trace(data.dataRows[0]);
						setState({
							dbTable:data.dataRows,
							dataCount:Std.parseInt(data.dataInfo['count']),
							pageCount: Math.ceil(Std.parseInt(data.dataInfo['count']) / props.limit)
						});
						var p:Promise<Dynamic> = App.store.dispatch(DataAction.QCsLoaded(data));
						//trace(Std.string(p));
						/*p.then(function(d:Dynamic) {
							trace(d);
						});*/
					}
					else 
						setState({values: ['loadResult'=>'Kein Ergebnis','closeAfter'=>-1]});					
				}
			}
		);
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
				//trace(props.history.)
				//forceUpdate();
			});			
		}
		else 
		{
			props.history.push(
				'${props.match.path.split(':section')[0]}List/get/${props.match.params.id!=null?props.match.params.id:''}'
			);
			//get(null);			
		}
		//props.storeData('Contacts', DataAction.Restore);
	}

	public function selectionClear() {
		var match:RouterMatch = copy(props.match);
		match.params.action = 'get';
		trace(state.dbTable.length);
		props.select(0, null,this, UnselectAll);	
		var s_cells:NodeList = Browser.document.querySelectorAll('.tabComponentForm .gridItem.selected');
		trace(s_cells.length);
		for(i in 0...s_cells.length){
			var s_cell:DivElement = cast(s_cells.item(i), DivElement);
			if(s_cell.classList.contains('selected')){
				trace('unselect:${s_cell.dataset.id}');
				s_cell.classList.remove('selected');
			}
		};
		//Browser.document.querySelector('[class="grid-container-inner"]').scrollTop = 0;
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
		//if(props.userState.dbUser != null)
			//trace('yeah: ${props.userState.dbUser.first_name}');
		get();
		//get({id:props.match.params.id});
		trace(state.uid);
		//state.formApi.doAction();
/*		if(props.match.params.action != null)
		//dbData = FormApi.init(this, props);
		{
			var fun:Function = Reflect.field(this,props.match.params.action);			
			trace(Reflect.isFunction(fun));
			if(Reflect.isFunction(fun))
			{
				Reflect.callMethod(this,fun,null);
			}
		}
		else 
			setState({loading: false});*/
	}
	
	function renderResults():ReactFragment
	{
		trace(props.match.params.section + ':${props.match.params.action}::' + Std.string(state.dbTable != null));
		//trace(dataDisplay["userList"]);
		var pState:FormState = props.parentComponent.state;
		trace(state.dbTable.length);
		//if(props.dataStore.contactsDbData != null)
		//trace(props.dataStore.contactsDbData.dataRows[0]);
		//else trace(props.dataStore.contactsDbData);
		trace(state.loading);
		if( state.dbTable.length==0)
			return state.formApi.renderWait();
		//trace('###########loading:' + state.rows[0]);
		//trace(state.dbTable[0]);
		return switch(props.match.params.action)
		{//  ${...props}
			case 'get':
				jsx('
					<Grid id="contactListQC" data=${state.dbTable} findBy="lead_id" doubleClickAction="update" 
				${...props} dataState = ${dataDisplay["qcList"]} 
				parentComponent=${this} className="is-striped is-hoverable" fullWidth=${true}/>		
				');
			default:
				null;
		}
		return null;
	}

	function getCellData(cP:Dynamic) {
		trace(cP);
	}
	
	override function render():ReactFragment
	{
		//if(state.dbTable != null)	trace(state.dbTable[0]);
		trace(props.match.params.section);		
		return state.formApi.render(jsx('
		<form className="tabComponentForm"  >
			${renderResults()}
		</form>
		'));		
	}

	override public function componentWillUnmount() {
		trace('...');
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

}