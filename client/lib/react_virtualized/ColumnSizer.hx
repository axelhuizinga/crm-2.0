package react_virtualized;

import haxe.Constraints.Function;
import react.PureComponent.PureComponentOfProps;
import react.ReactComponent.ReactFragment;
/**
 * ...
 * @author axel@cunity.me
 */

typedef ColumnSizerParams =
{
	adjustedWidth:Int,
	columnWidth:Int,
	getColumnWidth:Function,
	registerChild:Function	
}

typedef ColumnSizerProps =
{
	children:ColumnSizerParams->ReactFragment,
	?columnMaxWidth:Int,
	?columnMinWidth:Int,
	width:Int
}

@:jsRequire('react-virtualized', 'ColumnSizer')
extern class ColumnSizer extends PureComponentOfProps<ColumnSizerProps>
{

	public function new(props:ColumnSizerProps):Void;
	
}