package view.data.deals;

import view.shared.io.BaseForm;
import redux.Redux.Dispatch;
import js.lib.Promise;
import action.async.CRUD;
import model.deals.DealsModel;
import state.AppState;
import haxe.Constraints.Function;
import haxe.ds.IntMap;
import me.cunity.debug.Out;
import react.ReactComponent;
import react.ReactEvent;
import react.ReactMacro.jsx;
import react.ReactUtil;
import shared.DbData;
import shared.DBMetaData;
//import view.data.deals.model.Deals;
import view.shared.FormField;
import state.FormState;
import view.shared.SMItem;
import view.shared.SMenuProps;
import view.shared.io.FormApi;
import view.shared.io.DataFormProps;
import view.shared.io.DataAccess;
import loader.BinaryLoader;
import view.table.Table;

@:connect
class List extends BaseForm
{
	public static var menuItems:Array<SMItem> = [
		{label:'Anzeigen',action:'get'},
		{label:'Bearbeiten',action:'update'},
		//{label:'Finden',action:'get'},
		{label:'Neu', action:'insert'},
		{label:'Löschen',action:'delete'}
	];
		
	var dbData: shared.DbData;
	var dbMetaData:shared.DBMetaData;

	public function new(props) 
	{
		super(props);
		dataDisplay = DealsModel.dataDisplay;
		trace('...' + Reflect.fields(props));
		//state =  App.initEState({loading:false,values:new Map<String,Dynamic>()},this);
		//trace(state.loading);
		state =  App.initEState({
			dataTable:[],
			loading:false,
			dealsData:new IntMap(),			
			selectedRows:[],
			sideMenu:FormApi.initSideMenu2( this,
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
			//var sData = App.store.getState().dataStore.contactData;	props.match.params.section==null||		
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
	
    static function mapDispatchToProps(dispatch:Dispatch) {
        return {
            load: function(param) return dispatch(CRUD.read({
				className:'data.Deals',
				action:'get',
				filter:param.filter,
				limit:param.limit,
				offset:param.offset,
				table:'deals',
				user:param.user
			}))
        };
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
		setState({loading:true});
		if(ev != null && ev.page!=null)
		{
			offset = Std.int(props.limit * ev.page);
		}		
		var contact = (props.location.state.contact);
		var p:Promise<DbData> = props.load(
			{
				className:'data.Deals',
				action:'get',
				filter:(props.match.params.id!=null?'id|${props.match.params.id}':'mandator|1'),
				limit:props.limit,
				offset:offset>0?offset:0,
				table:'deals',
				user:props.user
			}
		);
		p.then(function(data:DbData){
			trace(data.dataRows.length); 
			setState({loading:false, dataTable:data.dataRows});
		});
	}
	
	public function edit(ev:ReactEvent):Void
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
		trace(props.match.params.section + ':' + Std.string(state.dataTable != null));
		//trace(dataDisplay["userList"]);
		trace(state.loading);
		if(state.loading)
			return state.formApi.renderWait();
		trace('###########loading:' + state.loading);
		return switch(props.match.params.action)
		{
			case 'get':
				jsx('
					<Table id="fieldsList" data=${state.dataTable} 
					${...props} dataState = ${dataDisplay["dealsList"]} renderPager=${renderPager} parentComponent=${this}
					className="is-striped is-hoverable" fullWidth=${true}/>
				');
			case 'update':
				jsx('
					<Table id="fieldsList" data=${state.dataTable}
					${...props} dataState = ${dataDisplay["clientList"]} 
					className="is-striped is-hoverable" fullWidth=${true}/>
				');			
			case 'insert':
				trace(dataDisplay["fieldsList"]);
				trace(state.dataTable[29]['id']+'<<<');
				jsx('
					<Table id="fieldsList" data=${state.dataTable}
					${...props} dataState = ${dataDisplay["fieldsList"]} 
					className="is-striped is-hoverable" fullWidth=${true}/>				
				');	
			case 'delete':
				null;
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
		<>
			<form className="tabComponentForm"  >
				${renderResults()}
			</form>
		</>'));		
	}
	
	function updateMenu(?viewClassPath:String):SMenuProps
	{
		var sideMenu = state.sideMenu;
		trace(sideMenu.section);
		for(mI in sideMenu.menuBlocks['Contact'].items)
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