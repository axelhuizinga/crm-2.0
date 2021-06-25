package view.accounting.directdebit;

import js.html.FormData;
import data.DataState;
import view.shared.FormInputElement;
import js.html.Event;
import db.DBAccessProps;
import model.accounting.DebitModel;
import js.html.HTMLCollection;
import js.Browser;
import js.html.Document;
import js.html.FormElement;
import view.shared.FormBuilder;
import view.shared.io.BaseForm;
import redux.Redux.Dispatch;
import action.AppAction;
import action.async.CRUD;
import model.Deal;
import state.AppState;
import haxe.Constraints.Function;
import js.lib.Promise;
import react.ReactComponent;
import react.ReactEvent;
import react.ReactMacro.jsx;
import react.ReactRef;
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

@:connect
class Edit extends ReactComponentOf<DataFormProps,FormState>
{
	public static var menuItems:Array<MItem> = [
		{label:'Neu Erstellen',action:'create', //name:'directDebitFile', type: FormInputElement.Button,
			options:[
			{label: 'Buchungstag', name: 'booking_day', type: Radio, options: ['1'=>'1','15'=>'15']}]
		},		
		{label:'Anzeigen',action:'get', disabled:true},
		{label:'Download', action:'download', disabled:true},
		{label:'Bearbeiten',action:'edit', disabled:true},
	];
	var dataAccess:DataAccess;	
	//var dataDisplay:Map<String,DataState>;
	var formApi:FormApi;
	var formBuilder:FormBuilder;
	var formFields:DataDisplay;
	var formRef:ReactRef<FormElement>;
	var fieldNames:Array<String>;
	var baseForm:BaseForm;
	var deal:Deal;
	var dbData: shared.DbData;
	var dbMetaData:shared.DBMetaData;
	var mounted:Bool = false;

	public function new(props) 
	{
		super(props);
		//baseForm =new BaseForm(this);
		
		trace(props.match.params);
		//trace(props.parentComponent);
		trace(Reflect.fields(props));

		//REDIRECT WITHOUT ID OR edit action
		if(props.match.params.id==null && ~/open(\/)*$/.match(props.match.params.action) )
		{
			trace('nothing selected - redirect');
			var baseUrl:String = props.match.path.split(':section')[0];
			props.history.push('${baseUrl}List/get');
			return;
		}		
		dataAccess = DebitModel.dataAccess;
		fieldNames = BaseForm.initFieldNames(dataAccess['open'].view.keys());
		//dataDisplay = DebitModel.dataDisplay;

		state =  App.initSectionState({
			//dataTable:[],
			actualState:null,
			initialData:null,
			loading:false,
			mHandlers:menuItems,
			selectedRows:[],
			sideMenu:props.parentComponent.state.sideMenu,/*FormApi.initSideMenuMulti( this,
			[	
				{
					dataClassPath:'data.DirectDebits',
					label:'Gesamtliste',
					section: 'List',
					items:List.menuItems
				},
				{
					dataClassPath:'data.DirectDebits',
					hasFindForm:false,
					label:'Bearbeiten',
					section: 'Edit',
					items: menuItems
				}
			],				
			{	
				section: props.match.params.section==null? 'Edit':props.match.params.section, 
				sameWidth: true
			}),*/
			/*storeListener:App.store.subscribe(function(){
				trace(App.store.getState().dataStore);
			}),*/
			values:new Map<String,Dynamic>()
		},this);
		
		trace(state.initialData);
	/*	dataDisplay = DealsModel.dataDisplay;
		trace('...' + Reflect.fields(props));
		state =  App.initEState({loading:false,values:new Map<String,Dynamic>()},this);*/
		trace(state.loading);
	}

	static function mapDispatchToProps(dispatch:Dispatch) {
		trace('here we should be ready to load');
        return {
            load: function(param:DBAccessProps) return dispatch(CRUD.read(param))
        };
	}
	
	static function mapStateToProps(aState:AppState) 
	{
		return {
			userState:aState.userState
		};
	}
	
	override public function componentDidMount():Void 
	{	
		dataAccess = DebitModel.dataAccess;
		trace(props.match.params.action);
		//state.formApi.doAction('get');
	}
	
	//public function create(arg:Array<FormData>):Void {
	public function create(fd:FormData):Void {
		//var fd:FormData = arg;//[0];
		trace(fd);
		if(fd==null)
			return;
		trace(fd.entries().next());
		var iPromise:Promise<Dynamic> = new Promise(function(resolve, reject){
			fd.append('devIP',App.devIP);
			fd.append('action','createDirectDebitsCSV');
			var xhr = new js.html.XMLHttpRequest();
			xhr.open('POST', '${App.config.api}', true);
			xhr.onerror = function(e) {
				trace(e);
				trace(e.type);
				reject({error:e});
			}
			xhr.withCredentials = true;
			xhr.onload = function(e) {
				trace(xhr.status);
				if (xhr.status != 200) {				
					trace(xhr.statusText);
					reject({error:xhr.statusText});
				}
				trace(xhr.response.length);
				resolve(xhr.response);
				//onLoaded(haxe.io.Bytes.ofData(xhr.response));
			}
			xhr.send(fd);
			setState({action:'createDirectDebitsCSV',loading:true});
		});
		
		iPromise.then(function (r:Dynamic) {
			trace(r);
			/*var dd:{rlData:Array<Dynamic>} = Json.parse(r);
			//trace(rD);
			var dT:Array<Map<String, Dynamic>> = new Array();
			for(dR in dd.rlData)
				dT.push(Utils.dynToMap(dR));
			setState({dataTable:dT,loading:false});
			App.store.dispatch(Status(Update( 
				{	
					text:dT.count() + ' Buchungsanforderungen erstellt'
				}
			)));*/
		}, function (r:Dynamic) {
			trace(r);
			App.store.dispatch(Status(Update( 
				{	className:'',
					text:(r.error==null?'':r.error)
				}
			)));
		});
	}

