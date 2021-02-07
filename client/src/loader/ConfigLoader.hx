package loader;

import db.DBAccessProps;
//import db.DbQuery;
import haxe.Json;
import haxe.CallStack;
import me.cunity.debug.Out;
//import shared.DbData;
/**
 * ...
 * @author axel@cunity.me
 */

import js.html.FileReader;
import js.html.FormData;
import js.html.XMLHttpRequest; 


class ConfigLoader {

	public static function go(url:String, p:Dynamic, onLoaded:DBAccessJsonResponse->Void):XMLHttpRequest
	{
		//trace(dbQP);
		var cL:ConfigLoader = new ConfigLoader(url);
		cL.param = p;
		cL.cB = onLoaded;
		cL.load();
		return cL.xhr;
	}
	var cB:DBAccessJsonResponse->Void;	
	var param:Dynamic;
	//var param:String;
	public var xhr:XMLHttpRequest;
	
	public var url(default, null) : String;

	public function new( url : String ) {
		this.url = url;
		xhr = new js.html.XMLHttpRequest();
		xhr.setRequestHeader('Access-Control-Allow-Origin', '*');
	}

	//public dynamic function onLoaded( bytes : haxe.io.Bytes ) {
	public function onLoaded( got : DBAccessJsonResponse ) {
		trace(got);
	}

	public dynamic function onProgress( cur : Int, max : Int ) {
	}

	public dynamic function onError( msg : String ) {
		Out.dumpStack(CallStack.callStack());
		trace(msg);
		throw msg;
	}

	public function load() {
		xhr.open('POST', url, true);
		//xhr.setRequestHeader("Content-type", "application/json;charset=UTF-8");
		//xhr.setRequestHeader("Content-type", "application/json;charset=UTF-8");
		xhr.responseType = js.html.XMLHttpRequestResponseType.ARRAYBUFFER;
		
		//xhr.onerror = function(e) onError(xhr.statusText);
		xhr.onerror = function(e) {
			trace(e);
			trace(e.type);
		}
		xhr.withCredentials = true;
		xhr.onload = function(e) {
			
			trace(xhr.readyState);
			trace(xhr.status);
			if (xhr.status != 200) {
				onError(xhr.statusText);
				return;
			}
			//onLoaded(haxe.io.Bytes.ofData(xhr.response));DBAccessJsonResponse->Void
			onLoaded(xhr.response);
			//trace(xhr.response.length);
		}
		
	/*	xhr.onprogress = function(e) {
			#if (haxe_ver >= 4)
			trace('${e.loaded} :: ${e.total}');
			//onProgress(Std.int(js.Syntax.code("{0}.loaded || {0}.position", e)), Std.int(js.Syntax.code("{0}.total || {0}.totalSize", e)));
			#else
			onProgress(Std.int(untyped __js__("{0}.loaded || {0}.position", e)), Std.int(untyped __js__("{0}.total || {0}.totalSize", e)));
			#end
		}*/
		xhr.send(param);
	}

}