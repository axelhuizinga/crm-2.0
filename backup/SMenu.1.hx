package view.shared;

import griddle.components.Components.Filter;
import haxe.ds.StringMap;
import haxe.Constraints.Function;
import haxe.Timer;
import js.html.InputElement;

import react.PureComponent.PureComponentOf;
import react.ReactComponent;
import react.ReactComponent.ReactComponentOf;
import react.ReactComponent.ReactFragment;
import react.React;
import react.ReactType;
import react.ReactMacro.jsx;
import bulma_components.Button;
import react.ReactRef;

using Lambda;

/**
 * ...
 * @author axel@cunity.me
 */

typedef SMenuBlock =
{
	?dataClassPath:String,
	?disabled:Bool,
	?viewClassPath:String,
	?className:String,
	?onActivate:Function,
	?img:String,
	?info:String,
	?isActive:Bool,
	items:Void->Array<SMItem>,
	?label:String,	
	?section:String,
}

typedef SMItem =
{
	?action:String,
	?className:String,
	?component:Dynamic,
	?dataClassPath:String,
	?disabled:Bool,	
	?handler:Function,
	?img:String,
	?info:String,
	?label:String,	
}
 
typedef SMenuProps =
{
	?className:String,
	?basePath:String,
	?hidden:Bool,
	?menuBlocks:Map<String,SMenuBlock>,
	?section:String,
	?items:Array<SMItem>,
	?right:Bool		
}

typedef SMenuState =
{
	?hidden:Bool,
	?disabled:Bool,
	?interactionStates:Map<String,InteractionState>
}

typedef  InteractionState =
{
	var disables:Array<String>;
	var enables:Array<String>;
}

class SMenu extends ReactComponentOf<SMenuProps,SMenuState>

{
	var initialActiveHeaderRef:ReactRef<InputElement>;
	public function new(props:SMenuProps) 
	{
		super(props);
		state = {
			hidden:props.hidden||false
		}
	}
	
	/*function activate()
	{
		trace(initialActiveHeaderRef.current);
		if (initialActiveHeaderRef.current != null)
		{
			trace(initialActiveHeaderRef.current.checked);
			initialActiveHeaderRef.current.checked = true;
			trace(initialActiveHeaderRef.current.checked);
		}ref=${check?initialActiveHeaderRef:null}
	}*/

	function renderHeader():ReactFragment
	{
		//initialActiveHeaderRef = React.createRef();
		if (props.menuBlocks.empty())
			return null;
		var header:Array<ReactFragment> = new Array();
		var i:Int = 1;		

		props.menuBlocks.iter(function(block:SMenuBlock) {
			var check:Bool = props.section==block.section;
			if(props.section==null && i==1)
			{
				check=true;
			}
			trace(props.section + '::' + block.section + ':' +check);
			header.push( jsx('
		<input type="radio" key=${i} id=${"sMenuPanel-"+(i++)} name="accordion-select" checked=${check} data-classpath=${block.viewClassPath} 
			onChange=${block.onActivate} data-section=${block.section} />
		'));
		});
		return header;
	}

	function renderPanels():ReactFragment
	{
		if (props.menuBlocks.empty())
			return null;
		//trace(props.menuBlocks);
		var i:Int = 1;
		var panels:Array<ReactFragment> = [];
		props.menuBlocks.iter(function(block:SMenuBlock) panels.push( jsx('	
			<div className="panel" key=${i}>
			  <label className="panel-heading" htmlFor=${"sMenuPanel-"+i}>${block.label}</label>
			  <div className=${"panel-block body-"+(i++)} children=${renderItems(block.items())}/>
			</div>		
		')));
		trace(panels.length);
		return panels;
	}		
	
	// <button className="toggle" aria-label="toggle"></button>
	
	function renderItems(items:Array<SMItem>):ReactFragment
	//function renderItems(items:Void->Map<String,SMItem>):ReactFragment
	{
		//var items:Map<String,SMItem> = _items();
		//var items:Array<SMItem> = _items(); 
		if (items == null || items.length == 0)
			return null;
		var i:Int = 1;
		return items.map(function(item:SMItem) 
		{
			return switch(item.component)
			{
				case Filter: jsx('<$Filter key=${i++}/>');
				default:jsx('<Button key=${i++} onClick=${item.handler} disabled=${item.disabled}>${item.label}</Button>');
			}
		}).array();
	}
	
	override public function render()
	{
		trace('...');
		return jsx('
		<div className="sidebar is-right is-hidden-mobile">
			<aside className="menu">
				${renderHeader()}
				${renderPanels()}
			</aside>
		</div>	
		');
	}
	
	override public function componentDidMount():Void 
	{
		//Timer.delay(function(){
			/*if (App.bulmaAccordion != null)
			{
				trace(App.bulmaAccordion);
				var accordions = App.bulmaAccordion.attach();
				trace(accordions);
			}		*/
		//}, 1000);
		//activate();
	}
	
	override public function componentDidUpdate(prevProps:SMenuProps, prevState:SMenuState):Void 
	{
		//super.componentDidUpdate(prevProps, prevState);
	}
}