package view.data.contacts;

import js.Browser;
import js.html.NodeList;
import js.html.TableRowElement;
import react.router.RouterMatch;
import db.DBAccessProps;
import view.shared.io.BaseForm;
import redux.Redux.Dispatch;
import js.lib.Promise;
import action.async.CRUD;
import action.DataAction;
import model.deals.DealsModel;
import state.AppState;
import haxe.Constraints.Function;
import haxe.ds.IntMap;
import me.cunity.debug.Out;
import react.ReactComponent;
import react.ReactEvent;
import react.ReactMacro.jsx;
import react.ReactUtil;
import shared.DbData;
import shared.DBMetaData;
//import view.data.deals.model.Deals;
import view.shared.FormField;
import state.FormState;
import view.shared.MItem;
import view.shared.MenuProps;
import view.shared.io.FormApi;
import view.shared.FormBuilder;

import view.shared.io.DataFormProps;
import view.shared.io.DataAccess;
import loader.BinaryLoader;
import view.table.Table;

//@:connect
class Deals //extends ReactComponentOf<DataFormProps,FormState>
{
	public static var menuItems:Array<MItem> = [
		{label:'Bearbeiten',action:'open',section: 'Edit'},
	//	{label:'Neu', action:'insert',section: 'Edit'},		
		{label:'Löschen',action:'delete'},
		{label:'Auswahl aufheben',action:'selectionClear'}
	];
	var dataAccess:DataAccess;	
	var dataDisplay:Map<String,DataState>;
	var formFields:DataView;
	var fieldNames:Array<String>;
	var baseForm:BaseForm;		
	var dbData: shared.DbData;
	var dbMetaData:shared.DBMetaData;

	public function new(props) 
	{
		super(props);
		//baseForm =new BaseForm(this);
		dataDisplay = DealsModel.dataDisplay;
		trace('...' + Reflect.fields(props));

		state =  App.initEState({
			dataTable:[],
			loading:false,
			dealsData:new IntMap(),			
			selectedRows:[],
			sideMenu:null,
			values:new Map<String,Dynamic>()
		},this);
		get(props.id);	
		trace(state.loading);
	}
	
    static function mapDispatchToProps(dispatch:Dispatch) {
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
	
	public function delete(ev:ReactEvent):Void
	{
		trace(state.selectedRows.length);
		var data = state.formApi.selectedRowsMap(state);
	}

	/**
	 * get all deals with this Contact! id
	 * @param id 
	 */

	public function get(contact:Int):Void
	{
		trace('hi $ev');
		var offset:Int = 0;
		state.loading =true;
		if(ev != null && ev.page!=null)
		{
			offset = Std.int(props.limit * ev.page);
		}		
		//var contact = (props.location.state.contact);
		var p:Promise<DbData> = return App.store.dispatch(CRUD.read(
			{
				classPath:'data.Deals',
				action:'get',
				filter:{contact:contact, mandator:'1'}),
				limit:props.limit,
				offset:offset>0?offset:0,
				table:'deals',
				resolveMessage:{					
					success:'Aktionsliste wurde geladen',
					failure:'Aktionsliste konnte nicht geladen werden'
				},				
				dbUser:props.userState.dbUser,
				devIP:App.devIP
			}
		));
		p.then(function(data:DbData){
			trace(data.dataRows.length); 
			state = ReactUtil.copy(state, {loading:false, dataTable:data.dataRows});
		});
	}
	
	public function edit(ev:ReactEvent):Void
	{
		trace(state.selectedRows.length);				
	}

	public function selectionClear() {
		var match:RouterMatch = ReactUtil.copy(props.match);
		match.params.action = 'get';
		trace(state.dataTable.length);
		props.select(1, null,match, UnselectAll);	
		//trace(formRef !=null);

		var trs:NodeList = Browser.document.querySelectorAll('.tabComponentForm tr');				
		trace(trs.length);
		for(i in 0...trs.length){
			var tre:TableRowElement = cast(trs.item(i), TableRowElement);
			if(tre.classList.contains('is-selected')){
				trace('unselect:${tre.dataset.id}');
				tre.classList.remove('is-selected');
			}
		};
		Browser.document.querySelector('[class="grid-container-inner"]').scrollTop = 0;
	}
		
	override public function componentDidMount():Void 
	{	
		dataAccess = [
			'get' =>{
				source:[
					"deals" => []
				],
				view:[]
			},
		];			
		//
		if(props.userState.dbUser != null)
		trace('yeah: ${props.userState.dbUser.first_name}');
		//dbData = FormApi.init(this, props);
		state.formApi.doAction();
		/*
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
	
	function renderResults():ReactFragment
	{
		trace(props.match.params.section + ':' + Std.string(state.dataTable != null));
		//trace(dataDisplay["userList"]);
		trace(state.loading);
		if(state.loading)
			return state.formApi.renderWait();
		trace('###########loading:' + state.loading);
		return switch(props.match.params.action)
		{
			case 'get':
			jsx('
				<form className="tabComponentForm" >
					<$Table id="fieldsList" data=${state.dataTable}  parentComponent=${this}
					${...props} dataState = ${dataDisplay["dealsList"]} renderPager=${{function()BaseForm.renderPager(this);}}
					className="is-striped is-hoverable" fullWidth=${true}/>
				</form>
			');			
			/*case 'get':
				jsx('
					<Table id="fieldsList" data=${state.dataTable} 
					${...props} dataState = ${dataDisplay["dealsList"]} renderPager=${function()BaseForm.renderPager(this)} parentComponent=${this}
					className="is-striped is-hoverable" fullWidth=${true}/>
				');*/
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
		//return state.formApi.render(jsx('${renderResults()}
		return jsx('
				<div className="modal ${props.isActive?'is-active':''}">Hello Modal :)</div>
		');		
	}
	
	function updateMenu(?viewClassPath:String):MenuProps
	{
		var sideMenu = state.sideMenu;
		trace(sideMenu.section);
		for(mI in sideMenu.menuBlocks['List'].items)
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