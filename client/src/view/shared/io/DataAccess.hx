package view.shared.io;

/**
 * ...
 * @author axel@cunity.me
 */

import data.DataState.DBQueryParam;
import haxe.ds.Map;

import view.shared.FormField;

typedef BaseView = Map<String,BaseField>;

/**
   keys = tablenames[?'alias',?'fields',?'jCond',?'filter']:String
**/


/**
 * Map data display|usage keys to array of DB Query Parameters
 */
 typedef DBJoinParams = Array<DBQueryParam>;

/**
 * Map data display keys to map of column names or alias => values (Result from DataState)
 */
 typedef DataSource = Map<String,Map<String,Dynamic>>;
 
   
/**
 * Map column name or alias to FormField
 */
typedef DataDisplay = Map<String,FormField>;

/**
 * Associates DataSource and DataDisplay where each key in DataDisplay has to exist in DataQuery keys
 */
typedef DataRelation =
{
	?gridCSSClass:String,
	source:DataSource,
	view:DataDisplay	
}
   
typedef DataAccess = Map<String,DataRelation>;

