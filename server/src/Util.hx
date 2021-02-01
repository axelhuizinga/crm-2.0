package;
import haxe.PosInfos;
import hxbit.Serializer;
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

		for(k => v in meta.keyValueIterator())
		{
			if(!Global.array_key_exists(k,row))
				continue;
			var kv:Dynamic = row[k];			
			var pdoType:Int = v['pdo_type'];			
			//if(kv==null||kv.indexOf('0000-00-00')==0||kv=='')
			if(kv==null||kv.indexOf('0000-')==0||kv=='')
			{
				//trace (v['native_type']);
				switch (v['native_type'])
				{
					case 'date'|'datetime'|'timestamp':
						pdoType = PDO.PARAM_NULL;
					case 'timestamptz':
						pdoType = PDO.PARAM_STR;
						trace(pdoType);
						pdoType = PDO.PARAM_INT;
						trace(pdoType);	
						continue;		
						//kv = 0;
					case 'text'|'varchar':
						kv = '';
					case 'int8':
						kv = 0;
				}
			}
			//trace('$k => ${v['native_type']} :: $pdoType:${kv}');
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
		//trace(meta);
		var i:Int = 0;
		for(k => v in meta.keyValueIterator())
		{
			//if(k=='id')
				//continue;
			
			var pdoType:Int = v['pdo_type'];
			
			if(row[i]==null||row[i].indexOf('0000-00-00')==0||row[i]=='')
			//if(row[i]==null||row[i]=='')
			{				
				//trace (v['native_type']);
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
			//trace('$k => $pdoType:${row[i]}');
			if(!stmt.bindValue(':$k',row[i], pdoType))//row[i]==null?1:
			{
				//trace('$k => $v');
				S.sendErrors(dbData,['bindValue'=>'${row[i]}:$pdoType']);
			}		
			i++;
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
			'action','classPath','offset','onlyNew','action_id','limit','maxImport','totalRecords'
		];
	 * 				{
					dbUser:props.userState.dbUser,
					classPath:props.classPath,
					action:props.action,
					extDB:true,
					action_id:(props.action_id == null?0:props.action_id),
					limit:props.limit,
					offset:props.offset,
					table:props.table,
					filter:props.filter,
					maxImport:props.maxImport==null?1000:props.maxImport,
					devIP:App.devIP
				},
	 */
	public static function buildDbQuery(param:Map<String,Dynamic>):String {
		S.dbQuery.dbUser.password='XXX';
		var dbQP:DBAccessProps = {
			dbUser:S.dbQuery.dbUser,
			action:param['action'],
			action_id:param['action_id'],
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
		trace(v);

		return {
			int:v,
			sql:(v>0 ? 'LIMIT ' + v:'')
		};
	}
	
	public static function offset(?v:Int):IntString {
		if (v == null)
			v = Std.parseInt(S.params.get('offset'));
		trace(v);

		return {
			int:v,
			sql:(v>0 ? 'OFFSET ' + v:'')
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

	public static function safeLog(log:String, ?pos:PosInfos) {
		Global.file_put_contents('/var/www/pitverwaltung.de/log/crm.log',log, 8);
	}
}