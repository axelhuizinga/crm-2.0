package view.accounting.returndebit;

import model.ORM;
import haxe.Exception;
import action.AppAction;
import model.Deal;
import db.DbUser;
import action.async.LiveDataAccess;
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
import react.ReactUtil.copy;
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
import view.grid.Grid;

using StringTools;

@:connect
class DealForm extends ReactComponentOf<DataFormProps,FormState>
{
	public static var classPath = Type.getClassName(Deal);

	var dataAccess:DataAccess;
	var dataDisplay:Map<String,DataState>;
	var deal:Deal;
	var formFields:DataView;
	var fieldNames:Array<String>;
	var dbData: shared.DbData;
	var dbMetaData:shared.DBMetaData;
	var parentState:FormState;

	public function new(props:DataFormProps) 
	{
		super(props);
		dataAccess = DealsModel.dataAccess;
		fieldNames = BaseForm.initFieldNames(dataAccess['open'].view.keys());
		dataDisplay = DealsModel.dataGridDisplay;		
		trace('...' + Reflect.fields(props));
		state =  App.initEState({
			actualStates:new IntMap<ORM>(),
			dataTable:[],
			loading:false,
			dealsData:new IntMap(),	
			model:'deals',
			selectedRows:[],
			sideMenu:null,
			values:new Map<String,Dynamic>()
		},this);	
		parentState = props.parentComponent.state;
		trace(state.loading);
		trace('id:${props.id}');
		if(props.id!=null){
			loadData(props.id);
		}
	}
	
	static function mapDispatchToProps(dispatch:Dispatch) {
        return {
			load: function(param:DBAccessProps) return dispatch(CRUD.read(param)),
			/*loadData:function(id:Int = -1, me:Dynamic) return me.loadData(id),
			save: function(me:Dynamic) return me.update(),
			select:function(id:Int = -1, data:Dynamic, me:Dynamic, ?sType:SelectType)
			{
				//if(true) trace('select:$id dbUser:${dbUser}');
				if(true) trace('select:$id me:${Type.getClassName(Type.getClass(me))} SelectType:${sType}');
				//me.loadDealData(id);
				//dispatch(DataAction.CreateSelect(id,data,match));
				//dispatch(LiveDataAccess.select({id:id,data:data,match:match,selectType: selectType}));
			}*/
		};
	}
		
