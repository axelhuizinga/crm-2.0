package view.data.deals;

import model.Deal;
import state.AppState;
import haxe.Constraints.Function;
import js.lib.Promise;
import react.ReactComponent;
import react.ReactEvent;
import react.ReactMacro.jsx;
import react.ReactUtil.copy;
import shared.DbData;
import shared.DBMetaData;
import view.shared.FormField;
import state.FormState;
import model.deals.DealsModel;
import view.shared.MItem;
import view.shared.MenuProps;
import view.shared.io.FormApi;
import view.shared.io.DataFormProps;
import view.shared.io.DataAccess;
import loader.BinaryLoader;
import view.table.Table;

using  shared.Utils;
using Lambda;
using StringTools;

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
	public static var menuItems:Array<MItem> = [
		{label:'Anzeigen',action:'get'},
		{label:'Bearbeiten',action:'update'},
		{label:'Neu', action:'insert'},
		{label:'Löschen',action:'delete'}
	];
	
	var dataDisplay:Map<String,DataState>;
	var dataAccess:DataAccess;	
	var dbData: shared.DbData;
	var dbMetaData:shared.DBMetaData;
	public function new(props) 
	{
		super(props);
		dataDisplay = DealsModel.dataDisplay;
		trace('...' + Reflect.fields(props));
		state =  App.initEState({loading:false,values:new Map<String,Dynamic>()},this);
		trace(state.loading);
	}
	
	static function mapStateToProps(aState:AppState) 
	{
		return {
			userState:aState.userState
		};
	}
	
	public function delete(ev:ReactEvent):Void
	{
		trace(state.selectedRows.length);
		var data = state.formApi.selectedRowsMap(state);
	}

	public function get(ev:ReactEvent):Void
	{
		trace('hi :)');
		//return;
		//dbMetaData = new  DBMetaData();
		//dbMetaData.dataFields = dbMetaData.stateToDataParams(vA);
		//trace(dbMetaData.dataFields.get(111));
		var s:hxbit.Serializer = new hxbit.Serializer();
		
		//return;
		state.formApi.requests.push( null);
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
		
	override public function componentDidMount():Void 
	{	
		trace('mounted:' + true);
		//mounted = true;
		loadDealData(Std.parseInt(props.match.params.id));
		/*dataAccess = [
			'get' =>{
				source:[
					"deals" => []
				],
				view:[]
			},
		];			
		//
		trace(props);
		//if(props.userState.dbUser != null)
		//trace('yeah: ${props.userState.dbUser.first_name}');
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
			setState({loading: false});*/
	}

	function loadDealData(id:Int):Void
		{
			trace('loading:$id');
			if(id == null)
				return;
			var p:Promise<DbData> = props.load(
				{
					classPath:'data.Deals',
					action:'get',
					filter:{id:id,mandator:1},
					resolveMessage:{
						success:'Abschluß ${id} wurde geladen',
						failure:'Abschluß ${id} konnte nicht geladen werden'
					},
					table:'deals',
					dbUser:props.userState.dbUser,
					devIP:App.devIP
				}
			);
			p.then(function(data:DbData){
				trace(data.dataRows.length); 
				if(data.dataRows.length==1)
				{
					var data = data.dataRows[0];
					trace(data);	
					//if( mounted)
					var cObj:Deal = new Deal(data);
					trace(cObj.id);
					setState({loading:false, actualState:new Deal(data)});
					trace(untyped state.actualState.id + ':' + state.actualState.fieldsInitalized.join(','));
					setState({initialData: copy(state.actualState)});
					trace(props.location.pathname + ':' + untyped state.actualState.amount);
					props.history.replace(props.location.pathname.replace('open','update'));
				}
			});
		}
	
	function renderResults():ReactFragment
	{
		trace(props.match.params.section + ':' + Std.string(state.dataTable != null));
		//trace(dataDisplay["userList"]);
		trace(state.loading + ':' + props.match.params.action);
		if(state.loading)
			return state.formApi.renderWait();
		trace('###########loading:' + state.loading);
		return switch(props.match.params.action)
		{
			case 'get':
				jsx('
					<Table id="fieldsList" data=${state.dataTable}
					${...props} dataState = ${dataDisplay["contactList"]} 
					className="is-striped is-hoverable" fullWidth=${true}/>
				');
			case 'update':
				jsx('
					<Table id="fieldsList" data=${state.dataTable}
					${...props} dataState = ${dataDisplay["dealsList"]} 
					className="is-striped is-hoverable" fullWidth=${true}/>
				');			
			case 'insert':
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
		return state.formApi.render(jsx('
		<>
			<form className="tabComponentForm"  >
				${renderResults()}
			</form>
		</>'));		
	}
	
	function updateMenu(?viewClassPath:String):MenuProps
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