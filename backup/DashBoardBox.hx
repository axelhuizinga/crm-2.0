package view;
import react.React;
import react.ReactComponent.ReactComponentOfProps;
import react.ReactMacro.jsx;
import view.DashBoard;

/**
 * ...
 * @author axel@cunity.me
 */

class DashBoardBox extends ReactComponentOfProps<Dynamic>
{

	public function new(?props:Dynamic) 
	{
		trace(Reflect.fields(props));
		super(props);
	}
	
	override public function render()
	{
		trace(Reflect.fields(props));
		return jsx('<DashBoard {...props}/>');
	}
	
}