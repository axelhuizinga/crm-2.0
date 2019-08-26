package view.data.contacts;
import haxe.ds.IntMap;
import action.AppAction;
import action.async.DataAction;
import shared.DBAccess;
import js.html.HTMLOptionsCollection;
import js.html.HTMLPropertiesCollection;
import me.cunity.debug.Out.DebugOutput;
import js.html.Document;
import js.Browser;
import js.html.Window;
import js.html.HTMLCollection;
import js.html.HTMLFormControlsCollection;
import js.html.SelectElement;
import haxe.macro.Type.Ref;
import js.html.InputElement;
import react.React;
import js.html.Element;
import js.html.Event;
import js.html.FormElement;
import react.router.RouterMatch;
import state.AppState;
import haxe.Constraints.Function;
import react.ReactComponent;
import react.ReactEvent;
import react.ReactRef;
import react.ReactMacro.jsx;
import react.ReactUtil.copy;
import shared.DbData;
import shared.DBMetaData;
import view.shared.FormBuilder;
import view.shared.FormField;
import view.shared.FormState;
import view.data.contacts.model.ContactsModel;
import view.shared.SMItem;
import view.shared.SMenuProps;
import view.shared.io.FormApi;
import view.shared.io.DataFormProps;
import view.shared.io.DataAccess;
import loader.BinaryLoader;
import view.table.Table;
import model.Contact;

using  shared.Utils;
using Lambda;
/*
 * GNU Affero General Public License
 *
 * Copyright (c) 2019 ParadiseProjects.de
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as published
 * by the Free Software Foundation::,\n either version 3 of the License:, or
 * (at your option) any later version.
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 * 
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */


/**
 * 
 */

class Edit extends ReactComponentOf<DataFormProps,FormState>
{
	public static var menuItems:Array<SMItem> = [
		{label:'Auswahl',action:'show',section: 'List'},
		{label:'Bearbeiten',action:'update'},
		{label:'Neu', action:'create'},
		{label:'Löschen',action:'delete'}
	];
	
	var dataDisplay:Map<String,DataState>;
	var dataAccess:DataAccess;	
	var dbData: shared.DbData;
	var dbMetaData:shared.DBMetaData;

	var formRef:ReactRef<FormElement>;
	var fieldNames:Array<String>;
	var actualState:Contact;
	
	public static var initialState:Contact;

	public function new(props) 
	{
		super(props);
		trace(props.match.params);
		initialState = {
			id:null,//2000328,
			edited_by: props.user.id,
			mandator: props.user.mandator
		};	
		//actualState = copy(initialState);initialState.mandator = props.user.mandator;
		if(props.match.params.id==null && ~/update(\/)*$/.match(props.match.params.action) )
		{
			trace('nothing selected - redirect');
			var baseUrl:String = props.match.path.split(':section')[0];
			props.history.push('${baseUrl}List/show');
			return;
		}		
		dataAccess = ContactsModel.dataAccess;
		fieldNames = new Array();
		for(k in dataAccess['update'].view.keys())
		{
			fieldNames.push(k);
		}	
		dataDisplay = ContactsModel.dataDisplay;
		trace('...' + Reflect.fields(props));
		formRef = React.createRef();
		//var formBuilder = new FormBuilder(this);
		//trace(props.user);
		if(props.match.params.id!=null)
			initialState.id = Std.parseInt(props.match.params.id);
		trace(App.store.getState().dataStore.contactData);
		
		if((initialState.id!=null && App.store.getState().dataStore.contactData.exists(initialState.id)))
		{
			initialState = loadContactData(initialState.id);
			actualState = copy(initialState);
			trace(actualState);		

			//OK we got the data	
		}
		else {			
			//actualState = copy(initialState);
			trace(actualState);
		}
		
		state =  App.initEState({
			dataTable:[],
			formBuilder:new FormBuilder(this),
			initialState:initialState,
			loading:false,
			selectedRows:[],
			sideMenu:FormApi.initSideMenu2( this,
				{
					dataClassPath:'data.Contacts',
					label:'Bearbeiten',
					section: 'Edit',
					items: menuItems
				}					
				,{	
					section: props.match.params.section==null? 'Edit':props.match.params.section, 
					sameWidth: true
				}),	
			values:new Map<String,Dynamic>()
		},this);
		trace(state.initialState.id);
	}

