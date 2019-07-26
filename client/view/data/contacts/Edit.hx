package view.data.contacts;
import model.AppState;
import haxe.Constraints.Function;
import react.ReactComponent;
import react.ReactEvent;
import react.ReactMacro.jsx;
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
	public function new(props) 
	{
		super(props);
		dataDisplay = ContactsModel.dataDisplay;
		trace('...' + Reflect.fields(props));
		state =  App.initEState({
			initialState:
			{
				id:0,
				edited_by: 0,
				formBuilder:new FormBuilder(this),
				mandator: 0
			},
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

	/*public function find(ev:ReactEvent):Void
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
				className:'data.Contacts',
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
	}*/
	
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
		setState({mounted:true});
		var baseUrl:String = props.match.path.split(':section')[0];
		trace(props.match);
		if(props.match.params.id==null && ~/edit(\/)*$/.match(props.match.params.action) )
		{
			//~/ 
			//trace('reme');
			//props.history.push(baseUrl);
		}
		dataAccess = ContactsModel.dataAccess;
		
		if(props.match.params != null)
		trace('yeah action: ${props.match.params.action}');
		//dbData = FormApi.init(this, props);
		if(props.match.params.id!=null)
		{
			trace('select ID(s)');
			
		}
		

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

	function handleChange(contact, value, t) {
		trace(contact);
		var field:String = contact.split('.')[1];
		trace(field);
		trace(contact.length);
		trace(t);
		var initialState = state.initialState;
		//trace(Type.typeof(contact));
		//Out.dumpObject(contact);
		//trace(contact[0].fp_incr(1));
		
		trace(value);
		Reflect.setField(initialState, field, value);
		setState({initialState: initialState});
	}		

	function handleSubmit(contact, t) {
		trace(contact);//initialState
		trace(t._targetInst);
		
		
		var fProps:Dynamic = Reflect.field(t._targetInst,'return').stateNode.props;
		trace(fProps.store.getState());
		trace(Reflect.fields(fProps));
		var form_ = Reflect.field(fProps.formValue,"$form");
		//trace(fProps.formValue);
		trace(Reflect.fields(form_));
		trace(form_.value);
		trace(form_.intents );
		trace(form_.pristine );
		
		return false;
	}	

	function save()
	{
		
	}

	/*function initStateFromDataTable(dt:Array<Map<String,String>>):Dynamic
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
	}*/
	
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
				trace('state.dataTable.length:'+state.dataTable.length);
				if(state.dataTable.length==0)				
					return null;
				jsx('
					<Table id="fieldsList" data=${state.dataTable} parentComponent=${this} 
					${...props} dataState = ${dataDisplay["contactList"]} 
					className="is-striped is-hoverable" fullWidth=${true}/>
				');
			case 'edit':
			//trace(initialState);
			//trace(model(initialState, contact, first_name));
			var fields:Map<String,FormField> = [
				for(k in dataAccess['edit'].view.keys()) k => dataAccess['edit'].view[k]
			];
			//trace(fields);
			state.formBuilder.renderLocal({
				fields:[
					for(k in dataAccess['edit'].view.keys()) k => dataAccess['edit'].view[k]
				],
				model:'contact',
				title: 'Kontakt - Bearbeite Stammdaten'
			},state.initialState);
			
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