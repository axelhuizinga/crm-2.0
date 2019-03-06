package view.shared;

import react.router.ReactRouter;
import react.router.Route.RouteMatchProps;
import react.router.RouterMatch;
import haxe.Constraints.Function;
import haxe.ds.Either;
import haxe.ds.Map;
import haxe.http.HttpJs;
import js.html.Event;
import js.html.HTMLCollection;
import js.html.InputEvent;
import js.html.TableRowElement;
import js.html.XMLHttpRequest;
import me.cunity.debug.Out;
import model.AppState;
import react.ReactComponent.ReactComponentOf;
import react.ReactComponent.ReactFragment;
import react.ReactMacro.jsx;
import react.router.Route.RouteRenderProps;
import redux.Redux.Dispatch;
import redux.Store;
import view.dashboard.model.RolesFormModel;
//import view.shared.io.DataAccessForm;
import view.shared.OneOf;

import view.table.Table.DataState;
import view.shared.FormElement;
import view.shared.RouteTabProps;
import view.shared.SMenuBlock;
import view.shared.SMenuProps;

/**
 * ...
 * @author axel@cunity.me
 */

//@:wrap(ReactRedux.connect(mapStateToProps,mapDispatchToProps))
class BaseForm extends ReactComponentOf<FormProps, FormState> 
{
	var mounted:Bool;
	var requests:Array<OneOf<HttpJs,XMLHttpRequest>>;	
	//var sideMenu:SMenuProps;
	var dataDisplay:Map<String,DataState>;//TODO: CHECK4INTEGRATION INTO state or props	
	
	public function new(?props:FormProps) 
	{
		super(props);	
		mounted = false;
		requests = [];		
		state = {
			data:new Map(),
			//loading:true,
			//viewClassPath:'',
			//content:new Array(),
			clean:true,
			errors:new Map(),
			//values:new StringMap(),
			//fields:new StringMap(),
			section: props.match.params.section,
			sideMenu:{},
			submitted:false,
			hasError:false		
		};
	}
	
	function cache(key:String):Dynamic
	{
		if (state.values.exists(key))
		{
			return state.values.get(key);
		}
		return null;
	}
	
	override public function componentDidMount():Void 
	{
		mounted = true;
		if(state.sideMenu !=null && state.section == null) 
			state.section = state.sideMenu.section;
		else
			state.sideMenu.section = state.section;
		trace(state.section);
		if(state.section != props.match.params.section)
		{
			var basePath:String = props.match.path.split('/:')[0];
			props.history.push('$basePath/${state.section}');
		}
		//trace(mounted);
	}
	
	override public function componentWillUnmount()
	{
		mounted=false;
		for (r in requests)
		{
			switch(r)
			{
				//HttpJs
				case Left(v): v.cancel();
				//XMLHttpRequest
				case Right(v): v.abort();
			}
		}
	}	
	
	function getRouterMatch():RouterMatch
	{
		var rmp:RouteMatchProps = cast props.match;
		return ReactRouter.matchPath(props.history.location.pathname, rmp);		
	}
	
	public function renderContent() {
		trace('You should override me :)');
        return null;
    }

	override public function render() 
	{
		var section:String = (state.section == null?state.sideMenu.section:state.section);
		trace(state.section + ':' + section +':' + state.sideMenu.section);
		return jsx('
		<div className="columns">
			${renderContent()}
			<$SMenu className="menu" sameWidth=${state.sideMenu.sameWidth} section=${section} itemHandler=${state.sideMenu.itemHandler}
			menuBlocks=${state.sideMenu.menuBlocks} />
		</div>			
		');
	}
	
	public function setStateFromChild(newState:FormState)
	{
		setState(newState);
		trace(newState);
	}
	
	public function switchContent(reactEventSource:Dynamic)
	{
		//trace(props.history.location);
		//trace(props.location);
		//trace(props.match.params);
		trace(props.history == App.store.getState().appWare.history);
		//var viewClassPath:String = reactEventSource.target.getAttribute('data-classpath');
		var section:String = reactEventSource.target.getAttribute('data-section');
		//trace( 'state.viewClassPath:${state.viewClassPath} viewClassPath:$viewClassPath');
		trace( 'state.section:${state.section} section:$section');
		//if (state.viewClassPath != viewClassPath)
		if (section != state.sideMenu.section)
		{
			//var menuBlocks:
			var sM:SMenuProps = state.sideMenu;
			sM.section = section;
			setState({
				//viewClassPath:viewClassPath,
				sideMenu: sM,
				section:section
			});
			var basePath:String = props.match.path.split('/:')[0];
			trace(props.location.pathname);
			props.history.push('$basePath/$section');
			trace(props.history.location.pathname);
			//props.history.push(props.match.url + '/' + viewClassPath);
		}
	}
	
	function initSideMenu(sMa:Array<SMenuBlock>, sM:SMenuProps):SMenuProps
	{
		var sma:SMenuBlock = {};
		for (smi in 0...sMa.length)
		{
			sMa[smi].onActivate = switchContent;
			//trace(sMa[smi].label);
		}

		sM.menuBlocks = [
			for (sma in sMa)
			sma.section => sma
		];
		return sM;
	}
	
}