	function loadContactData(id:Int)
	{
		trace('loading:$id');
		var c:Contact = {edited_by: props.user.id,mandator: 0};
		var data = App.store.getState().dataStore.contactData.get(id);
		trace(data);
		for(k=>v in data.keyValueIterator())
		{
			Reflect.setField(c,k, v);
		}
		return c;
	}
	
	static function mapStateToProps(aState:AppState) 
	{
		return {
			user:aState.appWare.user
		};
	}
	
	public function delete(ev:ReactEvent):Void
	{
		trace(state.selectedRows.length);
		var data = state.formApi.selectedRowsMap(state);
	}
		
	override public function componentDidMount():Void 
	{	
		if((initialState.id!=null && !App.store.getState().dataStore.contactData.exists(initialState.id)))
		{
			//DATA NOT IN STORE - LOAD IT
			App.store.dispatch(AppAction.GlobalState('contacts',initialState.id));
			//untyped props.globalState('contacts',initialState.id);
			trace('creating BinaryLoader ${App.config.api}');
			//return;
			BinaryLoader.create(
				'${App.config.api}', 
				{
					id:props.user.id,
					jwt:props.user.jwt,
					className:'data.Contacts',
					action:'show',
					filter:'id|${initialState.id}',
					table:'contacts',
					devIP:App.devIP
				},
				function(data:DbData)
				{			
					App.jwtCheck(data);
					trace(data.dataInfo);
					trace(data.dataRows.length);
					if(data.dataRows.length>0) 
					{
						if(!data.dataErrors.keys().hasNext())
						{
							//var sData:IntMap<Map<String,Dynamic>> = App.store.getState().dataStore.contactData;
							actualState = data.dataRows[0].MapToDyn();
							props.parentComponent.props.select(actualState.id,data.dataRows[0],props.match);
							trace(actualState);
						}
						else 
						{
							//TODO: IMPLEMENT GENERIC FAILURE FEEDBACK
							var baseUrl:String = props.match.path.split(':section')[0];
							props.history.push('${baseUrl}List/find');							
						}				
					}
				}
			);			
		}
		else if(actualState==null)
			actualState = copy(initialState);
		if(formRef.current != null)
		{
			//trace(Reflect.fields(formRef.current));
			formRef.current.addEventListener('keyup', handleChange);
			/*var formElement:Element = Browser.window.document.querySelector('form[name="contact"]');
			trace(Reflect.fields(formElement));*/
			formRef.current.addEventListener('mouseup', function(ev:Dynamic)
			{
				//trace(Reflect.fields(ev.originalTarget));
				trace(ev.target.value);
				//doChange(ev.target.name,ev.target.value);
			});
		}
	}
	
	public function doChange(name,value) {
		trace('$name: $value');
		if(name!=null && name!='')
		Reflect.setField(actualState,name,value);
		setState({initialState:actualState});
	}

	public function handleChange(e:Event) 
	{
		var el:Dynamic = e.target;
		//trace(Type.typeof(el));
		trace('${el.name}:${el.value}');
		if(el.name != '' && el.name != null)
		{
			trace('>>${el.name}<<');
			trace(actualState);
			Reflect.setField(actualState,el.name,el.value);
		}	

		trace(actualState);
	}		

