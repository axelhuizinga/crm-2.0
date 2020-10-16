package view.accounting;

import action.AppAction;
import db.DbQuery.DbQueryParam;
import redux.Redux.Dispatch;
import action.async.CRUD;
import js.lib.Promise;
import action.async.DBAccessProps;
import action.async.LivePBXSync;
import state.AppState;
import haxe.ds.Map;
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
import view.accounting.model.ReturnDebitModel;
import view.table.Table.DataState;
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
class Import extends ReactComponentOf<DataFormProps,FormState>
{

	static var _instance:Import;

	public static var menuItems:Array<MItem> = [		
		
		{label:'Kontoauszug Import ',action:'importCamt'},
		{label:'Speichern', action:'save'},
		{label:'Löschen',action:'delete'}
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
		dataDisplay = ReturnDebitModel.dataDisplay;
		dataAccess = ReturnDebitModel.dataAccess(props.match.params.action);
		formFields = ReturnDebitModel.formFields(props.match.params.action);
		trace('...' + Reflect.fields(props));
		state =  App.initEState({
			sideMenu:FormApi.initSideMenu2( this,
			[
				{
					dataClassPath:'admin.ImportCamt',
					label:"Import RüLa's",
					section: 'DBSync',
					items: ReturnDebit.menuItems
				}
			],
			{	
				section: props.match.params.section==null? 'DBSync':props.match.params.section, 
				sameWidth: true}					
			)
		},this);
			/*loading:false,
			dataTable:[],
			formBuilder:new FormBuilder(this),
			actualState:{
				edited_by: props.userState.dbUser.id,
				mandator: props.userState.dbUser.mandator
			},
			initialState:{
				edited_by: props.userState.dbUser.id,
				mandator: props.userState.dbUser.mandator
			},values:new Map<String,Dynamic>()},this);
		trace(state.loading);*/

	}

	static function mapStateToProps(aState:AppState) 
	{
		return {
			userState:aState.userState
		};
	}

	static function mapDispatchToProps(dispatch:Dispatch) {
        return {
			load: function(param:DbQueryParam) return dispatch(CRUD.update(param))			
        }
	}	
	
	public function delete(ev:ReactEvent):Void
	{
		trace(state.selectedRows.length);
		var data = state.formApi.selectedRowsMap(state);
		trace(data);
	}

	public function importCamt(_):Void
	{
		trace(props.userState.dbUser.first_name);
		setState({loading:true});
		doSyncAll(			
		{
			classPath:'admin.SyncExternalAccounts',
			action:'syncAll',
			extDB: true,
			filter:{mandator:'1'},
			limit:1000,
			offset:0,
			table:'accounts',
			dbUser:props.userState.dbUser,
			devIP:App.devIP,
			maxImport:4000,
			//relations:new Map()
		});
	}

	function doSyncAll(dbQueryParam:DbQueryParam) {
		
		var p:Promise<DbData> = props.load(dbQueryParam);
		p.then(function(data:DbData){
			if(data.dataInfo['offset']==null)
			{
				return App.store.dispatch(Status(Update(
				{
					cssClass:'error',
					text:'Fehler 0 ${data.dataInfo['classPath']} Aktualisiert'}
				)));
			}					
			var offset = Std.parseInt(data.dataInfo['offset']);
			App.store.dispatch(Status(Update(
				{
					cssClass:' ',
					text:'${offset} ${dbQueryParam.classPath} von ${data.dataInfo['maxImport']} aktualisiert'
				}
			)));

			trace('${offset} < ${data.dataInfo['maxImport']}');
			if(offset < data.dataInfo['maxImport']){
				//LOOP UNTIL LIMIT
				trace('next loop:${data.dataInfo}');
				return doSyncAll(cast data.dataInfo);
			}					
			else{
				setState({loading:false});
				return App.store.dispatch(Status(Update(
					{
						cssClass:' ',
						text:'${offset} ${dbQueryParam.classPath} von ${data.dataInfo['maxImport']} aktualisiert'
					}
				)));
			}

		});//*/
		return p;
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
		trace(state.loading);
		if(state.loading)
			return state.formApi.renderWait();
		trace('###########loading:' + state.loading);
		return switch(props.match.params.action)
		{
			/*case 'showUserList':
				jsx('
					<Table id="fieldsList" data=${state.dataTable}
					${...props} dataState = ${dataDisplay["userList"]} 
					className="is-striped is-hoverable" fullWidth=${true}/>
				');*/
			case 'importClientList':
				//trace(initialState);
				trace(state.actualState);
				/*var fields:Map<String,FormField> = [
					for(k in dataAccess['update'].view.keys()) k => dataAccess['update'].view[k]
				];*/
				(state.actualState==null ? state.formApi.renderWait():
				state.formBuilder.renderForm({
					mHandlers:state.mHandlers,
					fields:formFields,/*[
						for(k in dataAccess['update'].view.keys()) k => dataAccess['update'].view[k]
					],*/
					model:'importClientList',
					//ref:formRef,
					title: 'Stammdaten Import' 
				},state.actualState));	
			/*case 'showFieldList2':
				trace(dataDisplay["fieldsList"]);
				trace(state.dataTable[29]['id']+'<<<');
				jsx('
					<Table id="fieldsList" data=${state.dataTable}
					${...props} dataState = ${dataDisplay["fieldsList"]} 
					className="is-striped is-hoverable" fullWidth=${true}/>				
				');	*/
			case 'shared.io.DB.editTableFields':
				null;
			default:
				null;
		}
		return null;
	}	
}