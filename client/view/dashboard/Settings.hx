package view.dashboard;

import react.router.RouterMatch;
import haxe.Json;
import haxe.Serializer;
import haxe.http.HttpJs;
import js.html.XMLHttpRequest;
import me.cunity.debug.Out;
import model.AppState;
import model.AjaxLoader;
import react.React;
import react.ReactComponent.ReactComponentOf;
import react.ReactEvent;
import react.ReactMacro.jsx;
import react.ReactComponent.ReactFragment;
import react.ReactUtil;
//import view.dashboard.model.SettingsFormModel;
import view.shared.io.DataFormProps;
import view.shared.io.Design;
import view.shared.io.FormFunctions;
import view.shared.FormState;
import view.shared.OneOf;
import view.shared.SMenu;
import view.shared.io.Bookmarks;
import view.shared.io.User;

/**
 * ...
 * @author axel@cunity.me
 */

//@:connect
class Settings extends ReactComponentOf<DataFormProps,FormState>
{
	override function componentDidCatch(error, info) {
		// Display fallback UI
		trace(Reflect.fields(state));
		if(state.mounted)
		this.setState({ hasError: true });
		trace(error);
		trace(info);
	}

	public function new(?props:DataFormProps) 
	{
		super(props);	
		/*childFormProps = ReactUtil.copy(props, 
			{fullWidth: true, setStateFromChild:setStateFromChild});*/
		
		state = {
			clean:true,
			hasError:false,
			mounted:false,
			loading:true,
			sideMenu:FormFunctions.initSideMenu( this,
				[
					{
						dataClassPath:'auth.User',
						label:'UserDaten',
						section: 'user',
						items: User.menuItems
					},
					{
						dataClassPath:'settings.Bookmarks',
						label:'Lesezeichen',
						section: 'bookmarks',
						items: Bookmarks.menuItems
					},
					{
						dataClassPath:'settings.Design',
						label:'Design',
						section: 'design',
						items: Design.menuItems
					},										
				],
				{section: 'bookmarks',	sameWidth: true}
			)
		};
		if(props.match.params.section!=null)
		{
			trace(props.match.params.section);
			//state.viewClassPath = state.sideMenu.menuBlocks[props.match.params.section].viewClassPath;
			//state.sideMenu.menuBlocks[props.match.params.section].isActive=true;

		}
		trace('${props.match.params.section} ${props.match.params.action}');
		trace(Reflect.fields(props));
	}

	/*function registerFormContainer(fc:FormFunctions)//
	{
		setState({?formFunctions:FormFunctions:fc});
		trace(fc.props.match.params.section);
	}*/
	
	override public function componentDidMount():Void 
	{
		//
		trace(Reflect.fields(state));
		trace(state.loading);	
		trace(Reflect.fields(props));
		trace(props.match.params.section);				
		//setState{sideMenu:}
	}
	
	/*

		
	static function mapStateToProps(aState:AppState) {
		return function(aState:AppState) 
		{
			var uState = aState.appWare.user;
			//trace(uState);		
			return {
				user:uState
			};
		};
	}	*/
	
	override public function render() {
		return props.formFunctions.render();
	}

	public function renderContent():ReactFragment
	{
		trace(props.match.params);
		return switch(props.match.params.section)
		{
			case "User":
				jsx('
					<User ${...props} sideMenu=${state.sideMenu}
					 fullWidth={true}/>
				');	
			case "Bookmarks"|null:
				jsx('
					<Bookmarks ${...props} sideMenu=${state.sideMenu}
					 fullWidth={true}/>
				');
			default:		
				null;		
		}				
  }	
	
}