	function handleSubmit(event:Event) {
		//trace(Reflect.fields(event));
		//trace(Type.typeof(event));
		event.preventDefault();
		//var target:FormElement = cast(event.target, FormElement);
		//var elements:HTMLCollection = target.elements;
		//trace(elements.each(function(name:String, el:Dynamic)
		//trace(elements.dynaMap());
		//trace(state.actualState);
		trace(state.initialState.id);
		/*{
			//trace('$name => $el');
			//trace(el.value);
		});		*/
		var doc:Document = Browser.window.document;

		var formElement:FormElement = cast(doc.querySelector('form[name="contact"]'),FormElement);
		var elements:HTMLCollection = formElement.elements;
		for(k in dataAccess['update'].view.keys())
		{
			if(k=='id')
				continue;
			try 
			{
				var item:Dynamic = elements.namedItem(k);
				//trace('$k => ${item.type}:' + item.value);
				Reflect.setField(actualState, item.name, switch (item.type)
				{
					//case DateControl|DateTimrControl:

					case 'checkbox':
					trace('${item.name}:${item.checked?true:false}');
					item.checked?1:0;
					case 'select-multiple'|'select-one':
					var sOpts:HTMLOptionsCollection = item.selectedOptions;
					trace (sOpts.length);
					sOpts.length>1 ? [for(o in 0...sOpts.length)sOpts[o].value ].join('|'):item.value;
					default:
					trace('${item.name}:${item.value}');
					item.value;
				});			
			}
			catch(ex:Dynamic)
			{
				trace(ex);
			}
		}
		//setState({actualState: actualState});
		trace(actualState);
		execute(actualState);
	}


	function execute(aState:Dynamic)
	{
		trace(Reflect.fields(aState));
		var dbaProps:DBAccessProps = 
		{
			action:props.match.params.action,
			className:'data.Contacts',
			dataSource:null,
			//table:'contacts',
			user:props.user
		};
		switch (props.match.params.action)
		{
			case 'create':
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
			case 'delete':
				dbaProps.dataSource = [
					"contacts" => [
						"filter" => 'id|${state.initialState.id}'
					]
				];	
			case 'update':
				for(f in fieldNames)
				{
					//KEEP FIELDS WITH VALUES SET
					//trace('$f =>${Reflect.field(aState,f)}<=');
					if(Reflect.field(aState,f)=='')
						Reflect.deleteField(aState,f);
				}
				dbaProps.dataSource = [
					"contacts" => [
						"data" => aState,
						"filter" => 'id|${state.initialState.id}'
					]
				];
		}
		App.store.dispatch(DataAction.Execute(dbaProps));

		//props.parentComponent.props.update(dbaProps);
	}

	function renderResults():ReactFragment
	{
		trace(props.match.params.section + '/' + props.match.params.action + ' state.dataTable:' + Std.string(state.dataTable != null));
		trace('###########loading:' + state.loading);
		trace('########### action:' + props.match.params.action);

		return switch(props.match.params.action)
		{
			case 'update':
				trace(initialState);
				trace(actualState);
				/*var fields:Map<String,FormField> = [
					for(k in dataAccess['update'].view.keys()) k => dataAccess['update'].view[k]
				];*/
				(actualState==null ? state.formApi.renderWait():
				state.formBuilder.renderForm({
					handleSubmit:handleSubmit,
					fields:[
						for(k in dataAccess['update'].view.keys()) k => dataAccess['update'].view[k]
					],
					model:'contact',
					ref:formRef,
					title: 'Kontakt - Bearbeite Stammdaten' 
				},actualState));
				//null;
			case 'create':
				trace(actualState);
				state.formBuilder.renderForm({
					handleSubmit:handleSubmit,
					fields:[
						for(k in dataAccess['update'].view.keys()) k => dataAccess['update'].view[k]
					],
					model:'contact',
					ref:formRef,
					title: 'Kontakt - Neue Stammdaten' 
				},actualState);
			default:
				null;
		}
	}
	
	override function render():ReactFragment
	{
		//if(state.dataTable != null)	trace(state.dataTable[0]);
		trace(props.match.params.section);		
		trace(props.match.params.action);		
		//trace('state.loading: ${state.loading}');		
		return switch(props.match.params.action)
		{	
			case 'update':
			 //(state.loading || state.initialState.edited_by==0 ? state.formApi.renderWait():
				state.formApi.render(jsx('
						${renderResults()}
				'));	
			case 'create':
				state.formApi.render(jsx('
						${renderResults()}
				'));		
			default:
				state.formApi.render(jsx('
						${renderResults()}
				'));			
		}
	}
	
	function updateMenu(?viewClassPath:String):SMenuProps
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