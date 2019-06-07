package view.table;

import js.html.TableRowElement;
import js.html.MouseEvent;
import react.ReactMouseEvent;
import haxe.extern.EitherType;
import react.ReactComponent.ReactComponentOf;
import react.ReactComponent.ReactFragment;
import react.ReactComponent;
import react.PureComponent;
import react.ReactMacro.jsx;
import react.ReactRef;
import view.table.Table.DataCell;
import view.table.Table.DataCellPos;
import view.table.Table.DataColumn;
import view.table.Table.SortDirection;
using Lambda;

/**
 * ...
 * @author axel@cunity.me
 */

typedef TrProps = 
{
	var row:Int;
	var columns:Map<String,DataColumn>;
	var fieldNames:Array<String>;
	@:optional var firstTableRow:ReactRef<TableRowElement>;
	@:optional var data:Map<String,Dynamic>;
};

typedef  TrState = 
{
	var cells:Array<DataCell>;
	var selected:Bool;
};

class Tr extends PureComponentOf<TrProps,TrState>
{
	public var me:ReactFragment;

	public function new(?props:Dynamic)
	{
		super(props);	
		state = {cells:[], selected:false};	
	}

	override function componentDidMount()//,snapshot:Dynamic
	{
		if(props.row<3)
		{
			trace(props.data);
		}
	}

	function renderCells(rdMap:Map<String,Dynamic>):ReactFragment
	{
		if(props.data==null)
		{
			trace('oops...');
			return null;
		}
		if(props.row==3)
		{
			trace(props.columns);
			trace(rdMap);
		}
		var column:Int = 0;
		var reported:Bool = false;
		var cells:Array<DataCell> = props.fieldNames.map(function(fN:String){
			var columnDataState:DataColumn = props.columns.get(fN);
			if(columnDataState == null && !reported)
			{
				trace(fN);
				reported = true;
			}
			//trace(columnDataState.cellFormat != null ? fN:'');
			var cD:DataCell = (columnDataState == null? {show:false}:{
				cellFormat:columnDataState.cellFormat,
				className:columnDataState.className,
				data:rdMap[fN],
				dataDisplay:columnDataState.cellFormat != null ? columnDataState.cellFormat(rdMap[fN]):rdMap[fN],
				flexGrow:columnDataState.flexGrow,
				name:fN,
				pos:{column:column++, row:props.row},
				show:columnDataState.show != false
			});
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
	
	override public function render():ReactFragment
	{
		if(props.row==0)
		{
			trace(props.data);
		}
		if(props.data==null)
		{
			return null;
		}
		var cl:String = '';
		if(state !=null)
		{
			cl = state.selected ? 'is-selected' : '';
		}
		trace('class:$cl');
		me = jsx('
		<tr className=${cl} data-id=${props.data["id"]} title=${props.data["id"]} ref=${props.firstTableRow} onClick=${select}>
		${renderCells(props.data)}
		</tr>
		');
		//key=${"r"+props.row} 
		return me;
	}

	public function select(mEv:MouseEvent)
	{
		trace(props.row +':' + props.data.toString());
		setState({selected:!state.selected});
		trace(state.selected);
	}
}