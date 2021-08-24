package view.shared;
import model.ORM;
import view.shared.Menu;
import haxe.Constraints.Function;
import react.router.Route.RouteRenderProps;
import js.html.Event;
import view.shared.MItem;
import view.shared.MenuBlock;

typedef MenuProps =
{
	>RouteRenderProps,
	?instance:Menu,
	?className:String,
	?basePath:String,	
	?hidden:Bool,
	?mBshowActive:Bool,
	?menuBlocks:Map<String,MenuBlock>,
	?orm:ORM,
	?parentComponent:Dynamic,
	?section:String,
	?switchSection:Function,
	?items:Array<MItem>,
	?itemHandler:Event->Void,
	?right:Bool,
	?sameWidth:Bool
}
