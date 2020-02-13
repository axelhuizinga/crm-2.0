package view.data;

import view.data.deals.Edit;
import view.data.deals.List;

import react.ReactRef;
import react.router.RouterMatch;
import react.router.ReactRouter;
import comments.StringTransform;
import haxe.Serializer;
import haxe.ds.StringMap;
import haxe.Json;
import js.html.XMLHttpRequest;
import haxe.http.HttpJs;
import me.cunity.debug.Out;
import state.AppState;
import react.Fragment;
import react.ReactComponent;
import react.ReactMacro.jsx;
import react.ReactUtil;
import react.ReactType;
import loader.AjaxLoader;

import view.shared.io.DataFormProps;
import view.shared.io.FormApi;
import state.FormState;
import view.shared.OneOf;
import view.shared.SMenu;
import view.shared.SMenuProps;
//import view.shared.io.Deals;
//import view.shared.io.Contact;
//import view.shared.io.Accounts;
import view.table.Table;

/**
 * ...
 * @author axel@cunity.me
 */

class Deals extends ReactComponentOf<DataFormProps,FormState>
{
	//var requests:Array<OneOf<HttpJs, XMLHttpRequest>>;
	public function new(?props:DataFormProps) 
	{
		trace(props.user);
		super(props);	
		trace(Reflect.fields(props));
		trace(props.match.params.section);
		state = {
			clean:true,
			//formApi: new FormApi(this),
			hasError:false,
			mounted:false,
			loading:true,
			sideMenu:FormApi.initSideMenu( this,
				[
					{
						dataClassPath:'data.deals.List',
						label:'Aufträge',
						section: 'List',
						items: List.menuItems
					},
					{
						dataClassPath:'data.deals.Edit',
						label:'Aufträge',
						section: 'Edit',
						items: Edit.menuItems
					}
				]
				,{	
					section: props.match.params.section==null? 'List':props.match.params.section, 
					sameWidth: true}					
			)
		};
		trace(Reflect.fields(props));		
	}
	
	/*static function mapStateToProps() {

		return function(aState:state.AppState) 
		{
			var uState = aState.user;
			//trace(uState);		
			return {
				//appConfig:aState.config,
				id:uState.id,
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
		//setState({mounted:true});
		if (props.match.params.section == null)
		{
			var basePath:String = props.match.url;
			props.history.push('$basePath/List/get', props.location);
			trace(props.history.location.pathname);
			trace('redirecting to $basePath/List/get');
		}		
		trace('${}');
	
	}
	
	override public function render() 
	{
		trace(props.match.params.section);
		//trace(state.sideMenu); 
		return switch(props.match.params.section)
		{
			case "Edit":
				jsx('
					<$Edit ${...props} fullWidth={true} sideMenu=${state.sideMenu}/>
				');					
			case "List":
				jsx('
					<$List ${...props} fullWidth={true} sideMenu=${state.sideMenu}/>
				');						
			default:
				null;					
		}
	}
	
}