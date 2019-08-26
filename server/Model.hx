package;

import S.ColDef;
import haxe.Unserializer;

import haxe.io.Bytes;
import hxbit.Serializer;
import php.Lib;
import php.NativeArray;
import model.VicidialUsers;
import php.Syntax;
import php.Web;
import php.db.PDO;
import php.db.PDOStatement;
import shared.DbData;
import sys.io.File;

using Lambda;
using Util;


 /* ...
 * @author axel@cunity.me
 */


typedef MData = 
{
	@:optional var count:Int;
	@:optional var error:Dynamic;
	@:optional var page:Int;
	@:optional var editData:NativeArray;
	@:optional var globals:Dynamic;
	@:optional var rows:NativeArray;
	@:optional var content:String;
	@:optional var choice:NativeArray;
	@:optional var fieldDefault:NativeArray;
	@:optional var fieldNames:Map<String,String>;
	@:optional var fieldRequired:NativeArray;
	@:optional var jwt:String;
	@:optional var optionsMap:NativeArray;
	@:optional var recordings:NativeArray;
	@:optional var tableNames:Array<String>;
	@:optional var typeMap:NativeArray;
	@:optional var userMap:Array<UserInfo>;
	@:optional var user_id:Int;
	@:optional var user_name:String;
};

typedef RData =
{
	?rows:NativeArray,
	?error:Map<String,Dynamic>,
	?info:Map<String,Dynamic>
}

@:enum
abstract JoinType(String)
{
	var INNER = 'INNER';	
	var LEFT = 'LEFT';	
	var RIGHT = 'RIGHT';	
}

typedef DataRelation =
{
	var joinType:JoinType;
	var joinCondition:String;	
}

typedef DataSource =
{
	@:optional var alias:String;
	@:optional var fields:Array<String>;
	@:optional var filter:Array<Map<String,String>>;
}

class Model
{
	public var data:MData;
	public var db:String;
	public var joinSql:String;
	public var queryFields:String;
	public var filterSql:String;
	public var setSql:String;
	var filterValues:Array<Array<Dynamic>>;
	var setValues:Array<Dynamic>;
	public var globals:Dynamic;
	public var fieldNames:Array<String>;
	public var tableNames:Array<String>;
	public var table:String;
	public var num_rows(default, null):Int;
	var action:String;
	var dbData:DbData;
	var dParam:DbData;
	var dataSource:Map<String,Map<String,Dynamic>>;// EACH KEY IS A TABLE NAME
	var dataSourceSql:String;
	var param:Map<String, String>;
	
	public static function dispatch(param:Map<String,Dynamic>):Void
	{
		var cl:Class<Dynamic> = Type.resolveClass('model.' + param.get('className'));
		//trace(cl);
		if (cl == null)
		{
			trace('model.' + param.get('className') + ' ???');
			S.add2Response({error:' cannot find model.' + cast param.get('className')}, true);
			//return false;
		}
		var fl:Dynamic = Reflect.field(cl, '_create');
		//trace(fl);
		if (fl == null)
		{
			trace(cl + 'create is null');
			S.add2Response({error:cast cl + ' create is null'}, true);
		}
		var iFields:Array<String> = Type.getInstanceFields(cl);
		trace('$iFields ${param.get('action')}');
		if (iFields.has(param.get('action')))
		{
			trace('calling create ' + cl);
			Reflect.callMethod(cl, fl, [param]);
		}
		else 
		{
			trace('not calling create ');
			false;
		}
	}
	
	public static function paramExecute(stmt:PDOStatement, ?values:NativeArray):Bool
	{
		S.saveLog(values);
		if (!stmt.execute(values))
		{
			trace(stmt.errorInfo());
			return false;
		}
		return true;
	}
	
	public function count():Int
	{
		var sqlBf:StringBuf = new StringBuf();
		sqlBf.add('SELECT COUNT(*) AS count FROM ');

		if (tableNames.length>1)
		{
			sqlBf.add(buildJoin());
		}		
		else
		{
			trace(tableNames);
			trace('${tableNames[0]} ');
			sqlBf.add('${tableNames[0]} ');
		}
		if (filterSql != null)
		{
			sqlBf.add(filterSql);
		}
		var res:NativeArray = execute(sqlBf.toString());
		return Lib.hashOfAssociativeArray(res[0]).get('count');
		return Lib.hashOfAssociativeArray(execute(sqlBf.toString())[0]).get('count');
	}
	
