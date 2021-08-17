package shared;

import comments.CommentString.*;
import php.NativeArray;

class DB {
	public static function getFieldTypes(table:String):NativeArray {
		var sql:String = comment(unindent, format) /* SELECT a.attname,
		pg_catalog.format_type(a.atttypid, a.atttypmod),
		(SELECT substring(pg_catalog.pg_get_expr(d.adbin, d.adrelid) for 128) AS default
		 FROM pg_catalog.pg_attrdef d
		 WHERE d.adrelid = a.attrelid AND d.adnum = a.attnum AND a.atthasdef),
		a.attnotnull, a.attnum
	  FROM pg_catalog.pg_attribute a
	  WHERE a.attrelid = (SELECT c.oid 
		FROM pg_catalog.pg_class c
		LEFT JOIN pg_catalog.pg_namespace n ON n.oid = c.relnamespace
		WHERE c.relkind IN ('r','p','s','')
		AND n.nspname = 'crm' 
	   and  c.relname='$table'
		) AND a.attnum > 0 AND NOT a.attisdropped
	  ORDER BY a.attnum;
	  */;
	  return null;
	}
}