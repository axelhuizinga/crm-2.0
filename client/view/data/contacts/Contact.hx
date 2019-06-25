package view.data.contacts;
import action.AppAction;
import haxe.ds.IntMap;
import model.AppState;
import haxe.Constraints.Function;
import macrotools.Macro.model;
import react.ReactComponent;
import react.ReactEvent;
import react.ReactMacro.jsx;
import redux.Redux.Dispatch;

import view.data.contacts.model.Contacts;
import shared.DbData;
import shared.DBMetaData;
import view.model.Contact;
import view.shared.FormField;
import view.shared.FormState;
import view.shared.SMItem;
import view.shared.SMenuProps;
import view.shared.io.FormApi;
import view.shared.io.DataFormProps;
import view.shared.io.DataAccess;
import view.shared.io.BinaryLoader;
import view.table.Table;

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

@:connect
class Contact extends ReactComponentOf<DataFormProps,FormState>
{
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
	
	public static var initialState:view.model.Contact =
	{
		id:0,
		edited_by: 0,
		mandator: 0
	};

	public function new(props) 
	{
		super(props);
		dataAccess = Contacts.dataAccess;
		dataDisplay = Contacts.dataDisplay;
		trace('...' + Reflect.fields(props));
		state =  App.initEState({
			action:'find',loading:true,selectedData:new IntMap(), selectedRows:[],values:new Map<String,Dynamic>()
		},this);
		trace(state.selectedData);
		trace(state.loading);
	}

	static function mapDispatchToProps(dispatch:Dispatch):Dynamic
    {
		trace(dispatch + ':' + (dispatch == App.store.dispatch? 'Y':'N'));
        return {
			storeFormChange: function(cState:FormState) 
			{
				dispatch(AppAction.FormChange(
					'view.data.contacts.Contact',
					cState
				));
			}
		};
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
				className:'data.Contacts',
				action:'find',
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
					setState({dataTable:data.dataRows, values: ['loadResult'=>'','closeAfter'=>100]});
				}
				else 
					setState({values: ['loadResult'=>'Kein Ergebnis','closeAfter'=>-1]});					
				}
				//setState({dataTable:data.dataRows, loading: false});
			}
		));
	}
	
	public function edit(ev:ReactEvent):Void
	{
		//trace(ev);
		//trace(state.selectedData.keys());
		if(!state.selectedData.keys().hasNext())
		{
			setState({loading: false});
			var baseUrl:String = props.match.path.split(':section')[0];
			//trace(props.match);
			if(props.match.params.id==null && ~/edit(\/)*$/.match(props.match.params.action) )
			{
				//~/ 
				trace('redirect 2 ${baseUrl}${props.match.params.section}');
				props.history.push('${baseUrl}${props.match.params.section}');
				find(ev);
				//state.formApi.doAction('find');	
			}			
			return;
		}

		//setState({loading: true});
		var it:Iterator<Map<String,Dynamic>> = state.selectedData.iterator();
		var sData:Map<String,Dynamic> = it.next();
		//trace(sData);
		//sData = state.selectedData.get(state.selectedData.keys().next());
		//trace(sData);
		for(k in dataAccess['edit'].view.keys())
		{
			//trace('$k => ' + sData[k]);
			Reflect.setField(initialState, k, sData[k]);
		}
		//trace(it.hasNext());				
	}
		
	override public function componentDidMount():Void 
	{	
		trace(props.location);
		var baseUrl:String = props.match.path.split(':section')[0];
		trace(props.match);
		if(props.match.params.id==null && ~/edit(\/)*$/.match(props.match.params.action) )
		{
			//~/ 
			trace('redirect 2 ${baseUrl}${props.match.params.section}');
			//props.history.push('${baseUrl}${props.match.params.section}');
		}
		dataAccess = Contacts.dataAccess;/*[
			'find' =>{
				source:[
					"contacts" => []
				],
				view:[]
			},
		];*/
		//
		if(props.match.params != null)
		trace('yeah action: ${props.match.params.action}');
		//dbData = FormApi.init(this, props);
		if(props.match.params.action != null)
		{
			state.formApi.doAction();	
		}
		else 
		{
			//invoke default action if any
			state.formApi.doAction('find');	
		}
	}

	function handleChange(contact, value) {
		trace(contact);
		trace(value);
	}		

	function handleSubmit(contact, _) {
		trace(contact);
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
			case 'find':
				jsx('
					<Table id="fieldsList" data=${state.dataTable} parentComponent=${this} 
					${...props} dataState = ${dataDisplay["contactList"]} 
					className="is-striped is-hoverable" fullWidth=${true}/>
				');
			case 'edit':
			trace(initialState);
			trace(model(initialState, contact, first_name));
			var fields:Map<String,FormField> = [
				for(k in dataAccess['edit'].view.keys()) k => dataAccess['edit'].view[k]
			];
			//trace(fields);
			state.formBuilder.render({
				fields:[
					for(k in dataAccess['edit'].view.keys()) k => dataAccess['edit'].view[k]
				],
				model:'contact',
				title: 'Kontakt - Bearbeite Stammdaten'
			},initialState);
			/**
			 * typedef FormField =
{
	?className:String,
	?name:String,
	?label:String,
	?value:Dynamic,
	?dataBase:String, 
	?dataTable:String,
	?dataField:String,
	?displayFormat:Function,
	?type:FormElement,
	?primary:Bool,
	?readonly:Bool,
	?required:Bool,
	?handleChange:InputEvent->Void,
	?placeholder:String,
	?validate:String->Bool
}
			 */
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
		var hidden:ReactFragment = state.formBuilder.hidden(model(initialState,contact,id));
		return switch(props.match.params.action)
		{	
			case 'edit':
			 (state.loading ? state.formApi.renderWait():
				state.formApi.render(
					${renderResults()}
				));	
			default:
				state.formApi.render(jsx('
				<>
					<form className="tabComponentForm"  >
						${renderResults()}
					</form>
				</>'));		
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