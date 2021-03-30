package js.jq;

import jQuery.haxe.Plugin;
import js.JQuery;

/**
 * ...
 * @author axel@paradiseprojects.de
 */


extern class Autocomplete implements Plugin
{
	public var menu:JQuery;

	@:overload
	public function autocomplete( op:String, ?field:String, ?val:Dynamic):Dynamic
	{
		return untyped this.autocomplete(op, field, val);
	};
	
	@:overload
	public  function autocomplete(?options:Dynamic):JQuery
	{
		return untyped this.autocomplete(options);
	}
	
	@:overload
	public  function autocomplete(method:String):JQuery
	{
		return untyped this.autocomplete(method);
	}
	
	public  function instance(?options:Dynamic):JQuery
	{
		return untyped this.autocomplete("instance");
	}		
	
	@:runtime function _renderMenu( root:JQuery, items:Array<Dynamic> ) :JQuery
	{
		root.html('<table class="debug"></table>');
		var instance:JQuery = this;
		jQuery.JQueryStatic.each(items, function(index, item)
		{
			instance._renderItemData( root, item );
		});
		trace(root.html());
		return instance;
		//return untyped this._renderMenu(root, items);		
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