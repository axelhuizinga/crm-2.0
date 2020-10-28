package shared;

import php.NativeAssocArray;
import php.Global;
import haxe.Json;
import php.SuperGlobal;
import sys.io.File;
import php.Web;

class Upload {
	public static function go() {
		var rData = Web.getMultipart(10*1024*1024);
		var rKes:Array<String>=[];
		for(k in rData.keys()){
			if(k.indexOf('File')>-1)
				rKes.push(k);
		}
		trace(rKes.join(',')); 
		trace(SuperGlobal._FILES);
		if(rData.exists('returnDebitFile')){
			var rDF:NativeAssocArray<String> =  SuperGlobal._FILES['returnDebitFile'];
			var name = "/var/www/vhosts/pitverwaltung.de/files/" + rDF['name'];
			Global.move_uploaded_file(rDF['tmp_name'],name);
			var result:String = Global.file_get_contents('https://${SuperGlobal._SERVER["HTTP_HOST"]}/extlib/rla.php?file=$name');
			trace('https://${SuperGlobal._SERVER["HTTP_HOST"]}/extlib/rla.php?file=$name');
			trace(result);
			S.send(result,true);
		}
		S.send(Json.stringify({got:SuperGlobal._FILES}),true);
	}
}

