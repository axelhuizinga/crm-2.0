package view.dashboard;

import react.router.RouterMatch;
//import react.router.Route.RouteMatchProps;
//import react.router.RouteRenderProps;
import react.router.ReactRouter;
import comments.StringTransform;
import haxe.Serializer;
import haxe.ds.StringMap;
import haxe.Json;
import js.html.XMLHttpRequest;
import haxe.http.HttpJs;
import me.cunity.debug.Out;
import model.AppState;
import react.Fragment;
import react.ReactComponent;
import react.ReactMacro.jsx;
import react.ReactUtil;
import react.ReactType;
import model.AjaxLoader;

import view.shared.io.DataFormProps;
import view.shared.io.FormFunctions;
import view.shared.FormState;
import view.shared.OneOf;
import view.shared.SMenu;
import view.shared.SMenuProps;
import view.shared.io.DB;
import view.shared.io.DBSync;
import view.table.Table;

/**
 * ...
 * @author axel@cunity.me
 */

class Setup extends ReactComponentOf<DataFormProps,FormState>
{
	//var requests:Array<OneOf<HttpJs, XMLHttpRequest>>;
	public function new(?props:DataFormProps) 
	{
		trace(props.user);
		super(props);	
		trace(props.match.params.section);
		//trace(getRouterMatch().params);
		state = {
			clean:true,
			hasError:false,
			mounted:false,
			loading:true,
			sideMenu:FormFunctions.initSideMenu( this,
				[
					{
						dataClassPath:'model.tools.DB',
						label:'DB Design',
						section: 'DB',
						items: DB.menuItems
					},
					{
						dataClassPath:'model.admin.SyncExternal',
						label:'DB Abgleich',
						section: 'DBSync',
						items: DBSync.menuItems
					}
				]
				,{	
					section: props.match.params.section==null? 'DBSync':props.match.params.section, 
					sameWidth: true}					
			)
		};
		trace(Reflect.fields(props));		
	}
	
	/*static function mapStateToProps() {

		return function(aState:model.AppState) 
		{
			var uState = aState.appWare.user;
			//trace(uState);		
			return {
				//appConfig:aState.appWare.config,
				user_name:uState.user_name,
				jwt:uState.jwt,
				first_name:uState.first_name
			};
		};
	}	*/
	
	override function componentDidCatch(error, info) {
		// Display fallback UI
		if(state.mounted)
		this.setState({ hasError: true });
		trace(error);
	}	
	
	override public function componentDidMount():Void 
	{
		//
		setState({mounted:true});
		if (props.match.params.section == null)
		{
			var basePath:String = props.match.url;
			props.history.push('$basePath/DB');
			trace(props.history.location.pathname);
			trace('setting section to:DB');
			//props.history.push(props.match.url + '/' + viewClassPath);
		}		
		trace('${}');
		//TODO: AUTOMATE CREATE HISTORY TRIGGER IF DB TABLES CHANGED
		/*AjaxLoader.loadData('${App.config.api}', 
			{
				user_name:props.user.user_name,
				jwt:props.user.jwt,
				className:'admin.CreateHistoryTrigger',
				action:'run'				
			}, 
			function(data:String){
				trace(data); 
				if (data != null && data.length > 0)
				{
					var sData:StringMap<Dynamic> = state.data;
					sData.set('historyTrigger', Json.parse(data).data.rows);
					setState(ReactUtil.copy(state, {data:sData}));				
				}
			});	
			*/		
	}
	
	override public function render() {
		if(state.sideMenu != {})
		{
			//trace(state.sideMenu);
			if(state.sideMenu.menuBlocks!=null)
			{
				trace(state.sideMenu.menuBlocks.keys().next +':' + state.sideMenu.section);
			}
		}	
		
		return FormFunctions.render(this);
	}

	public function renderContent():ReactFragment
	{
		//var match:RouterMatch = getRouterMatch();
		//trace(state.formContainer);
		//trace(cState.formContainer.props.match.url);
		//if(state.formContainer!=null)
		trace(props.match.params.section);
		return switch(props.match.params.section)
		{
			case "DBSync":
				jsx('
					<$DBSync ${...props} fullWidth={true}/>
				');					
			case "DB":
				jsx('
					<$DB ${...props} fullWidth={true}/>
				');				
			default:
				null;					
		}
	}

	public function switchContent( reactEventSource:Dynamic)
	{
		//trace(props.history.location);
		trace(this.state);
		//trace(props.match.params);
		//trace(props.history == App.store.getState().appWare.history);
		//var viewClassPath:String = reactEventSource.target.getAttribute('data-classpath');
		var section:String = reactEventSource.target.getAttribute('data-section');
		trace(section);
		//trace( 'state.section:${props.match.params.section} section:$section');
		//if (state.viewClassPath != viewClassPath)
		if (section != props.match.params.section)
		{
			var basePath:String = props.match.path.split('/:')[0];
			props.history.push('$basePath/$section');
			trace(props.history.location.pathname);
			var sM:SMenuProps = state.sideMenu;
			sM.section = section;
			setState({sideMenu:sM});
			trace('setting state.sideMenu.section to:$section');
			//props.history.push(props.match.url + '/' + viewClassPath);
		}
	}
	
}