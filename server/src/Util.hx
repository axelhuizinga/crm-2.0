package;
import haxe.Unserializer;
import db.DbRelation;
import haxe.ds.StringMap;
import php.Exception;
import php.Lib;
import me.cunity.debug.Out;
import me.cunity.php.Debug;
import haxe.PosInfos;

import haxe.io.Bytes;
import db.DbQuery;
import db.DBAccessProps;
import php.Const;
import php.Global;
import shared.DbData;
import php.db.PDO;
import php.db.PDOStatement;
import php.Syntax;
import php.NativeArray;

using StringTools;
/**
 * ...
 * @author axel@cunity.me
 */

typedef IntString = {
	int:Int,
	sql:String
}

class Util
{

	public static function actionPath(ins:Dynamic) {
		return '\'${Type.getClassName(Type.getClass(ins)) + '.' + S.action}\'';
	}

	public static inline function any2bool(v:Dynamic) :Bool
	{
		return (v != null && v != 0 && v !='');
	}

	public static function bindClientData(table:String, stmt:PDOStatement, row:NativeArray, dbData:DbData)
	{
		var meta:Map<String, NativeArray> = S.columnsMeta(table);
		
		//Syntax.code("error_log({0})", table);
		//Syntax.code("error_log({0})", Std.string(row));
		//trace(meta);
		//Out.dumpVar(meta);

		for(k => v in meta.keyValueIterator())
		{
			if(!Global.array_key_exists(k,row)){
				//trace('$k missing@ $row["id"]');
				continue;
			}				
			
			//var kv:Dynamic = (v['native_type']=='bytea'?Bytes.ofString(row[k]).:row[k]);	
			var kv:Dynamic = row[k];
			var pdoType:Int = v['pdo_type'];			
			//trace('$pdoType::${v['native_type']}: $k => $kv');
			//if(kv==null||kv.indexOf('0000-00-00')==0||kv=='')
			if(kv==null||kv==''||pdoType>1&&kv.indexOf('0000-')==0)
			{
				//trace (v['native_type']);
				switch (v['native_type'])
				{
					case 'date'|'datetime'|'timestamp':
						pdoType = PDO.PARAM_NULL;
					case 'timestamptz':
						pdoType = PDO.PARAM_STR;
						//trace(pdoType);
						pdoType = PDO.PARAM_NULL;
						trace(pdoType);	
						//continue;		
						//kv = 0;
					case 'text'|'varchar':
						kv = '';
					case 'int8':
						kv = 0;
				}
			}
			//trace('$k => ${v['native_type']} ::$pdoType:$kv');
			if(!stmt.bindValue(':$k',kv, pdoType))//kv==null?1:
			{
				//trace('$k => $v');
				S.sendErrors(dbData,['bindValue'=>'${kv}:$pdoType']);
			}		
		}
	}

	public static function bindClientDataNum(table:String, stmt:PDOStatement, row:NativeArray, dbData:DbData)
	{
		var meta:Map<String, NativeArray> = S.columnsMeta(table);
		trace(Out.dumpKeys(meta.keys()));
		trace(Lib.toHaxeArray(Global.array_keys(row)).join('|'));
		var i:Int = 0;
		try{
			for(k => v in meta.keyValueIterator())
			{
				//if(k=='id')
					//continue;				
				var pdoType:Int = v['pdo_type'];
				if(Global.array_key_exists(i,row)){
				trace (k+':'+i+':'+v['native_type']+'::'+row[i]);
					if(row[i]==null||row[i].indexOf('0000-00-00')==0||row[i]=='')
					{										
						switch (v['native_type'])
						{
							case 'date'|'datetime'|'timestamp':
							pdoType = PDO.PARAM_NULL;
							case 'text'|'varchar':
							row[i] = '';
							case 'int8':
								
							row[i] = 0;
						}
					}
					trace('$k => $pdoType:${row[i]}');
					trace('pdoType: $pdoType == ${PDO.PARAM_INT }');
					if(!stmt.bindValue(':$k',row[i], pdoType))//row[i]==null?1:
					{
						//trace('$k => $v');
						S.sendErrors(dbData,['bindValue'=>'${row[i]}:$pdoType']);
					}
				}
				i++;
			}
		}
		catch(ex:haxe.Exception){
			trace(row);
			trace('i:$i');
			trace(ex.message);
		}
	}