	public function delete(ev:ReactEvent):Void
	{
		trace(state.selectedRows.length);
		var data = state.formApi.selectedRowsMap(state);
	}

	public function get(ev:Dynamic):Void
	{
		trace('hi $ev');
		var offset:Int = 0;
		if(ev != null && ev.page!=null)
		{
			offset = Std.int(props.limit * ev.page);
		}
		trace(props.userState);
		var p:Promise<DbData> = props.load(
			{
				classPath:'data.DirectDebits',
				action:'get',
				filter:(props.match.params.id!=null?{id:props.match.params.id, mandator:'1'}:{mandator:'1',processed:'false'}),
				limit:props.limit,
				offset:offset>0?offset:0,
				table:'debit_return_statements',
				resolveMessage:{					
					success:'',
					failure:''
				},
				dbUser:props.userState.dbUser,
				devIP: App.devIP
			}
		);
		p.then(function(data:DbData){
			trace(data.dataRows.length); 
			setState({loading:false, dataTable:data.dataRows});
		});
	}
	
	public function edit(ev:ReactEvent):Void
	{
		trace(state.selectedRows.length);				
	}

	function update()
	{
		//trace(Reflect.fields(aState));
		if(state.actualState != null)
			trace(state.actualState.fieldsModified.length);
		if(state.actualState == null || state.actualState.fieldsModified.length==0)
			return;
		var data2save = state.actualState.allModified();
		var doc:Document = Browser.window.document;

		/*var formElement:FormElement = cast(doc.querySelector('form[name="deal"]'),FormElement);
		var elements:HTMLCollection = formElement.elements;*/
		var aState:Dynamic = copy(state.actualState);
		/*var dbaProps:DBAccessProps = 
		{
			action:'update',
			classPath:'data.Deals',
			dataSource:null,
		//	table:'contacts',
			userState:props.userState
		};*/
		var dbQ:DBAccessProps = {
			classPath:'data.Deals',
			action:'update',
			data:data2save,
			filter:{id:state.actualState.id,mandator:1},
			resolveMessage:{
				success:'Spende ${state.actualState.id} wurde aktualisiert',
				failure:'Spende ${state.actualState.id} konnte nicht aktualisiert werden'
			},
			table:'deals',
			dbUser:props.userState.dbUser,
			devIP:App.devIP
		}
		trace('${props.match.params.action}: ${state.initialData.id} :: creation_date: ${aState.creation_date} ${state.initialData.creation_date}');

		if(state.actualState != null)
		trace(state.actualState.modified() + ':${state.actualState.fieldsModified}');

		//trace(aState);
		trace(state.actualState.id);
		if(!state.actualState.modified())
		{
			//TODO: NOCHANGE ACTION => Display Feedback nothing to save
			App.store.dispatch(Status(Update( 
				{	className:'',
					text:'Spende wurde nicht geändert'			
				}
			)));			
			trace('nothing modified');
			return;
		}
		trace(state.actualState.allModified());
		App.store.dispatch(CRUD.update(dbQ));
		
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
						success:'Aktion ${id} wurde geladen',
						failure:'Aktion ${id} konnte nicht geladen werden'
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
					var deal:Deal = new Deal(data);
					trace(deal.id);
					setState({loading:false, actualState:deal, initialData: copy(deal)});
					trace(untyped state.actualState.id + ':' + state.actualState.fieldsInitalized.join(','));
					//setState({});
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
			/*case 'get':
				jsx('
					<Table id="fieldsList" data=${state.dataTable}
					${...props} dataState = ${dataDisplay["dealsList"]} 
					className="is-striped is-hoverable" fullWidth=${true}/>
				');*/
			case 'open'|'update':
				trace(state.actualState);
				/*var fields:Map<String,FormField> = [
					for(k in dataAccess['open'].view.keys()) k => dataAccess['open'].view[k]
				];*/
				(state.actualState==null ? state.formApi.renderWait():
				state.formBuilder.renderForm({
					mHandlers:state.mHandlers,
					fields:[
						for(k in dataAccess['open'].view.keys()) k => dataAccess['open'].view[k]
					],
					model:'deal',
					//ref:formRef,
					title: 'Bearbeite Aktion' 
				},state.actualState));
		
			/*case 'insert':
				trace(dataDisplay["fieldsList"]);
				trace(state.dataTable[29]['id']+'<<<');
				jsx('
					<Table id="fieldsList" data=${state.dataTable}
					${...props} dataState = ${dataDisplay["fieldsList"]} 
					className="is-striped is-hoverable" fullWidth=${true}/>				
				');	*/
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
			<form className="tabComponentForm"  >
				${renderResults()}
			</form>
		'));		
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