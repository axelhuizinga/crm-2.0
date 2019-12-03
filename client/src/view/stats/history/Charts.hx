package view.stats.history;

import js.Browser;
import js.html.Element;
import shared.Utils;
import react.ReactDOM;
import react.React.*;
import react.ReactRef;
import js.d3.selection.Selection;
import js.d3.D3;
import view.shared.io.FormApi;
import react.ReactComponent.ReactFragment;
import react.ReactMacro.jsx;
import shared.DbData;
import loader.BinaryLoader;
import state.AppState;
import model.stats.HistoryModel;
import haxe.Constraints.Function;
import haxe.extern.EitherType;
import view.shared.SMItem;
import view.shared.io.BaseForm;

typedef ChartDataState =
{
	?altGroupPos:Int,
	columns:Map<String,ChartDataColumn>,
	?defaultSearch:Map<String,ChartDataColumn>,
	?search:Map<String,ChartDataColumn>
}

typedef ChartDataColumn = 
{
	@:optional var dbFormat:Function;
	@:optional var cellFormat:Function;
	@:optional var className:Dynamic;
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

typedef ChartDataCellPos =
{
	column:Int,
	row:Int
}
typedef ChartDataCell =
{
	@:optional var cellFormat:Function;
	@:optional var className:Dynamic;
	@:optional var data:Dynamic;// CELL CONTENT VALUE
	@:optional var dataDisplay:Dynamic;// CELL CONTENT DISPLAY VALUE
	@:optional var dataType:Dynamic;// CELL CONTENT VALUE TYPE
	@:optional var name:String;
	@:optional var id:String;
	@:optional var pos:ChartDataCellPos;
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
	var ASC;// = 'ASC';
	var DESC;// = 'DESC';
	var NONE;// = '';
}

typedef SortProps =
{
	column:String,
	direction:SortDirection
}

class Charts extends BaseForm
{
	public static var menuItems:Array<SMItem> = [
		//{label:'Anzeigen',action:'get'},
		{label:'Einstellung',action:'setup',section: 'Charts'},
	//	{label:'Auswahl umkehren',action:'selectionInvert'},
	//	{label:'Auswahl alle',action:'selectionAll'},
	];
	
	var dbData: shared.DbData;
	var chartBox:Element;
	var svg:Selection;

	public function new(props) 
	{
		super(props);
		dataDisplay = HistoryModel.dataDisplay;
		trace('...' + Reflect.fields(props));
		state =  App.initEState({
			dataTable:[],
			loading:false,
			//contactData:new IntMap(),			
			selectedRows:[],
			sideMenu:FormApi.initSideMenu2( this,
				{
					dataClassPath:'reports.History',
					label:'Charts',
					section: 'Charts',
					items: menuItems
				}					
				,{	
					section: props.match.params.section==null? 'Chart':props.match.params.section, 
					sameWidth: true
				}),
			values:new Map<String,Dynamic>()
		},this);
		if(props.match.params.section==null||props.match.params.action==null)
		{
			//var sData = App.store.getState().dataStore.contactData;			
			var baseUrl:String = props.match.path.split(':section')[0];
			trace('redirecting to ${baseUrl}Charts/get');
			props.history.push('${baseUrl}Charts/get');
			get(null);
		}
		else 
		{
			state.formApi.doAction();
		}		
		trace(state.loading);
	}
	
	static function mapStateToProps(aState:AppState) 
	{
		throw ('never');
		return {
			user:aState.user
		};
	}

	public function get(ev:Dynamic):Void
	{
		trace('hi $ev');
		var offset:Int = 0;
		if(ev != null && ev.page!=null)
		{
			offset = Std.int(props.limit * ev.page);
		}
		var params:Dynamic = {
			id:props.user.id,
			jwt:props.user.jwt,
			className:'stats.History',
			action:'get',
			filter:(props.filter==null?'termin<NOW()':props.filter),
			devIP:App.devIP,
			limit:props.limit,
			offset:offset>0?offset:0,
			order:'termin',
			table:'bank_transfers'
		};
		BinaryLoader.create(
			'${App.config.api}', 
			params,
			function(data:DbData)
			{			
				//UserAccess.jwtCheck(data);
				trace(data.dataInfo);
				trace(data.dataParams);
				trace(data.dataRows.length);
				if(data.dataRows.length>0) 
				{
					if(!data.dataErrors.keys().hasNext())
					{
						data.dataRows.pop();
						setState({
						//props.parentComponent.setStateFromChild({
							//rows:dRows,
							dataTable:data.dataRows,
							dataCount:Std.parseInt(data.dataInfo['count'])
						});
						
						if(chartBox==null)
						chartBox = Browser.window.document.querySelector('.chartBox');
						trace(chartBox);
						if(chartBox!=null)
						draw();
					}
					else 
						setState({values: ['loadResult'=>'Kein Ergebnis','closeAfter'=>-1]});					
				}
			}
		);
	}
	
	override public function componentDidMount():Void 
	{	
		dataAccess = [
			'get' =>{
				source:[
					"contacts" => []
				],
				view:[]
			},
		];			
		//
		if(props.user != null)
		trace('yeah: ${props.user.first_name}');
		trace(props.match.params.action);
		//state.formApi.doAction();
		//chartBox = ReactDOM.findDOMNode(this);
		if(chartBox==null)
		chartBox = Browser.window.document.querySelector('.chartBox');
		trace(chartBox);
		if(chartBox!=null)
		draw();
	}

	function draw() {
		trace(chartBox.outerHTML);		
		var cW:Int = chartBox.parentElement.offsetWidth-10;
		var cH:Int = chartBox.parentElement.offsetHeight-10;
		var maxSum:Float = Utils.keyMax(state.dataTable,'sum');
		var maxCount:Int = Math.round(Utils.keyMax(state.dataTable, 'count'));
		var cRatio:Float = cH/maxCount;
		var sRatio:Float = cH/maxSum;
		trace('$maxCount => $maxSum $cW: $cRatio $sRatio ${state.dataTable.length}');
		if(svg!=null)
			return;
		svg = D3.select('.chartBox').append('svg').attr('width',cW).attr('height', cH);

		//{var h = Std.parseFloat(d.get('sum'))*sRatio;trace(h);return h;}
		if(state.dataTable != null && state.dataTable.length>0)
		{
			var iW:Float = cW/state.dataTable.length;
			svg.selectAll("rect").data(state.dataTable).enter().append("rect").attr('x', function(d:Dynamic,i:Int)return i*iW)
			.attr('y',function(d:Dynamic,i:Int)return cH - sRatio * Std.parseFloat(d.get('sum'))).attr('width',iW-2).attr('height',function(d:Dynamic,i:Int)return Std.parseFloat(d.get('sum'))*sRatio).attr("fill", "green");
		}
			
	}
	
	function renderResults():ReactFragment
	{
		trace(props.match.params.section + ':${props.match.params.action}::' + Std.string(state.dataTable != null));
		//trace(dataDisplay["userList"]);
		if( state.dataTable.length==0)
			return state.formApi.renderWait();
		//trace('###########loading:' + state.rows[0]);
		return switch(props.match.params.action)
		{//  ${...props}<pre>${Std.string(state.dataTable)}</pre>
			case 'get':
				jsx('
					<form className="tabComponentForm" >
						<div className="chartBox"></div>
					</form>
				');
			default:
				null;
		}
		return null;
	}

	function getCellData(cP:Dynamic) {
		trace(cP);
	}
//cellDataGetter=${getCellData}
	
	override function render():ReactFragment
	{
		//if(state.dataTable != null)	trace(state.dataTable[0]);
		trace(props.match.params.section);		
		return state.formApi.render(jsx('
				${renderResults()}
		'));		
	}

	override public function componentWillUnmount() {
		trace('...');
	}
}