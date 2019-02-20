package view.shared;
import js.html.Event;
import view.shared.SMItem;
import view.shared.SMenuBlock;

typedef SMenuProps =
{
	?activeInstance:Dynamic,
	?className:String,
	?basePath:String,
	?hidden:Bool,
	?menuBlocks:Map<String,SMenuBlock>,
	?section:String,
	?items:Array<SMItem>,
	?itemHandler:Event->Void,
	?right:Bool,
	?sameWidth:Bool
}
