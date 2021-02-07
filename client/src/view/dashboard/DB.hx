package view.dashboard;
import action.AppAction;
import action.StatusAction;
import db.DBAccessProps;
import state.AppState;
import js.html.AreaElement;
import haxe.Json;
import haxe.Unserializer;
import haxe.ds.Map;
import haxe.io.Bytes;
import haxe.http.HttpJs;
import js.html.XMLHttpRequest;
import hxbit.Serializer;
import loader.ConfigLoader;
import json2object.JsonParser;
import js.html.FormData;
import js.html.FormDataIterator;
import js.html.HTMLCollection;
import js.lib.Promise;
import me.cunity.debug.Out;
import react.ReactComponent;
import react.ReactEvent;
import react.ReactMacro.jsx;
import shared.DbData;
import shared.DbDataTools;
import shared.DBMetaData;
import react.ReactUtil;
import state.FormState;
import view.dashboard.model.DBFormsModel;
import view.shared.FormField;
import view.shared.FormBuilder;
import view.shared.OneOf;
import view.shared.Menu;
import view.shared.MItem;
import view.shared.MenuProps;

import view.shared.io.DataAccess;
import view.shared.io.DataFormProps;
import view.shared.io.FormApi;
import view.shared.io.Loader;
import view.table.Table;
import view.table.Table.DataState;


/**
 * ...
 * @author axel@cunity.me
 */
@:connect
class DB extends ReactComponentOf<DataFormProps,FormState> 
{
	var dataDisplay:Map<String,DataState>;
	var dataAccess:DataAccess;
	public function new(props) 
	{
		super(props);
		trace('action:' + props.match.params.action);

		dataDisplay = null;//DBFormsModel.dataDisplay;
		//var sideMenu = updateMenu('DB'); //state.sideMenu;
		//state = {hasError:false, sideMenu:updateMenu('DB')};		
		state = {formApi:new FormApi(this), hasError:false, sideMenu:props.sideMenu};		
	}
	
	public static var menuItems:Array<MItem> = [		
		{label:'getView',action:'getView'},
		{label:'setView',action:'setView'},
		{label:'Formulare',action:'listForms'},
		//{label:'Create Fields Table',action:'createFieldList'},
		{label:'Bearbeiten',action:'edit'},
		{label:'Speichern', action:'save'},
		{label:'Löschen',action:'delete'}
	];
	
	static function mapStateToProps(aState:AppState) 
	{
		return {
			userState:aState.userState
		};
	}	

	public function createFieldList(ev:ReactEvent):Void
	{
		trace('hi :)');
		state.formApi.requests.push(Loader.load(	
			'${App.config.api}', 
			{
				id:props.userState.dbUser.id,
				jwt:props.userState.dbUser.jwt,
				classPath:'tools.DB',
				action:'createFieldList',
				update:'1'
			},
			function(data:Map<String,String>)
			{
				trace(data);
				//UserAccess.jwtCheck()
				if (data.exists('error'))
				{
					trace(data['error']);
					return;
				}				 
				//setState({data:data, viewClassPath:'shared.io.DB.showFieldList'});
				setState({data:data});
		}));
		trace(props.history);
		trace(props.match);
		//setState({viewClassPath:viewClassPath});
	}
	public function setView():Void{

	}
	public function getView():Void
	{
		App.store.dispatch(Status(Update(
		{
			className:'',
			text:'Load deals.DealsModel'}
		)));

		var pro:Promise<Dynamic> = new Promise<DbData>(function(resolve, reject){
			if (!props.userState.dbUser.online)
			{
				reject(DbDataTools.create(['LoginError'=>'Du musst dich neu anmelden!']));

			}				
			trace('creating ConfigLoader ${App.config.api}');
			ConfigLoader.go(App.config.api,{
				limit:100,
				userState:props.userState,
				//offset:0,
				classPath:'tools.Jsonb',
				action:'getView'
			},function (res:DBAccessJsonResponse) {
				trace(res);
			});
		});

		pro.then(function(jsonData:String) {
			trace(jsonData);
			var parser = new JsonParser<BaseView>();

			var dA:BaseView = parser.fromJson(jsonData);
		},function(whatever:Dynamic) {
			trace(whatever);
		});
	}

	public function createOrUpdateView():Void
	{
		App.store.dispatch(Status(Update(
		{
			className:'',
			text:'Update deals.DealsModel'
		})));
/*
		var pro:Promise<Dynamic> = action.async.LivePBXSync.check({
			limit:100,
			userState:props.userState,
			offset:0,
			//onlyNew: true,
			classPath:'tools.Jsonb',
			action:'createOrUpdateView'
		});

		pro.then(function(jsonData:String) {
			trace(jsonData);
			var parser = new JsonParser<BaseView>();
			var dA:DataAccess = parser.fromJson(jsonData, 'parsed.json');
		},function(whatever:Dynamic) {
			trace(whatever);
		});*/
	}
	/**
	 * fields:[
						for(k in dataAccess['open'].view.keys()) k => dataAccess['open'].view[k]
					],
	 * @param ev 
	 */

