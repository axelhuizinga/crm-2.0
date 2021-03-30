package js.jq;
import jQuery.haxe.Plugin;
import js.html.HtmlElement;
import js.jquery.JQuery;
/**
 * ...
 * @author axel@paradiseprojects.de
 */
extern class Tabs implements Plugin{

	@:overload (public function ( op:String, ?field:String, ?val:Dynamic):JQuery{});
	/*{
		return untyped this.tabs(op, field, val);
	};
	
	@:overload*/
	public  function tabs(?options:Dynamic):JQuery;/*
	{
		return untyped this.tabs(options);
	}*/
	
	public  function instance(?options:Dynamic):JQuery;/*
	{
		return untyped this.tabs("instance");
	}	*/
	
}