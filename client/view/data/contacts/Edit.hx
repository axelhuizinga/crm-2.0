package view.data.contacts;
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
		{label:'Anzeigen',action:'find',section: 'List'},
		{label:'Bearbeiten',action:'edit'},
		{label:'Neu', action:'add'},
		{label:'Löschen',action:'delete'}
	];
	
	var dataDisplay:Map<String,DataState>;
	var dataAccess:DataAccess;	
	var dbData: shared.DbData;
	var dbMetaData:shared.DBMetaData;

	var formRef:ReactRef<FormElement>;
	
	public static var initialState:Contact =
	{
		id:2000328,
		edited_by: 0,
		mandator: 0
	};	

	public function new(props) 
	{
		super(props);
		if(props.match.params.id==null && ~/edit(\/)*$/.match(props.match.params.action) )
		{
			//~/ 
			trace('nothing selected - redirect');
			var baseUrl:String = props.match.path.split(':section')[0];
			props.history.push('${baseUrl}List');
		}		
		dataAccess = ContactsModel.dataAccess;
		dataDisplay = ContactsModel.dataDisplay;
		trace('...' + Reflect.fields(props));
		formRef = React.createRef();
		//var formBuilder = new FormBuilder(this);
		trace(props.user);
		initialState = {
			id:2000328,
			edited_by: props.user.id,				
			mandator: props.user.mandator
		};
		for(k in dataAccess['edit'].view.keys())
		{
			//trace('$k => ' );
			if(!Reflect.hasField(initialState,k))
				Reflect.setField(initialState, k, '');
		}		
		//trace(initialState);
		state =  App.initEState({
			dataTable:[],
			formBuilder:new FormBuilder(this),
			actualState:
			{
				id:0,
				edited_by: props.user.id,				
				mandator: props.user.mandator
			},
			initialState:initialState,
			loading:false,
			selectedRows:[],
			values:new Map<String,Dynamic>()
		},this);
		trace(state.loading);

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
	
	public function edit(ev:ReactEvent):Void
	{
		//trace(ev);
		if(state.selectedData != null )
		{
			trace(state.selectedData.keys());
			if(!state.selectedData.keys().hasNext())
			{
				//NO SELECTION  - CHECK PARAMS

				//NO SELECTION  - NOTHING TO EDIT
				
				//setState({loading: false});
				
				trace(props.match);
				return;
			}
			var baseUrl:String = props.match.path.split(':section')[0];
			//setState({loading: true});
			var it:Iterator<Map<String,Dynamic>> = state.selectedData.iterator();
			var sData:Map<String,Dynamic> = it.next();
			//trace(sData);
			//sData = state.selectedData.get(state.selectedData.keys().next());
			trace(state.selectedData.keys().keysList());
			trace(FormApi.params(state.selectedData.keys().keysList()));
			props.history.push('${baseUrl}Edit/edit/${FormApi.params(state.selectedData.keys().keysList())}');
			initialState = {
				id:2000328,
				edited_by: props.user.id,				
				mandator: props.user.mandator
			};			
			for(k in dataAccess['edit'].view.keys())
			{
				trace('$k => ' + sData[k]);
				Reflect.setField(initialState, k, sData[k]);
			}			
		}

		setState({actualState:initialState,initialState: initialState});
		//trace(it.hasNext());				
	}
		
	override public function componentDidMount():Void 
	{	
		//trace(props.location);
		//setState({mounted:true});
		//return;
		var baseUrl:String = props.match.path.split(':section')[0];
		trace(props.match);
		if(props.match.params.id==null && ~/edit(\/)*$/.match(props.match.params.action) )
		{
			//~/ 
			//trace('reme');
			//props.history.push(baseUrl);
		}
		
		if(props.match.params != null)
		trace('yeah2action: ${props.match.params.action}');
		//dbData = FormApi.init(this, props);
		if(props.match.params.id!=null)
		{
			trace('select ID(s)');
			
		}

		/**
		 * testing => init view values
		 */		

		for(k in dataAccess['edit'].view.keys())
		{
			dataAccess['edit'].view[k].value = Reflect.field(initialState,k);
		}
		var actualState = copy(initialState);
		Reflect.deleteField(actualState,'id');
		setState({actualState:actualState,initialState: initialState});		
		
		//trace(formRef.current != null);
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

		for(dC in state.formBuilder.dateControls)
			dC.createFlatPicker();
		for(dtC in state.formBuilder.dateTimeControls)
			dtC.createFlatPicker();			
	}
	
	public function doChange(name,value) {
		trace('$name: $value');
		if(name!=null && name!='')
		Reflect.setField(state.actualState,name,value);
	}

	public function handleChange(e:Event) 
	{
		var el:Dynamic = e.target;
		trace(Type.typeof(el));

		trace('${el.name}:${el.value}');
		if(el.name != '' && el.name != null)
		{
			trace('>>${el.name}<<');
			trace(state.actualState);
			Reflect.setField(state.actualState,el.name,el.value);
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
		var aState = state.actualState;
		for(k in dataAccess['edit'].view.keys())
		{
			if(k=='id')
				continue;
			try 
			{
				var item:Dynamic = elements.namedItem(k);
				//trace('$k => ${item.type}:' + item.value);
				Reflect.setField(aState, item.name, switch (item.type)
				{
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
		//setState({actualState: aState});
		//trace(aState);
		update(aState);
	}	


	function update(aState:Contact)
	{
		trace(Reflect.fields(aState));
		var dbaProps:DBAccessProps = 
		{
			action:'update',
			className:'data.Contacts',
			dataSource:[
				"contacts" => [
					"data" => aState,
					"filter" => 'id|${state.initialState.id}'
				]
			],
			user:props.user
		};
		
		App.store.dispatch(DataAction.Update(dbaProps));
		//props.parentComponent.props.update(dbaProps);
	}

	function renderResults():ReactFragment
	{
		trace(props.match.params.section + '/' + props.match.params.action + ' state.dataTable:' + Std.string(state.dataTable != null));
		trace('###########loading:' + state.loading);
		trace('########### action:' + props.match.params.action);

		return switch(props.match.params.action)
		{
			case 'edit':
				trace(state.initialState);
				/*var fields:Map<String,FormField> = [
					for(k in dataAccess['edit'].view.keys()) k => dataAccess['edit'].view[k]
				];*/
				
				state.formBuilder.renderForm({
					handleSubmit:handleSubmit,
					fields:[
						for(k in dataAccess['edit'].view.keys()) k => dataAccess['edit'].view[k]
					],
					model:'contact',
					ref:formRef,
					title: 'Kontakt - Bearbeite Stammdaten' 
				},initialState);
				//null;
			case 'add':
				trace(dataDisplay["fieldsList"]);
				jsx('
					<Table id="fieldsList" data=${state.dataTable}
					${...props} dataState = ${dataDisplay["fieldsList"]} 
					className="is-striped is-hoverable" fullWidth=${true}/>				
				');	
			case 'delete':
				null;
			default:
				if(state.dataTable.length==0)				
					return null;
				jsx('
					<Table id="fieldsList" data=${state.dataTable} parentComponent=${this}
					${...props} dataState = ${dataDisplay["contactList"]} 
					className="is-striped is-hoverable" fullWidth=${true}/>
				');
		}
		return null;
	}
	
	override function render():ReactFragment
	{
		//if(state.dataTable != null)	trace(state.dataTable[0]);
		trace(props.match.params.section);		
		trace(props.match.params.action);		
		trace('state.loading: ${state.loading}');		
		return switch(props.match.params.action)
		{	
			case 'edit':
			 (state.loading || state.initialState.edited_by==0 ? state.formApi.renderWait():
				state.formApi.render(jsx('
						${renderResults()}
				')));	
			case 'add':
				state.formApi.render(jsx('
				<>
					<form className="tabComponentForm"  >
						${renderResults()}
					</form>
				</>'));		
			default:
				state.formApi.render(jsx('
					<form className="tabComponentForm"  >
						${renderResults()}
					</form>
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