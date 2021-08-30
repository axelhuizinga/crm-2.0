package view.grid;

import react.router.RouterLocation;
import react.router.RouterHistory;
import react.router.RouterMatch;
import js.html.Element;
import haxe.Timer;
import haxe.ds.IntMap;
import haxe.extern.EitherType;
import js.html.Event;
import haxe.Constraints.Function;
import data.DataState;

typedef DataCellPos =
{
	column:Int,
	row:Int
}

typedef DataCell =
{
	@:optional var cellFormat:Function;
	@:optional var className:String;
	@:optional var data:Dynamic;// CELL CONTENT VALUE
	@:optional var dataDisplay:Dynamic;// CELL CONTENT DISPLAY VALUE
	@:optional var dataType:Dynamic;// CELL CONTENT VALUE TYPE
	@:optional var name:String;
	var id:Int;
	@:optional var pos:DataCellPos;
	@:optional var show:Bool;
	@:value(true)
	@:optional var style:Dynamic;
	@:optional var title:String;
	@:optional var flexGrow:Int;
}

typedef Size =
{
	?height:Int,
	?width:Int
}

typedef GridProps =
{
	?className:String,
	data:Array<Dynamic>,
	dataState:DataState,
	?disableHeader:Bool,
	?doubleClickAction:String,
	?oddClassName: String,
	?evenClassName:String,	
	?defaultSort:Dynamic,	
	?defaultSortDescending:Bool,
	?fullWidth:Bool,
	?filterable:Dynamic,
	?itemsPerPage:Int,
	?id:String,
	?location:RouterLocation,
	?match:RouterMatch,
	?history:RouterHistory,	
	?findBy:String,
	?title:String,
	?onFilter:String->Void,
	?onPageChange:SortProps->Void,	
	?onDoubleClick:Event->Void,
	?onSort:Int->Void,
	?parentComponent:Dynamic,
	?readOnly:Bool,
	?sortable:EitherType<Bool, Array<EitherType<String,Dynamic>>>
}

typedef GridState =
{
	?enteredRow:Int,
	?selectedRow:Int,
	?selectedRows:IntMap<Bool>,
	?selectTimer:Timer,
	?_rowCells:Array<Element>,
	?_prevent:Bool,
	?_selecting:Bool,
	?_selectedCells:Array<Element>,
}
