package view.shared;

import haxe.Constraints.Function;
import haxe.Timer;
import react.Fragment;
import react.PureComponent.PureComponentOf;
import react.ReactComponent;
import react.ReactMacro.jsx;
import bulma_components.Button;

/**
 * ...
 * @author axel@cunity.me
 */

typedef SMenuBlock =
{
	?className:String,
	?onActivate:Function,
	?img:String,
	?info:String,
	?isActive:Bool,
	items:Array<SMItem>,
	?label:String,	
}

typedef SMItem =
{
	?className:String,
	?component:ReactComponent,
	?handler:Function,
	?img:String,
	?info:String,
	?label:String,
	
}
 
typedef SMenuProps =
{
	?className:String,
	?hidden:Bool,
	?menuBlocks:Array<SMenuBlock>,
	?items:Array<SMItem>,
	?right:Bool		
}

typedef SMenuState =
{
	hidden:Bool
}


class SMenu extends PureComponentOf<SMenuProps,SMenuState>

{

	public function new(props:SMenuProps) 
	{
		super(props);
		state = {
			hidden:props.hidden||false
		}
	}

	
	function renderArticles():ReactFragment
	{
		if (props.menuBlocks.length == 0)
			return null;
		var i:Int = 1;
		return props.menuBlocks.map(function(art:SMenuBlock) return jsx('
		<article className=${"accordion " + (art.isActive?"is-active":"")} key=${i++}>
			<div className="accordion-header toggle">
			  <p>${art.label}</p>
			</div>
			<div className="accordion-body">
			  <div className="accordion-content" children=${renderItems(art.items)}/>
			</div>
		</article>
		'));
	}//			 <button className="toggle" aria-label="toggle"></button>
	
	function renderItems(items:Array<SMItem>):ReactFragment
	{
		trace(items);
		if (items.length == 0)
			return null;
		var i:Int = 1;
		return items.map(function(item:SMItem) return jsx('
			<Button key=${i++} onClick=${item.handler}>${item.label}</Button>	
		'));
	}
	
	override public function render()
	{
		return jsx('
		<div className="is-right is-hidden-mobile">
			<aside className="menu">
				<section className="accordions" children=${renderArticles()}/>
				<ul className="menu-list" children=${props.items==null?null:renderItems(props.items)}/>
			</aside>
		</div>	
		');
	}
	
	override public function componentDidMount():Void 
	{
		//Timer.delay(function(){
			if (App.bulmaAccordion != null)
			{
				trace(App.bulmaAccordion);
				var accordions = App.bulmaAccordion.attach();
				trace(accordions);
			}		
		//}, 1000);
	}
	
	override public function componentDidUpdate(prevProps:SMenuProps, prevState:SMenuState):Void 
	{
		//super.componentDidUpdate(prevProps, prevState);
	}
}