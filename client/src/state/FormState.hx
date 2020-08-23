package state;

import view.shared.MItem;
import model.ORM;
import js.html.InputElement;
import haxe.ds.IntMap;
import js.html.FormElement;
import js.html.InputEvent;
import js.html.TableRowElement;
import react.ReactRef;
import view.shared.MenuProps;
import view.shared.FormBuilder;
import view.shared.FormField;
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
	?dataClassPath:String,
	?data:Map<String,Dynamic>,
	?dataTable:Array<Map<String,Dynamic>>,
	?dataCount:Int,
	?fields:Map<String,FormField>,//VIEW FORMFIELDS
	?formApi:FormApi,
	?formBuilder:FormBuilder,
	?formStateKey:String,
	?clean:Bool,
	?pageCount:Int,
	?ref:ReactRef<FormElement>,
	?initialData:Dynamic,//IntMap<Map<String,Dynamic>>,
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
	?model:String,
	?modelClass:Dynamic,
	?valuesArray:Array<Map<String,Dynamic>>,//FORMATTED DISPLAY VALUES
	?values:Map<String,Dynamic>,//FORMATTED DISPLAY VALUES
	?rows:Array<Dynamic>,
	?section:String,
	?sideMenu:MenuProps,
	?storeListener:redux.Redux.Unsubscribe,
	?submitted:Bool,
	?errors:Map<String,String>,
	?title:String
}