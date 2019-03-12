package view.shared;
import haxe.Constraints.Function;
import react.router.Route.RouteRenderProps;
import js.html.Event;
import view.shared.SMItem;
import view.shared.SMenuBlock;

typedef SMenuProps =
{
	>RouteRenderProps,
	?activeInstance:Dynamic,
	?className:String,
	?basePath:String,
	?hidden:Bool,
	?menuBlocks:Map<String,SMenuBlock>,
	?section:String,
	?switchSection:Function,
	?items:Array<SMItem>,
	?itemHandler:Event->Void,
	?right:Bool,
	?sameWidth:Bool
}
