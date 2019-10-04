package view.shared.io;
import haxe.Constraints.Function;
import model.Contact;
import haxe.Json;
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
import react.ReactPaginate;
import react.ReactRef;
import react.ReactUtil;
import react.ReactUtil.copy;
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
	
	function sessionStore(){
		trace(actualState);
		Browser.window.sessionStorage.setItem('contact',Json.stringify(actualState));
		Browser.window.removeEventListener('beforeunload', sessionStore);
	}

	function initSession()
	{
		Browser.window.addEventListener('beforeunload', sessionStore);
		var sessContacts = Browser.window.sessionStorage.getItem('contacts');
		if(sessContacts != null)
		{
			var sessionContact:Contact = Json.parse(sessContacts);
			trace(sessionContact);
			if(sessionContact.id == initialState.id)
			{
				trace(actualState);
				forceUpdate();
			}
		}
		else if((initialState.id!=null && !App.store.getState().dataStore.contactData.exists(initialState.id)))
		{
			//DATA NOT IN STORE - LOAD IT
			App.store.dispatch(DBAccess.get({
				action:'get',
				className:'data.Contacts',
				table:'contacts',
				filter:	'id|${initialState.id}',
				user:App.store.getState().user
			}));
			//p.then(function ())
			//App.store.dispatch(AppAction.GlobalState('contacts',initialState.id));
			//untyped props.globalState('contacts',initialState.id);
			
		}
		else if(actualState==null){
			actualState = copy(initialState);
			actualState = view.shared.io.Observer.run(actualState, function(newState){
				actualState = newState;
				trace(actualState);
			});	
		}
		if(formRef.current != null)
		{
			//trace(Reflect.fields(formRef.current));
			formRef.current.addEventListener('keyup', handleChange);
			/*var formElement:Element = Browser.window.document.querySelector('form[name="contact"]');
			trace(Reflect.fields(formElement));*/
			formRef.current.addEventListener('mouseup', function(ev:Dynamic)
			{
				//trace(Reflect.fields(ev.originalTarget));
				trace(ev.target.value);
				//doChange(ev.target.name,ev.target.value);
			});
		}		
	}

	/**
	 * PAGER HANDLING
	 */

	function renderPager():ReactFragment
	{
		trace('pageCount=${state.pageCount}');
		return jsx('
		<div className="paginationContainer">
			<nav>
				<$ReactPaginate previousLabel=${'<'} breakLinkClassName=${'pagination-link'}
					pageLinkClassName=${'pagination-link'}					
					nextLinkClassName=${'pagination-next'}
					previousLinkClassName=${'pagination-previous'}
					nextLabel=${'>'}
					breakLabel=${'...'}
					breakClassName=${'break-me'}
					pageCount=${state.pageCount}
					marginPagesDisplayed={2}
					pageRangeDisplayed={5}
					onPageChange=${onPageChange}
					containerClassName=${'pagination  is-small'}
					subContainerClassName=${'pages pagination'}
					activeLinkClassName=${'is-current'}/>
			</nav>	
		</div>		
		');
	}	

	function onPageChange(data) {
		trace('${props.match.params.action}:${data.selected}');
		var fun:Function = Reflect.field(this,props.match.params.action);
		if(Reflect.isFunction(fun))
		{
			Reflect.callMethod(this,fun,[{page:data.selected}]);
		}		
	}
	
}