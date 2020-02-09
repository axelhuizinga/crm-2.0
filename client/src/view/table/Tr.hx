package view.table;

import js.html.Location;
import js.html.History;
import js.html.Element;
import js.Browser;
import haxe.macro.Expr.Catch;
import react.ReactEvent;
import js.html.Event;
import action.DataAction;
import haxe.ds.IntMap;
import react.router.RouterMatch;
import js.html.TableRowElement;
import js.html.MouseEvent;
import react.ReactMouseEvent;
import haxe.extern.EitherType;
import react.ReactComponent.ReactComponentOfProps;
import react.ReactComponent.ReactFragment;
import react.ReactComponent;
import react.PureComponent;
import react.ReactMacro.jsx;
import react.React;
import react.ReactRef;
import react.ReactUtil.copy;
import state.FormState;
import view.table.Table.DataCell;
import view.table.Table.DataCellPos;
import view.table.Table.DataColumn;
import view.table.Table.SortDirection;

using shared.Utils;
using view.shared.io.FormApi;
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
	@:optional var parentComponent:Dynamic;
};

typedef  TrState = 
{
	var cells:Array<DataCell>;
	var selected:Bool;
};

class Tr extends ReactComponentOfProps<TrProps>
{
	public var me:ReactFragment;
	var id:String;
	var selected:Bool;
	var ref:ReactRef<TableRowElement>;

	public function new(?props:Dynamic)
	{
		super(props);	
		ref = React.createRef();
		var match:RouterMatch = props.parentComponent.props.match;
		id = props.data != null ? props.data.get('id'): '';
		//trace('$id ${match.params.id !=null && match.params.id.indexOf(id)>-1}');
		//state = {cells:[], selected:match.params.id !=null && match.params.id.indexOf(id)>-1?true:false};	
		selected = false;
		if(match.params.id !=null && match.params.id.indexOf(id)>-1)
		//if(match.location.hash !=null && match.params.id.indexOf(id)>-1)
		{
			select({select:true});
		}
		//var loc:Location = props.parentComponent.props.location;
		//if(loc.hash != '')
		//{
			//trace('id:$id ${loc.hash}');
		if(props.parentComponent.props.location.hash.indexOf(id)>-1)
			select({select:true});
		//}
	}

	override function componentDidMount()//,snapshot:Dynamic
	{
		/*if(selected && ref.current != null)
		{
			trace(ref.current.offsetTop);
			ref.current.scrollTo(0, ref.current.offsetTop);

		}*/
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
			//trace(props.columns);
			//trace(rdMap);
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
		//trace(selected);
		if(props.row==0)
		{
			//trace(props.data);setFormState
			ref = props.firstTableRow;
		}
		//else selected = props.parentComponent.props.match.params.id !=null && props.parentComponent.props.match.params.id.indexOf(id)>-1;		
		else selected = props.parentComponent.props.location.hash.indexOf(id)>-1;
		var cl:String =  selected ? 'is-selected' : '';
		
		//trace('$id == ${props.parentComponent.props.match.id} class:$cl');
		if(props.data==null)
		{
			return null;
		}		
		var makeRef:String = selected && props.row>0?'ref=${ref}':'';
		return jsx('
		<tr className=${cl} data-id=${props.data["id"]} data-row=${props.row} title=${props.data["id"]} ref=${ref} onClick=${select}>
		${renderCells(props.data)}
		</tr>
		');
		//key=${"r"+props.row} 
		//return me;
	}

	public function select(mEvOrID:Dynamic)
	{
		trace('select from contructor:${mEvOrID.select}');
		trace('${props.data['id']} selected:$selected');
		trace(Reflect.fields(props));
		//trace(props.row +':' + props.data.toString());
		if(mEvOrID.select == null)
		{
			try{
				var evt:ReactMouseEvent = cast(mEvOrID);
				
				var tEl:Element = cast(mEvOrID.target,Element);
				trace(tEl.closest('table'));
				//trace(Browser.window.document.querySelector('table'));
				/*TODO: IMPLEMENT MODIFIERS
				trace('altKey:${evt.altKey}');
				trace('ctrlKey:${evt.ctrlKey}');
				trace('shiftKey:${evt.shiftKey}');*/
				
				//var mEvt:MouseEvent = cast(evt.nativeEvent, MouseEvent);
			}
			catch(ex:Dynamic)
			{
				trace(ex);
			}
		}
		if(props.parentComponent != null)
		{
			if(!selected)
			{				
				props.parentComponent.props.select(props.data['id'], 
					[Std.int(props.data['id'])=>props.data], props.parentComponent.props.match);
			}//
			else
			{
				props.parentComponent.props.select(props.data['id'], null,props.parentComponent.props.match, Unselect);
			}	
			
		}
		selected = mEvOrID.select ? true:!selected;
		trace('selected:$selected');
		//if(!mEvOrID.select)
			//forceUpdate();
	}

}