	public function buildJoin():String
	{
		if (joinSql != null)
			return joinSql;
		var sqlBf:StringBuf = new StringBuf();				
		for (table in tableNames)
		{
			var tRel:Map<String,Dynamic> = dataSource.get(table);
			var alias:String = (tRel.exists('alias')? quoteIdent(tRel.get('alias')):'');
			var jCond:String = tRel.exists('jCond') ? tRel.get('jCond'):null;
			if (jCond != null)
			{
				if(~/\./.match(jCond))
				{
					var jParts = jCond.split('=');					
					trace(jParts.join('='));
					trace(jParts[0]);
					trace(jParts[1]);
					if(jParts[0].indexOf('.')>-1)
					{
						var dots = jParts[0].split('.');
						if(dots.length>2)
						{
							S.sendErrors(dbData,['invalidJoinCond'=>jCond]);
						}
						if(dots.length==2){
							jCond = '${quoteIdent(dots[0])}.${dots[1]}=${jParts[1]}';
						}
					}
					else {
						var dots = jParts[1].split('.');
						trace(dots);
						if(dots.length>2)
						{
							S.sendErrors(dbData,['invalidJoinCond'=>jCond]);
						}
						if(dots.length==2){
							jCond = '${jParts[0]}=${quoteIdent(dots[0])}.${dots[1]}';
						}						
					}
				}
				var jType:String = switch(tRel.get('jType'))
				{
					case JoinType.LEFT:
						'LEFT';
					case JoinType.RIGHT:
						'RIGHT';
					default:
						'INNER';
				}
				sqlBf.add('$jType JOIN ${quoteIdent(table)} $alias ON $jCond ');		
			}
			else
			{// FIRST TABLE
				sqlBf.add('${quoteIdent(table)} $alias ');
			}
		}
		joinSql = sqlBf.toString();
		return joinSql;
	}
	
	public function doSelect():NativeArray
	{	
		var sqlBf:StringBuf = new StringBuf();

		sqlBf.add('SELECT $queryFields FROM ');
		if (tableNames.length>1)
		{
			sqlBf.add(joinSql);
		}		
		else
		{
			sqlBf.add('${tableNames[0]} ');
		}
		if (filterSql != null)
		{
			sqlBf.add(filterSql);
		}		
		var groupParam:String = param.get('group');
		if (groupParam != null)
			buildGroup(groupParam, sqlBf);
		//TODO:HAVING
		var order:String = param.get('order');
		if (order != null)
			buildOrder(order, sqlBf);
		var limit:String = param.get('limit');
		buildLimit((limit == null?'150':limit), sqlBf);	//	TODO: CONFIG LIMIT DEFAULT
		return execute(sqlBf.toString());
		//return execute(sqlBf.toString(), q,filterValuess);
	}
	
	public function fieldFormat(fields:String):String
	{
		var fieldsWithFormat:Array<String> = new Array();
		var sF:Array<String> = fields.split(',');
		var dbQueryFormats:Map<String,Array<String>> = Lib.hashOfAssociativeArray(Lib.associativeArrayOfObject((S.conf.get('dbQueryFormats'))));
		trace(dbQueryFormats);
		
		var qKeys:Array<String> = new Array();
		var it:Iterator<String> = dbQueryFormats.keys(); 
		while (it.hasNext())
		{
			qKeys.push(it.next());
		}
	
		for (f in sF)
		{
			if (qKeys.has(f))
			{
				var format:Array<String> = dbQueryFormats.get(f);
				//trace(format);
				if (format[0] == 'ALIAS')
				fieldsWithFormat.push(S.dbh.quote( f ) + ' AS ' + format[1]);	
				else
				fieldsWithFormat.push(format[0] + '(' + S.dbh.quote(f) + ', "' + format[1] + '") AS `' + f + '`');
			}
			else
				fieldsWithFormat.push(S.dbh.quote( f ));				
		}
		//trace(fieldsWithFormat);
		return fieldsWithFormat.join(',');
	}
	
	public function show():Void
	{	
		var rData:RData =  {
			info:['count'=>count(),'page'=>(param.exists('page') ? Std.parseInt( param.get('page') ) : 1)],
			rows: doSelect()
		};
		S.sendData(dbData,rData);
	}
	
