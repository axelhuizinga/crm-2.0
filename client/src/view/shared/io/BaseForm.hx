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

class BaseForm
{
	var comp:ReactComponentOf<DataFormProps,FormState>;


	public function new(comp:Dynamic) {
		this.comp = comp;		
	}

	public function compareStates() {
		for(f in Reflect.fields(comp.state.initialState))
		{
			trace('$f:${Reflect.field(comp.state.actualState,f)}<==>${Reflect.field(comp.state.initialState,f)}<');
		}
	}

	public function doChange(name,value) {
		trace('$name: $value');
		if(name!=null && name!='')
		Reflect.setField(comp.state.actualState,name,value);
		
		//setState({comp.state.initialState:comp.state.actualState});
	}

	public function handleChange(e:Event) 
	{
		var el:Dynamic = e.target;
		//trace(Type.typeof(el));
		//trace('${el.name}:${el.value}');
		if(el.name != '' && el.name != null)
		{
			trace('>>${el.name}=>${el.value}<<');
			//trace(comp.state.actualState);
			Reflect.setField(comp.state.actualState,el.name,el.value);
			trace(comp.state.actualState.last_name);
		}	

		//trace(comp.state.actualState);
	}		

	/*function handleSubmit(event:Event) {

		event.preventDefault();
		trace(comp.state.initialState.id);
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
				Reflect.setField(comp.state.actualState, item.name, switch (item.type)
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
		//setState({comp.state.actualState: comp.state.actualState});
		trace(comp.state.actualState);
		go(comp.state.actualState);
	}*/

	public function initFieldNames(keys:Iterator<String>):Array<String> {
		var fieldNames = new Array();
		for(k in keys)
		{
			fieldNames.push(k);
		}		
		return fieldNames;
	}
	
	public function sessionStore(){
		trace(comp.state.actualState);
		Browser.window.sessionStorage.setItem('contact',Json.stringify(comp.state.actualState));
		Browser.window.removeEventListener('beforeunload', sessionStore);
	}

	public function storeParams(path:String, params:Dynamic):Map<String,Map<String,String>>
	{
		var pMap = [
			for(f in Reflect.fields(params))
				f => Reflect.field(params, f)
		];
		return [path=>pMap];
	}

	public function restoreParams(m:Map<String,String>):Dynamic
	{
		var p:Dynamic = {};
		for(k=>v in m.keyValueIterator())
			Reflect.setField(p,k,v);
		return p;
	}

	/**
	 * PAGER HANDLING
	 */

	public function renderPager():ReactFragment
	{
		trace('pageCount=${comp.state.pageCount}');
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
					pageCount=${comp.state.pageCount}
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

	public function onPageChange(data) {
		trace('${comp.props.match.params.action}:${data.selected}');
		var fun:Function = Reflect.field(this,comp.props.match.params.action);
		if(Reflect.isFunction(fun))
		{
			Reflect.callMethod(this,fun,[{page:data.selected}]);
		}		
	}
	
}