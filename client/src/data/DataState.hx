package data;

import view.shared.FormField;
import haxe.Constraints.Function;

typedef DataColumn = 
{
	?alias:String,
	?altGroupPos:Int,
	?dbFormat:Function,
	?cellFormat:Function,
	?className:Dynamic,
	?editable:Bool,
	?flexGrow:Int,
	?headerClassName:String,
	?headerFormat:Function,
	?headerStyle:Dynamic,
	?label:String,
	?name:String,	
	?title:String,
	?search:SortDirection,
	?searchField:FormField,
	?show:Bool,	
	?showSearch:Bool,
	?style:Dynamic,
	?useAsIndex:Bool,
	?useInTooltip:Int,//-1 = not, n = position
}

typedef DataJoin = {
	?alias:String,	
	columns:Map<String,DataColumn>,
	?db:String,
	?on:String,
	table:String,
}

typedef DataState =
{
	?altGroupPos:Int,
	columns:Map<String,DataColumn>,
	?defaultSearch:Map<String,DataColumn>,
	?joins:Array<DataJoin>,
	?tableAlias:String,
	?table:String,	
	?search:Map<String,DataColumn>
}

@:enum
abstract SortDirection(String){
	var ASC;// = 'ASC';
	var DESC;// = 'DESC';
	var NONE;// = '';
}

typedef SortProps =
{
	column:String,
	direction:SortDirection
}