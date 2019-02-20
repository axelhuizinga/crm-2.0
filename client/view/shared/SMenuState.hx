package view.shared;

typedef  InteractionState =
{
	var disables:Array<String>;
	var enables:Array<String>;
}

typedef SMenuState =
{
	?hidden:Bool,
	?disabled:Bool,
	?sameWidth:Int,
	?interactionStates:Map<String,InteractionState>
}
