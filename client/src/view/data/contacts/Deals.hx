package view.data.contacts;

import db.DbUser;
import action.async.LiveDataAccess;
import js.Browser;
import js.html.NodeList;
import js.html.TableRowElement;
import react.router.RouterMatch;
import db.DBAccessProps;
import view.shared.io.BaseForm;
import redux.Redux.Dispatch;
import js.lib.Promise;
import action.async.CRUD;
import action.DataAction;
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
import view.shared.MItem;
import view.shared.MenuProps;
import view.shared.io.FormApi;
import view.shared.FormBuilder;

import view.shared.io.DataFormProps;
import view.shared.io.DataAccess;
import loader.BinaryLoader;
import view.table.Table;

@:connect
class Deals extends ReactComponentOf<DataFormProps,FormState>
{
	var dataAccess:DataAccess;
	var dataDisplay:Map<String,DataState>;
	var formFields:DataView;
	var fieldNames:Array<String>;
	var dbData: shared.DbData;
	var dbMetaData:shared.DBMetaData;

	public function new(props:DataFormProps) 
	{
		super(props);
		dataAccess = DealsModel.dataAccess;
		fieldNames = BaseForm.initFieldNames(dataAccess['open'].view.keys());
		dataDisplay = DealsModel.dataDisplay;
		trace('...' + Reflect.fields(props));

		state =  App.initEState({
			dataTable:[],
			loading:false,
			dealsData:new IntMap(),	
			model:'deals',
			selectedRows:[],
			sideMenu:null,
			values:new Map<String,Dynamic>()
		},this);
		//get();	
		//props.parentComponent.registerOrmRef(this);
		trace(state.loading);
	}
	
	static function mapDispatchToProps(dispatch:Dispatch) {
        return {
			load: function(param:DBAccessProps) return dispatch(CRUD.read(param)),
			select:function(id:Int = -1, dbUser:DbUser)
			{
				if(true) trace('select:$id dbUser:${dbUser}');
				//dispatch(DataAction.CreateSelect(id,data,match));
				//dispatch(LiveDataAccess.select({id:id,data:data,match:match,selectType: selectType}));
			}
		};
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
	
	/**
	 * get all deals with this Contact id
	 */

	public function get():Void
	{
		var offset:Int = 0;
		trace(props.filter);
		setState({loading:true});	
		//var contact = (props.location.state.contact);
		var p:Promise<DbData> = props.load(
			{
				classPath:'data.Deals',
				action:'get',
				filter:(props.filter!=null?props.filter:{mandator:'1'}),
				limit:props.limit,
				offset:offset>0?offset:0,
				table:state.model,
				resolveMessage:{					
					success:'Aktionliste wurde geladen',
					failure:'Aktionliste konnte nicht geladen werden'
				},				
				dbUser:props.userState.dbUser,
				devIP:App.devIP
			}
		);
		p.then(function(data:DbData){
			trace(data.dataRows.length); 
			//setState({loading:false, dataTable:data.dataRows});
			setState({
				loading:false,
				dataTable:data.dataRows,
				dataCount:Std.parseInt(data.dataInfo['count']),
				pageCount: Math.ceil(Std.parseInt(data.dataInfo['count']) / props.limit)
			});			
		});
	}
	
	public function edit(ev:ReactEvent):Void
	{
		trace(state.selectedRows.length);				
	}

	public function selectionClear() {
		var match:RouterMatch = ReactUtil.copy(props.match);
		match.params.action = 'get';
		trace(state.dataTable.length);
		props.select(1, null,match, UnselectAll);	
		//trace(formRef !=null);

		var trs:NodeList = Browser.document.querySelectorAll('.tabComponentForm tr');				
		trace(trs.length);
		for(i in 0...trs.length){
			var tre:TableRowElement = cast(trs.item(i), TableRowElement);
			if(tre.classList.contains('is-selected')){
				trace('unselect:${tre.dataset.id}');
				tre.classList.remove('is-selected');
			}
		};
		Browser.document.querySelector('[class="grid-container-inner"]').scrollTop = 0;
	}
		
	override public function componentDidMount():Void 
	{	
		dataAccess = [
			'get' =>{
				source:[
					"deals" => []
				],
				view:[]
			},
		];			
		//
		trace(props.action);
		if(props.userState.dbUser != null)
		trace('yeah: ${props.userState.dbUser.first_name}');
		//dbData = FormApi.init(this, props);
		props.parentComponent.registerOrmRef(this);
		get();
		//state.formApi.doAction(props.action);
	}
	
	function renderResults():ReactFragment
	{
		trace(props.action);
		//trace(dataDisplay["userList"]);
		trace(state.loading);
		if(state.loading)
			return state.formApi.renderWait();
		//trace('###########loading:' + state.dataTable);
		return switch(props.action)
		{
			case 'get':
			jsx('				
					<$Table id="dealsList" data=${state.dataTable}  parentComponent=${this}
					${...props} dataState = ${dataDisplay.get("listColumns")} renderPager=${{function()BaseForm.renderPager(this);}}
					className="is-striped is-hoverable" fullWidth=${true}/>
			');			
			case 'delete':
				null;
			default:
				null;
		}
		return null;
	}
	
	override public function render():ReactFragment
	{
		//if(state.dataTable != null)	trace(state.dataTable[0]);
		return jsx('<form className="tabComponentForm formField" ref=${props.formRef} name="dealsList" > 
			${renderResults()}
		</form>');
	}
}