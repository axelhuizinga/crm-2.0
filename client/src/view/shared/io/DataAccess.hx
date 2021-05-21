package view.shared.io;

/**
 * ...
 * @author axel@cunity.me
 */

import haxe.ds.Map;

import view.shared.FormField;

typedef BaseView = Map<String,BaseField>;

/**
   keys = tablenames[?'alias',?'fields',?'jCond',?'filter']:String
**/
   
typedef DataSource = Map<String,Map<String,Dynamic>>;
   
typedef DataView = Map<String,FormField>;

typedef DataRelation =
{
	source:DataSource,
	view:DataView	
}
   
typedef DataAccess = Map<String,DataRelation>;

