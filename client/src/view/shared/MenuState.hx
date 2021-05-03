package view.shared;

import haxe.ds.StringMap;
import view.shared.MItem;

typedef  InteractionStates = StringMap<Bool>;

typedef MenuState =
{
	?hidden:Bool,
	?disabled:Bool,
	?sameWidth:Int,
	?section:String,
	?interactionStates:InteractionStates,
	?items:StringMap<MItem>
}
