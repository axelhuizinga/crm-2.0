package js.jq;
import js.html.Window;
import js.html.Element;
import js.html.Node;
import js.jquery.JQuery;

/**
 * @author axel@cunity.me
 */

class JHelper 
{
	@:overload(function(j:JQuery):JQuery{})
	@:overload(function(j:Window):JQuery{})
	@:overload(function(j:Element):JQuery{})
	@:overload(function(j:Node):JQuery{})
	@:overload(function(html:String, context:JQuery):JQuery{})
	public static inline function J( html : String ) : JQuery {
		return new JQuery(html);
	}
	
	public static inline function vsprintf(format:String, args:Array<Dynamic>):String
	{
		//trace(format);
		//trace(args);
		return (untyped __js__("vsprintf"))(format, args);
	};

}