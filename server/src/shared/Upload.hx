package shared;

import haxe.Json;
import php.SuperGlobal;
import sys.io.File;
import php.Web;

class Upload {
	public static function go() {
		var file = Web.getMultipart(10*1024*1024);
		//var out = File.write(SuperGlobal._POST[SuperGlobal._POST['action'])
		//var out = File.write(SuperGlobal._FILES)
		trace(SuperGlobal._FILES);
		S.send(Json.stringify({got:SuperGlobal._FILES}),true);
	}
}