	public function execute(sql:String):NativeArray
	{
		trace(sql);	
		trace(setValues.join(','));
		var stmt:PDOStatement =  S.dbh.prepare(sql,Syntax.array(null));
		if (S.dbh.errorCode()!='00000')
		{
			trace(stmt.errorInfo());
			S.sendErrors(dbData, ['DB' => stmt.errorInfo]);
			return null;
		}		
		var bindTypes:String = '';
		var values2bind:NativeArray = null;
		//var dbFieldTypes:Map<String,String> =  Lib.hashOfAssociativeArray(Lib.associativeArrayOfObject(S.conf.get('dbFieldTypes')));
		//trace(filterValues);
		var data:NativeArray = null;
		var success: Bool;
		var i:Int = 0;
		if(setValues.length>0)
		{
			for (fV in setValues)
			{
				var type:Int = PDO.PARAM_STR; //dbFieldTypes.get(fV[0]);
				values2bind[i++] = fV;
				//if (!stmt.bindParam(i, fV[1], type))//TODO: CHECK POSTGRES DRIVER OPTIONS
				if (!stmt.bindValue(i, fV, type))//TODO: CHECK POSTGRES DRIVER OPTIONS
				{
					trace('ooops:' + stmt.errorInfo());
					Sys.exit(0);
				}
			}	
		}
		if(filterValues.length>0)
		{
			for (fV in filterValues)
			{
				var type:Int = PDO.PARAM_STR; //dbFieldTypes.get(fV[0]);
				values2bind[i++] = fV[1];
				//if (!stmt.bindParam(i, fV[1], type))//TODO: CHECK POSTGRES DRIVER OPTIONS
				if (!stmt.bindValue(i, fV[1], type))//TODO: CHECK POSTGRES DRIVER OPTIONS
				{
					trace('ooops:' + stmt.errorInfo());
					Sys.exit(0);
				}
			}	
		}		
		if(i>0)
		{
			success = stmt.execute(values2bind);
			if (!success)
			{
				trace(stmt.errorInfo());
				S.sendErrors(dbData,['execute' =>S.errorInfo(stmt.errorInfo())]);
			}
			dbData.dataInfo['count'] = stmt.rowCount();			
			trace('>>$action<<');
			if(action=='update'||action=='delete')
			{
				//EXIT
				trace('done');
				S.sendInfo(dbData);
			}
			if (dbData.dataInfo['count']>0)
			{
				data = stmt.fetchAll(PDO.FETCH_ASSOC);
			}			
			trace(Lib.toHaxeArray(data).join(','));		
			trace(stmt.errorInfo());
			return(data);		
		}
		else {
			success = stmt.execute(new NativeArray());
			if (!success)
			{
				trace(stmt.errorInfo());
				dbData.dataErrors = [
					'error' => S.errorInfo(stmt.errorInfo()),
					'sql'	=> sql
				];
				S.sendErrors(dbData);
				//return Syntax.assocDecl({'error': stmt.errorInfo()});
			}
			//var result:EitherType<MySQLi_Result,Bool> = stmt.get_result();
			num_rows = stmt.rowCount();
			if (num_rows>0)
			{
				data = stmt.fetchAll(PDO.FETCH_ASSOC);				
			}			
			trace(Std.string(data).substr(0,150));
			return(data);	
		}
		S.sendErrors(dbData, ['error'=> S.errorInfo(stmt.errorInfo())]);
		return null;
	}
	
	public  function query(sql:String, ?resultType):NativeArray
	{
		if (resultType == null)
			resultType = PDO.FETCH_ASSOC;
		var stm:PDOStatement = S.dbh.query(sql);
		if (! untyped stm)
		{
			trace(S.dbh.errorInfo());
			Sys.exit(0);
		}
		stm.execute(new NativeArray());
		if (stm.errorCode() != '00000')
		{
			trace(stm.errorCode());
			trace(stm.errorInfo());
			Sys.exit(0);
		}
		trace(stm);
		var res:NativeArray = stm.fetchAll(resultType);
		Syntax.foreach(res, function(key:String, value:Dynamic){
			trace('$key => $value'); 
			res[key] = value;
		});
		return res;
	}
	
	public function update():NativeArray
	{	
		var sqlBf:StringBuf = new StringBuf();
		trace(queryFields);
		sqlBf.add('UPDATE ');
		trace ('${tableNames.length} $joinSql');
		if (tableNames.length>1)
		{
			sqlBf.add(joinSql);
		}		
		else
		{
			sqlBf.add('${quoteIdent(tableNames[0])} ');
		}
		sqlBf.add(setSql);
		if (filterSql != null)
		{
			sqlBf.add(filterSql);
		}		
		//buildLimit((limit == null?'25':limit), sqlBf);	//	TODO: CONFIG LIMIT REQUIRES SUBSELECT ON UPDATE 
		trace(sqlBf.toString());
		//return null;
		return execute(sqlBf.toString());
	}

