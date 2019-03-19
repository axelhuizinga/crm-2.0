package view.table;

import js.Browser;
import haxe.Constraints.Function;
import haxe.Timer;
import haxe.ds.Map;
import haxe.extern.EitherType;
import js.html.DOMRect;
import js.html.Element;
import js.html.HTMLCollection;
import js.html.MouseEvent;
import js.html.Node;
import js.html.NodeList;
import js.html.TableCellElement;
import js.html.TableElement;
import js.html.TableRowElement;
import js.html.DivElement;
import me.cunity.debug.Out;
import react.React;
import react.ReactRef;
import react.ReactComponent.ReactFragment;
import react.ReactComponent;
import react.ReactComponent.*;
import react.ReactMacro.jsx;
import shared.Utils;

import view.shared.FormState;
import view.shared.io.FormApi;
import view.shared.OneOf;
using Lambda;

/**
 * ...
 * @author axel@cunity.me
 */

typedef DataState =
{
	?altGroupPos:Int,
	columns:Map<String,DataColumn>,
	?defaultSearch:Map<String,DataColumn>,
	?search:Map<String,DataColumn>
}

typedef DataColumn = 
{
	@:optional var dbFormat:Function;
	@:optional var cellFormat:Function;
	@:optional var className:String;
	@:optional var editable:Bool;
	@:optional var flexGrow:Int;
	@:optional var headerClassName:String;
	@:optional var headerFormat:Function;
	@:optional var headerStyle:Dynamic;
	@:optional var label:String;
	@:optional var name:String;
	@:optional var title:String;
	@:optional var search:SortDirection;
	@:optional var show:Bool;
	@:optional var style:Dynamic;
}

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
	@:optional var id:String;
	@:optional var pos:DataCellPos;
	@:value(true)
	@:optional var show:Bool;
	@:optional var style:Dynamic;
	@:optional var title:String;
	@:optional var flexGrow:Int;
}

typedef Size =
{
	?height:Int,
	?width:Int
}

@:enum
abstract SortDirection(String){
	var ASC = 'ASC';
	var DESC = 'DESC';
	var NONE = '';
}

typedef SortProps =
{
	column:String,
	direction:SortDirection
}

typedef TableProps =
{
	?className:String,
	data:Array<Map<String,Dynamic>>,
	dataState:DataState,
	?disableHeader:Bool,
	?oddClassName: String,
  	?evenClassName:String,	
	?defaultSort:Dynamic,
	?defaultSortDescending:Bool,
	?filterable:Dynamic,
	?fullWidth:Bool,
	?id:String,
	?itemsPerPage:Int,
	?isConnected:Bool,
	?onFilter:String->Void,
	?onPageChange:SortProps->Void,
	?onSort:Int->Void,
	?pageButtonLimit:Int,
	//?parentForm:DataAccessForm,
	?primary:String,//defaults to 'id'
	?sortable:EitherType<Bool, Array<EitherType<String,Dynamic>>>,
	//?setStateFromChild:FormState->Void,
}

typedef TableState =
{
	?enteredRow:Int,
	?selectedRow:Int,
	?selectedRows:Array<TableRowElement>,
	?_rowCells:Array<Element>,
	?_selectedCells:Array<Element>,
	?_isSelected:Bool
}

class Table extends ReactComponentOf<TableProps, TableState>
{
	var fieldNames:Array<String>;
	var tableRef:ReactRef<TableElement>;
	var fixedHeader:ReactRef<DivElement>;
	var rowRef:ReactRef<TableRowElement>;
	var tHeadRef:ReactRef<TableRowElement>;
	var visibleColumns:Int;
	var headerUpdated:Bool;
	var _timer:Timer;
	
	public function new(?props:TableProps)
	{
		super(props);		
		headerUpdated = false;
		fieldNames = [];
		for (k in props.dataState.columns.keys())
		{
			//trace(k);
			fieldNames.push(k);
		}	
		trace(fieldNames);
		state = {selectedRows:[]};
	}
	
