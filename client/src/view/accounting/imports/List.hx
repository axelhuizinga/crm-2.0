package view.accounting.imports;

import js.html.Event;
import action.DataAction;
import action.DataAction.SelectType;
import action.async.LiveDataAccess;
import shared.Utils;
import model.accounting.ReturnDebitModel;
import haxe.Json;
import js.html.Blob;
import js.html.File;
import js.Syntax;
import js.html.FormData;
import view.shared.FormInputElement;
import js.Browser;
import js.html.FileReader;
import haxe.Unserializer;
import js.html.XMLHttpRequest;
import shared.DbDataTools;
import action.AppAction;
import db.DbQuery.DbQueryParam;
import redux.Redux.Dispatch;
import redux.thunk.Thunk;
import action.async.CRUD;
import js.lib.Promise;
import action.async.DBAccessProps;
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
import react.ReactUtil;
import shared.DbData;
import state.FormState;
import view.shared.FormBuilder;
import view.shared.MItem;
import view.shared.MenuProps;
import view.table.Table.DataState;
import view.table.Table;
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
class List extends ReactComponentOf<DataFormProps,FormState>
{

	static var _instance:List;

	public static var menuItems:Array<MItem> = [		
		{
			label:'Anzeigen',action:'listReturnDebit'
		},
		{
			label:'Details',action:'showDetails'
		}
	];	
	var dataAccess:DataAccess;	
	var dataDisplay:Map<String,DataState>;
	var formApi:FormApi;
	var formBuilder:FormBuilder;
	var formFields:DataView;
	var fieldNames:Array<String>;
	var baseForm:BaseForm;
	var contact:Contact;
	var dbData: shared.DbData;
	var dbMetaData:shared.DBMetaData;	

	public function new(props) 
	{
		super(props);
		_instance = this;
		dataDisplay = ReturnDebitModel.dataDisplay;
		
		trace('...' + Reflect.fields(props));
		baseForm = new BaseForm(this);
		
		state =  App.initEState({
			sideMenu:FormApi.initSideMenu( this,			
			{
				dataClassPath:'admin.ImportCamt',
				label:"Rücklastschriften",
				section: 'List',
				items: menuItems
			},
			{	
				section: props.match.params.section==null? 'List':props.match.params.section, 
				sameWidth: true					
			})
		},this);

		trace(props.match.path);
	}

	static function mapStateToProps(aState:AppState) 
	{
		return {
			userState:aState.userState
		};
	}

	static function mapDispatchToProps(dispatch:Dispatch) {
        return {
			load: function(param:DbQueryParam) return dispatch(CRUD.read(param)),
			storeData:function(id:String, action:DataAction)
			{
				dispatch(LiveDataAccess.storeData(id, action));
			},
			select:function(id:Int = -1,data:StringMap<Map<String,Dynamic>>,match:react.router.RouterMatch, ?selectType:SelectType)
			{
				if(true) trace('select:$id selectType:${selectType}');
				trace(data);
				dispatch(LiveDataAccess.sSelect({id:id,data:data,match:match,selectType: selectType}));
			}						
        }
	}	
	
	override public function componentDidMount():Void 
	{	
		dataAccess = ReturnDebitModel.dataAccess;
		trace(props.match.params.action);
		state.formApi.doAction('get');
	}

	public function delete(ev:ReactEvent):Void
	{
		trace(state.selectedRows.length);
		var data = state.formApi.selectedRowsMap(state);
		trace(data);
	}

	public function get(ev:Dynamic):Void
	{
		trace('hi $ev');
		var offset:Int = 0;
		if(ev != null && ev.page!=null)
		{
			offset = Std.int(props.limit * ev.page);
		}
		trace(props.userState);
		var p:Promise<DbData> = props.load(
			{
				classPath:'data.DebitReturnStatements',
				action:'get',
				filter:(props.match.params.id!=null?{id:props.match.params.id, mandator:'1'}:{mandator:'1',processed:'false'}),
				limit:props.limit,
				offset:offset>0?offset:0,
				table:'debit_return_statements',
				resolveMessage:{					
					success:'Rücklastschriften wurde geladen',
					failure:'Rücklastschriften konnten nicht geladen werden'
				},
				dbUser:props.userState.dbUser,
				devIP: App.devIP
			}
		);
		p.then(function(data:DbData){
			trace(data.dataRows.length); 
			setState({loading:false, dataTable:data.dataRows});
		});
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
		if(state.loading)
			return state.formApi.renderWait();
		trace('###########loading:' + state.loading);
		return switch(state.action)
		{
			case 'listReturnDebit':
				null;			
			default:
				jsx('
					<Table id="importedReturnDebit" data=${state.dataTable}
					${...props} dataState=${dataDisplay["rDebitList"]} renderPager=${baseForm.renderPager} 
					className="is-striped is-hoverable"  parentComponent=${this} fullWidth=${true}/>
				');							
		}
	}	
}