	static function mapStateToProps(aState:AppState) 
	{
		trace(Reflect.fields(aState));
		trace(aState.dataStore.returnDebitsData);
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
	 * get all deals with this Contact id
	 */

	public function get():Void
	{
		var offset:Int = 0;
		trace(props.filter);
		//setState({loading:true});	
		state.loading=true;	
		//var contact = (props.location.state.contact);
		var p:Promise<DbData> = props.load(
			{
				classPath:'data.Deals',
				action:'get',
				filter:(props.filter!=null?props.filter:{mandator:'1'}),
				limit:props.limit,
				offset:offset>0?offset:0,
				table:state.model,
				resolveMessage:{					
					success:'Spendenliste wurde geladen',
					failure:'Spendenliste konnte nicht geladen werden'
				},				
				dbUser:props.userState.dbUser,
				devIP:App.devIP
			}
		);
		p.then(function(data:DbData){
			trace(data.dataRows.length); 
			if(data.dataRows.length>0)
				trace(data.dataRows[0]);
			//setState({loading:false, dataTable:data.dataRows});
			setState({
				loading:false,
				dataTable:data.dataRows,
				dataCount:Std.parseInt(data.dataInfo['count']),
				pageCount: Math.ceil(Std.parseInt(data.dataInfo['count']) / props.limit)
			});			
		});
	}
	
	public function edit(ev:ReactEvent):Void
	{
		trace(state.selectedRows.length);				
	}
		
	override public function componentDidMount():Void 
	{	
		trace(props.action);
		if(props.userState.dbUser != null)
		trace('yeah: ${props.userState.dbUser.first_name}');
		//dbData = FormApi.init(this, props);
		props.parentComponent.registerOrmRef(this);
		//get();
		if(parentState.relDataComps!=null){
			parentState.relDataComps[Type.getClassName(Type.getClass(this))] = this;
		}
		//state.formApi.doAction(props.action);
	}
	
	public function loadData(id:Int):Void
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
					success:'Spende ${id} wurde geladen',
					failure:'Spende ${id} konnte nicht geladen werden'
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
				deal = new Deal(data);
				trace(deal.id);				
				setState({loading:false, actualState:deal, initialData: copy(deal)});
				//state = copy(state, {loading:false});
				deal.state.actualState = deal;
				state.actualStates.set(deal.id,deal);
				trace(untyped deal.state.actualState.id + ':' + deal.state.actualState.fieldsInitalized.join(','));
				//setState({});
				//trace(props.match);
				//trace(props.location.pathname + ':' + untyped state.actualState.amount);
				//trace(Reflect.fields(props));
				//trace(Reflect.fields(props.parentComponent.props));
				//props.history.replace(props.location.pathname.replace('open','update'));
				props.parentComponent.registerORM('deals',deal);
			}
		});
	}	
	
	function renderForm():ReactFragment
	{
		trace(state.loading + ':' + props.parentComponent.props.match.params.action);
		if(state.loading)
			return state.formApi.renderWait();
		//return jsx('<div key="dummy">Dummy</div>');
		////trace('###########loading:' + state.loading + ' state.actualState:${state.actualState}');
		//return null;
		return (state.actualState==null ? state.formApi.renderWait():
			state.formBuilder.renderForm({
				mHandlers:state.mHandlers,
				fields:[
					for(k in dataAccess['open'].view.keys()) k => dataAccess['open'].view[k]
				],
				model:'deals',
				//ref:formRef,
				title: 'Bearbeite Spende' 
			},state.actualState)
		);	
	}
	
	function renderResults():ReactFragment
	{
		//trace(props.action);
		//trace(dataDisplay["userList"]);
		//trace(state.loading);
		if(state.loading || state.dataTable == null || state.dataTable.length == 0)
			return state.formApi.renderWait();
		//trace('###########loading:' + state.dataTable);renderPager=${{function()BaseForm.renderPager(this);}}		
		trace(props.action);
		return switch(props.action)
		{
			case 'get':
			//trace(state.dataTable);<Fragment key=${i++}>
			jsx('
			<>
			<Grid id="dealsList" data=${state.dataTable}
			${...props} dataState = ${dataDisplay["dealsList"]} 
			parentComponent=${this} className="is-striped is-hoverable" fullWidth=${true}/>
			${renderForm()}		
			</>			
			');			
			case 'delete':
				null;
			default:
				null;
		}
		return null;
	}

	override public function render():ReactFragment
	{
		//if(state.dataTable != null)	trace(state.dataTable[0]);
		return null;
	}

	function update()
	{
		var changed:Int = 0;
		try{	
			//var it:Iterator<Deal> = props.parentComponent.state.ormRefs.get(state.model).orms.iterator();
			var it:Iterator<ORM> = state.actualStates.iterator();
			while(it.hasNext()){
				var deal:ORM = it.next();
				if(deal.fieldsModified.length>0){
					changed++;
					var data2save = deal.allModified();
					trace(data2save[0]);
					var dbQ:DBAccessProps = {
						classPath:'data.Deals',
						action:'update',
						data:data2save,
						filter:{id:deal.id,mandator:1},
						resolveMessage:{
							success:'Spende ${deal.id} wurde aktualisiert',
							failure:'Spende ${deal.id} konnte nicht aktualisiert werden'
						},
						table:'deals',
						dbUser:props.userState.dbUser,
						devIP:App.devIP
					}
					var p:Promise<Dynamic> = App.store.dispatch(CRUD.update(dbQ));
					p.then(function(d:Dynamic){
						trace(d);
						get();
					});
				}				
			}
		}
		catch(ex:Exception){
			trace(ex.details);
		}
		if(changed==0)
			trace('nothing to save');
		/*
		if(!state.actualState.modified())
		{
			//TODO: MAKE ALL MESSAGES CONFIGURABLE BY ADMIN
			App.store.dispatch(AppAction.Status(Update( 
				{	className:'',
					text:'Spende wurde nicht geändert'			
				}
			)));			
			trace('nothing modified');
			return;
		}*/
				
	}	
	
}