package view.grid;

import react.ReactUtil;
import haxe.Exception;
import js.html.TimeElement;
import data.DataState;
import react.ReactPaginate;
import view.grid.GridProps;
import view.shared.FormField;
import js.Syntax;
import action.DataAction.SelectType;
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
import react.Fragment;
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

class Grid extends ReactComponentOf<GridProps, GridState>
{
	var fieldNames:Array<String>;
	var gridRef:ReactRef<DivElement>;
	var headerRef:ReactRef<DivElement>;
	var gridStyle:String;
	var visibleColumns:Int;
	var headerUpdated:Bool;
	static var clickDelay:Int = 200;
	
	public function new(?props:GridProps)
	{
		super(props);		
		headerUpdated = false;
		gridRef = React.createRef();
		headerRef = React.createRef();
		visibleColumns = 0;
		fieldNames = [];
		for (k in props.dataState.columns.keys())
		{
			//trace(k);
			fieldNames.push(k);
		}	
		//trace(fieldNames);
		state = {
			_prevent:false,
			_selecting:false,
			selectedRow:null,
			selectedRows:new IntMap(),
			_rowCells:[],
			_selectedCells:[]
		}
	}
	
	override public function render():ReactFragment
	{
		//if(props.data != null)trace(props.data.length);
		//trace(props.className);		
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
	
		var headerRows:ReactFragment = renderHeaderDisplay();
		//trace('pageCount=${props.parentComponent.state.pageCount} dataCount=${props.parentComponent.state.dataCount} limit=${props.parentComponent.props.limit}');	

		return jsx('		
		<Fragment>
			<div className="grid_box" ref=${gridRef} id=${props.id} key=${"grid_list"+props.id}>		
					${headerRows}				
					${renderRows()}
			</div>					
			${renderPager(props.parentComponent)}
		</Fragment>');		
	}

	public function renderPager(comp:Dynamic):ReactFragment
	{
		//trace('pageCount=${comp.state.pageCount}');		
		if(Math.isNaN(comp.state.pageCount) || comp.state.pageCount<2)
			return null;
		return jsx('
		<div id="pct" className="paginationContainer">
			<nav>
				<$ReactPaginate previousLabel=${'<'} breakLinkClassName=${'pagination-link'}
					pageLinkClassName=${'pagination-link'}					
					nextLinkClassName=${'pagination-next'}
					previousLinkClassName=${'pagination-previous'}
					nextLabel=${'>'}
					breakLabel=${'...'}
					breakClassName=${'break-me'}
					pageCount=${comp.state.pageCount}
					marginPagesDisplayed={2}
					pageRangeDisplayed={5}
					onPageChange=${function(data){
						trace('${comp.props.match.params.action}  ${data.selected}');
						var fun:Function = Reflect.field(comp,comp.props.match.params.action);
						if(Reflect.isFunction(fun))
						{
							Reflect.callMethod(comp,fun,[{page:data.selected}]);
						}
					}}
					containerClassName=${'pagination is-small'}
					subContainerClassName=${'pages pagination'}
					activeLinkClassName=${'is-current'}/>
			</nav>	
		</div>		
		');
	}	

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
			<div key=${field+"header"} className=${"gridHeadItem " + (hC.headerClassName != null? hC.headerClassName : (hC.className!= null?hC.className:''))}>
			${hC.label != null? hC.label : hC.name}<span className="sort-box fa fa-sort"></span>
			</div>
			'));
		}
		//trace('$visibleColumns $gridStyle');
		return headerRow;
	}	

	function map2DataCell(rdMap:Map<String,Dynamic>,fN:String, column:Int, row:Int, rowClass:String):DataCell {
		var columnDataState:DataColumn = props.dataState.columns.get(fN);
		if(rdMap[fN]=='')
			rdMap[fN] = null;
		//trace(fN + '::' + rdMap[fN] + '::' + columnDataState.cellFormat);
		//trace(fN + '::' +columnDataState);
		return {
			cellFormat:columnDataState.cellFormat,
			className:(columnDataState.className==null?rowClass:columnDataState.className +' '+ rowClass),
			data:rdMap[fN],
			dataDisplay:columnDataState.cellFormat != null ? columnDataState.cellFormat(rdMap[fN]):rdMap[fN],
			id:rdMap['id'],
			name:fN,
			pos:{column:column, row:row},
			show:columnDataState.show != false,
			title: rdMap['title']
		};
	}

