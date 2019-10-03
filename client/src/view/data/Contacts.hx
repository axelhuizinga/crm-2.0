package view.data;

import action.DataAction;
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
import action.async.LiveDataAccess;
import view.data.contacts.List;
import view.data.contacts.Edit;

import model.contacts.ContactsModel;
import action.async.DBAccess;
import shared.DbData;
import shared.DBMetaData;
import model.Contact;
import view.shared.FormField;
import loader.BinaryLoader;
import view.shared.io.DataAccess;
import view.shared.io.DataFormProps;
import view.shared.io.FormApi;
import state.FormState;
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
			trace('reme');
			var baseUrl:String = props.match.path.split(':section')[0];
			props.history.push('${baseUrl}List/get');
		}		
		
		state =  App.initEState({
			dataTable:[],loading:false,contactData:new IntMap(), selectedRows:[],values:new Map<String,Dynamic>(),
		},this);
		//trace(state.contactData);
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

	/*override function shouldComponentUpdate(nextProps:DataFormProps, nextState:FormState) {
		trace('propsChanged:${nextProps!=props}');
		trace('stateChanged:${nextState!=state}');
		if(nextState!=state)
			return true;
		return nextProps!=props;
	}*/

	static function mapDispatchToProps(dispatch:Dispatch):Dynamic
    {
		
        return {
			globalState: function (key:String,?data:Dynamic)
			{
				trace('$key => $data');
				dispatch(GlobalState(key,data));
			},
			select:function(id:Int,data:IntMap<Map<String,Dynamic>>,match:RouterMatch, ?selectType:SelectType)
			{
				trace('select:$id selectType:${selectType}');
				//dispatch(DataAction.CreateSelect(id,data,match));
				dispatch(LiveDataAccess.select({id:id,data:data,match:match,selectType: selectType}));
			},
			storeActData:function (data:IntMap<Map<String,Dynamic>>)
			{
				dispatch(DataAction.SelectActContacts(data));
			}/*,
			storeFormChange: function(path:String, formState:FormState) 
			{
				trace(Reflect.fields(formState));
				trace(formState.selectedRows.length);
				return;
				dispatch(AppAction.FormChange(
					path,
					formState
				));
			}*/
			/*edit: function(dbaProps:DBAccessProps) {
				trace(dbaProps);
				dispatch(DataAction.Update(dbaProps));
			}*/
		};
    }
	
	static function mapStateToProps(aState:AppState) 
	{
		//trace(aState.dataStore.contactData);
		trace(aState.dataStore.contactData.keys().next());
		var bState =  {
			dataStore:aState.dataStore,
			user:aState.user,
			//idLoaded:aState.dataStore.contactData.keys().next()
		};
		//trace(bState);
		return bState;
	}
		
	override public function componentDidMount():Void 
	{	
		trace(props.location.pathname);
		//setState({mounted:true});
		return;
		var baseUrl:String = props.match.path.split(':section')[0];
		trace(props.match);
	}
	
	override function render():ReactFragment
	{
		//if(state.dataTable != null)	trace(state.dataTable[0]);
		trace(props.match.params.section);		
		trace(props.match.params.action);		
		return switch(props.match.params.section)
		{
			case "List":
				jsx('
					<$List ${...props} limit=${1000} formApi=${state.formApi} fullWidth={true} sideMenu=${state.sideMenu}/>
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