	public function delete(ev:ReactEvent):Void
	{
		trace(state.selectedRows.length);
		var data = state.formApi.selectedRowsMap(state);
	}

	
	public function editTableFields(ev:ReactEvent):Void
	{
		trace(state.selectedRows.length);
		var data = state.formApi.selectedRowsMap(state);
		var view:Map<String,FormField> = dataAccess['editTableFields'].view.copy();
		trace(dataAccess['editTableFields'].view['table_name']);
		trace(data[0]['id']+'<');
	/*	state.formApi.renderModalForm({
			data:new Map(),
			dataTable:data,
			mHandlers: saveTableFields,
			hasError:false,
			isConnected:true,
			initialState: initStateFromDataTable(data),
			model:'tableFields',
			//viewClassPath:'shared.io.DB.editTableFields',			
			fields:view,
			valuesArray:state.formApi.createStateValuesArray(data, dataAccess['editTableFields'].view), 
			loading:false,
			title:'Tabellenfelder Eigenschaften'
		});	*/
		
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
				if(dataDisplay['fieldsList'].columns[k].cellFormat == DBFormsModel.formatBool)
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
	
	public function saveTableFields(vA:Dynamic):Void
	{
		trace(vA);
		//Out.dumpObject(vA);
		/*dbMetaData = new  DBMetaData();
		dbMetaData.dataFields = dbMetaData.stateToDataParams(vA);
		trace(dbMetaData.dataFields.get(111));
		var s:hxbit.Serializer = new hxbit.Serializer();
		
		return;
		requests.push( BinaryLoader.insert(
			'${App.config.api}', 
			{
				id:props.id,
				jwt:props.jwt,
				fields:'disabled:disabled,element=:element,required=:required,use_as_index=:use_as_index',
				classPath:'tools.DB',
				action:'saveTableFields',
				dbData:s.serialize(dbData),
				devIP:App.devIP
			},
			function(data:DbData)
			{			
				UserAccess.jwtCheck(data);	
				trace(data);
			}
		));*/
	}
	
	public function showFieldList(_):Void
	{
		//state.formApi.selectAllRows(state);
		state.formApi.requests.push( /*BinaryLoader.insert(
			'${App.config.api}', 
			{
				id:props.userState.dbUser.id,
				jwt:props.userState.dbUser.jwt,
				fields:'id,table_name,field_name,disabled,element,required,use_as_index',
				classPath:'tools.DB',
				action:'createFieldList',
				devIP:App.devIP
			},
			function(data:DbData)
			{
				UserAccess.jwtCheck(data);
				if (data.dataRows.length==0)
				{
					var error:Map<String,Dynamic> = data.dataErrors;
					var eK:Iterator<String> = error.keys();
					var hasError:Bool = false;
					while (eK.hasNext())
					{
						hasError = true;
						trace(Std.string(error.get(eK.next())));
					}
					if(!hasError){
						trace('Keine Daten!');
					}
					return;
				}		
				trace(data.dataRows);
				//trace(data.dataRows[29]['id'] + '<<<');
				//setState({dataTable:data.dataRows, viewClassPath:'shared.io.DB.showFieldList'});
				setState({dataTable:data.dataRows});
			}
		)*/null);
		//setState({viewClassPath:'shared.io.DB.showFieldList'});
	}
	
	override public function componentDidMount():Void 
	{		
		trace('Ok');
		dataAccess = [
			'editTableFields' =>{
				source:[
					"selectedRows" => null//selectedRowsMap()
				],
				view:[
					'table_name'=>{label:'Tabelle',disabled:true},
					'field_name'=>{label:'Feldname',disabled:true},
					'field_type'=>{label:'Datentyp',type:Select},
					'element'=>{label:'Eingabefeld', type:Select},
					'disabled' => {label:'Readonly', type:Checkbox},
					'required' => {label:'Required', type:Checkbox},
					'use_as_index' => {label:'Index', type:Checkbox},
					'any' => {label:'Eigenschaften', disabled:true, type:Hidden},
					'id' =>{primary:true, type:Hidden}
				]
			},
			'saveTableFields' => {
				source:null,
				view:null
			}
		];		
		//state.formApi.doAction();	
	}

	/*override public function componentWillUnmount()
	{
		mounted=false;
		state.formApi.removeRequest(this)
	}*/
	
	function renderResults():ReactFragment
	{
		if (state.dataTable != null)
		return switch(props.match.params.action)
		{
			case 'showFieldList':
				//trace(dataDisplay["fieldsList"]);
				trace(state.dataTable[29]['id']+'<<<');
				jsx('
					<Table id="fieldsList" data=${state.dataTable}
					${...props} dataState = ${dataDisplay["fieldsList"]}
					className = "is-striped is-hoverable" fullWidth=${true}/>				
				');	
			case 'editForm':
				null;
			default:
				null;
		}
		return null;
	}
	
	override function render():ReactFragment
	{
		if(state.values != null)
			trace(state.values);
		trace(props.match.params.section);
		//return null;<form className="form60"></form>	
		
		return state.formApi.render(jsx('
			<form className="tabComponentForm" >
				<div className="caption">DB</div>
				${renderResults()}
			</form>
		'));		
	}
	
	function updateMenu(?viewClassPath:String):MenuProps
	{
		//trace('${Type.getClassName(Type.getClass(this))} task');
		var sideMenu = state.sideMenu;
		//sideMenu.menuBlocks['DB'].handlerInstance = this;
		for(mI in sideMenu.menuBlocks['DB'].items)
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