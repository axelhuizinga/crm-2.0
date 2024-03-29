package view.accounting.directdebit;

//import view.accounting.returndebit.Files;
import js.lib.Error;
import comments.CommentString.*;
import shared.FindFields;
import view.shared.Menu.Filter;

import js.html.Event;
import action.DataAction;
import action.DataAction.SelectType;
import action.async.LiveDataAccess;
import shared.Utils;
import model.accounting.DebitModel;
import haxe.Json;
import js.html.Blob;
import js.html.File;
import js.Syntax;
import js.html.FormData;
import view.shared.FormInputElement;
import js.Browser;
import js.html.FileReader;
import js.html.XMLHttpRequest;
import haxe.Serializer;
import haxe.Unserializer;
import shared.DbDataTools;
import action.AppAction;
import redux.Redux.Dispatch;
import redux.thunk.Thunk;
import action.async.CRUD;
import js.lib.Promise;
import db.DBAccessProps;
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
import data.DataState;
import view.grid.Grid;
import view.shared.io.BaseForm;
import view.shared.io.DataAccess;
import view.shared.io.DataFormProps;
import view.shared.io.FormApi;

using Lambda;
/**
 * ...
 * @author axel@cunity.me
 */

//@:connect
class List extends ReactComponentOf<DataFormProps,FormState>
{

	static var _instance:List;

	public static var menuItems:Array<MItem> = [];
		
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
	var got:Bool;

