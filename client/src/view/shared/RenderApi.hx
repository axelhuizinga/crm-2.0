package view.shared;

import haxe.Constraints.Function;
import view.shared.SMenuProps;
import react.ReactComponent;
import react.ReactComponent.ReactFragment;
import react.ReactMacro.jsx;
import react.React;
import react.ReactRef;
import react.ReactType;

using Lambda;

/**
 * ...
 * @author axel@cunity.me
 */

class RenderApi
{
    var component:Dynamic;
	
	public function new(comp:ReactComponent)
	{
		component = comp;
	}	

	
	public function callMethod(method:String):Bool
	{
		var fun:Function = Reflect.field(component,method);
		if(Reflect.isFunction(fun))
		{
			Reflect.callMethod(component,fun,null);
			return true;
		}
		return false;
	}
	
	public function renderWithMenu()
	{
		var sM:SMenuProps = component.state.sideMenu;
		if(sM.menuBlocks != null)
			trace(sM.menuBlocks.keys().next() + ':' + component.props.match.params.section);
		return jsx('
			<div className="columns">
				${component.renderContent()}
				<$SMenu className="menu" {...sM} />
			</div>			
		');
	}
	
}