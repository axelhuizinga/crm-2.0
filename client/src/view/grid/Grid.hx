package view.grid;

import haxe.ds.IntMap;
import js.Browser;
import haxe.Constraints.Function;
import haxe.Timer;
import haxe.ds.StringMap;
import haxe.extern.EitherType;
import js.html.DOMRect;
import js.html.DOMRectList;
import js.html.Element;
import js.html.Event;
import js.html.MouseEvent;
import js.html.Node;
import js.html.NodeList;
import js.html.TableCellElement;
import js.html.TableElement;
import js.html.TableRowElement;
import js.html.DivElement;
import me.cunity.debug.Out;
import react.React;
import react.ReactEvent;
import react.ReactRef;
import react.ReactComponent.ReactFragment;
import react.ReactComponent;
import react.ReactComponent.*;
import react.ReactMacro.jsx;
import shared.Utils;

/**
 * ...
 * @author axel@cunity.me
 */

typedef DataState =
{
	columns:StringMap<DataColumn>,
	?defaultSearch:StringMap<DataColumn>,
	?search:StringMap<DataColumn>
}

typedef DataColumn = 
{
	@:optional var cellFormat:Function;
	@:value('')
	@:optional var className:String;
	@:optional var displayFormat:String;
	@:optional var editable:Bool;
	@:optional var flexGrow:Int;
	@:value('')
	@:optional var headerClassName:String;
	@:optional var headerFormat:Function;
	@:optional var headerStyle:Dynamic;
	@:optional var label:String;
	@:optional var name:String;
	@:optional var search:SortDirection;
	@:value(true)
	@:optional var show:Bool;
	@:optional var useAsIndex:Bool;
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
	@:optional var id:Int;
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

typedef GridProps =
{
	?className:String,
	data:Array<Dynamic>,
	dataState:DataState,
	?disableHeader:Bool,
	?oddClassName: String,
    ?evenClassName:String,	
	?defaultSort:Dynamic,	
	?defaultSortDescending:Bool,
	?fullWidth:Bool,
	?filterable:Dynamic,
	?id:String,
	?itemsPerPage:Int,
	?onFilter:String->Void,
	?onPageChange:SortProps->Void,
	?onSort:Int->Void,
	?parentComponent:Dynamic,
	?sortable:EitherType<Bool, Array<EitherType<String,Dynamic>>>
}

typedef GridState =
{
	?enteredRow:Int,
	?selectedRow:Int,
	?selectedRows:IntMap<Bool>,
	?_rowCells:Array<Element>,
	?_selectedCells:Array<Element>,
	?_selecting:Bool
}

class Grid extends ReactComponentOf<GridProps, GridState>
{
	var fieldNames:Array<String>;
	var gridRef:ReactRef<DivElement>;
	var headerRef:ReactRef<DivElement>;
	var gridStyle:String;
	var visibleColumns:Int;
	var headerUpdated:Bool;
	
	public function new(?props:GridProps)
	{
		super(props);		
		headerUpdated = false;
		visibleColumns = 0;
		fieldNames = [];
		for (k in props.dataState.columns.keys())
		{
			//trace(k);
			fieldNames.push(k);
		}	
		trace(fieldNames);
		state = {
			_selecting:false,
			selectedRow:null,
			selectedRows:new IntMap(),
			_rowCells:[],
			_selectedCells:[]
		}
	}
	
	override public function render():ReactFragment
	{
		if(props.data != null)
		trace(props.data.length);
		trace(props.className);
		
		if (props.data == null || props.data.length == 0)
		{
			return jsx('
			<section className="hero is-alt">
			  <div className="hero-body">
			  <div className="loader"  style=${{width:'3rem', height:'3rem', margin:'auto', borderWidth:'0.58rem'}}/>
			  </div>
			</section>
			');					
		}		
		//className="${props.className} sort-decoration"
		//return jsx('<div>1</div>');
		gridRef = React.createRef();
		headerRef = React.createRef();
		//renderRows();
		//var rows:ReactFragment = jsx('<div>1</div>');// ${renderHeaderDisplay()}		
		var headerRows:ReactFragment = renderHeaderDisplay();
		//return headerRows;
		//var rows:ReactFragment = renderHeaderDisplay();
		trace(gridStyle);
		//return rows; style="{{grid-template-columns:$gridStyle}}"
		return jsx('		
			<div className="grid-container" ref=${gridRef}>			
					${headerRows}
					${renderRows()}
			</div>					
		');		
	}
			
	/**
	   
	${renderHeaderRow()}
	   @return
	**/

	/*function renderHeaderRow():ReactFragment
	{
		if(props.dataState==null)
			return null;
		//trace(props.dataState.columns.keys());
		var headerRow:Array<ReactFragment> = [];
		var col:Int = 0;
		gridStyle = '';
		for (field in props.dataState.columns.keys())
		{
			var hC:DataColumn = props.dataState.columns.get(field);
			if (hC.show == false)
				continue;
			//' auto';//
			gridStyle +=  (hC.flexGrow == 1?' 1fr':' auto');
			if (col == 0)
				trace('${hC.headerClassName} :${hC.className}');
			headerRow.push(jsx('	
			<div key={field} 
				className= ${"gridHeadItem "+(hC.headerClassName != null? hC.headerClassName :
					(hC.className!=null?hC.className:''))}
				ref=${col==0?gridHead:null}>
				{hC.label != null? hC.label : hC.name}<span className="sort-box fa fa-sort"></span>
			</div>
			'));
			col++;
		}
		trace(headerRow.length);
		return headerRow;
	}*/
	
	function renderHeaderDisplay():ReactFragment
	{
		if(props.dataState==null)
			return null;
		var headerRow:Array<ReactFragment> = [];
		//var headerRow:String = '';
		//trace(props.dataState.columns.keys());
		gridStyle = '';
		for (field in props.dataState.columns.keys())
		{
			var hC:DataColumn = props.dataState.columns.get(field);
			if (hC.show == false)
				continue;
			visibleColumns++;
			gridStyle +=  (hC.flexGrow !=null ?' ${hC.flexGrow}fr':' max-content');
			headerRow.push(jsx('	
			<div key={field} className=${"gridHeadItem " + (hC.headerClassName != null? hC.headerClassName :hC.className)}>
			${hC.label != null? hC.label : hC.name}<span className="sort-box fa fa-sort"></span>
			</div>
			'));
		}
		return headerRow;
	}	

	function renderCells(rdMap:Map<String,Dynamic>, row:Int):ReactFragment
	{
		//@:arrayAccess
		//trace(rD);
		//var rdMap:Map<String,Dynamic> = Utils.dynaMap(rD);
		trace(fieldNames.join('|'));
		//trace('|'+rdMap['h'].keys().next()+'|');
		trace(state.selectedRows.toString());
		var column:Int = 0;
		var isSelected:Bool = state.selectedRows.exists(row);
		var rowClass = (row % 2 == 0?'gridItem even':'gridItem odd');
		if(isSelected)
			rowClass += ' selected';
		var cells:Array<DataCell> = fieldNames.map(function(fN:String){
			var columnDataState:DataColumn = props.dataState.columns.get(fN);
			trace(fN + '::' + rdMap[fN]);
			var cD:DataCell = {
				cellFormat:columnDataState.cellFormat,
				className:(columnDataState.className==null?rowClass:columnDataState.className +' '+ rowClass),
				data:rdMap[fN],
				dataDisplay:columnDataState.cellFormat != null ? columnDataState.cellFormat(rdMap[fN]):rdMap[fN],
				name:fN,
				pos:{column:column++, row:row},
				show:columnDataState.show != false
			};
			return cD;					
		});
		var rCs:Array<ReactFragment> = [];
		for (cD in cells)
		{
			//trace(cD);
			if (!cD.show)
			 continue;
			rCs.push(
			jsx('<div className=${cD.className} key=${"r"+cD.pos.row+"c"+cD.pos.column} data-value=${cD.cellFormat!=null?cD.data:null} data-gridpos=${cD.pos.row+"_"+cD.pos.column} onClick=${highLightRow} >
				${cD.dataDisplay}
			</div>'));
		}
		return rCs;
	}
	
	function renderRows(?dRows:Array<Dynamic>):ReactFragment
	{
		if (dRows == null)
			dRows = props.data;
		var dRs:Array<ReactFragment> = [];
		var row:Int = 0;
		for (dR in dRows)
		{			
			trace(dR);
			dRs.push(renderCells(dR, row++));
		}//
		return dRs;
	}
	override function componentDidMount() {
		trace('ok');
		var grid:Element = gridRef.current;
		grid.style.setProperty('grid-template-columns', gridStyle);
	}

	override function componentDidUpdate(prevProps:Dynamic, prevState:Dynamic)	
	{
		trace(headerUpdated+ ':' + headerRef); 
		//return;

		/*if (gridHead != null)
		{
			if (headerUpdated)
				return;
			headerUpdated = true;	
			trace(gridRef.current.children)	;
			for (child in gridRef.current.children)
			{
				child.onmouseleave = leaveRow;
				child.onmouseenter = highLightRow;
			}
			var gridHeight:Float = gridRef.current.clientHeight;
			var scrollBarWidth = gridRef.current.parentElement.offsetWidth - gridRef.current.offsetWidth;
			trace('$scrollBarWidth ${gridRef.current.parentElement.offsetWidth} ${gridRef.current.offsetWidth}');
			//headerRef.current.style.setProperty('padding-right', '${scrollBarWidth}px');
			trace('gridHeight:$gridHeight');
			trace(gridRef.current + 'visibleColumns:$visibleColumns children:${gridRef.current.children.length}');

			//headerRef.current.style.setProperty('grid-template-columns', gridStyle);
			var grid:Element = gridRef.current;
			grid.style.setProperty('grid-template-columns', gridStyle);
			return;
			//grid.style.setProperty('grid-template-rows', '0px auto');
			var gH:Element = gridHead.current;
			gridHead.current.style.visibility = "collapse";	
			trace(gH.offsetWidth + ':' + gH.clientWidth);
			var rowRects:Array<DOMRect> = [gH.getBoundingClientRect()];
			gH.style.setProperty('visibility', "collapse");			
			for (i in 1...visibleColumns) 
			{
				trace(i);
				gH = gH.nextElementSibling;
				rowRects.push(gH.getBoundingClientRect());
				gH.style.setProperty('visibility', 'collapse');
				//trace(gH);
			}
			trace(headerRef);
			trace(gridHead);
			//return;
			var i = 0;
			for (fixedHeaderCell in headerRef.current.children)
			{
				trace(fixedHeaderCell);
				var r:DOMRect = rowRects.shift();
				fixedHeaderCell.setAttribute('style', 'width:${r.width}px;');
				i++;
				//x += w;left:${r.left}px;
				//trace(fixedHeaderCell.getAttribute('style'));
			}
			//showDims(gridHead);
			//nodeDims(headerRef.current);
		}*/
	}
	
	function leaveRow(evt:MouseEvent)
	{
		if (state.enteredRow != null)
		{
			var pos:Array<Any> = cast (cast (evt.target, Element).dataset.gridpos.split("_"));
			trace (pos[0] +"==" + state.enteredRow +  ':' + state._rowCells.length);
			if (pos[0] == state.enteredRow)
			{
				return;//	SAME ROW
			}
			for (c in state._rowCells)
			{
				c.style.removeProperty('background-color'); 
			}
		}
	}
	
	function highLightRow(evt:MouseEvent)
	{
		trace (state._selecting + ':' + evt.altKey);

		//state._selecting = true;
		trace(cast (evt.target, Element).dataset.gridpos);
		_selectRowOfCell(cast (evt.target, Element));
		//Out.dumpObject(evt);
	}
	
	/*public function select(mEvOrID:Dynamic)
	{
		//trace('select from contructor:${mEvOrID.select}');
		trace('${props.data['id']} selected:${state.selected}');
		if(!props.selectAble)
			return;
		trace(Reflect.fields(props));
		//trace(props.row +':' + props.data.toString());
		if(mEvOrID.select == null)
		{
			try{
				var evt:ReactMouseEvent = cast(mEvOrID);
				
				var tEl:Element = cast(mEvOrID.target,Element);
				trace(tEl.closest('table'));
				//trace(Browser.window.document.querySelector('table'));
				//TODO: IMPLEMENT MODIFIERS				
				//var mEvt:MouseEvent = cast(evt.nativeEvent, MouseEvent);
			}
			catch(ex:Dynamic)
			{
				trace(ex);
			}
		}

		if(props.parentComponent != null && props.parentComponent.props.select != null)
		{
			if(!state.selected)
			{
				//trace(props.data['id'] + ':' + props.parentComponent.props.match);
				trace(props.data['id'] + ':' + Type.getClassName(Type.getClass(props.parentComponent)));
				//trace(Type.typeof(props.parentComponent));
				if(props.parentComponent.props.match==null){
					props.parentComponent.props.select(props.data['id'], props.parentComponent);
				}
				else {
					var data:StringMap<StringMap<Dynamic>> = [props.data['id']=>props.data];
					props.parentComponent.props.select(props.data['id'], 
					data,//[props.data['id']=>props.data], 
					props.parentComponent.props.match);
				}				
			}
			else
			{
				trace('unselect');
				if(props.parentComponent.props.match==null){
					props.parentComponent.props.select(props.data['id'], props.parentComponent, Unselect);
				}
				else {
				props.parentComponent.props.select(props.data['id'], null,props.parentComponent.props.match, Unselect);
				}
			}	
			
		}
		if(props.selectAble)
			setState({selected: mEvOrID.select ? true:!state.selected});
		trace('selected:${state.selected}');
		//trace(props.parentComponent.props.classPath);
		if(true) trace('props.parentComponent.props.classPath:${Type.getClassName(Type.getClass(props.parentComponent))}');
		//if(!mEvOrID.select)
			//forceUpdate();
	}*/
		
	function _selectRowOfCell(el:Element)
	{
		if (state._selecting)
			return;		
		state._rowCells = [];
		state._selectedCells = [];				
		state._selecting = true;
		var eCol:Int;
		var pos:Array<Int> = cast el.dataset.gridpos.split("_");
		state.enteredRow = pos[0];
		state.selectedRows.set(state.enteredRow, true);
		trace(state.selectedRows.get(state.enteredRow));
		var rowCells = Browser.window.document.querySelectorAll('.gridItem[data-gridpos^="${state.enteredRow}"]');
		trace(rowCells.length);
		var aCol = eCol = pos[1];
		while (aCol > 0)
		{
			el = el.previousElementSibling;
			aCol--;
		}
		trace(pos);
		setState({selectedRows:state.selectedRows});
		state._selecting = false;
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