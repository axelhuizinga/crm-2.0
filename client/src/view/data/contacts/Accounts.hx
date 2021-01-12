package view.data.contacts;

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
import view.table.Table;
import model.accounting.AccountsModel;

@:connect
class Accounts extends ReactComponentOf<DataFormProps,FormState>
{
	var dataDisplay:Map<String,DataState>;
	var dataAccess:DataAccess;	
	var dbData: shared.DbData;
	var dbMetaData:shared.DBMetaData;

	public function new(props) 
	{
		super(props);
		//baseForm =new BaseForm(this);
		dataDisplay = AccountsModel.dataDisplay;
		trace('...' + Reflect.fields(props));
		state =  App.initEState({
			dataTable:[],
			loading:false,
			model:'accounts',
			accountsData:new IntMap(),			
			selectedRows:[],
			sideMenu:null,
			values:new Map<String,Dynamic>()
		},this);
		props.parentComponent.registerOrmRef(this);
		trace(state.loading);	
	}

	static function mapDispatchToProps(dispatch:Dispatch) {
        return {
            load: function(param:DBAccessProps) return dispatch(CRUD.read(param))
        };
	}
	
	static function mapStateToProps(aState:AppState) 
	{
		trace(aState.userState);
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
		trace('hi :)');
		var offset:Int = 0;
		setState({loading:true});
		//var contact = (props.location.state.contact);
		trace(props.userState);
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
		props.parentComponent.registerOrmRef(this);
		get();
	}
	
	function renderResults():ReactFragment
	{
		trace(state.loading);
		if(state.loading)
			return state.formApi.renderWait();
		trace('###########loading:' + props.action);
		return switch(props.action)
		{
			case 'get':
				jsx('
					<Table id="accountsList" data=${state.dataTable}
					${...props} dataState = ${dataDisplay["accountsList"]} renderPager=${function()BaseForm.renderPager(this)}
					parentComponent=${this} className="is-striped is-hoverable" fullWidth=${true}/>
				');
			case 'update':
				jsx('
					<Table id="accountsList" data=${state.dataTable}
					${...props} dataState = ${dataDisplay["accountsList"]} 
					className="is-striped is-hoverable" fullWidth=${true}/>
				');			
			case 'insert':
				trace(dataDisplay["accountsList"]);
				trace(state.dataTable[29]['id']+'<<<');
				jsx('
					<Table id="accountsList" data=${state.dataTable}
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
		return state.formApi.render(jsx('
			<form className="tabComponentForm" name="accountsList" >
				${renderResults()}
			</form>
		'));		
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