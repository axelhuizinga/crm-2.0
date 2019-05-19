package view.data;

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
import model.AppState;
import react.Fragment;
import react.ReactComponent;
import react.ReactMacro.jsx;
import react.ReactUtil;
import react.ReactType;
import model.AjaxLoader;
import view.data.contacts.Edit;
import view.data.contacts.List;
import view.data.contacts.model.Contacts;
import view.shared.io.DataFormProps;
import view.shared.io.FormApi;
import view.shared.FormState;
import view.shared.OneOf;
import view.shared.SMenu;
import view.shared.SMenuProps;
import view.table.Table;

/**
 * ...
 * @author axel@cunity.me
 */

class Contacts extends ReactComponentOf<DataFormProps,FormState>
{
	//var requests:Array<OneOf<HttpJs, XMLHttpRequest>>;
	public function new(?props:DataFormProps) 
	{
		//trace(props.user);
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
					/*{
						dataClassPath:'data.Contacts',
						label:'Kontakte',
						section: 'List',
						items: List.menuItems
					},*/
					{
						dataClassPath:'data.Contacts',
						label:'Edit',
						section: 'Edit',
						items: Edit.menuItems
					}
				]
				,{	
					section: props.match.params.section==null? 'Contacts':props.match.params.section, 
					sameWidth: true}					
			)
		};
		trace(Reflect.fields(props));		
	}
	
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
			props.history.push('$basePath/Edit');
			trace(props.history.location.pathname);
			trace('setting section to:Edit');
		}		
	
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
			default:
				jsx('
					<$Edit ${...props} fullWidth={true} sideMenu=${state.sideMenu}/>
				');					
		}
	}
	
}