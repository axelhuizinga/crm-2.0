package state;

import view.shared.Menu;
import view.grid.Grid;
import react.ReactComponent.ReactComponentOf;
import haxe.Constraints.Function;
import js.html.Element;
import js.Object;
import haxe.ds.ObjectMap;
import react.ReactComponent.ReactFragment;
import db.DBAccessProps;
import view.shared.MItem;
import model.ORM;
import js.html.InputElement;
import haxe.ds.IntMap;
import haxe.ds.StringMap;
import js.html.FormElement;
import js.html.InputEvent;
import js.html.TableRowElement;
import react.ReactRef;
import view.shared.MenuProps;
import view.shared.FormBuilder;
import view.shared.FormField;
import view.shared.io.DataFormProps;
import view.shared.io.FormApi;

enum abstract HandlerAction(String) 
{
	var Close;
	var Delete;
	var New;
	var Reset;
	var Save;
	var SaveAndClose;
}

typedef SubmitHandler = 
{
	handler:InputEvent->Void,
	?handlerAction:HandlerAction,
	label:String
}

typedef FormState =
{
	?action:String,	
	?actualState:ORM,
	?actualStates:IntMap<ORM>,
	?clean:Bool,
	?data:Map<String,Dynamic>,
	?dataGrid:Grid,
	?classPath:String,
	?dataClassPath:String,
	?dbTable:Array<Map<String,Dynamic>>,
	?dataCount:Int,
	?dbQueryParam:DBAccessProps,
	?errors:Map<String,String>,
	?gridCSSClass:String,
	?ormRefs:Map<String,ORMComps>,
	?relDataComps:Map<String,ReactComponentOf<DataFormProps,FormState>>,
	?fields:Map<String,FormField>,//VIEW FORMFIELDS
	?formApi:FormApi,
	?formBuilder:FormBuilder,
//	?formStateKey:String,
	?formRef:ReactRef<FormElement>,
	?ref:Function,//,	
	?initialData:Dynamic,//IntMap<Map<String,Dynamic>>,
	?selectedData:IntMap<Map<String,Dynamic>>,
	?selectedRows:Array<TableRowElement>,
	?selectedRowIDs:Array<Int>,
	?handleChange:InputEvent->Void,
	?mHandlers:Array<MItem>,	
	?hasError:Bool,
	?limit:Int,
	?mounted:Bool,
	?isConnected:Bool,
	?loading:Bool,
	?initialState:Dynamic,
	?model:String,//db table name
	?modelClass:Dynamic,
	?valuesArray:Array<Map<String,Dynamic>>,//FORMATTED DISPLAY VALUES
	?values:Map<String,Dynamic>,//FORMATTED DISPLAY VALUES
	?forms:Map<String,FormView>,
	?page:Int,
	?pageCount:Int,
	?rows:Array<Dynamic>,
	?section:String,	
	?sideMenu:MenuProps,
	?sideMenuInstance:Menu,
	?storeListener:redux.Redux.Unsubscribe,
	?submitted:Bool,
	?title:String,
	?uid:String
}

typedef FormView = {
	form:ReactFragment,
	orm:ORM,
	props:DataFormProps,
	view:ReactComponentOf<DataFormProps,FormState>
}

typedef ORMComps = {
	orms:IntMap<ORM>,
	compRef:ReactComponentOf<DataFormProps,FormState>
}