	override public function render():ReactFragment
	{
		if(props.data != null)
		trace(props.data.length);
		trace(props.className);
		if (props.data == null || props.data.length == 0)
		{
			return jsx('
			<section className="hero is-alt" style={{flexGrow:1}}>
	<div className="hero-body" style={{flexGrow:0}}>
			  <div className="loader"  style=${{width:'6rem', height:'6rem', margin:'auto', borderWidth:'0.64rem', alignSelf:'center'}}/>
			  </div>
			</section>
			');					
		}		
		//trace(props.data);
		tableRef = React.createRef();
		fixedHeader = React.createRef();
		tHeadRef = React.createRef();
		rowRef = React.createRef();
		return jsx('		
			<div className="fixed-grid-container" >
				<div className="header-background" >
					<table className="table head">
						<thead>
							<tr ref={fixedHeader}>
								${renderHeaderDisplay()}
							</tr>
						</thead>
					</table>				
				</div>				
				<div className="grid-container-inner">							
					<table className=${"table " + props.className} ref={tableRef}>
						<thead>
							<tr ref=${tHeadRef}>
								${renderHeaderRow()}
							</tr>
						</thead>
						<tbody>
							${renderRows()}
						</tbody>
					</table>
				</div>
				<div className="pager">
				</div>
			</div>
		');		
	}
			
	/**
	   @return
	**/

	function renderHeaderRow():ReactFragment
	{
		if(props.dataState==null)
			return null;
		//trace(props.dataState.columns.keys());
		var headerRow:Array<ReactFragment> = [];
		for (field in props.dataState.columns.keys())
		{
			var hC:DataColumn = props.dataState.columns.get(field);
			if (hC.show == false)
				continue;
			//trace(hC);
			headerRow.push(jsx('	
			<th key={field}>
				<div  className={"th-box " + (hC.headerClassName != null? hC.headerClassName :hC.className)}>
				{hC.label != null? hC.label : hC.name}<span className="sort-box fa fa-sort"></span>
				</div>
			</th>
			'));
		}
		trace(headerRow.length);
		return headerRow;
	}	
	
	function renderHeaderDisplay():ReactFragment
	{
		if(props.dataState==null)
			return null;
		//trace(props.dataState.columns.keys());
		var headerRow:Array<ReactFragment> = [];
		for (field in props.dataState.columns.keys())
		{
			var hC:DataColumn = props.dataState.columns.get(field);
			if (hC.show == false)
				continue;
			visibleColumns++;	
			headerRow.push(jsx('	
			<th key={field}>
			<div  className={"th-box " + (hC.headerClassName != null? hC.headerClassName :hC.className)}>
			{hC.label != null? hC.label : hC.name}<span className="sort-box fa fa-sort"></span>
			</div>
			</th>
			'));
		}
		return headerRow;
	}	

	function renderCells(rdMap:Map<String,Dynamic>, row:Int):ReactFragment
	{
		//trace(rdMap);
		//trace(rdMap.remove('primary'));
		//trace(rdMap['use_as_index']);
		var column:Int = 0;
		var cells:Array<DataCell> = fieldNames.map(function(fN:String){
			var columnDataState:DataColumn = props.dataState.columns.get(fN);
			//trace(columnDataState.cellFormat != null ? fN:'');
			var cD:DataCell = {
				cellFormat:columnDataState.cellFormat,
				className:columnDataState.className,
				data:rdMap[fN],
				dataDisplay:columnDataState.cellFormat != null ? columnDataState.cellFormat(rdMap[fN]):rdMap[fN],
				flexGrow:columnDataState.flexGrow,
				name:fN,
				pos:{column:column++, row:row},
				show:columnDataState.show != false
			};
			return cD;					
		});
		var rCs:Array<ReactFragment> = [];
		for (cD in cells)
		{
			if (!cD.show)
			 continue;//!=null?cD.flexGrow:null
			rCs.push(
			jsx('<td className=${cD.className} data-name=${cD.name} key=${"r"+cD.pos.row+"c"+cD.pos.column} data-grow=${cD.flexGrow}>
				${cD.dataDisplay}
			</td>'));
		}
		return rCs;
	}
	
	function renderRows(?dRows:Array<Map<String,Dynamic>>):ReactFragment
	{
		if (dRows == null)
			dRows = props.data;
		var dRs:Array<ReactFragment> = [];
		var row:Int = 0;
		var primary:String = (props.primary!=null && props.primary.length > 0?props.primary:'id');
		for (dR in dRows)
		{			
			var id:String = (dR.exists(primary)? '${dR.get(primary)}':'');
			if (row == 1)
			{
				//trace(dR);
				trace('<tr data-id=${id}< ke..');
			}
				
			dRs.push(
			jsx('<tr data-id=${id} title=${id} key=${"r"+row} ref=${row==0?rowRef:null} onClick={select}>
				${renderCells(dR, row++)}				
			</tr>'));
		}//
		trace(dRs.length);
		return dRs;
	}
	
	public function select(mEv:MouseEvent)
	{
		trace(mEv.altKey);
		trace(mEv.currentTarget);
		var htRow:TableRowElement = cast(mEv.currentTarget, TableRowElement);
		var rows:HTMLCollection = htRow.parentElement.children;
		if (mEv.altKey)
		{
			selectAltGroup(props.dataState.altGroupPos, htRow);
		}
		else if (mEv.ctrlKey)
		{			
			for (r in rows)
				r.classList.toggle('is-selected');
		}
		else 
			htRow.classList.toggle('is-selected');
		var selRows:Array<TableRowElement> = new Array();
		for (r in rows)
		{
			if (r.classList.contains('is-selected'))
				selRows.push(cast r);
		}
		setState({selectedRows:selRows});
		//props.parentForm.setStateFromChild({selectedRows:selRows});
	}
	
	function selectAltGroup(altGroupPos:Int, cRow:TableRowElement):Void
	{
		var groupName:String = cRow.cells.item(altGroupPos).textContent;
		var tEl:TableElement = cast cRow.parentElement;
		for (i in 0...tEl.children.length)
		{
			var row:TableRowElement = cast tEl.children.item(i);
			trace(row.cells.item(altGroupPos).nodeValue + '==' + groupName);
			if(row.cells.item(altGroupPos).textContent==groupName)
				row.classList.toggle('is-selected');
		}
		
	}

	function selectedRowsMap():Array<Map<String,String>>
	{
		return [for (r in state.selectedRows) selectedRowMap(r)];
	}
	
	function selectedRowMap(row:TableRowElement):Map<String,String>
	{
		var rM:Map<String,String> = [
			for (c in row.cells)
				c.dataset.name => c.innerHTML
		];
		rM['id'] = row.dataset.id;
		return rM;
	}

	public function layOut():Void
	{
		trace('firstCall: $headerUpdated $tHeadRef: ${tHeadRef != null && tHeadRef.current != null}');
		//return;
		if(tHeadRef == null || tHeadRef.current == null)
		{
			trace('$tHeadRef: ${tHeadRef != null && tHeadRef.current != null}');
			if(_timer != null)
				return;
			_timer = App.await(250,function() return tHeadRef != null && tHeadRef.current != null, layOut);
			return;
		}
			
		headerUpdated = true;			
		//var tableHeight:Float = tableRef.current.clientHeight;
		var scrollBarWidth:Float = App.config.getScrollbarWidth();
		var freeWidth:Float = tableRef.current.parentElement.offsetWidth - tableRef.current.offsetWidth - scrollBarWidth;
		//tableRef.current.setAttribute('style','margin-top:${tHeadRef.current.offsetHeight*-1}px');
		trace(tableRef.current.offsetHeight);
		tHeadRef.current.style.visibility = "collapse";						
		trace(tableRef.current.offsetHeight);
		//trace(tHeadRef.current.nodeName + ':' + tHeadRef.current.style.visibility);						
		var i:Int = 0;
		var grow:Array<Int> = [];
		if (props.fullWidth)
		{
			for (cell in rowRef.current.children)
			{
				var cGrow = cell.getAttribute('data-grow');
				if (cGrow != null)
				{
					grow[i] = Std.parseInt(cGrow);
					//trace(grow[i]);
				}
				i++;
			}		
			var growSum:Int = 0;
			grow.iter(function(el) growSum += (el==null?0:el));
			trace (grow +':' + growSum );
			if (growSum > 0)
			{
				var growUnit:Float = freeWidth / growSum;
				//trace(growSum);		
				for (i in 0...grow.length)
				{
					if (grow[i] != null && grow[i] !=0)
					{
						//trace(grow[i] * growUnit + rowRef.current.children.item(i).offsetWidth);
						trace('$i ${grow[i]} * $growUnit + ${rowRef.current.children.item(i).offsetWidth}');
						rowRef.current.children.item(i).setAttribute(
							'width', Std.string(grow[i] * growUnit + rowRef.current.children.item(i).offsetWidth) + 'px'
						);
					}
				}					
			}			
		}
		i = 0;
		for (cell in tHeadRef.current.children)
		{
			var w:Int = cell.offsetWidth;
			trace(w +':' + cell.clientWidth);
			var fixedHeaderCell = cast(fixedHeader.current.childNodes[i],Element);
			fixedHeaderCell.setAttribute('style', 'width:${w}px');
			i++;
		}
	}
	
	override function componentDidMount()//,snapshot:Dynamic
	{
		App.onResizeComponents.add(this);
		Browser.window.requestAnimationFrame(function (t:Float)
		{
			trace(t);
			layOut();
		});
	}

	override function componentDidUpdate(prevProps:Dynamic, prevState:Dynamic)//,snapshot:Dynamic
	{
		trace(headerUpdated + ':' + tHeadRef); 

		if (tHeadRef != null)
		{
			if (headerUpdated)
				return;
			
			//showDims(tHeadRef);
			//nodeDims(fixedHeader.current);
		}
	}

	override public function componentWillUnmount():Void 
	{
		trace('leaving...');
		if(_timer != null)
			_timer.stop();
		App.onResizeComponents.remove(this);
	}
	
	function showDims(ref:Dynamic)
	{
		var i:Int = 0;
		var s:Float = 0;
		var cells:Array<TableCellElement> = (ref.current != null? ref.current.cells : ref.cells);
		for (cell in cells)
		{
			trace(untyped cell.getBoundingClientRect().toJSON());
			s += cell.getBoundingClientRect().width;
		}
		trace(' sum:$s');
	}

	function nodeDims(n:Node)
	{
		var i:Int = 0;
		var s:Float = 0;
		var cells:NodeList = n.childNodes;
		for (cell in cells)
		{
			var dRect:DOMRect = untyped cast(cell, Element).getBoundingClientRect().toJSON();
			trace(dRect);
			//Out.dumpObject(cast(cell, Element).getBoundingClientRect());
			s += cast(cell, Element).getBoundingClientRect().width;
		}
		trace(' sum:$s');
	}
	
}

	/*function createColumns():ReactFragment
	{
		if(state.data.length>0)
			trace(Reflect.fields(state.data[0]));
		trace(Reflect.fields(props.headerColumns));
		var cols:Array<ReactFragment> = [];
		for (field in props.headerColumns.keys())
		{
			var hC:DataCell = props.headerColumns.get(field);
			cols.push(jsx('	
				<Column
					label=${field.substr(0, 1).toUpperCase() + field.substr(1).toLowerCase()}
					dataKey={field}
					key={field}
					width = {122}
					className = {hC.className}
					flexGrow = {hC.flexGrow}
				/>
				')
			);
		}
		return cols;
	}*/