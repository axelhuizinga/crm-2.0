package view.shared;
import redux.Redux.Dispatch;
import haxe.Constraints.Function;
import haxe.ds.IntMap;
import history.History;
import history.Location;
import js.html.InputEvent;
import js.html.TableRowElement;
import react.ReactType;
import react.ReactComponent;
import view.shared.FormBuilder;
import view.shared.SMenuProps;
import view.shared.io.FormApi;

enum Loading
{
	Component;
	Data(action:Function);
	State;
}

typedef FormState =
{
	?action:String,
	?dataClassPath:String,
	?data:Map<String,Dynamic>,
	?dataTable:Array<Map<String,Dynamic>>,
	?formApi:FormApi,
	?formBuilder:FormBuilder,
	?clean:Bool,
	?selectedData:IntMap<Map<String,Dynamic>>,
	?selectedRows:Array<TableRowElement>,
	?handleChange:InputEvent->Void,
	?handleSubmit:Dynamic->Void,	
	?hasError:Bool,
	?mounted:Bool,
	?isConnected:Bool,
	?loading:Bool,
	?initialState:Dynamic,
	?model:String,
	?fields:Map<String,FormField>,//VIEW FORMFIELDS
	?valuesArray:Array<Map<String,Dynamic>>,//FORMATTED DISPLAY VALUES
	?values:Map<String,Dynamic>,//FORMATTED DISPLAY VALUES
	?section:String,
	?sideMenu:SMenuProps,
	?submitted:Bool,
	?errors:Map<String,String>,
	?title:String
}