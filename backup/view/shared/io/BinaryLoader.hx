package view.shared.io;

import shared.DbData;
/**
 * ...
 * @author axel@cunity.me
 */

import haxe.io.Bytes;
import hxbit.Serializer;
import js.html.FormData;
import js.html.XMLHttpRequest;


class BinaryLoader {

	public static function create(url:String, p:Dynamic, onLoaded:DbData->Void):XMLHttpRequest
	{
		var bl:BinaryLoader = new BinaryLoader(url);
		bl.cB = onLoaded;
		bl.param = new FormData();
		for (f in Reflect.fields(p))
		{
			bl.param.set(f, Reflect.field(p, f));
		}
		bl.load();
		return bl.xhr;
	}
	var cB:DbData->Void;
	var param:FormData;
	public var xhr:XMLHttpRequest;
	
	public var url(default, null) : String;
	#if flash
	var loader : flash.net.URLLoader;
	#end

	public function new( url : String ) {
		this.url = url;
		xhr = new js.html.XMLHttpRequest();
	}

	public dynamic function onLoaded( bytes : haxe.io.Bytes ) {
		var u:Serializer = new Serializer();
		var data:DbData = u.unserialize(bytes, DbData);
		cB(data);
	}

	public dynamic function onProgress( cur : Int, max : Int ) {
	}

	public dynamic function onError( msg : String ) {
		throw msg;
	}

	public function load() {
		xhr.open('POST', url, true);
		xhr.responseType = js.html.XMLHttpRequestResponseType.ARRAYBUFFER;
		xhr.onerror = function(e) onError(xhr.statusText);
		xhr.withCredentials = true;
		xhr.onload = function(e) {
			
			if (xhr.status != 200) {
				onError(xhr.statusText);
				return;
			}
			onLoaded(haxe.io.Bytes.ofData(xhr.response));
		}
		
		xhr.onprogress = function(e) {
			#if (haxe_ver >= 4)
			onProgress(Std.int(js.Syntax.code("{0}.loaded || {0}.position", e)), Std.int(js.Syntax.code("{0}.total || {0}.totalSize", e)));
			#else
			onProgress(Std.int(untyped __js__("{0}.loaded || {0}.position", e)), Std.int(untyped __js__("{0}.total || {0}.totalSize", e)));
			#end
		}
		xhr.send(param);
	}

}