	public function delete():NativeArray
	{
		var sqlBf:StringBuf = new StringBuf();
		trace(queryFields);
		sqlBf.add('DELETE FROM ');
		if (tableNames.length>1)
		{
			S.sendErrors(dbData, ['error'=> S.errorInfo('Delete with join not supported!')]);
			return null;
		}		
		else
		{
			sqlBf.add('${quoteIdent(tableNames[0])} ');
		}
		if (filterSql != null)
		{
			sqlBf.add(filterSql);
		}	
		else 
		{
			S.sendErrors(dbData, ['error'=> S.errorInfo('Delete without Filter not supported!')]);
			return null;			
		}	
		trace(sqlBf.toString());
		return execute(sqlBf.toString());
	}

	public function create():NativeArray
	{
		var sqlBf:StringBuf = new StringBuf();
		trace(queryFields);
		sqlBf.add('INSERT INTO ');
		if (tableNames.length>1)
		{
			S.sendErrors(dbData, ['error'=> S.errorInfo('Create with join not supported!')]);
			return null;
		}		
		else
		{
			sqlBf.add('${quoteIdent(tableNames[0])} ');
		}
		sqlBf.add('($queryFields) VALUES${setSql} RETURNING id');
		if (filterSql != null)
		{
			sqlBf.add(filterSql);
		}		
		trace(sqlBf.toString());
		return execute(sqlBf.toString());
	}
	
	public function buildCond(filter:String):String
	{
		if (filter == null)		
		{
			return filterSql;			
		}
		var filters:Array<Dynamic> = filter.split(',');
		var	fBuf:StringBuf = new StringBuf();
		var first:Bool = true;
		filterValues = new Array();
		for (w in filters)
		{			
			//if(alias!=null)
				//fBuf.add(quoteIdent(alias))+'.';
			var wData:Array<String> = w.split('|');
			var dots = wData[0].split('.');
			if(dots.length>2)
			{
				S.sendErrors(dbData,['invalidFilter'=>S.errorInfo(wData[0])]);
			}

			var values:Array<String> = wData.slice(2);			
			
			if (first)
				fBuf.add(' WHERE ' );
			else
				fBuf.add(' AND ');
			first = false;			

			if(dots.length==2)
			{
				fBuf.add('${quoteIdent(dots[0])}.${quoteIdent(dots[1])}');
			}			
			else //no alias
				fBuf.add(quoteIdent(wData[0]));
			switch(wData[1].toUpperCase())
			{
				case 'BETWEEN':
					if (!(values.length == 2) && values.foreach(function(s:String) return s.any2bool()))
						S.exit( {error:'BETWEEN needs 2 values - got only:' + values.join(',')});
					
					fBuf.add(' BETWEEN ? AND ?');
					filterValues.push([dots[0], values[0]]);
					filterValues.push([dots[0], values[1]]);
				case 'IN':					
					fBuf.add(' IN(');
					fBuf.add( values.map(function(s:String) { 
						filterValues.push([dots[0], values.shift()]);
						return '?'; 
						} ).join(','));							
					fBuf.add(')');
				case 'LIKE':					
					fBuf.add(' LIKE ?');
					filterValues.push([dots[0], wData[2]]);
				case _:
					if (~/^(<|>)/.match(wData[1]))
					{
						var eR:EReg = ~/^(<|>)/;
						eR.match(wData[1]);
						var val = Std.parseFloat(eR.matchedRight());
						fBuf.add(eR.matched(0) + '?');
						filterValues.push([dots[0],val]);
						continue;
					}
					//PLAIN VALUES
					if( wData[1] == 'NULL' )
						fBuf.add(" IS NULL");
					else {
						fBuf.add(" = ?");
						filterValues.push([dots[0],wData[1]]);	
					}			
			}			
		}
		filterSql = fBuf.toString();
		return filterSql;
	}

	public function buildGroup(groupParam:String, sqlBf:StringBuf):Bool
	{
		//TODO: HANDLE expr|position
		var fields:Array<String> = groupParam.split(',');
		if (fields.length == 0)
			return false;
		sqlBf.add(' GROUP BY ');
		sqlBf.add(fields.map(function(g:String) return  quoteIdent(g)).join(','));
		return true;
	}
	
