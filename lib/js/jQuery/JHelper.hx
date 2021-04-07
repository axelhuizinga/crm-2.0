package js.jQuery;
import js.html.Window;
import js.html.Element;
import js.html.Node;
import js.jquery.JQuery;

/**
 * @author axel@cunity.me
 */

class JHelper {
	@:overload(function(element:js.html.Element):JQuery { })
	@:overload(function(elementArray:haxe.extern.EitherType<js.html.NodeList, Array<js.html.Element>>):JQuery { })
	@:overload(function(selection:js.jquery.JQuery):JQuery { })
	@:overload(function(callback:haxe.Constraints.Function):JQuery { })
	@:overload(function(object:Dynamic):JQuery { })
	@:overload(function(html:String, attributes:Dynamic):JQuery { })
	@:overload(function(selector:String, ?context:haxe.extern.EitherType<js.html.Element, js.jquery.JQuery>):JQuery { })
	@:overload(function(html:String, ?ownerDocument:js.html.Document):JQuery { })
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