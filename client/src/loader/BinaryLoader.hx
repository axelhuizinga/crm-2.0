package loader;

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
import hxbit.Serializer;
import js.html.FileReader;
import js.html.FormData;
import js.html.XMLHttpRequest; 


class BinaryLoader {

	public static function create(url:String, p:Dynamic, onLoaded:DbData->Void):XMLHttpRequest
	{
		return dbQuery(url, p, onLoaded);
		var bl:BinaryLoader = new BinaryLoader(url);
		trace(p);
		bl.param = new FormData();
		//bl.param = Json.stringify(p);
		bl.cB = onLoaded;
		for (f in Reflect.fields(p))
		{
			bl.param.set(f, Reflect.field(p, f));
		}
		bl.load();
		return bl.xhr;
	}

	public static function dbQuery(url:String,dbQP:DBAccessProps, onLoaded:DbData->Void) {
		//trace(dbQP);
		var s:Serializer = new Serializer();
		var bl:BinaryLoader = new BinaryLoader(url);
		var dbQuery = new DbQuery(dbQP);//.toHex();
		var b:Bytes = s.serialize(dbQuery);
		//trace(dbQuery.getSerializeSchema());
		//trace(dbQuery.relations.get('contacts').fields);
		//dbQuery.dump('/tmp/dbQuery.json');
		//trace(dbQuery);
		trace('b.length:${b.length}');
		var blen:Int = b.length;
		for(i in 0...blen){
			//trace('$i:${b.get(i)}  ${b.getString(i,1)}');
		}
		//bl.param = b.getString(0,b.length); //s.serialize(dbQuery);//.toHex();
		bl.param = b.getData();
		//bl.param = new FileReader().readAsBinaryString(s.serialize(new DbQuery(dbQuery)));
		//trace(bl.param);
		//trace(bl.param.toHex().length + ' :: ' + bl.param.toString().length + ' : ' + bl.param.length);
		bl.cB = onLoaded;
		bl.load();
		return bl.xhr;
	}
	var cB:DbData->Void;	
	var param:Dynamic;
	//var param:String;
	public var xhr:XMLHttpRequest;
	
	public var url(default, null) : String;
	#if flash
	var loader : flash.net.URLLoader;
	#end

	public function new( url : String ) {
		this.url = url;
		xhr = new js.html.XMLHttpRequest();
	}

	//public dynamic function onLoaded( bytes : haxe.io.Bytes ) {
	public function onLoaded( bytes : haxe.io.Bytes ) {
		trace(bytes.length);
		var u:Serializer = new Serializer();
		var data:DbData = u.unserialize(bytes, DbData);
		cB(data);
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
			trace(xhr.status);
			if (xhr.status != 200) {
				onError(xhr.statusText);
				return;
			}
			trace(xhr.response.length);
			onLoaded(haxe.io.Bytes.ofData(xhr.response));
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