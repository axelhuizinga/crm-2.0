package view.shared.io;

typedef ToolTipOptions =
{
	data:String,
	?className:String,
	?multiLine:Bool;
}

class UXTools {

	public static function tooltip(el:js.html.Element, ttOpt:ToolTipOptions):Void
	{
		el.classList.add('tooltip','is-tooltip-danger','is-tooltip-active');
		if(ttOpt.multiLine)
			el.classList.add('is-tooltip-multiline');
		el.dataset.tooltip = ttOpt.data;		
	}
	
}