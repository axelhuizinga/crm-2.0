package view.shared;

import model.AppState;
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
import view.shared.SMItem;
import view.shared.SMenuBlock;
import view.shared.SMenuProps;
import view.shared.SMenuState;

using Lambda;

/**
 * ...
 * @author axel@cunity.me
 */

 typedef Filter = ReactType;

@:connect
//@:wrap(react.router.ReactRouter.withRouter)
//@:wrap(ReactRedux.connect(null,mapDispatchToProps))
class SMenu extends ReactComponentOf<SMenuProps,SMenuState>

{
	var menuRef:ReactRef<DivElement>;
	var aW:Int;

	static function mapDispatchToProps(dispatch:Dispatch):SMenuProps
    {
		trace(dispatch + ':' + (dispatch == App.store.dispatch? 'Y':'N'));
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

	public function new(props:SMenuProps) 
	{
		super(props);
		//trace(props.menuBlocks);
		state = {
			hidden:props.hidden||false
		};
		//Out.dumpStack(CallStack.callStack());
		//trace('OK');
	}

	function renderHeader():ReactFragment
	{
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
		props.menuBlocks.iter(function(block:SMenuBlock)
		{
			//trace(block.handlerInstance);
			panels.push( jsx('	
				<div className="panel" key=${i} style=${style}>
				<label className="panel-heading" htmlFor=${"sMenuPanel-"+i}>${block.label}</label>
				<div id=${"pblock" + i} className=${"panel-block body-"+(i++)} children=${renderItems(block.items)}/>
				</div>		
			'));
		} );
		//trace(panels.length);
		return panels;
	}	

	function renderPanel(_i:Int,block:SMenuBlock):ReactFragment
	{
		var i:Int = _i+1;
		var style:Dynamic =(props.sameWidth && state.sameWidth>0 ? 
			//{width:'${state.sameWidth}px'} : null
			{width:'100%'} : null
		);
		//trace(block.handlerInstance);
		return jsx('	
			<div className="panel" key=${i} style=${style}>
			<label className="panel-heading" htmlFor=${"sMenuPanel-"+i}>${block.label}</label>
			<div id=${"pblock" + i} className=${"panel-block body-"+(i++)} children=${renderItems(block.items)}/>
			</div>		
		');
	}
	
	function renderItems(items:Array<SMItem>):ReactFragment
	{
		if (items == null || items.length == 0)
			return null;
		var i:Int = 1;
		return items.map(function(item:SMItem) 
		{
			return switch(item.component)
			{
				//case Filter: jsx('<$Filter  key=${i++}/>');
				default:jsx('<Button key=${i++} onClick=${props.itemHandler} data-action=${item.action}
				disabled=${item.disabled}>${item.label}</Button>');
			}
		}).array();
	}
	
	override public function render()
	{
		trace(Reflect.fields(props));
		if(props.menuBlocks == null)
		return null;
		trace(props.menuBlocks.keys().next);
		menuRef = React.createRef();
		var style:Dynamic = null;
		if(true&&props.sameWidth && state.sameWidth == null)//sameWidth
		{
			style = {
				visibility: 'hidden'
			};
		}
		style = {
			minWidth:App.config.sidebarDims.minWidth
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
		trace( 'state.section:${state.section} section:$section');
		//if (state.viewClassPath != viewClassPath)
		if (section != props.section)
		{
			//var menuBlocks:
			var basePath:String = props.match.path.split('/:')[0];
			trace(props.location.pathname);
			props.history.push('$basePath/$section');
			//props.switchSection('$basePath/$section');
			trace(props.history.location.pathname);
			//props.history.push(props.match.url + '/' + viewClassPath);
		}
	}

	function layout()
	{
		var i:Int = 0;
		var activePanel:Int = null;
		aW = menuRef.current.getElementsByClassName('panel').item(0).offsetWidth;
		trace(aW);//
		if(state.sameWidth==null)
		setState({sameWidth:aW},function (){
			trace("what's up?");
		});
	}
	
	override public function componentDidMount():Void 
	{
		if(props.sameWidth && state.sameWidth == null)
		{
			//Timer.delay(layout,800);
			trace(menuRef.current.offsetWidth);
			layout();
			trace(menuRef.current.offsetWidth);
		}
	}
	
	override public function componentDidUpdate(prevProps:SMenuProps, prevState:SMenuState):Void 
	{
		//super.componentDidUpdate(prevProps, prevState);
	}
}