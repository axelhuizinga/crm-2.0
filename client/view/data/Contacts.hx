package view.data;

import action.async.DataAction;
import haxe.Constraints.Function;
import state.DataAccessState;
import haxe.macro.Expr.Catch;
import action.AppAction;
import react.ReactRef;
import react.router.RouterMatch;
import react.router.ReactRouter;
import comments.StringTransform;
import haxe.CallStack;
import haxe.Serializer;
import haxe.ds.IntMap;
import haxe.ds.StringMap;
import haxe.Json;
import js.html.XMLHttpRequest;
import haxe.http.HttpJs;
import macrotools.Macro.model;
import me.cunity.debug.Out;
import state.AppState;
import react.ReactEvent;
import react.Fragment;
import react.ReactComponent;
import react.ReactMacro.jsx;
import react.ReactUtil;
import react.ReactType;
import redux.Redux.Dispatch;
import loader.AjaxLoader;
import view.data.contacts.List;
import view.data.contacts.Edit;

import view.data.contacts.model.ContactsModel;
import shared.DBAccess;
import shared.DbData;
import shared.DBMetaData;
import model.Contact;
import view.shared.FormField;
import loader.BinaryLoader;
import view.shared.io.DataAccess;
import view.shared.io.DataFormProps;
import view.shared.io.FormApi;
import view.shared.FormState;
import view.shared.OneOf;
import view.shared.SMenu;
import view.shared.SMItem;

import view.shared.SMenuProps;
import view.table.Table;
using  shared.Utils;

/**
 * ...
 * @author axel@cunity.me
 */

@:connect
class Contacts extends ReactComponentOf<DataFormProps,FormState>
{
	
	var dataDisplay:Map<String,DataState>;
	var dataAccess:DataAccess;	
	var dbData: shared.DbData;
	var dbMetaData:shared.DBMetaData;
	
	public static var initialState:Contact=
	{
		id:0,
		edited_by: 0,
		mandator: 0
	};

	public function new(props) 
	{
		super(props);
		dataAccess = ContactsModel.dataAccess;
		dataDisplay = ContactsModel.dataDisplay;
		trace('...' + Reflect.fields(props));
		trace(props.match.params);
		if(props.match.params.section==null)
		{
			//SET DEFAULT SECTION
			//trace('reme');
			var baseUrl:String = props.match.path.split(':section')[0];
			props.history.push('${baseUrl}List');
		}		
		
		state =  App.initEState({
			dataTable:[],loading:false,selectedData:new IntMap(), selectedRows:[],values:new Map<String,Dynamic>(),
		},this);
		//trace(state.selectedData);
		//trace(state.loading);		
	}
	
	override function componentDidCatch(error, info) {
		// Display fallback UI
		//if(state.mounted)
		try{
			this.setState({ hasError: true });
		}
		catch(ex:Dynamic)
		{trace(ex);}
		
		trace(error);
		Out.dumpStack(CallStack.callStack());
	}	

	override function shouldComponentUpdate(nextProps:DataFormProps, nextState:FormState) {
		trace('propsChanged:${nextProps!=props}');
		trace('stateChanged:${nextState!=state}');
		if(nextState!=state)
			return true;
		return nextProps!=props;
	}

	static function mapDispatchToProps(dispatch:Dispatch):Dynamic
    {
		trace(dispatch + ':' + (dispatch == App.store.dispatch? 'Y':'N'));
        return {
			select:function(id:Int,data:Map<String,Dynamic>,match:RouterMatch)
			{
				trace('select:$id');
				dispatch(DataAction.CreateSelect(id,data,match));
			},
			storeFormChange: function(path:String, formState:FormState) 
			{
				trace(Reflect.fields(formState));
				trace(formState.selectedRows.length);
				return;
				dispatch(AppAction.FormChange(
					path,
					formState
				));
			},
			/*update: function(dbaProps:DBAccessProps) {
				trace(dbaProps);
				dispatch(DataAction.Update(dbaProps));
			}*/
		};
    }
	
	static function mapStateToProps(aState:AppState) 
	{
		trace(aState.dataStore.dbData);
		return {
			user:aState.appWare.user
		};
	}
	
	public function delete(ev:ReactEvent):Void
	{
		trace(state.selectedRows.length);
		var data = state.formApi.selectedRowsMap(state);
	}

	public function read(ev:ReactEvent):Void
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
				id:props.user.id,
				jwt:props.user.jwt,
				className:'data.Contacts',
				action:'read',
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
				
				read(ev);
				//state.formApi.doAction('read');	
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
		props.history.push('${baseUrl}Edit/${FormApi.params(state.selectedData.keys().keysList())}');
		for(k in dataAccess['update'].view.keys())
		{
			//trace('$k => ' + sData[k]);
			Reflect.setField(initialState, k, sData[k]);
		}
		//trace(it.hasNext());				
	}
		
	override public function componentDidMount():Void 
	{	
		trace(props.location);
		//setState({mounted:true});
		return;
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
			state.formApi.doAction('read');	
		}
	}

	function handleChange(contact, value, t) {
		trace(contact);
		var field:String = contact.split('.')[1];
		trace(field);
		trace(contact.length);
		trace(t);
		
		//trace(Type.typeof(contact));
		//Out.dumpObject(contact);
		//trace(contact[0].fp_incr(1));
		
		trace(value);
		Reflect.setField(initialState, field, value);
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
	
	/*function renderResults():ReactFragment
	{
		trace(props.match.params.section + '/' + props.match.params.action + ' state.dataTable:' + Std.string(state.dataTable != null));
		//trace(dataDisplay["userList"]);

		trace('###########loading:' + state.loading);
		return switch(props.match.params.action)
		{
			case 'read':
				trace('state.dataTable.length:'+state.dataTable.length);
				if(state.dataTable.length==0)				
					return null;
				jsx('
					<Table id="fieldsList" data=${state.dataTable} parentComponent=${this} 
					${...props} dataState = ${dataDisplay["contactList"]} 
					className="is-striped is-hoverable" fullWidth=${true}/>
				');
			case 'update':
			//trace(initialState);
			//trace(model(initialState, contact, first_name));
			var fields:Map<String,FormField> = [
				for(k in dataAccess['update'].view.keys()) k => dataAccess['update'].view[k]
			];
			//trace(fields);
			state.formBuilder.renderLocal({
				fields:[
					for(k in dataAccess['update'].view.keys()) k => dataAccess['update'].view[k]
				],
				model:'contact',
				title: 'Kontakt - Bearbeite Stammdaten'
			},initialState);
				
			case 'create':
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
	}*/
	
	override function render():ReactFragment
	{
		//if(state.dataTable != null)	trace(state.dataTable[0]);
		trace(props.match.params.section);		
		trace(props.match.params.action);		
		return switch(props.match.params.section)
		{
			case "List":
				jsx('
					<$List ${...props} formApi=${state.formApi} fullWidth={true} sideMenu=${state.sideMenu}/>
					');					
			case "Edit":
				jsx('
					<$Edit ${...props} parentComponent=${this} formApi=${state.formApi} fullWidth={true} sideMenu=${state.sideMenu}/>
				');				
			default:
				null;					
		}		
	}

}