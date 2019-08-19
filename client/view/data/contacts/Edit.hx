package view.data.contacts;
import haxe.ds.IntMap;
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
		{label:'Auswahl',action:'read',section: 'List'},
		{label:'Bearbeiten',action:'update'},
		{label:'Neu', action:'create'},
		{label:'Löschen',action:'delete'}
	];
	
	var dataDisplay:Map<String,DataState>;
	var dataAccess:DataAccess;	
	var dbData: shared.DbData;
	var dbMetaData:shared.DBMetaData;

	var formRef:ReactRef<FormElement>;
	var actualState:Contact;
	
	public static var initialState:Contact =
	{
		id:null,//2000328,
		edited_by: 0,
		mandator: 0
	};	

	public function new(props) 
	{
		super(props);
		trace(props.match.params);
		actualState = copy(initialState);
		if(props.match.params.id==null && ~/edit(\/)*$/.match(props.match.params.action) )
		{
			trace('nothing selected - redirect');
			var baseUrl:String = props.match.path.split(':section')[0];
			props.history.push('${baseUrl}List/find');
			return;
		}		
		dataAccess = ContactsModel.dataAccess;
		dataDisplay = ContactsModel.dataDisplay;
		trace('...' + Reflect.fields(props));
		formRef = React.createRef();
		//var formBuilder = new FormBuilder(this);
		//trace(props.user);
		if(props.match.params.id!=null)
			initialState.id = Std.parseInt(props.match.params.id);
		trace(App.store.getState().dataStore.selectedData);
		trace(actualState);
		
		if((initialState.id!=null && App.store.getState().dataStore.selectedData.exists(initialState.id)))
		{
			initialState = loadContactData(initialState.id);
			actualState = copy(initialState);
			trace(initialState);		

			for(k in dataAccess['update'].view.keys())
			{
				dataAccess['update'].view[k].value = Reflect.field(actualState,k);
			}			
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
		var data = App.store.getState().dataStore.selectedData.get(id);
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
		if((initialState.id!=null && !App.store.getState().dataStore.selectedData.exists(initialState.id)))
		{
			//load id	 state.formApi.requests.push( 
			trace('creating BinaryLoader ${App.config.api}');
			//return;
			BinaryLoader.create(
				'${App.config.api}', 
				{
					id:props.user.id,
					jwt:props.user.jwt,
					className:'data.Contacts',
					action:'read',
					filter:'id|${initialState.id}',
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
							var sData:IntMap<Map<String,Dynamic>> = App.store.getState().dataStore.selectedData;
							actualState = data.dataRows[0].MapToDyn();
							trace(actualState);
							for(k in dataAccess['update'].view.keys())
							{
								dataAccess['update'].view[k].value = Reflect.field(actualState,k);
							}		
							sData.set(initialState.id,data.dataRows[0]);
							setState({initialState: copy(actualState)});
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

		/*for(dC in state.formBuilder.dateControls)
			dC.createFlatPicker();
		for(dtC in state.formBuilder.dateTimeControls)
			dtC.createFlatPicker();			*/
	}
	
	public function doChange(name,value) {
		trace('$name: $value');
		if(name!=null && name!='')
		Reflect.setField(actualState,name,value);
	}

	public function handleChange(e:Event) 
	{
		var el:Dynamic = e.target;
		trace(Type.typeof(el));

		trace('${el.name}:${el.value}');
		if(el.name != '' && el.name != null)
		{
			trace('>>${el.name}<<');
			trace(actualState);
			Reflect.setField(actualState,el.name,el.value);
		}	

		trace(state.actualState);
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


	function execute(aState:Contact)
	{
		trace(Reflect.fields(aState));
		var dbaProps:DBAccessProps = 
		{
			action:props.match.params.action,
			className:'data.Contacts',
			dataSource:null,
			user:props.user
		};
		switch (props.match.params.action)
		{
			case 'create':
				Reflect.deleteField(aState,'id');
				dbaProps.dataSource = [
					"contacts" => [
						"data" => aState
					]
				];
			case 'delete':
				dbaProps.dataSource = [
					"contacts" => [
						"filter" => 'id|${state.initialState.id}'
					]
				];	
			case 'update':
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
				trace(actualState);
				/*var fields:Map<String,FormField> = [
					for(k in dataAccess['update'].view.keys()) k => dataAccess['update'].view[k]
				];*/
				(actualState.id==null ? state.formApi.renderWait():
				state.formBuilder.renderForm({
					handleSubmit:handleSubmit,
					fields:[
						for(k in dataAccess['update'].view.keys()) k => dataAccess['update'].view[k]
					],
					model:'contact',
					ref:formRef,
					title: 'Kontakt - Bearbeite Stammdaten' 
				},initialState));
				//null;
			case 'create':
				state.formBuilder.renderForm({
					handleSubmit:handleSubmit,
					fields:[
						for(k in dataAccess['update'].view.keys()) k => dataAccess['update'].view[k]
					],
					model:'contact',
					ref:formRef,
					title: 'Kontakt - Bearbeite Stammdaten' 
				},initialState);
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