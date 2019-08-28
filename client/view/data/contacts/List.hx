package view.data.contacts;
import state.AppState;
import haxe.Constraints.Function;
import haxe.ds.IntMap;
import react.ReactComponent;
import react.ReactEvent;
import react.ReactMacro.jsx;
import shared.DbData;
import shared.DBMetaData;
import view.shared.FormBuilder;
import view.shared.FormField;
import view.shared.FormState;
import view.data.contacts.model.ContactsModel;
import view.shared.SMItem;
import view.shared.SMenuProps;
import view.shared.io.FormApi;
import view.shared.io.DataFormProps;
import view.shared.io.DataAccess;
import loader.BinaryLoader;
import view.table.Table;
import model.Contact;

class List extends ReactComponentOf<DataFormProps,FormState>
{
	public static var menuItems:Array<SMItem> = [
		//{label:'Anzeigen',action:'show'},
		{label:'Bearbeiten',action:'update',section: 'Edit'},
		{label:'Neu', action:'create',section: 'Edit'},
		{label:'Löschen',action:'delete'}
	];
	
	var dataDisplay:Map<String,DataState>;
	var dataAccess:DataAccess;	
	var dbData: shared.DbData;
	var dbMetaData:shared.DBMetaData;
	public function new(props) 
	{
		super(props);

		dataDisplay = ContactsModel.dataDisplay;
		trace('...' + Reflect.fields(props));
		state =  App.initEState({
			dataTable:[],
			loading:false,
			contactData:new IntMap(),			
			selectedRows:[],
			sideMenu:FormApi.initSideMenu2( this,
				{
					dataClassPath:'data.Contacts',
					label:'Auswahl',
					section: 'List',
					items: menuItems
				}					
				,{	
					section: props.match.params.section==null? 'List':props.match.params.section, 
					sameWidth: true
				}),
			values:new Map<String,Dynamic>()
		},this);
		if(props.match.params.section==null||props.match.params.action==null)
		{
			//var sData = App.store.getState().dataStore.contactData;			
			var baseUrl:String = props.match.path.split(':section')[0];
			trace('redirecting to ${baseUrl}List/show');
			props.history.push('${baseUrl}List/show');
			//show(null);
}		
		trace(state.loading);
	}
	
	static function mapStateToProps(aState:AppState) 
	{
		return {
			user:aState.appWare.user
		};
	}
	
	public function delete(ev:ReactEvent):Void
	{
		trace(state.selectedRows.length);
		var data = state.formApi.selectedRowsMap(state);
	}

	public function show(ev:ReactEvent):Void
	{
		trace('hi :)');
		var s:hxbit.Serializer = new hxbit.Serializer();
		
		state.formApi.requests.push( BinaryLoader.create(
			'${App.config.api}', 
			{
				id:props.user.id,
				jwt:props.user.jwt,
				className:'data.Contacts',
				action:'show',
				devIP:App.devIP,
				table:'contacts'
			},
			function(data:DbData)
			{			
				App.jwtCheck(data);
				trace(data.dataInfo);
				trace(data.dataRows.length);
				if(data.dataRows.length>0) 
				{
					if(!data.dataErrors.keys().hasNext())
					{
						setState({dataTable:data.dataRows});
					}
					else 
						setState({values: ['loadResult'=>'Kein Ergebnis','closeAfter'=>-1]});					
				}
			}
		));
	}
	
	public function edit(ev:ReactEvent):Void
	{
		trace(state.selectedRows.length);	
		trace(Reflect.fields(ev));
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
				if(dataDisplay['fieldsList'].columns[k].cellFormat == view.shared.Format.formatBool)
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
		
	override public function componentDidMount():Void 
	{	
		dataAccess = [
			'show' =>{
				source:[
					"contacts" => []
				],
				view:[]
			},
		];			
		//
		if(props.user != null)
		trace('yeah: ${props.user.first_name}');
		//dbData = FormApi.init(this, props);
		if(props.match.params.action != null)
		{
			var fun:Function = Reflect.field(this,props.match.params.action);
			if(Reflect.isFunction(fun))
			{
				Reflect.callMethod(this,fun,null);
			}
		}
		else 
			setState({loading: false});
	}
	
	function renderResults():ReactFragment
	{
		trace(props.match.params.section + ':' + Std.string(state.dataTable != null));
		//trace(dataDisplay["userList"]);
		trace(state.loading);
		if(state.dataTable.length==0)
			return state.formApi.renderWait();
		trace('###########loading:' + state.loading);
		return switch(props.match.params.action)
		{
			case 'show':
				jsx('
				<form className="tabComponentForm" >
					<Table id="fieldsList" data=${state.dataTable}  parentComponent=${this}
					${...props} dataState = ${dataDisplay["contactList"]} 
					className="is-striped is-hoverable" fullWidth=${true}/>
				</form>
				');
			default:
				null;
		}
		return null;
	}
	
	override function render():ReactFragment
	{
		//if(state.dataTable != null)	trace(state.dataTable[0]);
		trace(props.match.params.section);		
		return state.formApi.render(jsx('
				${renderResults()}
		'));		
	}

	function select(data:IntMap<Map<String,Dynamic>>)
	{
		
	}
	
	function updateMenu(?viewClassPath:String):SMenuProps
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