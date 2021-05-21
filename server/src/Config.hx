package;

import php.Lib;
import php.Syntax;
import php.Web;
import sys.FileSystem;
import sys.io.File;
import tjson.TJSON;
//import me.cunity.php.Services_JSON;
import StringTools;
using StringTools;
/**
 * ...
 * @author axel@cunity.me
 */
class Config
{
	/**
	 * [Load configuration from file in javascript format]
	 * @param cjs 
	 * @return Map<String,Dynamic>
	 */
	public static function load(cjs:String) :Map<String,Dynamic>
	{
		var js:String = File.getContent(cjs);
		//Syntax.("file_get_contents", cjs);
		//trace(js);
		var vars:Array<String> = js.split('var');
		vars.shift();
		var result:Map<String,Dynamic> = new Map();
		//trace(vars.length);
		for (v in vars)
		{
			var data:Array<String> = v.split('=');
			var json:Dynamic = TJSON.parse(data[1]);
			result.set(data[0].trim(), json);
		}		
		return result;
	}
	
}