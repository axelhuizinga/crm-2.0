package js.jq;

import jQuery.haxe.Plugin;
import js.JQuery;

/**
 * ...
 * @author axel@paradiseprojects.de
 */


extern class AutocompleteTag implements Plugin
{
	public var menu:JQuery;

	@:overload
	public function autocomplete( op:String, ?field:String, ?val:Dynamic):Dynamic
	{
		return untyped this.autocompletetag(op, field, val);
	};
	
	@:overload
	public  function autocomplete(?options:Dynamic):JQuery
	{
		return untyped this.autocompletetag(options);
	}
	
	@:overload
	public  function autocomplete(method:String):JQuery
	{
		return untyped this.autocompletetag(method);
	}
	
	public  function instance(?options:Dynamic):JQuery
	{
		return untyped this.autocompletetag("instance");
	}		
	
	function _renderMenu( root:JQuery, items:Array<Dynamic> ) :JQuery
	{
		return untyped this._renderMenu(root, items);		
	}
	
	function _renderItemData( root:JQuery, item:Dynamic ):JQuery
	{
        return untyped this._renderItemData( root, item );
    }
	
	dynamic function _renderItem( root:JQuery, item:Dynamic ):JQuery 
	{
		return untyped this._renderItem(root, item);
    }
}