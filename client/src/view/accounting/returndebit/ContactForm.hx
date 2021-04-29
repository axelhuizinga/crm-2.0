package view.accounting.returndebit;

import model.ORM;
import haxe.Exception;
import action.AppAction;
import db.DbUser;
import model.Contact;
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
import state.AppState;
import model.contacts.ContactsModel;
import model.deals.DealsModel;
import model.accounting.AccountsModel;
import haxe.Constraints.Function;
import haxe.ds.IntMap;
import me.cunity.debug.Out;
import react.ReactComponent;
import react.ReactEvent;
import react.ReactMacro.jsx;
import react.ReactUtil.copy;
import shared.DbData;
import shared.DBMetaData;
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
class ContactForm extends ReactComponentOf<DataFormProps,FormState>
{
	public static var classPath = Type.getClassName(ContactForm);

	var dataAccess:DataAccess;
	var dataDisplay:Map<String,DataState>;
	var contact:Contact;
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
		dataDisplay = ContactsModel.dataGridDisplay;		
		trace('...' + Reflect.fields(props));
		state =  App.initEState({
			actualStates:new IntMap<ORM>(),
			dataTable:[],
			loading:false,
			dealsData:new IntMap(),	
			model:'contacts',
			selectedRows:[],
			sideMenu:null,
			values:new Map<String,Dynamic>()
		},this);	
		parentState = props.parentComponent.state;
		trace('id:${props.id}');
		//trace(Reflect.fields(props.parentComponent.state.relDataComps).join('|'));
		//trace(state.loading);
		//trace(Type.typeof(props.parentComponent.state.relDataComps));
		if(props.id!=null){
			loadData(props.id);
		}
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
	
	override public function componentDidMount():Void 
	{	
		dataAccess = [
			'get' =>{
				source:[
					"contacts" => []
				],
				view:[]
			},
		];			
		//
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
				classPath:'data.Contacts',
				action:'get',
				filter:{id:id,mandator:1},
				resolveMessage:{
					success:'Kontakt ${id} wurde geladen',
					failure:'Kontakt ${id} konnte nicht geladen werden'
				},
				table:'contacts',
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
				contact = new Contact(data);
				trace(contact.id);				
				//setState({loading:false, actualState:contact, initialData: copy(contact)});
				//state = copy(state, {loading:false});
				contact.state.actualState = contact;
				state.actualStates.set(contact.id,contact);
				trace(untyped contact.state.actualState.id + ':' + contact.state.actualState.fieldsInitalized.join(','));
				//setState({});
				//trace(props.match);
				//trace(props.location.pathname + ':' + untyped state.actualState.amount);
				//trace(Reflect.fields(props));
				//trace(Reflect.fields(props.parentComponent.props));
				//props.history.replace(props.location.pathname.replace('open','update'));
				props.parentComponent.registerORM('contacts',contact);
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
		trace('###########loading:' + state.loading + 'state.actualState:${state.actualState}');
		//return null;
		return (state.actualState==null ? state.formApi.renderWait():
			state.formBuilder.renderForm({
				mHandlers:state.mHandlers,
				fields:[
					for(k in dataAccess['open'].view.keys()) k => dataAccess['open'].view[k]
				],
				model:'contact',
				//ref:formRef,
				title: 'Bearbeite Spende' 
			},state.actualState)
		);			
	}
	
	override public function render():ReactFragment
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
			case 'importReturnDebitFile':
			//trace(state.dataTable);
			jsx('
			<>
			<Grid id="contact" data=${state.dataTable}
			${...props} dataState = ${dataDisplay["contactsList"]} 
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
	
	function update()
	{
		var changed:Int = 0;
		try{	
			//var it:Iterator<Deal> = props.parentComponent.state.ormRefs.get(state.model).orms.iterator();
			var it:Iterator<ORM> = state.actualStates.iterator();
			while(it.hasNext()){
				var contact:ORM = it.next();
				if(contact.fieldsModified.length>0){
					changed++;
					var data2save = contact.allModified();
					trace(data2save[0]);
					var dbQ:DBAccessProps = {
						classPath:'data.Deals',
						action:'update',
						data:data2save,
						filter:{id:contact.id,mandator:1},
						resolveMessage:{
							success:'Spende ${contact.id} wurde aktualisiert',
							failure:'Spende ${contact.id} konnte nicht aktualisiert werden'
						},
						table:'contacts',
						dbUser:props.userState.dbUser,
						devIP:App.devIP
					}
					var p:Promise<Dynamic> = App.store.dispatch(CRUD.update(dbQ));
					p.then(function(d:Dynamic){
						trace(d);
						loadData(props.id);
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