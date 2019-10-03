package view.table;

import haxe.Constraints.Function;
import react.ReactComponent;
import react.ReactMacro.jsx;

import react_virtualized.AutoSizer;
import react_virtualized.Table;
import react_virtualized.Column;
import react_virtualized.ColumnSizer;
import react_virtualized.Grid;

typedef VDataGridProps = 
{
	?autoSize:Bool,
	?className:String,
	?disableHeight:Bool,
	?disableWidth:Bool,
	?width:Int,
	?height:Int,	
	?id:String,
	?listColumns:Map<String,VDataColumn>,
	dataRows:Array<Dynamic>,
	?onResize:Function

}

typedef VDataColumn = 
{
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
	?search:VSortDirection,
	?show:Bool,
	?style:Dynamic
}

typedef VSize = 
{
	height:Int,
	width:Int
}

class VDataGrid {
	
	var props:VDataGridProps;

	public function new(props:VDataGridProps) {
		this.props = props;
	}

	public function renderAutoSizer():ReactFragment
	{
		return react.ReactMacro.jsx('
			<$AutoSizer children=${function(size:Dynamic){
				trace(size);
					props.height = size.height;
					props.width = size.width;
					return renderTable();
				}}
			/>
		');
	}

	public static function renderVirtualTable(props:VDataGridProps):ReactFragment
	{
		var instance:VDataGrid = new VDataGrid(props);
		return props.autoSize? instance.renderAutoSizer(): instance.renderTable();
	}

	public function renderTable():ReactFragment
	{
		return react.ReactMacro.jsx('
			<$Table className="is-striped is-hoverable" width=${props.width}
			height=${props.height} rowHeight=${24}  headerHeight=${24} 
				rowGetter=${function(p:Dynamic)return props.dataRows[p.index]}
				rowCount=${props.dataRows.length} >
			${renderColumns(props.listColumns)}
			</$Table>
		');
	}

	public function renderColumns(colProps:Map<String,VDataColumn>):ReactFragment
	{
		var ki:Int = 0;
		return [for(k=>v in colProps.keyValueIterator())
		 jsx('<$Column key=${'c_' + ki++} dataKey=${k} label=${v.label} width=${100}  />')
		];
	}
	
}