	/**
	 * Create jsonb object
	 * @param keys Array<String>
	 * @param ob Map<String,Dynamic>
	 */
	
	 public  static function buildJsonB(keys:Array<String>, ob:Map<String,Dynamic>):String {
		var s:String = '{';
		for(k in keys){
			if(ob.exists(k)){
				if(Std.isOfType(ob.get(k), String)){
					s += '"$k":"${ob.get(k)}", ';
				}
				else {
					s += '"$k":${ob.get(k)}, ';
				}
				
			}
		}
		
		//var r:EReg = ~/,$/;//new EReg(",$");
		var r:EReg = new EReg(", $","i");
		s = r.replace(s,'}');
		return s;
	}

	public  static function cliArgs(arg:Map<String,Dynamic>):String {
		var s:String = '';
		for(k=>v in arg.keyValueIterator()){
			if(Std.isOfType(v, String)){
				s += '-$k "${v}" ';
			}
			else {
				s += '-$k ${v} ';
			}				
		}
		//s = r.replace(s,'}');
		return s;
	}

	/**
	 * actionFields = [
			'action','classPath','offset','onlyNew','id','limit','maxImport','totalRecords'
		];
	 * 				{
					dbUser:props.userState.dbUser,
					classPath:props.classPath,
					action:props.action,
					extDB:true,
					id:(props.id == null?0:props.id),
					limit:props.limit,
					offset:props.offset,
					table:props.table,
					filter:props.filter,
					maxImport:props.maxImport==null?1000:props.maxImport,
					devIP:App.devIP
				},
	 */
	/*public static function buildDbQuery(param:Map<String,Dynamic>):String {
		S.dbQuery.dbUser.password='XXX';
		var dbQP:DBAccessProps = {
			dbUser:S.dbQuery.dbUser,
			action:param['action'],
			id:param['id'],
			extDB:param['extDB'],
			filter:param['filter'],
			offset:param['offset'],
			limit:param['limit'],
			maxImport:param['maxImport']
		};
		var s:Serializer = new Serializer();
		var dbQuery = new DbQuery(dbQP);//.toHex();
		S.safeLog(dbQuery);
		var b:Bytes = s.serialize(dbQuery);
		return b.toString();
	}*/

	/**
	 * Convert Map to Object
	 * @param map Map<T>
	 * @return  Dynamic	 
	 */

	public static function map2dyn<V>(map: Map<String,V>) {
		var ob:Dynamic = {};
		for(k=>v in map.keyValueIterator())
		{
			Reflect.setField(ob,k,v);
		}
		return ob;
	}

	/**
	 * Convert NativeArray to Map
	 * @param row NativeArray
	 * @param keys Array<String>
	 * @return Map<String,Dynamic>
	 */

	public static function map2fields(row:NativeArray,keys:Array<String>):Map<String,Dynamic> {
		
		//trace(row);
		//trace(keys);
		return[
			for(k in keys.filter(function(k)return Global.array_key_exists(k,row)))
				k => row[k]				
		];
	}

	public static function map2fieldsNum(row:NativeArray,keys:Array<String>):Map<String,Dynamic> {
		var i:Int = 0;
		return[
			for(k in keys)
				k => row[i++]
		];
	}
	public static function copy2map(m:Map<String,Dynamic>, obj:Dynamic):Void
	{
		for (field in Reflect.fields(obj))
			m.set(field, Reflect.field(obj, field));
	}
	
	public static function copy(source1:Dynamic, ?source2:Dynamic):Dynamic
	{
		var target = {};
		for (field in Reflect.fields(source1))
			Reflect.setField(target, field, Reflect.field(source1, field));
		if (source2 != null)
			for (field in Reflect.fields(source2))
				Reflect.setField(target, field, Reflect.field(source2, field));
		return target;
	}
	
	public static function copyStringMap<T>(source:Map<String,T>, ?source2:Map<String,T>):Map<String,T>
	{
		var copy:Map<String,T> = new Map();
		var keys = source.keys();
		while (keys.hasNext())
		{
			var k:String = keys.next();
			copy.set(k, source.get(k));
		}
		if (source2 != null)
			keys = source2.keys();
			while (keys.hasNext())
			{
				var k:String = keys.next();
				copy.set(k, source2.get(k));
			}		
		return copy;
	}