	public function new(props) 
	{
		super(props);
		_instance = this;
		got = false;
		dataDisplay = DebitModel.dataGridDisplay;
		
		trace('...' + Reflect.fields(props));
		//baseForm =new BaseForm(this);
		
		state =  App.initEState({
			
			action:(props.action==null?(props.match.params.action==null?'get':props.match.params.action):props.action),
			//action:(props.match.params.action==null?'get':props.match.params.action),
			loading:true,
			sideMenu:props.sideMenu
		},this);
		if(state.action==null&&props.match.params.action==null)
		{
			//var sData = App.store.getState().dataStore.contactsData;			
			var baseUrl:String = props.match.path.split(':section')[0];
			trace('redirecting to ${baseUrl}List/get');
			props.history.push('${baseUrl}List/get');
			//get(null);
		}
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
			load: function(param:DBAccessProps) return dispatch(CRUD.read(param)),
			storeData:function(id:String, action:DataAction)
			{
				dispatch(LiveDataAccess.storeData(id, action));
			},
			select:function(id:Int = -1,data:IntMap<Map<String,Dynamic>>,me:List, ?selectType:SelectType)
			{
				trace(data);
				if(true) trace('select:$id selectType:${selectType}');
				dispatch(LiveDataAccess.sSelect({id:id,data:data,match:me.props.match,selectType: selectType}));
			},
			update: function(param:DBAccessProps) return dispatch(CRUD.update(param)),

        }
	}	

	override function componentDidCatch(error:Error, info:Dynamic) {
		// Display fallback UI
		setState({action:'error',dbTable: []});
		trace(error);
		trace(info);
	}
	
	override public function componentDidMount():Void 
	{	
		dataAccess = DebitModel.dataAccess;
		trace(props.match.params.action);
		//state.formApi.doAction('get');
		//if(props.match.params.action=='get')
		if(state.action == 'get')
			get();
		else if(Reflect.isFunction(Reflect.field(this,state.action)))
			Reflect.callMethod(this,Reflect.field(this,state.action),[]);
		got = true;
	}

	public function get(?filter:Dynamic):Void
	{
		if(got)
			return;
		var offset:Int = 0;
		if(filter != null && filter.page!=null)
		{
			trace(filter);
			offset = Std.int(props.limit * filter.page);
			Reflect.deleteField(filter,'page');
		}

		filter = Utils.extend(filter, (props.match.params.id!=null?
			{mandat_id:FindFields.iLike(props.match.params.id), mandator:props.userState.dbUser.mandator}:
			{mandator:props.userState.dbUser.mandator })
		);
		trace('hi $filter');
		/*trace('hi $ev');
		var offset:Int = 0;
		if(ev != null && ev.page!=null)
		{
			offset = Std.int(props.limit * ev.page);
		}
		trace(props.match.params);*/
		var p:Promise<DbData> = cast App.store.dispatch(CRUD.read(
			{
				classPath:'data.DirectDebits',
				action:'get',
				//dataSource: dS,
				filter:filter,//(props.match.params.id!=null?{id:props.match.params.id, mandator:'1'}:{mandator:'1'}),
				table:'booking_requests',
				limit:props.limit,
				offset:offset>0?offset:0,
				resolveMessage:{					
					success:'Bankeinzug wurden geladen',
					failure:'Bankeinzug konnte nicht geladen werden'
				},
				dbUser:props.userState.dbUser,
				devIP: App.devIP
			}
		));
		p.then(function(data:DbData){
			trace(data.dataRows.length); 
			//setState({loading:false, dbTable:data.dataRows});
			setState({
				loading:false,
				dbTable:data.dataRows,
				dataCount:Std.parseInt(data.dataInfo['count']),
				pageCount: Math.ceil(Std.parseInt(data.dataInfo['count']) / props.limit)
			});			
		});
	}

	public function getHistory(?filter:Dynamic):Void
	{
		var offset:Int = 0;
		if(got)
			return;
		got = true;
		if(filter != null && filter.page!=null)
		{
			trace(filter);
			offset = Std.int(props.limit * filter.page);
			Reflect.deleteField(filter,'page');
		}
		//TODO: LIST ALL PRODUCTS FOR CLIENT ID
		filter = Utils.extend(filter, (props.match.params.id!=null?
			{deal_id:props.match.params.id, mandator:props.userState.dbUser.mandator}:
			{mandator:props.userState.dbUser.mandator })
		);
		trace('hi $filter');
		/*trace('hi $ev');mandat_id:FindFields.iLike(props.match.params.id)*///'join'=>'INNER JOIN debit_return_statements drs ON  bor.mandat_id = drs.deal_id' 
		trace(props.match.params);
		/*var dS:DataSource = [					
			'booking_requests'=> [
				'alias' => 'bor',
				'fields'=>'termin,id,mandat_id deal_id,betrag amount,info'				
			],
			'debit_return_statements' =>[
				'alias'=>'drs',
				'fields'=>'value_date termin,deal_id,kid id,amount,sepa_code info',
			] 
		];*/
		var p:Promise<DbData> = cast App.store.dispatch(CRUD.read(
			{
				classPath:'data.DirectDebits',
				action:'getHistory',
				/*dataSource: [					
					'booking_requests'=> [
						'alias' => 'bor',
						'fields'=>'termin,id,mandat_id deal_id,betrag amount,cast(id as text) info,mandator'				
					],
					'debit_return_statements' =>[
						'alias'=>'drs',
						'fields'=>'value_date termin,kid id,deal_id,amount,sepa_code info,mandator',
					]
				],*/
				dbRelations:[
					{
						table:'booking_requests',
						jType: UNION,
						fields:'termin,id,mandat_id deal_id,betrag amount,cast(id as text) info,mandator' 
					},
					{
						table:'debit_return_statements',
						fields:'value_date termin,kid id,deal_id,amount,sepa_code info,mandator'
					},
				],
				//fields:'',
				filter:filter,//(props.match.params.id!=null?{id:props.match.params.id, mandator:'1'}:{mandator:'1'}),				
				//table:'booking_requests',
				limit:props.limit,
				offset:offset>0?offset:0,
				order: 'termin| ASC',
				resolveMessage:{					
					success:'Buchungen wurden geladen',
					failure:'Keine Buchungen',
					failureClass:''
				},
				dbUser:props.userState.dbUser,
				devIP: App.devIP
			}
		));
		p.then(function(data:DbData){
			trace(data.dataRows.length); 
			if(data.dataRows.length>0)
			trace(data.dataRows[data.dataRows.length-1]); 
			//setState({loading:false, dbTable:data.dataRows});
			setState({
				loading:false,
				dbTable:data.dataRows,
				dataCount:Std.parseInt(data.dataInfo['count']),
				pageCount: Math.ceil(Std.parseInt(data.dataInfo['count']) / props.limit)
			});			
		},function(data:Dynamic) {
			trace(data);
			setState({
				loading:false
			});
		});
	}

	public function delete(ev:ReactEvent):Void
	{
		trace(state.selectedRows.length);
		var data = state.formApi.selectedRowsMap(state);
		trace(data);
	}

	public function processReturnDebitStatements(_):Void
	{
		trace(state.dbTable);
		var p:Promise<DbData> = props.update(
			{
				classPath:'data.DebitReturnStatements',
				action:'insert',
				mandator:1,
				//data: state.dbTable,//Serializer.run(state.dbTable),
				data: Serializer.run(state.dbTable),
				table:'debit_return_statements',
				resolveMessage:{					
					success:'Rücklastschriften wurden verarbeitet',
					failure:'Rücklastschriften konnten nicht verarbeitet werden'
				},
				dbUser:props.userState.dbUser,
				devIP: App.devIP
			}
		);
		p.then(function(data:DbData)
		{			
			trace(Unserializer.run(data.dataInfo['data'])); 
			trace(Utils.getAllByKey(Unserializer.run(data.dataInfo['data']),'id')); 
			//setState({loading:false, dbTable:data.dataRows});
		});
	}	

	public function loadLocal() {
		var finput = cast Browser.document.getElementById('returnDebitFile');
		//var files = php.Lib.hashOfAssociativeArray(finput.files);
		
		trace(finput.files);
		trace(Reflect.fields(finput));
		js.Syntax.code("console.log({0})",finput.files);
		trace(finput.value);				
	}

	override function render():ReactFragment
	{
		//if(state.dbTable != null)	trace(state.dbTable[0]);
		trace(props.match.params.section);	
		if(state.sideMenu.menuBlocks == null)	{
			return renderResults();
		}

		return state.formApi.render(jsx('
		<>
			<form className="tabComponentForm"  >
				${renderResults()}
			</form>
		</>'));		
	}
	
	function renderResults():ReactFragment
	{
		trace(props.match.params.action + ':' + Std.string(state.dbTable != null));
		if(state.loading)
			return state.formApi.renderWait();
		trace('###########loading:' + state.loading +' state.action:' + state.action);
		return switch(state.action)
		{
			case 'get' :		
				if(state.dbTable == null || state.dbTable.length==0)	
					null;
				else 
				jsx('				
				<Grid id="rDebitList" data=${state.dbTable}
				${...props} dataState = ${dataDisplay["rDebitList"]} 
				parentComponent=${this} className="is-striped is-hoverable" fullWidth=${true}/>			
				');		
			case 'getHistory':	
				if(state.dbTable == null || state.dbTable.length==0)	
					null;
				else 			
				jsx('				
				<Grid id="rDebitList" data=${state.dbTable} title="Verlauf" scrollHeight="15"
				${...props} dataState = ${dataDisplay["historyList"]} 
				parentComponent=${this} className="is-striped is-hoverable" fullWidth=${true}/>		
				');						
			default:
				state.data==null?null:
				jsx('<div className="hint">${state.data.get('hint')}</div>');				
		}
	}	
}