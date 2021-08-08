package view.shared;

//import js.lib.Reflect;
//import model.FormInputElement;
import js.lib.Reflect;
import js.html.FormElement;
import js.html.Element;
import js.html.FormData;
import js.html.FormDataIterator;
import js.html.SelectElement;
import view.shared.io.BaseForm;
import js.html.NodeList;
import js.html.Document;
import state.AppState;
import action.LocationAction;
import js.html.ButtonElement;
import js.html.Event;
import haxe.CallStack;
import me.cunity.debug.Out;
//import view.shared.io.DataAccessForm;
import js.Browser;
import js.html.DivElement;
import haxe.ds.StringMap;
import haxe.Constraints.Function;
import haxe.Timer;
import js.html.InputElement;

import react.ReactComponent;
//import react.ReactComponent.ReactComponentOf;
//import react.ReactComponent.ReactFragment;
import react.React;
import react.ReactType;
import react.ReactMacro.jsx;
import bulma_components.Button;
import react.ReactRef;
import redux.Redux.Dispatch;
import redux.react.ReactRedux;
import view.shared.FormInputElement;
import view.shared.MItem;
import view.shared.MenuBlock;
import view.shared.MenuProps;
import view.shared.MenuState;

using tools.ClassInfo;
using Lambda;

/**
 * ...
 * @author axel@cunity.me
 */

 typedef Filter = ReactType;

//@:connect
@:wrap(react.router.ReactRouter.withRouter)
//@:wrap(ReactRedux.connect(null,mapDispatchToProps))
class Menu extends ReactComponentOf<MenuProps,MenuState>

{
	var menuRef:ReactRef<DivElement>;
	var aW:Int;
	var hasFindForm:Bool;
	
	static function printProps(props:Dynamic):String{
		var dump:String = '';
		for(f in Reflect.fields(props)){
			if(f=='parentComponent'){
				var o = props.parentComponent;
				dump += 'parentComponent.props.match.url:' + o.props.match.url + "\n";
			}
			else
				dump += f + ':' + Std.string(Reflect.field(props, f)) + "\n";
		}
		return dump;
	}

	static function mapDispatchToProps(dispatch:Dispatch):MenuProps
    {
		
      	return {
				switchSection: function(url:String) {
					trace(url);
					dispatch(LocationAction.Push(url));
					//App.store.dispatch(LocationAction.Push(url));
				}
					//,
				//initChildren: function() dispatch()
			};
    }
	
	static function mapStateToProps(state:AppState) {
		return {};
	}

	public function new(props:MenuProps) 
	{
		super(props);
		//trace(props.menuBlocks);
		trace(Reflect.fields(props));		
		//trace(Reflect.fields(props.menuBlocks.iterator().next()));
		trace(Reflect.fields(props.menuBlocks.iterator().next()));
		
		//var items:Array<MItem> = props.menuBlocks.iterator().next().items;
		var items:Array<MItem> = props.menuBlocks[props.section].items;
		trace(props.parentComponent.state.mHandlers);
		trace(props.section + ':' + items);

		hasFindForm = false;
		state = {
			hidden:props.hidden||false,
			items: new StringMap()
			//interactionStates: new StringMap()
		};
		//Out.dumpStack(CallStack.callStack());
		//trace('OK');
	}

	public function enableItem(id:String,?enable:Bool = true):Bool
	{
		trace(state.items.keyNames().join('|'));
		trace('$id $enable');
		if(!state.items.exists(id))
			return null;
		var item = state.items.get(id);
		if(item.formField!=null&&item.formField.submit!=null){
			trace('looking4:#${item.id+"_submit"}');
			var submit = Browser.document.querySelector('#${item.id+"_submit"}');
			if(enable){
				submit.removeAttribute('disabled');
				submit.addEventListener('click',item.handler);
			}
			else
				submit.setAttribute('disabled',enable?'false':'true');
			trace(item.handler);
			//trace(getEventListeners(submit)))
		}
		item.disabled = !enable;
		return !item.disabled;
	}

