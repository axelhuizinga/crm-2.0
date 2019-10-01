package state;

import haxe.ds.IntMap;
import js.html.FormElement;
import js.html.InputEvent;
import js.html.TableRowElement;
import react.ReactRef;
import view.shared.SMenuProps;
import view.shared.FormBuilder;
import view.shared.FormField;
import view.shared.io.FormApi;


/*enum Loading
{
	Component;
	Data(action:Function);
	State;
}*/

typedef FormState =
{
	?action:String,
	?actualState:Dynamic,
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
	//?contactData:IntMap<Map<String,Dynamic>>,
	?initialData:IntMap<Map<String,Dynamic>>,
	?selectedRows:Array<TableRowElement>,
	?selectedRowIDs:Array<Int>,
	?handleChange:InputEvent->Void,
	?handleSubmit:Dynamic->Void,	
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
	?section:String,
	?sideMenu:SMenuProps,
	?storeListener:redux.Redux.Unsubscribe,
	?submitted:Bool,
	?errors:Map<String,String>,
	?title:String
}