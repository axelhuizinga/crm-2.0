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

	public static function go(url:String, p:Dynamic, onLoaded:DBAccessJsonResponse->Void):ConfigLoader
	{
		//trace(dbQP);
		var cL:ConfigLoader = new ConfigLoader(url,p);
		//cL.param = p;
		cL.cB = onLoaded;
		//cL.load();
		var fD:FormData = new FormData();
		for(f in Reflect.fields(p))
		{
			if(f=='userState'){
				//Out.dumpObject(Reflect.field(p,f));
			}
			else 
			fD.append(f, Reflect.field(p,f));
		}
		cL.param = fD;
		//cL.xhr.send(fD);
		return cL;
	}
	var cB:DBAccessJsonResponse->Void;	
	public var param:FormData;
	//var param:String;
	public var xhr:XMLHttpRequest;
	
	public var url(default, null) : String;

	public function new( url : String, ?p:Dynamic ) {
		this.url = url;
		xhr = new js.html.XMLHttpRequest();
		trace(xhr.readyState);
		xhr.withCredentials = true;
		xhr.onreadystatechange = function() {
			trace(xhr.readyState);
			switch (xhr.readyState){
				case XMLHttpRequest.OPENED:					
					xhr.send(p);
				case XMLHttpRequest.LOADING:
					//
				case XMLHttpRequest.HEADERS_RECEIVED:
					//xhr.send(p);
			}
		}
		load();		
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
		//throw msg;
	}

	public function load() {
		trace(url);
		xhr.open('POST', url, true);
		//xhr.setRequestHeader('Access-Control-Allow-Origin', '*');
		//xhr.setRequestHeader("Content-type", "multipart/form-data");
		//xhr.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
		//xhr.setRequestHeader("Content-type", "application/json;charset=UTF-8");
		//xhr.responseType = js.html.XMLHttpRequestResponseType.JSON;
		
		//xhr.onerror = function(e) onError(xhr.statusText);
		xhr.onerror = function(e) {
			Out.dumpObject(e);
			trace(e.type);
		}
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
		
		xhr.onprogress = function(e) {
			trace('${e.loaded} :: ${e.total}');
			//onProgress(Std.int(js.Syntax.code("{0}.loaded || {0}.position", e)), Std.int(js.Syntax.code("{0}.total || {0}.totalSize", e)));
		}
		//xhr.send(param);
	}

}