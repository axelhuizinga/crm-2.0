package view.data.contacts;
import state.AppState;
import haxe.Constraints.Function;
import haxe.ds.IntMap;
import react.data.ReactDataGrid;
import react.ReactComponent;
import react.ReactEvent;
import react.ReactMacro.jsx;
import shared.DbData;
import shared.DBMetaData;
import view.shared.FormBuilder;
import view.shared.FormField;
import state.FormState;
import model.contacts.ContactsModel;
import view.shared.SMItem;
import view.shared.SMenuProps;
import view.shared.io.BaseForm;
import view.shared.io.FormApi;
import view.shared.io.DataFormProps;
import view.shared.io.DataAccess;
import loader.BinaryLoader;
import view.table.VDataGrid;
import model.Contact;

class List extends BaseForm//ReactComponentOf<DataFormProps,FormState>
{
	public static var menuItems:Array<SMItem> = [
		//{label:'Anzeigen',action:'get'},
		{label:'Bearbeiten',action:'update',section: 'Edit'},
		{label:'Neu', action:'insert',section: 'Edit'},
		{label:'Löschen',action:'delete'}
	];
	
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
			trace('redirecting to ${baseUrl}List/get');
			props.history.push('${baseUrl}List/get');
			//get(null);
}		
		trace(state.loading);
	}
	
	static function mapStateToProps(aState:AppState) 
	{
		return {
			user:aState.user
		};
	}
	
	public function delete(ev:ReactEvent):Void
	{
		trace(state.selectedRows.length);
		var data = state.formApi.selectedRowsMap(state);
	}

	public function get(ev:Dynamic):Void
	{
		trace('hi $ev');
		var offset:Int = 0;
		if(ev != null && ev.page!=null)
		{
			offset = Std.int(props.limit * ev.page);
		}
		//var s:hxbit.Serializer = new hxbit.Serializer();		
		//state.formApi.requests.push( 
			BinaryLoader.create(
			'${App.config.api}', 
			{
				id:props.user.id,
				jwt:props.user.jwt,
				className:'data.Contacts',
				action:'get',
				filter:(props.match.params.id!=null?'id|${props.match.params.id}':'mandator|1'),
				devIP:App.devIP,
				limit:props.limit,
				offset:offset>0?offset:0,
				table:'contacts'
			},
			function(data:DbData)
			{			
				//UserAccess.jwtCheck(data);
				trace(data.dataInfo);
				trace(data.dataRows.length);
				if(data.dataRows.length>0) 
				{
					if(!data.dataErrors.keys().hasNext())
					{
						var dRows:Array<Dynamic> = [];
						for(row in data.dataRows)
						{
							var rO:Dynamic = {};
							for(k=>v in row.keyValueIterator())
								Reflect.setField(rO, k , v);
							dRows.push(rO);						
						}
						trace(dRows);
						setState({
							rows:dRows,
							dataTable:data.dataRows,
							dataCount:data.dataInfo['count'],
							pageCount: Math.ceil(data.dataInfo['count'] / props.limit)
						});
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

	/*function initStateFromDataTable(dt:Array<Map<String,String>>):Dynamic
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
	}*/
		
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
		trace(props.match.params.section + ':${props.match.params.action}::' + Std.string(state.dataTable != null));
		//trace(dataDisplay["userList"]);
		trace(state.loading);
		if( state.dataTable.length==0)
			return state.formApi.renderWait();
		trace('###########loading:' + state.rows[0]);
		return switch(props.match.params.action)
		{//  ${...props}
			case 'get':
				jsx('
					<form className="tabComponentForm" >
						<$VDataGrid ${...props}
							autoSize=${false} 
							listColumns=${cast ContactsModel.listColumns}
							dataRows=${state.rows}
							renderPager=${renderPager} rowClassName=${
								function (r:IObj)return(r.index % 2 == 0?'even':'odd')}
						/>
					</form>
				');
			default:
				null;
		}
		return null;
	}

	function getCellData(cP:Dynamic) {
		trace(cP);
	}
//cellDataGetter=${getCellData}
	
	override function render():ReactFragment
	{
		//if(state.dataTable != null)	trace(state.dataTable[0]);
		trace(props.match.params.section);		
		return state.formApi.render(jsx('
				${renderResults()}
		'));		
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