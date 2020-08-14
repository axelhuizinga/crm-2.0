package;
import shared.DbData;
import php.db.PDO;
import php.db.PDOStatement;
import php.Syntax;
import php.NativeArray;


/**
 * ...
 * @author axel@cunity.me
 */
class Util
{

	public static inline function any2bool(v:Dynamic) :Bool
	{
		return (v != null && v != 0 && v !='');
	}

	public static function bindClientData(table:String, stmt:PDOStatement, row:NativeArray, dbData:DbData)
	{
		var meta:Map<String, NativeArray> = S.columnsMeta(table);
		
		Syntax.code("error_log({0})", table);
		Syntax.code("error_log({0})", Std.string(row));
		for(k => v in meta.keyValueIterator())
		{
			//if(k=='id')
				//continue;
			
			var pdoType:Int = v['pdo_type'];
			if(row[k]==null||row[k].indexOf('0000-00-00')==0||row[k]=='')
			{
				//trace (v['native_type']);
				switch (v['native_type'])
				{
					case 'date'|'datetime'|'timestamp':
					pdoType = PDO.PARAM_NULL;
					case 'text'|'varchar':
					row[k] = '';
					case 'int8':
					row[k] = 0;
				}
			}
			//trace('$k => $pdoType:${row[k]}');
			if(!stmt.bindValue(':$k',row[k], pdoType))//row[k]==null?1:
			{
				//trace('$k => $v');
				S.sendErrors(dbData,['bindValue'=>'${row[k]}:$pdoType']);
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
	 * Convert NativeArray to Map
	 * @param row NativeArray
	 * @param keys Array<String>
	 * @return Map<String,Dynamic>
	 */

	public static function map2fields(row:NativeArray,keys:Array<String>):Map<String,Dynamic> {
		
		trace(row);
		trace(keys);
		return[
			for(k in keys)
				k => (Syntax.code('array_key_exists({0},{1})', k, row) ? row[k]:null)
		];
	}

	public static function map2fieldsNum(row:NativeArray,keys:Array<String>):Map<String,Dynamic> {
		var i:Int = 0;
		return[
			for(k in keys)
				k => row[i++]
		];
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
	
	public static inline function randomString(length:Int, ?charactersToUse = "abcdefghijklmnopqrstuvwxyz_§!%ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"):String
	{
		return Random.string(length,charactersToUse);
	}
}