package view.shared.io;

/**
 * ...
 * @author axel@cunity.me
 */

import haxe.ds.Map;

import view.shared.FormField;

/**
   dataClassPath=><action>=>[?'alias',?'fields',?'jCond'] each=>String
**/
   
typedef DataSource = Map<String,Map<String,String>>;

/**
   fieldName=>FormField
**/
   
typedef DataView = Map<String,FormField>;

typedef DataRelation =
{
	source:DataSource,
	view:DataView	
}

/**
   viewClassPath=>DataRelation
**/
   
typedef DataAccess = Map<String,DataRelation>;

