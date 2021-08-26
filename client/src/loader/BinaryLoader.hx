package loader;

import haxe.Unserializer;
import haxe.Serializer;
import db.DBAccessProps;
import db.DbQuery;
import haxe.Json;
import haxe.CallStack;
import me.cunity.debug.Out;
import shared.DbData;
/**
 * ...
 * @author axel@cunity.me
 */

import haxe.io.Bytes;
import js.html.FileReader;
import js.html.FormData;
import js.html.XMLHttpRequest; 


class BinaryLoader {

	public static function create(url:String, p:Dynamic, onLoaded:DbData->Void):XMLHttpRequest
	{
		return dbQuery(url, p, onLoaded);
	}

	public static function dbQuery(url:String,dbAP:DBAccessProps, onLoaded:DbData->Void) {
		//trace(url);
		//trace(dbAP.relations);
		//trace(dbAP);
		//trace('${dbAP.classPath}.${dbAP.action} filter:${dbAP.filter} table:${dbAP.table}');
		var s = new Serializer();
		//var s = new json2object.JsonWriter<DbQuery>();
		var bl:BinaryLoader = new BinaryLoader(url);
		var dbQuery = new DbQuery(dbAP);//.toHex();
		//trace(dbQuery.dbParams);
		//Out.dumpObject(dbQuery);
		//var b:Bytes = s.serialize(dbQuery);
		s.serialize(dbQuery);
		bl.param = s.toString();
		bl.cB = onLoaded;
		bl.load();
		return bl.xhr;
	}

	/*public static function jsonQuery(url:String,dbAP:DBAccessProps, onLoaded:DbData->Void) {
		//trace(url);
		//trace(dbAP.relations);
		//trace(dbAP);
		//trace('${dbAP.classPath}.${dbAP.action} filter:${dbAP.filter} table:${dbAP.table}');
		var s = new json2object.JsonWriter<DbQuery>();
		var bl:BinaryLoader = new BinaryLoader(url);
		var dbQuery = new DbQuery(dbAP);//.toHex();
		trace(dbQuery);
		//Out.dumpObject(dbQuery);
		//var b:Bytes = s.serialize(dbQuery);
		bl.param = s.write(dbQuery);
		bl.cB = onLoaded;
		bl.load();
		return bl.xhr;
	}	*/

	/*public static function go(url:String, dbAP:DBAccessProps, onLoaded:DBAccessJsonResponse->Void){
		//trace(dbAP);
		var s:Serializer = new Serializer();
		var bl:BinaryLoader = new BinaryLoader(url);
		var dbQuery = new DbQuery(dbAP);//.toHex();
		//trace(dbQuery);
		var b:Bytes = s.serialize(dbQuery);
		bl.param = b.getData();
		bl.dBa = onLoaded;
		bl.loadJson();
		return bl.xhr;
	}*/


	var cB:DbData->Void;	
	var dBa:DBAccessJsonResponse->Void;
	var param:Dynamic;
	//var param:String;
	public var xhr:XMLHttpRequest;
	
	public var url(default, null) : String;

	public function new( url : String ) {
		this.url = url;
		xhr = new js.html.XMLHttpRequest();
	}

	public function onLoaded( bytes : String ) {
		//trace(bytes);
		if(bytes!=null && bytes.length>0){
			//var u = new Unserializer();
			/*var something = Unserializer.run(bytes);
			trace(something);*/
			var data:DbData = Unserializer.run(bytes);
			//trace(data);
			cB(data);			
		}
		else 
			trace('got nothing');

	}
	/**
	 * [Description]			var u = new json2object.JsonParser<DbData>();
			var data:DbData = u.fromJson(bytes);
	 * @param cur 
	 * @param max 
	 */
	public dynamic function onProgress( cur : Int, max : Int ) {
		trace('$cur of $max');
	}

	public dynamic function onError( msg : String ) {
		Out.dumpStack(CallStack.callStack());
		trace(msg);
		throw msg;
	}

	public function load() {
		xhr.open('POST', url, true);
		//xhr.setRequestHeader('Origin', 'https://${App.devIP}:9000');
		//xhr.setRequestHeader('Access-Control-Request-Method', 'POST');
		//xhr.setRequestHeader('Access-Control-Allow-Origin', 'https://dev.pitverwaltung.de');
		//xhr.setRequestHeader('Access-Control-Allow-Origin', '*');
		//xhr.setRequestHeader("Content-type", "application/json;charset=UTF-8");
		//xhr.responseType = js.html.XMLHttpRequestResponseType.ARRAYBUFFER;
		
		//xhr.onerror = function(e) onError(xhr.statusText);
		xhr.onerror = function(e) {
			trace(e);
			trace(e.type);
		}
		xhr.withCredentials = true;
		//xhr.withCredentials = false;
		xhr.onload = function(e) {
			//trace(xhr.status);
			if (xhr.status != 200) {
				onError(xhr.statusText);
				return;
			}
			//trace(xhr.response.length);
			onLoaded(xhr.response);
			//onLoaded(haxe.io.Bytes.ofData(xhr.response));
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

	public function loadJson() {
		xhr.open('POST', url, true);
		//xhr.setRequestHeader("Content-type", "application/json;charset=UTF-8");
		xhr.setRequestHeader('Access-Control-Allow-Origin', '*');
		xhr.responseType = js.html.XMLHttpRequestResponseType.ARRAYBUFFER;
		
		xhr.onerror = function(e) {
			trace(e);
			trace(e.type);
		}
		xhr.withCredentials = false;
		xhr.onload = function(e) {
			//trace(xhr.status);
			if (xhr.status != 200) {
				onError(xhr.statusText);
				return;
			}
			//trace(xhr.response.length);
			//dBa(haxe.io.Bytes.ofData(xhr.response));
		}
		xhr.send(param);
	}
}