	public function buildOrder(orderParam:String, sqlBf:StringBuf):Bool
	{
		var fields:Array<String> = orderParam.split(',');
		if (fields.length == 0)
			return false;
		sqlBf.add(' ORDER BY ');
		sqlBf.add(fields.map(function(f:String)
		{
			var g:Array<String> = f.split('|');
			return  quoteIdent(g[0]) + ( g.length == 2 && g[1] == 'DESC'  ?  ' DESC' : '');
		}).join(','));
		return true;
	}

	public function buildSetWithDefaults(data:Dynamic, alias:String):String
	{
		trace(alias);
		return alias;
	}

	public function buildSet(tableName:String,data:Dynamic, alias:String):String
	{
		alias = alias!=null?'${quoteIdent(alias)}.':'';
		var defaults:Array<ColDef> = S.columnDefaults(tableName);
		trace(defaults[0]);		
		var set:Array<String> = new Array();		
		trace(Reflect.fields(data).join(','));
		for(col in defaults)
		{
			set.push('${alias}${col.column_name}=?');
			var val:String = Reflect.field(data,col.column_name);
			trace('$val / default:${col.column_default}');
			setValues.push(val==null?col.column_default:val);
		}
		trace( 'SET ${set.join(',')} ');
		return 'SET ${set.join(',')} ';
	}
	
	public function buildLimit(limitParam:String, sqlBf:StringBuf):Void
	{
		sqlBf.add(' LIMIT ' + (limitParam.indexOf(',') > -1 ? limitParam.split(',').map(function(s:String):Int return Std.parseInt(s)).join(',') 
			: Std.string(Std.parseInt(limitParam))));
	}
	
	function quoteIdent(f : String):String 
	{
		if ( ~/^([a-zA-Z_])[a-zA-Z0-9_]+$/.match(f))
		{
			return f;
		}
		
		return '"$f"';
	}	
	
	function row2jsonb(row:Dynamic):String
	{
		var _jsonb_array_text:StringBuf = new StringBuf();
		for (f in Reflect.fields(row))
		{
			//trace('$f: ${Reflect.field(row, f)}');
			var val:Dynamic = Reflect.field(row, f);
			if (val == null)
			{
				//trace(null);
				val = '""';
			}
			else if (val == '')
			{
				//trace("''");
				val = '""';
			}
			var _comma:String = _jsonb_array_text.length > 2?',':'';
			_jsonb_array_text.add('$_comma$f,$val');
		}
		return _jsonb_array_text.toString();
	}

	public static function binary(param:Bytes)
	{
		param = Bytes.ofString(Web.getPostData());
		var d:DbData = new DbData();
		trace(param);
		var s:Serializer = new Serializer();
		trace(s.unserialize(param, DbData));
	}
	
	public function new(?param:Map<String,String>) 
	{
		this.param = param;
		trace(param);
		action = param.get('action');
		data = {};
		data.rows = new NativeArray();
		dbData = new DbData();
		filterSql = '';
		filterValues = new Array();
		setValues = new Array();
		queryFields = setSql = '';
		tableNames = new Array();
		trace('exists dbData:' + (param.exists('dbData')?'Y':'N'));
		if(param.exists('dbData'))
		{
			trace(param.get('dbData'));
			trace(Bytes.ofString(param.get('dbData')));
			var s:Serializer = new Serializer();			
			dParam = s.unserialize(Bytes.ofString(param.get('dbData')),DbData);
			dataSource = dParam.dataParams;
			trace(dataSource.toString());
		}
		else 
		{
			if(param.exists('table'))
				table = param.get('table');
			if(table != null)
			{
				fieldNames = param.exists('fields')? 
					param.get('fields').split(',').map(function (f)return quoteIdent(f)): 
					S.tableFields(table).map(function (f)return quoteIdent(f));
				tableNames = [table];
				queryFields = fieldNames.join(',');
				trace(tableNames);
			}
			else
				tableNames = [];
			var fields:Array<String> = [];
			if(param.get('dataSource') != null)
			{
				dataSource = Unserializer.run(param.get('dataSource'));	
			}
		}
		var fields:Array<String> = [];
		if(dataSource != null)
		{
			var tKeys:Iterator<String> = dataSource.keys();
			while(tKeys.hasNext())
			{
				var tableName = tKeys.next();
				tableNames.push(tableName);
				var tableProps = dataSource.get(tableName);
				trace(tableProps.toString());
				if(action == 'update')
				{
					setSql += buildSet(tableName, tableProps.get('data'), tableProps.get('alias'));
				}
				fields = fields.concat(buildFieldsSql(tableName, tableProps));
				if(action == 'create')
				{
					fields.remove('id');
					fieldNames = fields;
					buildValues(tableProps.get('data'));
					setSql = fields.map(function (_)return '?').join(',');
					setSql = '($setSql)';
				}
				if(tableProps.exists('filter'))
					filterSql += buildCond(tableProps.get('filter'));
				trace('filterSql:$filterSql::${}');
			}			
			queryFields += fields.length > 0 ? fields.join(','):'';
		}		
		trace('${param.get('action')}:' + tableNames.toString());
		trace(queryFields);
		trace(setSql);
		if (tableNames.length>1)
		{
			joinSql = buildJoin();
		}			
		if(param.exists('filter'))
			filterSql += buildCond(param.get('filter'));
	}
	
