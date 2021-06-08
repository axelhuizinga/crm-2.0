package view.shared;

//import js.lib.Reflect;
//import model.FormInputElement;
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
	var hasForm:Bool;

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
		//trace(props);
		//trace(props.menuBlocks);
		hasForm = false;
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
		trace(state.items.keys());
		trace('$id $enable');
		if(!state.items.exists(id))
			return null;
		var item = state.items.get(id);
		item.disabled = !enable;
		return !item.disabled;
	}

	function clear() {
		var inputs:NodeList = Browser.document.querySelectorAll('.formRow .input');
		var el:InputElement;
		for(i in 0...inputs.length){
			el = cast( inputs[i], InputElement);
			el.value = '';
		}
	}

	function find() {
		var inputs:NodeList = Browser.document.querySelectorAll('.formRow .input');
		trace(inputs.length);
		var el:InputElement;
		var param:Dynamic = {};
		for(i in 0...inputs.length){
			el = cast( inputs[i], InputElement);
			trace(i+':'+ el.name + '::' + el.value);
			if(StringTools.trim(el.value)!='')
				Reflect.setField(param, el.name,el.value);
		}
		props.parentComponent.get(BaseForm.filter(props.parentComponent.props,param));
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
				<div id=${"pblock" + i} className=${"panel-block body-"+(i++)} children=${renderItems(block.items)}></div>
			</div>		
			'));
		} );
		//trace(panels.length);
		return panels;
	}	
	
	function renderItems(items:Array<MItem>):ReactFragment
	{
		if (items == null || items.length == 0)
			return null;
		var B:ReactType = ${bulma_components.Button};
		var i:Int = 1;
		var items =  items.map(function(item:MItem) 
		{
			if(item.id != null && !state.items.exists(item.id))
			{
				//REGISTER ITEM INTERACTIONSTATE
				state.items.set(item.id, item);
			}

			if(item.separator){ return jsx('<hr key=${i++} className="menuSeparator"/>');}
			var type:FormInputElement;
			type = (item.formField==null?Button:(item.formField.type==null?FormInputElement.Text: item.formField.type));
			//trace(i + ':' + type);
			if(type!=Button)
				hasForm = true;
			return switch(type)
			{
				//case Filter: jsx('<$Filter  key=${i++}/>');				
				/*case File:
					jsx('<div key=${"uf"+(i++)}  id="uploadForm"   className="uploadBox" >
					<input  id=${item.formField.name} type="file" name=${item.formField.name} onChange=${item.formField.handleChange} className="fileinput"  />
					<label htmlFor=${item.formField.name} className="button" >${item.label}</label>
					<Button onClick=${item.handler} data-action=${item.action}
				data-section=${item.section} disabled=${item.disabled}>${item.formField.submit}</Button>
				</div>');*/
				case Text:
					jsx('<div key=${"uf"+(i++)}  id="findForm_${i}"   className="formRow" >
					<label htmlFor=${item.formField.name} className="" >${item.label}</label>
					<input  id=${item.formField.name} type="text" name=${item.formField.name} onChange=${item.formField.handleChange} className="input"  />
				</div>');
				case Upload:
					//trace(item.formField.handleChange);
					jsx('<div key=${"up"+(i++)}  id="uploadForm"  className="uploadBox" >
					<input id=${item.formField.name} type="file" name=${item.formField.name} onChange=${item.formField.handleChange} className="fileinput"  />
					<label htmlFor=${item.formField.name} className="button" >${item.label}</label>
					<$B onClick=${item.handler} data-action=${item.action}
				data-section=${item.section} disabled=${item.disabled}>${item.formField.submit}</$B>
				</div>');

				default:
					//trace('key:${"bu"+(i)}');
					jsx('<$B key=${"bu"+(i++)} onClick=${props.itemHandler} data-action=${item.action} data-then=${item.then}
					data-section=${item.section} disabled=${item.disabled}>${item.label}</$B>');
			}
		}).array();
		if(hasForm){			
			items.push(jsx('<$B key=${"bu"+(i++)} onClick=${find} data-action="find" data-then=${null}>Finden</$B>'));
			items.push(jsx('<$B key=${"bu"+(i++)} onClick=${clear} data-action="clear" data-then=${null}>Zurücksetzen</$B>'));
		}
		return items;
	}
	
	override public function render()
	{
		//trace(Reflect.fields(props));
		if(props.menuBlocks == null)
		return null;
		//if(props.parentComponent != null)
			//trace(Type.getClassName(Type.getClass(props.parentComponent)));
		//trace(props.menuBlocks.keys().next);
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