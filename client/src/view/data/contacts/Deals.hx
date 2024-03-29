package view.data.contacts;

import react.router.ReactRouter;
import model.ORM;
import haxe.Exception;
import action.AppAction;
import model.Deal;
import data.DataState;
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
class Deals extends ReactComponentOf<DataFormProps,FormState>
{
	public static var classPath = Type.getClassName(Deals);

	var dataAccess:DataAccess;
	var dataDisplay:Map<String,DataState>;
	var deal:Deal;
	var formFields:DataDisplay;
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
			dbTable:[],
			loading:false,
			dealsData:new IntMap(),	
			model:'deals',
			selectedRows:[],
			sideMenu:null,
			values:new Map<String,Dynamic>()
		},this);	
		parentState = props.parentComponent.state;
		//trace(state.loading);
		//trace(Reflect.fields(props.parentComponent.state.relDataComps).join('|'));
		//trace(Type.typeof(props.parentComponent.state.relDataComps));
	}
	
	static function mapDispatchToProps(dispatch:Dispatch) {
        return {
			load: function(param:DBAccessProps) return dispatch(CRUD.read(param)),
			loadData:function(id:Int = -1, me:Dynamic) return me.loadData(id),
			save: function(me:Dynamic) return me.update(),
			select:function(id:Int = -1, data:Dynamic, me:Dynamic, ?sType:SelectType)
			{
				//if(true) trace('select:$id dbUser:${dbUser}');
				if(true) trace('select:$id me:${Type.getClassName(Type.getClass(me))} SelectType:${sType}');
				//me.loadDealData(id);
				//dispatch(DataAction.CreateSelect(id,data,match));
				//dispatch(LiveDataAccess.select({id:id,data:data,match:match,selectType: selectType}));
			}
		};
	}
		
	static function mapStateToProps(aState:AppState) 
	{
		trace(Reflect.fields(aState));
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
		//trace(props.filter);
		if(deal!=null)
			trace(deal.id + ':' + deal.contact);
		var filter:Dynamic = (deal!=null?{id:deal.id, contact:deal.contact, mandator:1}:{mandator:'1'});
		if(props.filter!=null){
			filter = BaseForm.copy(filter,props.filter);
		}
		trace(filter);
		//setState({loading:true});	
		state.loading=true;	
		//var contact = (props.location.state.contact);
		var p:Promise<DbData> = props.load(
			{
				classPath:'data.Deals',
				action:'get',
				filter:filter,
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
			//setState({loading:false, dbTable:data.dataRows});
			setState({
				loading:false,
				dbTable:data.dataRows,
				dataCount:Std.parseInt(data.dataInfo['count']),
				pageCount: Math.ceil(Std.parseInt(data.dataInfo['count']) / props.limit)
			});			
		});
	}
	
	public function edit(ev:ReactEvent):Void
	{
		trace(state.selectedRows.length);				
	}

	/*public function selectionClear() {
		var match:RouterMatch = copy(props.match);
		match.params.action = 'get';
		trace(state.dbTable.length);
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
	}*/
		
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
		trace(props.action);
		if(props.userState.dbUser != null)
		trace('yeah: ${props.userState.dbUser.first_name}');
		trace(Type.getClassName(Type.getClass(props.parentComponent)));
		//dbData = FormApi.init(this, props);
		trace(props.parentComponent.props.match);
		trace(props.match);
		props.parentComponent.registerOrmRef(this);
		get();
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
			//trace(data.dataRows.length); 
			if(data.dataRows.length==1)
			{
				var data = data.dataRows[0];
				trace(data);
				//if( mounted)
				deal = new Deal(data);
				trace(deal.id + ':' + deal.contact);				
				//setState({loading:false, actualState:deal, initialData: copy(deal)});
				//state = copy(state, {loading:false});
				deal.state.actualState = deal;
				state.actualStates.set(deal.id,deal);
				//trace(untyped deal.state.actualState.id + ':' + deal.state.actualState.contact + ':' + deal.state.actualState.fieldsInitalized.join(','));
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
		//trace(props.action);
		//trace(dataDisplay["userList"]);
		trace(state.loading + ':' + props.parentComponent.props.match.params.action);
		if(state.loading)
			return state.formApi.renderWait();
		trace('###########loading:' + state.loading);
		//return null;
		return switch(props.parentComponent.props.match.params.action)
		{
			case 'open2'|'update2':
				trace(Reflect.fields(state.actualState).join('|'));
				//trace(state.actualState);
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
					//title: 'Bearbeite Spende' 
				},state.actualState));
			default:
				trace('>>>${props.parentComponent.props.match.params.action}<<<');
				null;
		}
		//trace('###########loading:' + state.dbTable);renderPager=${{function()BaseForm.renderPager(this);}}
	}
	
	function renderResults():ReactFragment
	{
		//trace(props.action);
		//trace(dataDisplay["userList"]);
		//trace(state.loading);
		if(state.loading || state.dbTable == null || state.dbTable.length == 0)
			return state.formApi.renderWait();
		//trace('###########loading:' + state.dbTable);renderPager=${{function()BaseForm.renderPager(this);}}		
		trace(props.action);
		return switch(props.action)
		{
			case 'get':
			//trace(state.dbTable);
			jsx('
			<>
			<Grid id="dealsList" data=${state.dbTable}
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
	/**
	 * <$Table id="dealsList" data=${state.dbTable}  parentComponent=${this}
					${...props} dataState=${dataDisplay.get("dealsList")} 
					className="is-striped is-hoverable" fullWidth=${true}/>
	 */
	override public function render():ReactFragment
	{
		//if(state.dbTable != null)	trace(state.dbTable[0]);
		return jsx('
		<div className="t_caption">Spenden
		<form className="tabComponentForm2" ref=${props.formRef} name="dealsList" key="dealsList"> 			
			${renderResults()}
		</form></div>');
	}

	function update()
	{
		var changed:Int = 0;
		try{	
			//var it:Iterator<Deal> = props.parentComponent.state.ormRefs.get(state.model).orms.iterator();
			var it:Iterator<ORM> = state.actualStates.iterator();
			while(it.hasNext()){
				deal = cast(it.next(),Deal);
				trace(deal.id + ':' + deal.contact +' fieldsModified.length:' + deal.fieldsModified.length);
				if(deal.fieldsModified.length>0){
					changed++;
					trace(changed);
					var data2save = deal.allModified();
					//trace(data2save[0]);
					trace(Type.typeof(data2save));

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
						//get();
					});
				}				
			}
		}
		catch(ex:Exception){
			trace(ex.details());
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