	function clear(evt:Event) {
		evt.preventDefault();
		var form:FormElement = untyped evt.target.form;
		form.reset();
		/*var inputs:NodeList = Browser.document.querySelectorAll('.formRow input');
		var el:InputElement;
		for(i in 0...inputs.length){
			el = cast( inputs[i], InputElement);			
			el.value = '';
		}
		var selects:NodeList = Browser.document.querySelectorAll('.formRow select');
		var sel:SelectElement;
		for(i in 0...selects.length){
			sel = cast(selects[i], SelectElement);
			for(o in 0...sel.options.length){
				if(sel.options[o].defaultSelected)
					sel.options[o].selected = true
			}
		}*/

	}

	function find(evt:Event) {
		evt.preventDefault();
		//trace(untyped evt.target.form);
		//return;
		var form:FormElement = untyped evt.target.form;
		var fD:FormData = new FormData(form);
		if(Reflect.isFunction(Reflect.field(props.parentComponent, 'find'))){
			return props.parentComponent.find(fD);
		}
		var fDe:FormDataIterator = fD.entries();
		//while(e:Dynamic = fDe.next())
		fD.forEach(function(d:Dynamic) {
			trace(d);
		});
		//trace(fD.getAll('*'));
		var inputs:NodeList = Browser.document.querySelectorAll('.formRow input');
		trace(inputs.length);
		var el:InputElement;
		var param:Dynamic = {};
		for(i in 0...inputs.length){
			el = cast( inputs[i], InputElement);
			trace(i+':'+ el.name + '::' + el.value);
			if(StringTools.trim(el.value)!='')
				Reflect.setField(param, el.name,el.value);
		}
		return props.parentComponent.get(BaseForm.filter(props.parentComponent.props,param));
	}	

