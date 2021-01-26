package view.data.contacts;

import me.cunity.debug.Out;
import action.DataAction.SelectType;
import db.DBAccessProps;
import action.async.CRUD;
import haxe.ds.IntMap;
import redux.Redux.Dispatch;
import view.shared.io.BaseForm;
import js.lib.Promise;
import state.AppState;
import haxe.Constraints.Function;
import react.ReactComponent;
import react.ReactEvent;
import react.ReactMacro.jsx;
import shared.DbData;
import shared.DBMetaData;
import view.shared.FormField;
import state.FormState;
import view.shared.MItem;
import view.shared.MenuProps;
import view.shared.io.FormApi;
import view.shared.io.DataFormProps;
import view.shared.io.DataAccess;
import loader.BinaryLoader;
import view.grid.Grid;
//import view.table.Table;
import model.accounting.AccountsModel;

@:connect
class Accounts extends ReactComponentOf<DataFormProps,FormState>
{
	public static var classPath = Type.getClassName(Accounts);	
	var dataDisplay:Map<String,DataState>;
	var dataAccess:DataAccess;	
	var dbData: shared.DbData;
	var dbMetaData:shared.DBMetaData;

	public function new(props) 
	{
		super(props);
		//baseForm =new BaseForm(this);
		dataDisplay = AccountsModel.dataGridDisplay;
		trace('...' + Reflect.fields(props));
		state =  App.initEState({
			dataTable:[],
			loading:true,
			model:'accounts',
			accountsData:new IntMap(),			
			selectedRows:[],
			sideMenu:null,
			values:new Map<String,Dynamic>()
		},this);
		trace(state.loading);	
	}

	static function mapDispatchToProps(dispatch:Dispatch) {
        return {
			load: function(param:DBAccessProps) return dispatch(CRUD.read(param)),
			select:function(id:Int = -1, me:Dynamic, ?sType:SelectType)
				{
					//if(true) trace('select:$id dbUser:${dbUser}');
					if(true) trace('select:$id me:${Type.getClassName(Type.getClass(me))} SelectType:${sType}');
				//dispatch(DataAction.CreateSelect(id,data,match));
				//dispatch(LiveDataAccess.select({id:id,data:data,match:match,selectType: selectType}));
			}
        };
	}
	
	static function mapStateToProps(aState:AppState) 
	{		
		//trace(aState.userState);
		trace(Reflect.fields(aState));
		return {
			userState:aState.userState
		};
	}
	
	public function delete(ev:ReactEvent):Void
	{
		trace(state.selectedRows.length);
		var data = state.formApi.selectedRowsMap(state);
	}

	public function get():Void
	{
		//trace('hi :)');
		trace(props.filter);
		var offset:Int = 0;
		//setState({loading:true});
		//var contact = (props.location.state.contact);
		Out.dumpObject(props.userState);
		var p:Promise<DbData> = props.load(
			{
				classPath:'data.Accounts',
				action:'get',
				filter:(props.filter!=null?props.filter:{mandator:'1'}),
				limit:props.limit,
				offset:offset>0?offset:0,
				table:state.model,
				resolveMessage:{					
					success:'Kontenliste wurde geladen',
					failure:'Kontenliste konnte nicht geladen werden'
				},					
				dbUser:props.userState.dbUser,
				devIP:App.devIP
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
				if(dataDisplay['fieldsList'].columns.get(k).cellFormat == view.shared.Format.formatBool)
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
		trace('ok');
		props.parentComponent.registerOrmRef(this);
		get();
	}
	
	//renderPager=${function()BaseForm.renderPager(this)}
	function renderResults():ReactFragment
	{
		trace(state.loading + ':' + props.action);
		if(state.loading)
			return state.formApi.renderWait();
		trace('###########loading:' + props.action);
		return switch(props.action)
		{
			case 'get':
				trace(state.dataTable);
				//jsx('<div>dummy</div>');
				jsx('
					<Grid id="accountsList" data=${state.dataTable}
					${...props} dataState = ${dataDisplay["accountsList"]} 
					parentComponent=${this} className="is-striped is-hoverable" fullWidth=${true}/>
				');
			case 'update':
				jsx('
					<Grid id="accountsList" data=${state.dataTable}
					${...props} dataState = ${dataDisplay["accountsList"]} 
					className="is-striped is-hoverable" fullWidth=${true}/>
				');			
			case 'insert':
				trace(dataDisplay["accountsList"]);
				trace(state.dataTable[29]['id']+'<<<');
				jsx('
					<Grid id="accountsList" data=${state.dataTable}
					${...props} dataState = ${dataDisplay["accountsList"]} 
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
		trace(props.action);				
		//return state.formApi.render(jsx('
		return jsx('
		<div className="t_caption">Konten
			<form className="tabComponentForm" name="accountsList" >				
				${renderResults()}
			</form>
		</div>
		');		
	}

	public function select(mEvOrID:Dynamic)
	{		
		trace(Reflect.fields(props));
		trace(mEvOrID);
	}	
	
	function updateMenu(?viewClassPath:String):MenuProps
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