package js.jq;

/**
 * ...
 * @author axel@cunity.me
 */

extern class Accordion implements js.jquery.Plugin
{
	public var panels:Array<js.html.HtmlElement>;
	
	@:overload(function( options:Dynamic):js.jquery.JQuery{})
	@:overload(function( op:String, ?field:String, ?val:Dynamic):js.jquery.JQuery{})
	public  function accordion(op:String, ?field:String):js.jquery.JQuery;	
	
}