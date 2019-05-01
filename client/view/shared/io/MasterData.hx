package view.shared.io;

import haxe.DynamicAccess;
import model.AppState;
import haxe.Constraints.Function;
import js.html.AreaElement;
import haxe.Json;
import haxe.Unserializer;
import haxe.ds.Map;
import haxe.io.Bytes;
import hxbit.Serializer;
import js.html.Event;
import js.html.FormData;
import js.html.FormDataIterator;
import js.html.HTMLCollection;
import me.cunity.debug.Out;
import react.ReactComponent;
import react.ReactEvent;
import react.ReactMacro.jsx;
import react.ReactUtil;
import shared.DbData;
import shared.DBMetaData;
import view.model.ContactORM;
import view.shared.FormField;
import view.shared.FormState;
import view.shared.SMItem;
import view.shared.io.FormApi;
import view.shared.io.DataFormProps;
import view.shared.io.DataAccess;
import view.shared.io.Loader;
import view.table.Table;


/**
 * ...
 * @author axel@cunity.me
 */
@:connect
class MasterData extends ReactComponentOf<DataFormProps,FormState>
{

	static var _instance:DBSync;

	public static var menuItems:Array<SMItem> = [
		{label:'Anzeigen',action:'find'},
		{label:'Bearbeiten',action:'edit'},
		//{label:'Finden',action:'find'},
		{label:'Neu', action:'add'},
		{label:'Löschen',action:'delete'}
	];
	
	var dataDisplay:Map<String,DataState>;
	var dataAccess:DataAccess;	
	var dbData: shared.DbData;
	var dbMetaData:shared.DBMetaData;
	public function new(props) 
	{
		super(props);
		dataDisplay = ContactORM.dataDisplay;
		/*dataDisplay = [
			'contactList' => {columns:[
				'first_name'=>{label:'Vorname', flexGrow:0},
				'last_name'=>{label:'Name', flexGrow:0},
				'email'=>{label:'Email'},
				'phone_number'=>{label:'Telefon', flexGrow:1},		
				'state' => {label:'Aktiv', className:'cRight', 
					cellFormat:function(v:String) return (v=='active'?'J':'N')},
				'id' => {show:false}
			]},
			'dealList' => {columns: [
				'user_group' => {label:'UserGroup', flexGrow:0},
				'group_name'=>{label:'Beschreibung', flexGrow:1},
				'allowed_campaigns'=>{label:'Kampagnen',flexGrow:1}
			]}
		];*/
		//dataDisplay = ContactModel.dataDisplay;
		trace('...' + Reflect.fields(props));
		state =  App.initEState({loading:false,values:new Map<String,Dynamic>()},this);
		trace(state.loading);
		//trace(props.sideMenu);
		//trace(state.sideMenu);
		//var sideMenu =  updateMenu('DBSync');//state.sideMenu;
		//trace(sideMenu.section);

	}
	
	static function mapStateToProps(aState:AppState) 
	{
		return {
			user:aState.appWare.user
		};
	}
	
	public function find(ev:ReactEvent):Void
	{
		trace('hi :)');
		//return;
		//dbMetaData = new  DBMetaData();
		//dbMetaData.dataFields = dbMetaData.stateToDataParams(vA);
		//trace(dbMetaData.dataFields.get(111));
		var s:hxbit.Serializer = new hxbit.Serializer();
		
		//return;
		state.formApi.requests.push( BinaryLoader.create(
			'${App.config.api}', 
			{
				user_name:props.user.user_name,
				jwt:props.user.jwt,
				//fields:'readonly:readonly,element=:element,required=:required,use_as_index=:use_as_index',
				className:'contacts.Contact',
				action:'find',
				//dataSource:Serializer.run(dataAccess['find'].source),
				devIP:App.devIP
			},
			function(data:DbData)
			{			
				App.jwtCheck(data);
				trace(data.dataInfo);
				if(data.dataRows.length>0)
				setState({dataTable:data.dataRows});
			}
		));
		/*
		state.formApi.requests.push(Loader.load(	
			'${App.config.api}', 
			{
				user_name:props.user.user_name,
				jwt:props.user.jwt,
				className:'contacts.Contact',
				action:'find',
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
		}));
		trace(props.history);
		trace(props.match);
		//setState({viewClassPath:viewClassPath});*/
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
	
	public function saveTableFields(vA:Dynamic):Void
	{
		trace(vA);
		//Out.dumpObject(vA);
		dbMetaData = new  DBMetaData();
		dbMetaData.dataFields = dbMetaData.stateToDataParams(vA);
		trace(dbMetaData.dataFields.get(111));
		var s:hxbit.Serializer = new hxbit.Serializer();
		
		return;
		props.formApi.requests.push( BinaryLoader.create(
			'${App.config.api}', 
			{
				user_name:props.user.user_name,
				jwt:props.user.jwt,
				fields:'readonly:readonly,element=:element,required=:required,use_as_index=:use_as_index',
				className:'tools.DB',
				action:'saveTableFields',
				dbData:s.serialize(dbData),
				devIP:App.devIP
			},
			function(data:DbData)
			{	
				App.jwtCheck(data);			
				trace(data);
			}
		));
	}
	
	public function importClientList(_):Void
	{
		//FormApi.requests.push( 
		BinaryLoader.create(
			'${App.config.api}', 
			{
				user_name:props.user.user_name,
				jwt:props.user.jwt,
				fields:'id,table_name,field_name,readonly,element,required,use_as_index',
				className:'admin.SyncExternalClients',
				action:'importClientDetails',
				devIP:App.devIP
			},
			function(data:DbData)
			{
				trace(data);
				App.jwtCheck(data);
				//trace(data.dataRows[data.dataRows.length-2]['phone_data']);
				trace(data.dataErrors.keys().hasNext());
				if(!data.dataErrors.keys().hasNext())
				{
					setState({values: ['loadResult'=>'Verarbeite Importdaten...','closeAfter'=>8000]});
				}
				else 
					setState({values: ['loadResult'=>'Kein Ergebnis','closeAfter'=>-1]});
			}
		);
		trace('setState loading true => ${state.loading}');
		setState({loading: true});
	}

	public function showUserList(_):Void
	{
		//FormApi.requests.push( 
		trace(App.config.api);
		BinaryLoader.create(
			'${App.config.api}', 
			//'https://pitverwaltung.de/sync/proxy.php', 
			{
				user_name:props.user.user_name,
				jwt:props.user.jwt,
				fields:'id,table_name,field_name,readonly,element,required,use_as_index',
				className:'admin.SyncExternal',
				action:'syncUserDetails',
				target: 'syncUsers.php',
				devIP:App.devIP
			},
			function(data:DbData)
			{
				App.jwtCheck(data);
				trace(data);
				//trace(data.dataRows[data.dataRows.length-2]['phone_data']);
				trace(data.dataRows.length);
				if(data.dataRows.length>0)
				setState({dataTable:data.dataRows});
			}
		);
	}
	
	override public function componentDidMount():Void 
	{	
		dataAccess = [
			'find' =>{
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
			case 'find':
				jsx('
					<Table id="fieldsList" data=${state.dataTable}
					${...props} dataState = ${dataDisplay["contactList"]} 
					className="is-striped is-hoverable" fullWidth=${true}/>
				');
			case 'edit':
				jsx('
					<Table id="fieldsList" data=${state.dataTable}
					${...props} dataState = ${dataDisplay["clientList"]} 
					className="is-striped is-hoverable" fullWidth=${true}/>
				');			
			case 'add':
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
		//return null;<form className="form60"></form>	
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