	function renderCells(rdMap:Map<String,Dynamic>, row:Int):ReactFragment
	{
		//trace(rdMap.toString());
		//trace('|'+rdMap['h'].keys().next()+'|');
		//trace(state.selectedRows.toString());
		var column:Int = 0;

		var rowClass = (row % 2 == 0?'gridItem even':'gridItem odd');

		if(state.selectedRows.exists(rdMap.get('id')))
			rowClass += ' selected';		
		var cells:Array<DataCell> = fieldNames.map(function(fN:String){
			return map2DataCell(rdMap, fN, column++, row, rowClass);
		});

		var rCs:Array<ReactFragment> = [];
		//trace(cells.length);
		for (cD in cells){
			// Map DataFieldName to DisplayFieldName, 		
			if(props.dataState.titleMap!=null){
				for( key => val in props.dataState.titleMap){
					if(cD.name==val && rdMap.exists(key)&&rdMap.exists(val)){
						cD.title = rdMap.get(key);
					}
				}
			}
		}
		for (cD in cells){
			//trace(cD);"r"+cD.pos.row+"c"+cD.pos.column
			//trace(row + ':' + cD.id + '_' + cD.pos.column);
			//trace(cD.name+':'+cD.title+':'+cD.show);
			if (cD.show)
				rCs.push(
			jsx('<div className=${cD.className} key=${cD.id + '_' + cD.name} data-value=${cD.data} 
			data-id=${cD.id} data-name=${cD.name} title=${cD.title} 
			data-gridpos=${cD.pos.row+"_"+cD.pos.column} onClick=${select} onDoubleClick=${editRow}>
				${(cD.dataDisplay==null||cD.dataDisplay==''?<span>&nbsp;</span>:cD.dataDisplay)}
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
			//trace(dR);
			dRs.push(renderCells(dR, row++));
		}
		return dRs;
	}
	
	override function componentDidMount() {
		if(gridRef == null ||gridRef.current == null){
			trace(Type.getClassName(Type.getClass(props.parentComponent)));
			return;
		}
		//trace('ok ${gridRef}');
		props.parentComponent.state.dataGrid=this;
		var grid:Element = gridRef.current;
		grid.style.setProperty('grid-template-columns', gridStyle);
	}

	override function componentDidUpdate(prevProps:Dynamic, prevState:Dynamic)	
	{
		trace(headerUpdated+ ':' + headerRef +' cmp state:' + (prevState==state?'Y':'N')); 
	}
	
	function editRow(ev:Event) {
		state.selectTimer.stop();
		state._prevent = true;
		var el:Element = cast(ev.target,Element);
		if(!el.classList.contains('selected'))
			highLightRow(ev);
		Timer.delay(function() {
			state._prevent = false;
		},clickDelay*2);
		trace('here we go :)'+props.onDoubleClick);
		if(props.onDoubleClick != null){
			props.onDoubleClick(ev);
		}
	}

	function select(e:ReactEvent){
		//trace(e);
		untyped e.persist();
		state.selectTimer = Timer.delay(function() {
			if(!state._prevent)
				highLightRow(e);
		},clickDelay);
	}

	function highLightRow(evtOrId:Dynamic)
	{			
		trace('evtOrId');
		if (state._selecting)
			return;		
		state._selecting = true;
		//trace(evtOrId);
		var el:Element = (Std.is(evtOrId, Int)?
		Browser.window.document.querySelector('.gridItem[data-id="${evtOrId}"]'):
		cast (evtOrId._targetInst.stateNode, Element));
		var rN:Int = Std.parseInt(el.dataset.id);
		var selectedNow:IntMap<Bool> = state.selectedRows.copy();

		trace (el.dataset.id + ':' + state._selecting + ' ctrlKey:' + evtOrId.ctrlKey);
		//rN = Std.parseInt(el.dataset.id);             
		//rN = Std.parseInt(el.dataset.gridpos.split("_")[0]);
		if(!evtOrId.ctrlKey && !evtOrId.shiftKey){
			//clear selection only
			state.selectedRows = new IntMap();	
			if(selectedNow.exists(rN)){
				setState({selectedRows:state.selectedRows});		
				state._selecting = false;
				return;				
			}
			else{
				state.selectedRows.set(rN, true);
				trace(state.selectedRows);
			}
		}
		else {
			//TODO: HANDLE SELECTION WITH MODIFIERS
		}
		
		var rowCells = Browser.window.document.querySelectorAll('.gridItem[data-id="${el.dataset.id}"]');
		//trace(rowCells.length + ':' + untyped rowCells.item(0).innerHTML);
		var rowEls:Array<Element> = Syntax.code("Array.from({0})",rowCells);
		setState({selectedRows:state.selectedRows});
		//trace(el.dataset.id + ':' + rowEls[0].innerHTML + getRowData(rowEls).toString());
		props.parentComponent.props.select(el.dataset.id,[el.dataset.id => getRowData(rowEls)], props.parentComponent, SelectType.One);
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
	
	//function getRowData(rCs:NodeList):StringMap<Dynamic> {
	function getRowData(rCs:Array<Element>):StringMap<Dynamic> {
		if(rCs.length==0)
			return null;
		/*for (el in rCs){
			trace(el.dataset.id+':'+el.innerHTML);
		}*/
		return [
			for (el in rCs)
				el.dataset.name => el.dataset.value
		];
	}
}
