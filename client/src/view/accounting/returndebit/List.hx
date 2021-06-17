package view.accounting.returndebit;

import db.DbRelation;
import haxe.Serializer;
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

@:connect
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

	public function new(props) 
	{
		super(props);
		_instance = this;
		//dataDisplay = ReturnDebitModel.dataGridDisplay;
		dataDisplay = ReturnDebitModel.listReturnDebitsDisplay;
		
		//trace('...' + Reflect.fields(props));
		//baseForm =new BaseForm(this);
		
		state =  App.initEState({
			action:(props.match.params.action==null?'listReturnDebit':props.match.params.action),
			loading:true,
			sideMenu:FormApi.initSideMenu2( this,			
				[
					{
						dataClassPath:'admin.Debit',//Rücklastschriften (admin.ImportCamt)
						label:"Liste",
						section: 'List',
						items: List.menuItems
					},
					{
						dataClassPath:'admin.Debit',//admin.ImportCamt
						label:"Dateien",
						section: 'Files',
						items: Files.menuItems
					}

				],
				{	
					section: props.match.params.section==null? 'List':props.match.params.section, 
					sameWidth: true					
				}
			)
		},this);
		if(props.match.params.action==null)
		{
			//var sData = App.store.getState().dataStore.contactData;			
			var baseUrl:String = props.match.path.split(':section')[0];
			trace('redirecting to ${baseUrl}List/listReturnDebit');
			props.history.push('${baseUrl}List/listReturnDebit');
			listReturnDebit(null);
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
	override public function componentDidMount():Void 
	{	
		dataAccess = ReturnDebitModel.dataAccess;
		//trace(props.match.params.action);
		//state.formApi.doAction('get');
		if(props.match.params.action=='listReturnDebit')
			listReturnDebit();
	}

	public function listReturnDebit(?ev:Dynamic):Void
	{
		//trace('hi $ev');
		var offset:Int = 0;
		if(ev != null && ev.page!=null)
		{
			offset = Std.int(props.limit * ev.page);
		}
	
		var dS:db.DataSource = [
			'debit_return_statements' => [
				'alias' => 'drs',
				'fields' => 'id,sepa_code,iban,ba_id,amount,mandator,last_modified,processed,created_at,value_date',
				//	TODO: BUILD FILTER FUNCTION
				//'filter' => (props.match.params.id!=null?{id:props.match.params.id, mandator:'1'}:{mandator:'1'}),
			],				
			'booking_requests' => [
				'fields' => 'zahlpfl_name,mandat_id',
				'jCond' => 'drs.ba_id=ref_id'
			],
			'sepa_return_codes' => [
				'fields' => 'description',
				'jCond' => 'drs.sepa_code=code'
			]
		];
		var params:Dynamic = {		
			dbUser:props.userState.dbUser,
			devIP: App.devIP,
			jwt:props.userState.dbUser.jwt,
			classPath:'data.DebitReturnStatements',
			action:'get',				
			dataSource:Serializer.run(dS),
			limit:props.limit,
			resolveMessage:{					
				success:'Rücklastschriften wurde geladen',
				failure:'Rücklastschriften konnte nicht geladen werden'
			},			
			offset:(offset>0?offset:0),
			joinID:'drs.id'
		};
		var p:Promise<DbData> = props.load(params);		
		p.then(function(data:DbData){			
			//trace(data.dataRows.length); 
			if(data.dataRows.length>0)
				trace(data.dataRows[0]); 
			setState({
				loading:false,
				dataTable:data.dataRows,
				dataCount:Std.parseInt(data.dataInfo['count']),
				pageCount: Math.ceil(Std.parseInt(data.dataInfo['count']) / props.limit)
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
		trace(state.dataTable);
		var p:Promise<DbData> = props.update(
			{
				classPath:'data.DebitReturnStatements',
				action:'insert',
				mandator:1,
				//data: state.dataTable,//Serializer.run(state.dataTable),
				data: Serializer.run(state.dataTable),
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
			//setState({loading:false, dataTable:data.dataRows});
		});
	}	

	override function render():ReactFragment
	{
		//if(state.dataTable != null)	trace(state.dataTable[0]);
		//trace(props.match.params.section);		
		return state.formApi.render(jsx('
		<>
			<form className="tabComponentForm2"  >
				${renderResults()}
			</form>
		</>'));		
	}
	
	function renderResults():ReactFragment
	{
		//trace(props.match.params.action + ':' + Std.string(state.dataTable != null));
		if(state.loading)
			return state.formApi.renderWait();
		//trace('###########loading:' + state.loading +' state.action:' + state.action);
		return switch(state.action)
		{
			case 'listReturnDebit':				
				jsx('				
				<Grid id="returnDebitList" data=${state.dataTable}
				${...props} dataState = ${dataDisplay["rDebitData"]} 
				parentComponent=${this} className="is-striped is-hoverable" fullWidth=${true}/>			
				');		
			default:
				state.data==null?null:
				jsx('<div className="hint">${state.data.get('hint')}</div>');				
		}
	}	
}