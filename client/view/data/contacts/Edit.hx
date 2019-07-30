package view.data.contacts;
import js.html.Element;
import js.html.Event;
import react.router.RouterMatch;
import model.AppState;
import haxe.Constraints.Function;
import react.ReactComponent;
import react.ReactEvent;
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
import view.shared.io.BinaryLoader;
import view.table.Table;
import view.model.Account;

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
@:connect
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
	
	public static var initialState:view.model.Contact =
	{
		id:0,
		edited_by: 0,
		mandator: 0
	};	

	public function new(props) 
	{
		super(props);
		dataDisplay = ContactsModel.dataDisplay;
		trace('...' + Reflect.fields(props));
		state =  App.initEState({
			dataTable:[],
			formBuilder:new FormBuilder(this),
			actualState:
			{
				id:0,
				edited_by: 0,				
				mandator: 0
			},
			loading:false,
			selectedRows:[],
			values:new Map<String,Dynamic>()
		},this);
		dataAccess = ContactsModel.dataAccess;
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
		trace(state.selectedData.keys());
		if(!state.selectedData.keys().hasNext())
		{
			//NO SELECTION  - CHECK PARAMS

			//NO SELECTION  - NOTHING TO EDIT
			
			//setState({loading: false});
			
			//trace(props.match);
			/*if(props.match.params.id==null && ~/edit(\/)*$/.match(props.match.params.action) )
			{
				trace('redirect 2 ${baseUrl}');
				//props.history.push('${baseUrl}${props.match.params.section}');
				props.history.push('${baseUrl}');
				
				find(ev);
				//state.formApi.doAction('find');	
			}			*/
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
		var initialState:view.model.Contact = {
			id:0,
			edited_by: 0,
			mandator: 0
		};
		for(k in dataAccess['edit'].view.keys())
		{
			//trace('$k => ' + sData[k]);
			Reflect.setField(initialState, k, sData[k]);
		}
		setState({initialState: initialState});
		//trace(it.hasNext());				
	}
		
	override public function componentDidMount():Void 
	{	
		trace(props.location);
		//setState({mounted:true});
		var baseUrl:String = props.match.path.split(':section')[0];
		trace(props.match);
		if(props.match.params.id==null && ~/edit(\/)*$/.match(props.match.params.action) )
		{
			//~/ 
			//trace('reme');
			//props.history.push(baseUrl);
		}
		
		//trace(dataAccess);
		if(props.match.params != null)
		trace('yeah action: ${props.match.params.action}');
		//dbData = FormApi.init(this, props);
		if(props.match.params.id!=null)
		{
			trace('select ID(s)');
			
		}
		

		if(props.match.params.action != null)
		{
			//state.formApi.doAction();	
		}
		else 
		{
			//invoke default action if any
			//state.formApi.doAction('find');	
		}
	}

	function getDispatch(dispatch) {
		trace(dispatch);
	}

	function handleChange(contact, value, t) {
		//trace(contact);
		//trace(contact.storeSubscription.store.getState());
		//var field:String = contact.split('.')[1];
		//trace(field);
		//trace(contact.length);
		//trace(t);
		//state.formApi.storeFormState(field,value);
		//trace(value);	
		/*return function(u){
			trace(u);
		};*/
	}		

	function handleSubmit(contact:Dynamic) {
		trace(contact);
		trace(Type.typeof(contact));
		contact.preventDefault();
		trace(contact.target);
		
	}	

	function save()
	{
		
	}

	function renderResults():ReactFragment
	{
		trace(props.match.params.section + '/' + props.match.params.action + ' state.dataTable:' + Std.string(state.dataTable != null));
		//trace(dataDisplay["userList"]);
		/*trace(state.loading);
		if(state.loading)
			return state.formApi.renderWait();*/
		trace('###########loading:' + state.loading);
		return switch(props.match.params.action)
		{
			case 'edit':
			//trace(model(initialState, contact, first_name));
			trace(state.initialState);
			var fields:Map<String,FormField> = [
				for(k in dataAccess['edit'].view.keys()) k => dataAccess['edit'].view[k]
			];
			//trace(fields);
			state.formBuilder.renderForm({
				handleSubmit:handleSubmit,
				fields:[
					for(k in dataAccess['edit'].view.keys()) k => dataAccess['edit'].view[k]
				],
				model:'contact',
				title: 'Kontakt - Bearbeite Stammdaten' 
			},initialState);
			
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
			 (state.loading ? state.formApi.renderWait():
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