	public static function initNativeArray():NativeArray
	{
		return Syntax.array(null);
	}

	public static function minId() {
		return (
			S.params.get('offset') != null && Std.parseInt(S.params.get('offset')) != null? 
			Std.parseInt(S.params.get('offset'))+9999999 : 
			9999999);
	}

	public static function limit(?v:Int):IntString {
		if (v == null)
			v = Std.parseInt(S.params.get('limit'));
		if(v==null||v<0)
			v=0;
		trace(v);

		return {
			int:v,
			sql:(v>0 ? ' LIMIT ' + v:'')
		};
	}
	
	public static function offset(?v:Int):IntString {
		if (v == null)
			v = Std.parseInt(S.params.get('offset'));
		if(v==null)
			v=0;
		trace(v);
		return {
			int:v,
			sql:(v>0 ? ' OFFSET ' + v:'')
		};
	}

	public static inline function randomString(length:Int, ?charactersToUse = "abcdefghijklmnopqrstuvwxyz_§!%ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"):String
	{
		return Random.string(length,charactersToUse);
	}

	public static function nativeArray2String(n:NativeArray):String {
		var s:String = '';
		var ki:KeyValueIterator<String,Dynamic> = n.keyValueIterator();
		while (ki.hasNext()){
			var kv = ki.next();
			s += '${kv.key}=>${kv.value}' + Const.PHP_EOL;
		}
		return s;
	}

	public static function safeLog(what:Dynamic, recursive:Bool = false, ?pos:PosInfos) {
		var fields:Array<String> = Reflect.fields(what);
		//trace(fields.join('|'), pos);
		var sLog:String = '';
		for (f in fields)
		{
			if(f.indexOf('pass') > -1 || f.indexOf('__hx')>-1)
			{
				continue;
			}
			var val:Dynamic = Reflect.field(what,f);
			if(Type.typeof(val)==TUnknown){				
				//Util.safeLog([for (k in Lib.hashOfAssociativeArray(val).keys())k].join('|'),pos);
				sLog += '$f:';
				for (k=>v in Lib.hashOfAssociativeArray(val).keyValueIterator()){
					sLog += k.indexOf('pass') == -1 ? '$k:${Std.string(v)}' : '$k:xxx';
				};
				sLog += '\n';
				continue;
			}
			//Util.safeLog(Std.string(Type.typeof(val)) + ':' + Std.isOfType(val, Array),pos);
			//trace(cName + ':' + val + ':' + Std.isOfType(val, Array),pos);
			//if(cName=='Array'){
			if(Std.isOfType(val, Array)){
				sLog += '$f:' + cast(val,Array<Dynamic>).filter(function (f:Dynamic) {
					return cast(f, String).indexOf('pass') == -1;
				}).join(',');
				sLog += '\n';
				continue;
			}
			var cName:String = Type.getClassName(Type.getClass(val));
			if(cName.indexOf('.')>-1)
			{
				//Util.safeLog('recurse4 $cName', pos);
				sLog += '$f:';
				sLog += Util.safeLog(val, true, pos);
				continue;
			}			
		}
		/**
		 * return String from recursive call
		 */
		if(recursive)
			return sLog;

		if(Lib.isCli())
			trace(pos.fileName+':'+pos.lineNumber+'::'+sLog);
		else 
			Global.file_put_contents(Debug.logFile,
				pos.fileName+':'+pos.lineNumber+'::'+ Std.string(sLog) + "\n", Const.FILE_APPEND);
		return null;
	}

	public static function rels2string(rels:StringMap<DbRelation>):String {
		var s:String = '';
		if(rels==null)
			return s;
		for(k=>v in rels.keyValueIterator()){
			s += '$k:' + Reflect.fields(v).join('|') + "\n";
			//s += '$k:' + Type.typeof(v) + "\n";
			//s += '$k:' + Std.string(v) + "\n";
		}
		return s;
	}

	public static function unserialize(serialized:String):Dynamic {
		//var s:Serializer = new Serializer();
		//return s.unserialize(Bytes.ofString(serialized));
		return Unserializer.run(serialized);
	}
}