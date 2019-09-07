package view.shared.io;
import action.async.DBAccess;
import state.AppState;
import haxe.ds.Map;
import js.html.Document;
import js.html.Event;
import js.html.FormElement;
import js.html.HTMLCollection;
import js.html.HTMLOptionsCollection;
import js.Browser;
import me.cunity.debug.Out;
import react.ReactComponent;
import react.ReactEvent;
import react.ReactMacro.jsx;
import react.ReactRef;
import react.ReactUtil;
import view.shared.FormBuilder;
import state.FormState;
import view.dashboard.model.DBSyncModel;
import view.shared.SMItem;
import view.shared.io.FormApi;
import view.shared.io.DataFormProps;
import view.shared.io.DataAccess;
import view.table.Table;

class BaseForm extends ReactComponentOf<DataFormProps,FormState>
{
	var dataDisplay:Map<String,DataState>;
	var dataAccess:DataAccess;	
	var actualState:Dynamic;	
	var initialState:Dynamic;
	var formFields:DataView;
	var formRef:ReactRef<FormElement>;
	var fieldNames:Array<String>;

	public function doChange(name,value) {
		trace('$name: $value');
		if(name!=null && name!='')
		Reflect.setField(actualState,name,value);
		setState({initialState:actualState});
	}

	public function handleChange(e:Event) 
	{
		var el:Dynamic = e.target;
		//trace(Type.typeof(el));
		//trace('${el.name}:${el.value}');
		if(el.name != '' && el.name != null)
		{
			trace('>>${el.name}=>${el.value}<<');
			//trace(actualState);
			Reflect.setField(actualState,el.name,el.value);
			trace(actualState.last_name);
		}	

		//trace(actualState);
	}		

	function handleSubmit(event:Event) {

		event.preventDefault();
		trace(state.initialState.id);
		var doc:Document = Browser.window.document;
		var formElement:FormElement = formRef.current;//cast(doc.querySelector('form[name="contact"]'),FormElement);
		var elements:HTMLCollection = formElement.elements;
		for(k in formFields.keys())
		{
			if(k=='id')
				continue;
			try 
			{
				var item:Dynamic = elements.namedItem(k);
				//trace('$k => ${item.type}:' + item.value);
				Reflect.setField(actualState, item.name, switch (item.type)
				{
					//case DateControl|DateTimrControl:

					case 'checkbox':
					//trace('${item.name}:${item.checked?true:false}');
					item.checked?1:0;
					case 'select-multiple'|'select-one':
					var sOpts:HTMLOptionsCollection = item.selectedOptions;
					//trace (sOpts.length);
					sOpts.length>1 ? [for(o in 0...sOpts.length)sOpts[o].value ].join('|'):item.value;
					default:
					//trace('${item.name}:${item.value}');
					item.value;
				});			
			}
			catch(ex:Dynamic)
			{
				trace(ex);
			}
		}
		//setState({actualState: actualState});
		trace(actualState);
		go(actualState);
	}

	function go(aState:Dynamic){}

	override public function render():ReactFragment {
		return null;
	}	
}