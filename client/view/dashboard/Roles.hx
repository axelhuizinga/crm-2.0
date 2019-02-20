package view.dashboard;

//import gigatables_react.Reactables.ReactableSettings;
import haxe.Serializer;
import haxe.ds.StringMap;
//import haxe.Json;
//import haxe.http.HttpJs;
//import haxe.io.Bytes;
import model.AjaxLoader;
import model.AppState;
import react.ReactComponent.ReactFragment;
import react.ReactComponent;
import shared.DbData;

import view.shared.io.BinaryLoader;
import view.table.Table;
//import react.ReactComponent.ReactComponentOfProps;
import react.ReactEvent;
import react.ReactMacro.jsx;
import react.ReactUtil;
import react.ReactType;
import redux.Redux.Dispatch;
import view.dashboard.model.RolesFormModel;
import view.shared.io.DataFormProps;
import view.shared.io.FormFunctions;
import view.shared.FormState;
import view.shared.SMenu;
import view.shared.SMenuProps;
import view.shared.io.Users;
using Lambda;
/**
 * ...
 * @author axel@cunity.me
 */

@:connect
class Roles extends ReactComponentOf<DataFormProps,FormState>
{			
	public function new(?props:DataFormProps) 
	{
		super(props);
		//dataDisplay = RolesFormModel.dataDisplay;		
		state = {
			clean:true,
			hasError:false,
			mounted:false,
			loading:true,
			sideMenu:FormFunctions.initSideMenu( this,
				[
					{
						dataClassPath:'roles.User',
						label:'Benutzer',
						section: 'Users',
						items: Users.menuItems
					},
					{
						dataClassPath:'settings.Bookmarks',
						label:'Benutzergruppen',
						section: 'Bookmarks',
						items: []//Bookmarks.menuItems
					},
					{
						dataClassPath:'roles.Permissions',
						label:'Rechte',
						section: 'permissions',
						items: []//Design.menuItems
					},										
				],
				{section: 'Users',	sameWidth: true}
			)
		};
		trace(Reflect.fields(props));
	}
	
	public function createUsers(ev:ReactEvent):Void
	{
		
	}
	public function editUsers(ev:ReactEvent):Void
	{
		
	}
	public function deleteUsers(ev:ReactEvent):Void
	{
		
	}
	
	public function createUserGroups(ev:ReactEvent):Void
	{
		
	}
	public function editUserGroups(ev:ReactEvent):Void
	{
		
	}
	public function deleteUserGroups(ev:ReactEvent):Void
	{
		
	}	
	public function createRoles(ev:ReactEvent):Void
	{
		
	}
	public function editRoles(ev:ReactEvent):Void
	{
		
	}
	public function deleteRoles(ev:ReactEvent):Void
	{
		
	}	
	
	
	public function importExternalUsers(ev:ReactEvent):Void
	{
		trace(ev.currentTarget);
		props.formContainer.requests.push(AjaxLoader.load(
			'${App.config.api}', 
			{
				user_name:props.user.user_name,
				jwt:props.user.jwt,
				first_name:props.user.first_name,
				className:'admin.CreateUsers',
				action:'importExternal'
			},
			function(data){
				trace(data);				
			}
		));
	}
	
	static function mapStateToProps(aState:AppState) {
		return function(aState:model.AppState) 
		{
			var uState = aState.appWare.user;
			trace(uState);		
			return {
				user:uState
			};
		};
	}	
	
	override public function componentDidMount():Void 
	{
		
		trace(state.loading);
		
		//props.formContainer.requests.push(
			BinaryLoader.create(
			'${App.config.api}', 
			{
				user_name:props.user.user_name,
				jwt:props.user.jwt,
				className:'roles.Users',
				action:'list',
				filter:'active|TRUE',
				dataSource:Serializer.run([
					"users" => ["alias" => 'us',
						"fields" => 'user_name,last_login'],
					"user_groups" => [
						"alias" => 'ug', 
						"fields" => 'name', 
						"jCond"=>'ug.id=us.user_group'],
					"contacts" => [
						"alias" => 'co', 
						"fields" => 'first_name,last_name,email', 
						"jCond"=>'contact=co.id']
				]),
				devIP:App.devIP
			},
			function(data:DbData)
			{
				trace(Reflect.fields(data));
				//trace(data);
				trace(data.dataRows[0]);
				setState({dataTable:data.dataRows, loading:false});					
				//setState({data:['userList'=>data.dataRows], loading:false});					
			}
		);
	}
	
	/*override public function componentWillUnmount()
	{
		for (r in requests)
			r.cancel();
	}
	//columnSizerProps = {{}}defaultSort = ${{column:"full_name", direction: SortDirection.ASC}}
    override function render() {
		trace(Reflect.fields(props));
		//trace(state);
		//trace(props);
        return jsx('		
				<div className="columns">
					<div className="tabComponentForm" children={renderContent()} />
					<SMenu className="menu" menuBlocks={state.sideMenu.menuBlocks}/>					
				</div>		
        ');
    }	*/	
	
	override public function render() {
		var sM:SMenuProps = state.sideMenu;
		if(sM.menuBlocks != null)
			trace(sM.menuBlocks.keys().next() + ':' + props.match.params.section);
		return jsx('
			<div className="columns">
				${renderContent()}
				<$SMenu className="menu" {...sM} />
			</div>			
		');		
		//return jsx('<FormContainer ${...props} sideMenu=${state.sideMenu} render=${renderContent}/>');
	}

	function renderContent():ReactFragment
	{
		trace(props.match.params.action);
		return switch(props.match.params.action)
		{
			case "userList":
				jsx('
					<$Users	${...props} fullWidth={true}  />				
				');				
			default:
				null;
		}
	}
	
}

/**formContainer=${cState.formContainer}
 * 							autoSize = {true} 
							headerClassName = "table tablesorter is-striped is-fullwidth is-hoverable"
							headerColumns=${displayUsers}
							oddClassName="trOdd"
							evenClassName = "trEven"
							sortColumn = "full_name"
							sortDirection = {SortDirection.ASC}
*/