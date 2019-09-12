package view.dashboard;
import action.async.DBAccessProps;
import action.async.LivePBXSync;
import state.AppState;
import haxe.ds.Map;
import loader.BinaryLoader;
import me.cunity.debug.Out;
import react.ReactComponent;
import react.ReactEvent;
import react.ReactMacro.jsx;
import react.ReactUtil;
import shared.DbData;
import view.shared.FormBuilder;
import view.shared.SMItem;
import view.shared.SMenuProps;
import view.dashboard.model.DBSyncModel;
import view.shared.io.BaseForm;



/**
 * ...
 * @author axel@cunity.me
 */
@:connect
class DBSync extends BaseForm
{

	static var _instance:DBSync;

	public static var menuItems:Array<SMItem> = [
		{label:'BenutzerDaten Abgleich',action:'showUserList'},
		{label:'Stammdaten Import ',action:'importAll'},
		{label:'Speichern', action:'save'},
		{label:'Löschen',action:'delete'}
	];
	

	public function new(props) 
	{
		super(props);
		initialState = {
			edited_by: props.user.id,
			mandator: props.user.mandator
		}
		dataDisplay = DBSyncModel.dataDisplay;
		dataAccess = DBSyncModel.dataAccess(props.match.params.action);
		formFields = DBSyncModel.formFields(props.match.params.action);
		trace('...' + Reflect.fields(props));
		state =  App.initEState({
			loading:false,
			dataTable:[],
			formBuilder:new FormBuilder(this),
			initialState:initialState,values:new Map<String,Dynamic>()},this);
		trace(state.loading);
		actualState = initialState;
		//trace(props.sideMenu);
		//trace(state.sideMenu);
		//var sideMenu =  updateMenu('DBSync');//state.sideMenu;
		//trace(sideMenu.section);

	}
	
	static function mapStateToProps(aState:AppState) 
	{
		return {
			user:aState.user
		};
	}
	
	public function createFieldList(ev:ReactEvent):Void
	{
		trace('hi :)');
		return;
		/*props.formApi.requests.push(Loader.load(	
			'${App.config.api}', 
			{
				id:props.user.id,
				jwt:props.user.jwt,
				className:'tools.DB',
				action:'createFieldList',
				update:'1'
			},
			function(data:Map<String,String>)
			{
				trace(data);
				if (data.exists('error'))
				{
					trace(data['error']);
					return;
				}				 
				setState({data:data});
		}));*/
		trace(props.history);
		trace(props.match);
		//setState({viewClassPath:viewClassPath});
	}
	
	public function editTableFields(ev:ReactEvent):Void
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
				if(dataDisplay['fieldsList'].columns[k].cellFormat == DBSyncModel.formatBool)
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
		var s:hxbit.Serializer = new hxbit.Serializer();*/
		
		return;
		props.formApi.requests.push( /*BinaryLoader.insert(
			'${App.config.api}', 
			{
				id:props.user.id,
				jwt:props.user.jwt,
				fields:'disabled:disabled,element=:element,required=:required,use_as_index=:use_as_index',
				className:'tools.DB',
				action:'saveTableFields',
				dbData:s.serialize(dbData),
				devIP:App.devIP
			},
			function(data:DbData)
			{		
				UserAccess.jwtCheck(data);		
				trace(data);
			}
		)*/null);
	}
	
	public function importAll(_):Void
	{
		action.async.LivePBXSync.syncAll({
				batchCount: 0,
				batchSize: 100,
				user:props.user,
				className:'admin.SyncExternal',
				action:'syncAll'
			});
	}

	public function showUserList(_):Void
	{
		//FormApi.requests.push( 
		trace(App.config.api);
		BinaryLoader.create(
			//'${App.config.api}', 
			'https://pitverwaltung.de/sync/proxy.php', 
			{
				id:props.user.id,
				jwt:props.user.jwt,
				fields:'id,table_name,field_name,disabled,element,required,use_as_index',
				className:'admin.SyncExternal',
				action:'syncUserDetails',
				target: 'syncUsers.php',
				devIP:App.devIP
			},
			function(data:DbData)
			{
				//UserAccess.jwtCheck(data);
				//trace(data);
				//trace(data.dataRows[data.dataRows.length-2]['phone_data']);
				trace(data.dataRows.length);
				if(data.dataRows.length>0)
				setState({dataTable:data.dataRows});
			}
		);
	}
	
	override public function componentDidMount():Void 
	{				
		//
		if(props.user != null)
		trace('yeah: ${props.user.first_name}');
	}

	override function go(aState:Dynamic)
	{
		trace(Reflect.fields(aState));
		var dbaProps:DBAccessProps = 
		{
			action:props.match.params.action,
			className:'data.Contacts',
			dataSource:null,
			table:'contacts',
			user:props.user
		};
		switch (props.match.params.action)
		{
			case 'insert':
				for(f in fieldNames)
				{
					trace('$f =>${Reflect.field(aState,f)}<=');
					if(Reflect.field(aState,f)=='')
						Reflect.deleteField(aState,f);
				}
				Reflect.deleteField(aState,'id');
				Reflect.deleteField(aState,'creation_date');				
				dbaProps.dataSource = [
					"contacts" => [
						"data" => aState,
						"fields" => Reflect.fields(aState).join(',')
					]
				];
			case 'delete'|'get':
			//#
		}
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
				trace(actualState);
				/*var fields:Map<String,FormField> = [
					for(k in dataAccess['update'].view.keys()) k => dataAccess['update'].view[k]
				];*/
				(actualState==null ? state.formApi.renderWait():
				state.formBuilder.renderForm({
					handleSubmit:handleSubmit,
					fields:formFields,/*[
						for(k in dataAccess['update'].view.keys()) k => dataAccess['update'].view[k]
					],*/
					model:'importClientList',
					//ref:formRef,
					title: 'Stammdaten Import' 
				},actualState));	
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
	
	
	function updateMenu(?viewClassPath:String):SMenuProps
	{
		var sideMenu = state.sideMenu;
		trace(sideMenu.section);
		//sideMenu.menuBlocks['DBSync'].handlerInstance = this;
		for(mI in sideMenu.menuBlocks['DBSync'].items)
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