	function buildFieldsSql(name:String, tParam:Map<String,Dynamic>):Array<String>
	{
		var prefix = (tParam.exists('alias')?quoteIdent(tParam.get('alias'))+'.':'');
		trace(prefix);
		if (tParam.exists('fields'))
		{
			return tParam.get('fields').split(',').map(function(field) return '${prefix}${quoteIdent(field)}');
		}
		return S.tableFields(name).map(function(field) return '${prefix}${quoteIdent(field)}');
	}

	function buildValues(data:Dynamic):Void
	{
		//var fields:Array<String> = [];
		for(key in fieldNames)
		{
			var val:String = Reflect.field(data,key);
			setValues.push(val==''? 'DEFAULT':val);
		}		
		//return fields;
	}
	
	public function json_encode():Void
	{	
		//data.user_name = S.user_name;
		data.user_id = S.user_id;
		data.globals = globals;
		S.add2Response({data:data});
	}
	
	public function json_response(res:String):String
	{
		return Syntax.code("json_encode({0},{1})", {content:res}, 64);//JSON_UNESCAPED_SLASHES
	}
	
	function getEditorFields(?table_name:String):Map<String,Array<Map<String,String>>>
	{
		var sqlBf:StringBuf = new StringBuf();
		var filterValues:Array<Array<Dynamic>> = new Array();
		var param:Map<String,String> = new Map();
		param.set('table', 'fly_crm.editor_fields');
		
		param.set('filter', 'field_cost|>-2' + (table_name != null ? 
		',table_name|' + quoteIdent(table_name): ''));
		param.set('fields', 'field_name,field_label,field_type,field_options,table_name');
		param.set('order', 'table_name,field_rank,field_order');
		param.set('limit', '100');
		//trace(param);
		var eFields:Array<Dynamic> = Lib.toHaxeArray( doSelect());
		//var eFields:NativeArray = doSelect(param, sqlBffilterValueses);
		//var eFields:Dynamic = doSelect(param, sqlBffilterValueses);
		//trace(eFields);
		//trace(eFields.length);
		var ret:Map<String,Array<Map<String,String>>> = new Map();
		//var ret:Array<Map<String,String>> = new Array();
		for (ef in eFields)
		{
			var table:String = untyped ef['table_name'];
			if (!ret.exists(table))
			{
				ret.set(table, []);
			}
			//var field:Map<String,String> = Lib.hashOfAssociativeArray(ef);
			//trace(field.get('field_label')+ ':' + field);
			var a:Array<Map<String,String>> = ret.get(table);
			a.push(Lib.hashOfAssociativeArray(ef));
			ret.set(table, a);
			//return ret;
		}
		//trace(ret);
		return ret;
	}
	
	function serializeRows(rows:NativeArray):Bytes
	{
		var s:Serializer = new Serializer();
		Syntax.foreach(rows, function(k:Int, v:Dynamic)
		{
			dbData.dataRows.push(Lib.hashOfAssociativeArray(v));
		});
		trace(dbData);
		return s.serialize(dbData);
	}
	
	function sendRows(rows:NativeArray):Bool
	{
		var s:Serializer = new Serializer();
		
		Syntax.foreach(rows, function(k:Int, v:Dynamic)
		{
			dbData.dataRows.push(Lib.hashOfAssociativeArray(v));			
		});
		Web.setHeader('Content-Type', 'text/html charset=utf-8');
		Web.setHeader("Access-Control-Allow-Headers", "access-control-allow-headers, access-control-allow-methods, access-control-allow-origin");
		Web.setHeader("Access-Control-Allow-Credentials", "true");
		Web.setHeader("Access-Control-Allow-Origin", 'https://${S.devIP}:9000');
		var out = File.write("php://output", true);
		out.bigEndian = true;
		out.write(s.serialize(dbData));
		Sys.exit(0);
		return true;
	}
}