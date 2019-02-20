package view.shared.io;

import js.html.Event;
import react.router.RouterMatch;
import react.ReactType;
import react.React;
import js.html.Plugin;
import js.Syntax;
import haxe.Serializer;
import haxe.ds.StringMap;
import model.AjaxLoader;
import react.ReactComponent;
import react.ReactComponent.ReactFragment;
import react.ReactEvent;
import react.ReactMacro.jsx;
import react.ReactUtil;
import shared.DbData;
import view.shared.SMenu;
//import view.shared.io.DataAccessForm;
import view.shared.io.DataFormProps;
import view.shared.io.DataAccess.DataSource;
import view.table.Table.*;


/**
 * ...
 * @author axel@cunity.me
 */

typedef BookmarksModel = DataSource;

//typedef UserFilter = Dynamic;
@:connect
class Bookmarks extends ReactComponentOf<DataFormProps,FormState>
{
	
	override function componentDidCatch(error, info) {
		// Display fallback UI
		if(state.mounted)
		this.setState({ hasError: true });
		trace(error);
		trace(info);
	}
	
	public function add(ev:Event):Void
	{

	}

	public function delete(ev:Event):Void
	{
		
	}

	public function edit(ev:Event):Void
	{
		trace('hi :)');
		props.formContainer.requests.push(AjaxLoader.load(	
			'${App.config.api}', 
			{
				user_name:props.user.user_name,
				jwt:props.user.jwt,
				className:'auth.User',
				action:'edit',
				filter:'user_name|${props.user.user_name}',
				dataSource:Serializer.run(null)
			},
			function(data:Dynamic )
			{
				if (data.rows == null)
					return;
				trace(data.rows.length);
				var dataRows:Array<Dynamic> = data.rows;
				trace(Reflect.fields(dataRows[0]));
				trace(dataRows[0].active);
				setState({data:['accountData'=>dataRows], loading:false});					
			}
		));
		setState({dataClassPath:"auth.User.edit"});
	}
	
	public function save(ev:Event):Void
	{

	}

	public function no(ev:Event):Void
	{

	}

	public function new(props:DataFormProps)
	{
		super(props);
		/*dataAccess = [
			'edit' =>{
				source:new Map(),
				view:new Map()
			}
		];*/
		//_menuItems = [];//{handler:edit, label:'Bearbeiten', action:'edit'}];
		var sideMenu = updateMenu('bookmarks');
		//sideMenu.menuBlocks['bookmarks'].items = function() return _menuItems;
		//trace(sideMenu.menuBlocks['bookmarks'].items());
		state = {
			clean:true,
			hasError:false,
			mounted:false,
			loading:true,
			sideMenu:sideMenu, 
		};
		//trace(this.props);
	}
	
	override function render()
	{

		trace(state);
		//var NewLayoutInstance = React.createElement(NewLayout);;
		//trace(data);
		trace(props.match.params.section);
		
		return jsx('
			<div className="tabComponentForm"  >
				dummy	
			</div>		
		');
	}

	public static var menuItems:Array<SMItem> = [
		{label:'Neu',action:'create'},
		{label:'Bearbeiten',action:'edit'},
		{label:'Speichern', action:'save'},
		{label:'Löschen',action:'delete'},
	];

	function updateMenu(?viewClassPath:String):SMenuProps
	{
		if(state==null)
		{
			trace(state);
			return null;
		}
		var sideMenu = state.sideMenu;
		sideMenu.menuBlocks['bookmarks'].isActive = true;
		sideMenu.menuBlocks['bookmarks'].label='Lesezeichen';
		for(mI in sideMenu.menuBlocks['bookmarks'].items)
		{
			switch(mI.action)
			{		
				case 'edit':
					mI.disabled = state.selectedRows.length==0;
				case 'save':
					mI.disabled = state.clean;
				default:

			}			
		}		
		//trace(sideMenu.menuBlocks['user'].items);	
		return sideMenu;
	}	

	function getRow(row:Dynamic):{one: String, two: String, three: String}
	{
		return {one: row.one, two: row.two, three: row.three};
	}
}
/*<$ReactTable
	          	data=${data}
    	      	columns=${columns}
				defaultPageSize={20}
          		style=${style}
         	 	className="-striped -highlight" />*/