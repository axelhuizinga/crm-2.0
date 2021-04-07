package me.cunity.php;
#if (haxe_ver >= 4)
import php.Syntax;
#end
/**
 * ...
 * @author axel@cunity.me
 */
extern class Services_JSON
{
	public static inline var SERVICES_JSON_LOOSE_TYPE:Int   = 16;
	
	public static inline var SERVICES_JSON_SUPPRESS_ERRORS:Int   = 32;

	public function new(?use:Int) :Void;
	
	public function decode(str:String):Dynamic;
	
	public function encode(data:Dynamic):String;
	
	static function __init__():Void {
		#if (haxe_ver >= 4)
		Syntax.code('require_once({0})', 'php/JSON.php');
		#else
		untyped __call__('require_once', 'php/JSON.php');
		#end
	}
	
}