	function renderHeader():ReactFragment
	{
		if (props.menuBlocks.empty())
			return null;
		var header:Array<ReactFragment> = new Array();
		var i:Int = 1;		

		props.menuBlocks.iter(function(block:MenuBlock) {
			var check:Bool = props.section==block.section;
			if(props.section==null && i==1)
			{
				check=true;
			}
			//trace(block.label + '::' + block.onActivate + ':' +check);
			//trace(props.section + '::' + block.section + ':' +check);//data-classpath=${block.viewClassPath}
			header.push( jsx('
			<input type="radio" key=${i} id=${"sMenuPanel-"+(i++)} name="accordion-select" checked=${check}  
				onChange=${switchContent} data-section=${block.section} />
			'));
		});
		return header;
	}

	function renderPanels():ReactFragment
	{
		if (props.menuBlocks.empty())
			return null;
		var style:Dynamic = null;
		style = {
			minWidth:App.config.sidebarDims.minWidth,
			maxWidth:App.config.sidebarDims.maxWidth
		};
		style = null;
		//var className = ''; 'panel-block';
		if(props.sameWidth && state.sameWidth>0) {
			//style = {width:'${state.sameWidth}px'};
		}
		var i:Int = 1;
		//style = null;
		var panels:Array<ReactFragment> = [];
		//var panels:Array<ReactFragment> = props.menuBlocks.mapi(renderPanel).array();
		//trace(props.menuBlocks);		
		props.menuBlocks.iter(function(block:MenuBlock)
		{
			//trace(block.handlerInstance);
			panels.push( jsx('	
			<div className="panel" key=${"pa"+i} style=${style}>
				<label className="panel-heading" htmlFor=${"sMenuPanel-"+i}>${block.label}</label>
				<div id=${"pblock" + i} className=${"panel-block body-"+(i++)} children=${renderBlock(block,i)}></div>
			</div>		
			'));
		} );
		//trace(panels.length);
		return panels;
	}	
	
	function renderBlock(block:MenuBlock, i:Int):ReactFragment
	{
		//trace(block);
		var items:ReactFragment = renderItems(block);
		return block.hasFindForm ? jsx('<form name=${block.dataClassPath} key=${"f_"+i}>$items</form>'):jsx('<>${items}</>');
	}

	function renderItemForm(formFields:Array<FormField>):ReactFragment{
		var formFieldElements:Array<ReactFragment> = [];
		var i = 0;
		for(fF in formFields){
			trace(fF.type);
			formFieldElements.push(
				switch(fF.type){
					case Checkbox:
						jsx('<span key=${"l_"+(i++)}>${fF.label}<input type="checkbox" name=${fF.name} /></span>');
					case Radio: 
						var o:Int = 0;
						var options:ReactFragment = [
						for(k=>v in fF.options.keyValueIterator()){
							jsx('<span key=${"o_"+(o++)}>${v} <input type="radio" name=${fF.name} value=${v} /></span>');
						}];
						jsx('<div className="formRow" key=${"fr_"+(i++)} >
						<label key=${"l_"+i}>${fF.label}</label><div  key=${"opt_"+i} className="formRow2">$options</div>
						</div>');	
					default:
						null;					
				}
			);
		}
		return formFieldElements;
	}

	function renderItems(block:MenuBlock):ReactFragment
	{
		var items:Array<MItem> = block.items;
		if (items == null || items.length == 0)
			return null;
		var B:ReactType = ${bulma_components.Button};
		var i:Int = 1;
		var rItems =  items.map(function(item:MItem):ReactFragment
		{
			if(item.id != null && !state.items.exists(item.id))
			{
				//REGISTER ITEM INTERACTIONSTATE
				state.items.set(item.id, item);
			}
			else{
				if(item.action != null && !state.items.exists(item.action)){
					item.id = item.action;
					state.items.set(item.id, item);
				}
			}

			if(item.separator){ return jsx('<hr key=${"s_"+i++} className="menuSeparator"/>');}
			var type:FormInputElement;
			type = (item.formField==null?Button:(item.formField.type==null?FormInputElement.Text: item.formField.type));
			//trace(i + ':' + type);
			var dis:Bool = !(item.disabled==null||item.disabled==false);
			//if(type!=Button)
				//block.hasFindForm = true;
			return switch(type)
			{
				case Radio: 
					var o:Int = 0;
					var options:ReactFragment = [
					for(k=>v in item.formField.options.keyValueIterator()){
						jsx('<span key=${"o_"+(o++)Y}>${v} <input type="radio" name=${item.formField.name} value=${v} /></span>');
					}];
					jsx('<div className="formRow" key=${"fr_"+(i++)} >
					<label key=${"l_"+i}>${item.label}</label><div  key=${"opt_"+i} className="formRow2">$options</div>
					</div>');	
				/*case File:
					jsx('<div key=${"uf"+(i++)}  id="uploadForm"   className="uploadBox" >
					<input  id=${item.formField.name} type="file" name=${item.formField.name} onChange=${item.formField.handleChange} className="fileinput"  />
					<label htmlFor=${item.formField.name} className="button" >${item.label}</label>
					<Button onClick=${item.handler} data-action=${item.action}
				data-section=${item.section} disabled=${item.disabled}>${item.formField.submit}</Button>
				</div>');<div class="recordings">         <span class="label">2021-08-03 09:24:52 </span><br>     <audio controls="" preload="metadata">      <source src="https://pbx.pitverwaltung.de/RECORDINGS/MP3/2021-08-03/20210803-092450_306636275_POSTSTATUS-all.mp3" type="audio/mpeg">     </audio><br>        </div>*/
				
				case Audio:
					// htmlFor=${item.formField.name}
					jsx('<div  key=${"uf"+(i++)}  id="findForm_${i}"   className="formRow1" >         
					<label key=${"l_"+i}>${item.label}</label> 
					<audio  key=${"a_"+i} id="aud_${i}" controls="1" preload="metadata" >
					<source src=${item.formField.src} type="audio/mpeg"/>     
					</audio>
					</div>');

				case Text:
					jsx('<div key=${"uf"+(i++)}  id="findForm_${i}"   className="formRow" >
					<label htmlFor=${item.formField.name} className=""  key=${"l_"+i}>${item.label}</label>
					<input  id=${item.formField.name} type="text" name=${item.formField.name} onChange=${item.formField.handleChange} className="input"  key=${"i_"+i} />
				</div>');
				case Upload:
					//trace(item.formField.handleChange);		
					trace(item.handler);
					if(item.options!=null&&item.options.length==1&&item.options[0].multiple){
						//jsx('');
						jsx('<div key=${"up"+(i++)}  id="uploadForm"  className="uploadBox" >
						<input id=${item.formField.name} type="file" name=${item.formField.name} onChange=${item.formField.handleChange} className="fileinput" multiple />
						<label htmlFor=${item.formField.name} className="button" >${item.label}</label>
						<button onClick=${item.handler} data-action=${item.action} id=${item.id+"_submit"} className="act" 
					data-section=${item.section} disabled=${dis} >${item.formField.submit}</button>
					</div>');
					}
					else
					jsx('<div key=${"up"+(i++)}  id="uploadForm"  className="uploadBox" >
					<input id=${item.formField.name} type="file" name=${item.formField.name} onChange=${item.formField.handleChange} className="fileinput" $multi />
					<label htmlFor=${item.formField.name} className="button" >${item.label}</label>
					<$B onClick=${item.handler} data-action=${item.action}
				data-section=${item.section} disabled=${dis} >${item.formField.submit}</$B>
				</div>');

				default:
					//trace('key:${"bu"+(i)}');
					if(item.options!=null&&item.options.length>0){

						jsx('<form key=${"bu"+(i++)} name=${item.action}>
						${renderItemForm(item.options)}
						<$B key=${"bu"+(i++)} onClick=${props.itemHandler} data-action=${item.action} data-then=${item.then} 					data-section=${item.section} disabled=${dis}>${item.label}</$B>
						</form>');
					}
					else
						jsx('<$B key=${"bu"+(i++)} onClick=${props.itemHandler} data-action=${item.action} data-then=${item.then} 					data-section=${item.section} disabled=${dis} >${item.label}</$B>');
			}
		});
		if(block.hasFindForm){			
			rItems.push(jsx('<$B key=${"bu"+(i++)} onClick=${find} data-action="find" data-then=${null}>Finden</$B>'));
			rItems.push(jsx('<$B key=${"bu"+(i++)} onClick=${clear} data-action="clear" data-then=${null}>Zurücksetzen</$B>'));
		}
		trace(state.items.keyNames());
		return rItems;
	}
	
	override public function render()
	{
		//trace(Reflect.fields(props));
		if(props.menuBlocks == null)
		return null;
		//if(props.parentComponent != null)
		//trace(props.menuBlocks.keys());
		//trace(props.menuBlocks.get('Edit'));
			//trace(Type.getClassName(Type.getClass(props.parentComponent)));
		//trace(props.basePath);
		menuRef = React.createRef();
		var style:Dynamic = null;
		if(true&&props.sameWidth && state.sameWidth == null)//sameWidth
		{
			style = {
				visibility: 'hidden'
			};
		}
		style = {
			//minWidth:App.config.sidebarDims.minWidth,
			width:App.config.sidebarDims.maxWidth
		}
		return jsx('
		<div className="sidebar is-right"  style=${style} > 
			<aside className="menu" ref=${menuRef}>
				${renderHeader()}
				${renderPanels()}
			</aside>
		</div>	
		');
	}

	public function switchContent(reactEventSource:Dynamic)
	{
		//var viewClassPath:String = reactEventSource.target.getAttribute('data-classpath');
		var section:String = reactEventSource.target.getAttribute('data-section');
		//trace( 'state.viewClassPath:${state.viewClassPath} viewClassPath:$viewClassPath');
		//trace( 'state.section:${state.section} section:$section');
		//if (state.viewClassPath != viewClassPath)
		if (section != props.section)
		{
			//var menuBlocks:
			var basePath:String = props.match.path.split('/:')[0];
			//trace(props.location.pathname);
			props.history.push('$basePath/$section');
			//props.switchSection('$basePath/$section');
			//trace(props.history.location.pathname);
			//props.history.push(props.match.url + '/' + viewClassPath);
		}
	}

	function layout()
	{
		var i:Int = 0;
		var activePanel:Int = null;
		aW = menuRef.current.getElementsByClassName('panel').item(0).offsetWidth;
		//trace(aW);//
		/*if(state.sameWidth==null)
		this.setState({sameWidth:aW},function (){
			trace("what's up?");
		});*/
	}
	
	override public function componentDidMount():Void 
	{
		if(props.parentComponent.state.sideMenu==null){
			//trace(Type.getClass(props.parentComponent));
			return;
		}
		//trace(Type.getClass(props.parentComponent));
		//trace(printProps(props));
		props.parentComponent.state.sideMenu.instance = this;
		if(props.sameWidth && state.sameWidth == null)
		{
			//Timer.delay(layout,800);
			//trace(menuRef.current.offsetWidth);
			layout();
			//trace(menuRef.current.offsetWidth);
		}
	}
	
	override public function componentDidUpdate(prevProps:MenuProps, prevState:MenuState):Void 
	{
		//super.componentDidUpdate(prevProps, prevState);
	}
}