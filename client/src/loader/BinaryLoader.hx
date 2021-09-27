package loader;

import haxe.Unserializer;
import haxe.Exception;
import hxbit.Serializer;
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

	public static function dbQuery(url:String,dbAP:DBAccessProps, onLoaded:DbData->Void):XMLHttpRequest {
		trace(url);
		//trace(dbAP.relations);
		//trace(dbAP);
		if(s==null)
			s = new Serializer();
		//var s = new Serializer();
		//trace('${dbAP.classPath}.${dbAP.action} filter:${dbAP.filter} table:${dbAP.table}');
		//var s = new json2object.JsonWriter<DbQuery>();
		var bl:BinaryLoader = new BinaryLoader(url);
		var dbQuery = new DbQuery(dbAP);//.toHex();
		trace(dbQuery.dbParams);
		if(dbQuery.dbParams['dataSource'] != null){
			//dbQuery.dbParams['dataSource'] = haxe.Serializer.run(dbQuery.dbParams['dataSource']);
			trace(Std.string(Unserializer.run(dbQuery.dbParams['dataSource'])));
		}
		//Out.dumpObject(dbQuery);
		var b:Bytes = s.serialize(dbQuery);
		trace(b.length);
		//trace(b.toHex());
		//s.serialize(dbQuery);
		bl.param = b.getData();//s.toString();
		//trace(bl.param.byteLength);
		//trace(Unserializer.run(bl.param));
		bl.cB = onLoaded;
		bl.load();
		return bl.xhr;
	}

	var cB:DbData->Void;	
	var dBa:DBAccessJsonResponse->Void;
	var param:Dynamic;
	public static var qi:Int = 0;
	public var xhr:XMLHttpRequest;
	static var s:Serializer;
	static var u:Serializer;
	public var url(default, null) : String;

	public function new( url : String ) {
		this.url = url;
		xhr = new js.html.XMLHttpRequest();
	}

	public function onLoaded( bytes : Bytes ) {
		if(bytes!=null && bytes.length>0){
			trace(bytes.toString());
			//var u = new Unserializer();
			/*var something = Unserializer.run(bytes);
			trace(something);*/
			//var u:Serializer = new Serializer();
			//if(u==null)
				u = new Serializer();

			var data:DbData = u.unserialize(bytes, DbData);//Unserializer.run(bytes);
			trace(data);
			cB(data);			
		}
		else 
			trace('got nothing'+bytes.length);

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
		xhr.responseType = js.html.XMLHttpRequestResponseType.ARRAYBUFFER;

		xhr.onerror = function(e) {
			trace(e);
			trace(e.type);
		}
		xhr.withCredentials = true;
		//xhr.withCredentials = false;
		xhr.onload = function(e) {
			trace(xhr.status);
			if (xhr.status != 200) {
				onError(xhr.statusText);
				return;
			}
			//onLoaded(haxe.io.Bytes.ofString(xhr.response));
			try{
				trace(Type.typeof(xhr.response));
				trace(Std.isOfType(xhr.response, String));
				if(Std.isOfType(xhr.response, String)){
					onLoaded(haxe.io.Bytes.ofString(xhr.response));
				}
				//onLoaded(haxe.io.Bytes.ofData(xhr.response));
				else			
					onLoaded(haxe.io.Bytes.ofData(xhr.response));
					//onLoaded(xhr.response);
			}
			catch(ex:Exception){
				trace(ex.details());
			}			
		}
		
		/*xhr.onprogress = function(e) {
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
		//xhr.setRequestHeader('Access-Control-Allow-Origin', '*');
		xhr.responseType = js.html.XMLHttpRequestResponseType.JSON;
		
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
			trace(xhr.response);
		}
		xhr.send(param);
	}
}