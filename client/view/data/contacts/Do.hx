package view.data.contacts;
import model.AppState;
import haxe.Constraints.Function;
import react.ReactComponent;
import react.ReactEvent;
import react.ReactMacro.jsx;
import react.redux.form.LocalForm;
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
class Do extends ReactComponentOf<DataFormProps,FormState>
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
	
	public static var initModel:Contact =
	{
		id:0,
		edited_by: 0,
		mandator: 0
	};

	public function new(props) 
	{
		super(props);
		dataDisplay = Contacts.dataDisplay;
		trace('...' + Reflect.fields(props));
		state =  App.initEState({loading:true,selectedRows:[], values:new Map<String,Dynamic>()},this);
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
				className:'data.Contacts',
				action:'find',
				//dataSource:Serializer.run(dataAccess['find'].source),
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
		trace(state.selectedRows);
		if(state.selectedRows.length==0)
		{
			setState({loading: false});
		}
		return;
		trace(state.selectedRows.length);				
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
	}*/
		
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


	function handleSubmit(contact, _) {
		trace(contact);
	}	
	
	function renderResults():ReactFragment
	{
		trace(props.match.params.section + '/' + props.match.params.action + ' state.dataTable:' + Std.string(state.dataTable != null));
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
				null;	
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
					<Table id="fieldsList" data=${state.dataTable}
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
		return switch(props.match.params.action)
		{	
			case 'edit':
				state.formApi.render(jsx('
				<>
					<$LocalForm model="contact" onSubmit=${handleSubmit} className="tabComponentForm" >
						${renderResults()}
					</$LocalForm>					
				</>'));				
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