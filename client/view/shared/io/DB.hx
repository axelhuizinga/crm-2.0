package view.shared.io;

import js.html.AreaElement;
import haxe.Json;
import haxe.Unserializer;
import haxe.ds.Map;
import haxe.io.Bytes;
import haxe.http.HttpJs;
import js.html.XMLHttpRequest;
import hxbit.Serializer;
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
import view.dashboard.model.DBFormsModel;
import view.shared.FormField;
import view.shared.OneOf;
import view.shared.SMenu;
import view.shared.SMItem;
import view.shared.io.DataAccess;
import view.shared.io.FormFunctions;
import view.shared.io.Loader;
import view.table.Table;
import view.table.Table.DataState;


/**
 * ...
 * @author axel@cunity.me
 */

class DB extends ReactComponentOf<DataFormProps,FormState> 
{
	var dataDisplay:Map<String,DataState>;
	var dataAccess:DataAccess;
	public function new(?props) 
	{
		super(props);

		dataDisplay = DBFormsModel.dataDisplay;
		//var sideMenu = updateMenu('DB'); //state.sideMenu;
		//state = {hasError:false, sideMenu:updateMenu('DB')};		
		state = App.initEState(this);
	}
	
	public static var menuItems:Array<SMItem> = [
		{label:'Create Fields Table',action:'createFieldList'},
		{label:'Table Fields',action:'showFieldList'},
		{label:'Bearbeiten',action:'editTableFields'},
		{label:'Speichern', action:'save'},
		{label:'Löschen',action:'delete'}
	];
	
	public function createFieldList(ev:ReactEvent):Void
	{
		trace('hi :)');
		props.formFunctions.requests.push(Loader.load(	
			'${App.config.api}', 
			{
				user_name:props.user.user_name,
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
				//setState({data:data, viewClassPath:'shared.io.DB.showFieldList'});
				setState({data:data});
		}));
		trace(props.history);
		trace(props.match);
		//setState({viewClassPath:viewClassPath});
	}
	
	public function editTableFields(ev:ReactEvent):Void
	{
		trace(state.selectedRows.length);
		var data = props.formFunctions.selectedRowsMap(state);
		var view:Map<String,FormField> = dataAccess['editTableFields'].view.copy();
		trace(dataAccess['editTableFields'].view['table_name']);
		trace(data[0]['id']+'<');
		props.formFunctions.renderModalForm({
			data:new Map(),
			dataTable:data,
			handleSubmit: saveTableFields,
			hasError:false,
			isConnected:true,
			initialState: initStateFromDataTable(data),
			model:'tableFields',
			//viewClassPath:'shared.io.DB.editTableFields',			
			fields:view,
			valuesArray:props.formFunctions.createStateValuesArray(data, dataAccess['editTableFields'].view), 
			loading:false,
			title:'Tabellenfelder Eigenschaften'
		});	
		
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
		requests.push( BinaryLoader.create(
			'${App.config.api}', 
			{
				user_name:props.user_name,
				jwt:props.jwt,
				fields:'readonly:readonly,element=:element,required=:required,use_as_index=:use_as_index',
				className:'tools.DB',
				action:'saveTableFields',
				dbData:s.serialize(dbData),
				devIP:App.devIP
			},
			function(data:DbData)
			{				
				trace(data);
			}
		));*/
	}
	
	public function showFieldList(_):Void
	{
		//trace(state);
		state.formFunctions.selectAllRows(state);
		state.formFunctions.requests.push( BinaryLoader.create(
			'${App.config.api}', 
			{
				user_name:props.user.user_name,
				jwt:props.user.jwt,
				fields:'id,table_name,field_name,readonly,element,required,use_as_index',
				className:'tools.DB',
				action:'createFieldList',
				devIP:App.devIP
			},
			function(data:DbData)
			{
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
		));
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
					'table_name'=>{label:'Tabelle',readonly:true},
					'field_name'=>{label:'Feldname',readonly:true},
					'field_type'=>{label:'Datentyp',type:Select},
					'element'=>{label:'Eingabefeld', type:Select},
					'readonly' => {label:'Readonly', type:Checkbox},
					'required' => {label:'Required', type:Checkbox},
					'use_as_index' => {label:'Index', type:Checkbox},
					'any' => {label:'Eigenschaften', readonly:true, type:Hidden},
					'id' =>{primary:true, type:Hidden}
				]
			},
			'saveTableFields' => {
				source:null,
				view:null
			}
		];			
	}

	/*override public function componentWillUnmount()
	{
		mounted=false;
		props.formFunctions.removeRequest(this)
	}*/
	
	function renderResults():ReactFragment
	{
		if (state.data != null)
		return switch(props.match.params.action)
		{
			case 'showFieldList':
				//trace(dataDisplay["fieldsList"]);
				//trace(state.dataTable[29]['id']+'<<<');
				jsx('
					<Table id="fieldsList" data=${state.dataTable}
					${...props} dataState = ${dataDisplay["fieldsList"]}
					className = "is-striped is-hoverable" fullWidth=${true}/>				
				');	
			case 'editTableFields':
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
		return jsx('
		<>
			<form className="tabComponentForm"  >
				${renderResults()}
			</form>
			<$SMenu className="menu" ${...props.sideMenu} itemHandler=${state.formFunctions.itemHandler} />
		</>');		
	}
	
	function updateMenu(?viewClassPath:String):SMenuProps
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