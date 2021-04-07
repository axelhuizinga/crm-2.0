package js.jq;
import js.jquery.JQuery;
import js.jquery.Plugin;


/**
 * ...
 * @author axel@cunity.me
 */
extern class Utils implements Plugin
//@:keep class Utils
{
	static public function fileDownload(url:String, options:Dynamic):JQuery;
	/*{
		return untyped Browser.window.fileDownload(url, options);
	}*/
}