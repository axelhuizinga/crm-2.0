package view.grid;

import react.router.RouterMatch;
import react.router.ReactRouter;
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
import react.router.ReactRouter.matchPath;
import react.ReactMacro.jsx;
import shared.Utils;

/**
 * ...
 * @author axel@cunity.me
 */

@:wrap(ReactRouter.withRouter)
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
		trace('props.scrollHeight:${props.scrollHeight}');
		if(true&&props.scrollHeight>0)
			return jsx('
		<div className="grid_container">			
			<div className="rounded_box">	
				<div className="g_caption" key=${"caption"} style=${null}>${props.title}</div>
				
				<div className="grid_scroll_box grid${visibleColumns}c" ref=${gridRef} id=${props.id} key=${"grid_list"+props.id} 
				>	
					${headerRows}				
					${renderRows()}					
				</div>
			</div>				
			${renderPager(props.parentComponent)}
		</div>');
		else 
			return jsx('		
		<div className="grid_container">			
				<div className="grid_box grid${visibleColumns}c" ref=${gridRef} id=${props.id} key=${"grid_list"+props.id}>	
					${renderTitle(visibleColumns)}
					${headerRows}				
					${renderRows()}					
				</div>				
			
		</div>');		
	}
//${renderPager(props.parentComponent)}
	public function renderPager(comp:Dynamic):ReactFragment
	{
		trace('pageCount=${comp.state.pageCount}');		
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
	
	function renderTitle(?vcol=2):ReactFragment
	{
		if(props.title==null)
			return null;
		vcol++;
		return jsx('<div className="g_caption" key=${"caption"} style=${{gridColumn:"1/"+vcol}}>${props.title}</div>');
	}
	
	function renderHeaderDisplay():ReactFragment
	{
		if(props.dataState==null)
			return null;
		var headerRow:Array<ReactFragment> = [];
		visibleColumns = 0;
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
			<span key=${field+"header"} className=${"gridHeadItem " + (hC.headerClassName != null? hC.headerClassName : (hC.className!= null?hC.className:''))}>
			${hC.label != null? hC.label : hC.name}<span className="sort-box fa fa-sort"></span>
			</span>
			'));
			//trace(hC.label +':' + hC.flexGrow);
		}
		trace('$visibleColumns $gridStyle');
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
			id:(rdMap['id']==null&&props.findBy!=null?rdMap[props.findBy]:rdMap['id']),
			//id:rdMap['id'],
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
		//
		var id:String = (props.findBy!=null&&props.findBy.length>0?props.findBy:'id');
		var rowClass = (row % 2 == 0?'gridItem even':'gridItem odd');

		if(state.selectedRows.exists(rdMap.get(id)))
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
					//if(cD.name==val && rdMap.exists(key)&&rdMap.exists(val)){
					if(cD.name==val && rdMap.exists(key)){
						cD.title = rdMap.get(key);
					}
				}
			}
		}
		for (cD in cells){
			//trace(cD);"r"+cD.pos.row+"c"+cD.pos.column
			//trace(row + ':' + cD.id + '_' + cD.pos.column);
			//trace(cD.name+':'+cD.title+':'+cD.show);
			if (cD.show){
			/*	if(cD.id==null&&props.findBy!=null){
					cD.id = 
				}*/
				rCs.push(
					if(!props.readOnly)
						jsx('<div className=${cD.className} key=${cD.id + '_' + cD.name} data-value=${cD.data} 
			data-id=${cD.id} data-name=${cD.name} title=${cD.title} 
			data-gridpos=${cD.pos.row+"_"+cD.pos.column} onClick=${select} onDoubleClick=${editRow}>
				${(cD.dataDisplay==null||cD.dataDisplay==''?<span>&nbsp;</span>:cD.dataDisplay)}
			</div>')
					else
						jsx('<div className=${cD.className} key=${cD.id + '_' + cD.name} data-value=${cD.data} 
			data-id=${cD.id} data-name=${cD.name} title=${cD.title} 
			data-gridpos=${cD.pos.row+"_"+cD.pos.column}>
				${(cD.dataDisplay==null||cD.dataDisplay==''?<span>&nbsp;</span>:cD.dataDisplay)}
			</div>')					
				);
			}
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
		trace(untyped ev.target.nodeName);
		state.selectTimer.stop();
		state._prevent = true;
		var el:Element = cast(ev.target,Element);
		if(!el.classList.contains('selected'))
			highLightRow(ev);
		Timer.delay(function() {
			state._prevent = false;
		},clickDelay*2);
		trace(props.onDoubleClick);
		trace('here we go :) '+ getUrl(el.dataset.action,'Edit'));
		//props.parentComponent.props.history.push(getUrl(el.dataset.action,'Edit'),props.parentComponent.props.location.state);
		
		
		if(props.onDoubleClick != null){
			props.onDoubleClick(ev);
		}
		else 
			props.history.push(getUrl(el.dataset.action,'Edit'),props.location.state);
	}

	public function getUrl(?action:String,?targetSection:String):String
	{
		//if(match)
		//var match:RouterMatch = props.parentComponent.props.match;
		var match:RouterMatch = props.match;
		trace(match);
		//trace(props.match);
		//trace(Type.typeof(props.parentComponent));
		trace(Type.getClassName(Type.getClass(props.parentComponent)));
		var baseUrl:String = match.path.split(':section')[0];		
		var section = match.params.section;
		if(action==null||action==''){
			action = props.doubleClickAction;
		}
		//trace(props.parentComponent.props.location);trace (aState.dataStore.qcData.keys().next());
		if(props.parentComponent.state.selectedData!=null)
			trace(props.parentComponent.state.selectedData.toString());
		//var id:String = (match.params.id==null||action=='insert'?'':'/${match.params.id}');
		var id:String = (props.parentComponent.state.selectedData ==null||action=='insert'?'':'/${Utils.keysList(props.parentComponent.state.selectedData.keys())[0]}');
		trace('>>$id<<');
		if(id=='/undefined')
			id='';
		return '${baseUrl}${targetSection==null?section:targetSection}/${action}${id}';
	}
		
	function select(e:ReactEvent){
		//trace(e);
		trace(untyped e.target.nodeName + ':' + state._prevent);
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
		var rowCells = Browser.window.document.querySelectorAll('.gridItem[data-id="${el.dataset.id}"]');
		var rowEls:Array<Element> = Syntax.code("Array.from({0})",rowCells);
		var selectedNow:IntMap<Bool> = state.selectedRows.copy();
		trace (el.dataset.id + ':' + state._selecting + ' ctrlKey:' + evtOrId.ctrlKey);
		if(!evtOrId.ctrlKey && !evtOrId.shiftKey){
			//clear selection only
			if(selectedNow.exists(rN)){
				setState({selectedRows:new IntMap()});		
				state._selecting = false;
				props.parentComponent.props.select(el.dataset.id,[el.dataset.id => getRowData(rowEls)], props.parentComponent, 
				SelectType.Unselect);
				return;				
			}
			else{
				//state.selectedRows = new IntMap();	
				//state.selectedRows.set(rN, true);
				selectedNow = [rN => true];
				trace(selectedNow);
			}
		}
		else {
			//TODO: HANDLE SELECTION WITH MODIFIERS
		}		

		setState({selectedRows:selectedNow});
		trace(props.parentComponent.state.uid);
		var match = ReactRouter.matchPath(Browser.location.pathname,{});
		//trace(untyped props.match);
		trace(Type.getClassName(Type.getClass(props.parentComponent)));
		//trace(Reflect.fields(props).join('|'));
		props.parentComponent.props.select(el.dataset.id,[el.dataset.id => getRowData(rowEls)],props.parentComponent
		, SelectType.One);
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
		//trace(rCs.length);
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
