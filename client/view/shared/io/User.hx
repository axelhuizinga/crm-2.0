package view.shared.io;

import action.AppAction;
import tink.core.Error.Stack;
import haxe.Serializer;
import haxe.ds.StringMap;
import haxe.http.HttpJs;
import haxe.io.Bytes;
import js.html.Event;
import js.html.InputElement;
import js.html.InputEvent;
import js.html.XMLHttpRequest;
import model.AjaxLoader;
import model.UserState;
import react.ReactComponent;
import react.ReactComponent.ReactComponentOf;
import react.ReactComponent.ReactFragment;
import react.ReactEvent;
import react.ReactMacro.jsx;
import react.ReactUtil;
import react.ReactRef;
import shared.DbData;
import view.shared.FormState;
import view.shared.OneOf;
import view.shared.SMenu;
import view.shared.io.FormFunctions;
import view.shared.io.DataAccess;
import view.shared.io.DataFormProps;
import view.shared.io.DataAccess.DataSource;
import view.table.Table;


using Lambda;
using shared.Utils;

/**
 * ...
 * @author axel@cunity.me
 */

typedef UserProps = UserState;


typedef UserModel = DataSource;

typedef UserFilter = Dynamic;

class User extends ReactComponentOf<DataFormProps,FormState>
{
	static var _instance:User;
	public static var menuItems:Array<SMItem> = [
		{label:'Neu',action:'create'},
		{label:'Bearbeiten',action:'edit'},
		{label:'Speichern', action:'save'},
		{label:'Löschen',action:'delete'}
	];
	var dataAccess:DataAccess;
	//var requests:Array<OneOf<HttpJs, XMLHttpRequest>>;
	var autoFocus:ReactRef<InputElement>;
	var dataDisplay:Map<String,DataState>;

	public function new(?props:DataFormProps)
	{
		super(props);
		new FormFunctions(this, props);
		dataAccess = [
			'changePassword' =>
			{
				source:[
					"users" => [
						"fields" => 'user_name,change_pass_required,password']
				],
				view:[
					'user_name' => {type:Hidden},
					'pass' => {type:Password},
					'new_pass' => {type:Password}
				]
			},
			'edit' =>{
				source:[
					"users" => ["alias" => 'us',
						"fields" => 'user_name,last_login,change_pass_required,password'],
					"contacts" => [
						"alias" => 'co',
						"fields" => 'first_name,last_name,email',
						"jCond"=>'contact=co.id']
				],
				view:[
					'user_name'=>{label:'UserID',readonly:true, type:Hidden},
					'pass'=>{label:'Passwort', type:Hidden},
					'first_name'=>{label:'Vorname'},
					'last_name'=>{label:'Name'},
					'email' => {label:'Email'},
					'last_login'=>{label:'Letze Anmeldung',readonly:true, displayFormat:FormFunctions.localDate}
				]
			},
			'save' => {
				source:null,
				view:null
			}
		];
	}
	
	override public function componentDidMount():Void 
	{
			

		
			
		props.formFunctions.requests.push(BinaryLoader.create(
			'${App.config.api}', 
			{				
				user_name:props.user.user_name,
				jwt:props.user.jwt,
				className:'auth.User',
				action:'edit',
				filter:'user_name|${props.user.user_name}',
				dataSource:Serializer.run(dataAccess['edit'].source),
				devIP:App.devIP	
			},
			function(data:DbData)
			{
				trace(Reflect.fields(data));
				//trace(data);
				trace(Reflect.fields(data.dataRows[0]));
				if (data.dataRows[0]['change_pass_required'] == '1')
				{
					setState({data:data.dataRows[0], action:'changePassword',
					fields:dataAccess['changePassword'].view,
					values:props.formFunctions.createStateValues(data.dataRows[0], 
					dataAccess['changePassword'].view), loading:false});	
					App.store.dispatch(AppAction.User({
						first_name:data.dataRows[0]['first_name'],
						last_name:data.dataRows[0]['last_name'],
						user_name:props.user.user_name,
						email:data.dataRows[0]['email'],
						pass:'',
						new_pass:'',
						new_pass_confirm:'',
						waiting:false,
						loggedIn: true,
						last_login:Date.fromString(data.dataRows[0]['last_login']),
					}));				
				}
				else{
					setState({data:data.dataRows[0], action:'edit',
					fields:dataAccess['edit'].view,
					values:props.formFunctions.createStateValues(data.dataRows[0], 
					dataAccess['edit'].view), loading:false});	
					trace(Date.fromString(data.dataRows[0]['last_login']));
					App.store.dispatch(AppAction.User({
						first_name:data.dataRows[0]['first_name'],
						last_name:data.dataRows[0]['last_name'],
						user_name:props.user.user_name,
						email:data.dataRows[0]['email'],
						pass:'',
						waiting:false,
						loggedIn:false,
						last_login:Date.fromString(data.dataRows[0]['last_login']),
					}));
				} 				
			}
		));
	}
	
	override public function componentDidUpdate(prevProps:DataFormProps, prevState:FormState):Void 
	{
		//trace(prevProps);
		//trace(prevState);
		//trace(state.values);
		trace(App.store.getState().appWare.user.first_name);
		//trace(props.match.params.action);
		if(autoFocus!=null)
		autoFocus.current.focus();
	}
	
	public function changePassword(ev:ReactEvent):Void
	{
		trace(state.values);
		trace(props.match.params.action);
		if(props.match.params.action!='changePassword')
		{
			updateMenu('changePassword');
			props.history.push(props.location.pathname + '/user/changePassword/${props.user.user_name}');
			return setState({action:'changePassword'});
		}
		else {
			if(!(state.values['pass'].length>7 && state.values['new_pass'].length>7))
				return setState({errors:['changePassword'=>'Die Passwörter müssen mindestens 8 Zeichen habe!']});
		}
			
		if (state.values['new_pass'] != state.values['new_pass_confirm'])
			return setState({errors:['changePassword'=>'Die Passwörter stimmen nicht überein!']});
		if (state.values['new_pass'] == state.values['pass'] && state.values['new_pass']!='' && state.values['new_pass']!=null)
			return setState({errors:['changePassword'=>'Das Passwort muss geändert werden!']});
		trace(App.store.getState().appWare.user);
		props.formFunctions.requests.push(BinaryLoader.create(
			'${App.config.api}', 
			{				
				user_name:props.user.user_name, 
				jwt:props.user.jwt,
				className:'auth.User',
				action:'changePassword',
				new_pass:state.values['new_pass'],
				pass:state.values['pass'],
				devIP:App.devIP
			},
			function(data:DbData)
			{
				trace(Reflect.fields(data));
				trace(data);
				if (data.dataErrors.keys().hasNext())
				{
					trace(data.dataErrors.toString());
				}
				if (data.dataInfo['changePassword'] == 'OK')
				{
					trace(App.store.getState().appWare.user.dynaMap());
					setState({
						//viewClassPath:'edit',
						fields:dataAccess['edit'].view,
						values:props.formFunctions.createStateValues(App.store.getState().appWare.user.dynaMap(), dataAccess['edit'].view),
					 	loading:false});
				}
				else trace(data.dataErrors);				
			}
		));
	}
	
	public function edit(ev:ReactEvent):Void
	{
		trace('hi :)');
		props.formFunctions.requests.push(Loader.loadData(	
			'${App.config.api}', 
			{
				user_name:props.user.user_name,
				jwt:props.user.jwt,
				className:'auth.User',
				action:'edit',
				filter:'user_name|${props.user.user_name}',
				dataSource:Serializer.run(dataAccess['edit'].source)
			},
			function(data:Array<Map<String,String>>)
			{
				trace(data);
				if (data == null)
					return;
				if (data[0].exists('ERROR'))
				{
					trace(data[0]['ERROR']);
					return;
				}
				//trace(Reflect.fields(dataRows[0]));
				//trace(dataRows[0].active);
				setState({
					//data:data[0],
					fields:dataAccess['edit'].view,
					values:props.formFunctions.createStateValues(data[0], 
					dataAccess['edit'].view), loading:false});					
			}
		));
	}
	
	public function save(evt:Event)
	{
		evt.preventDefault();
		trace(state.data);
		trace(state.values);
		var skeys:Array<String> = untyped dataAccess['edit'].view.keys().arr;
		skeys = skeys.filter(function(k) return !dataAccess['edit'].view[k].readonly);
		trace(FormFunctions.filterMap(state.values, skeys));
		trace(skeys.toString());
		trace(dataAccess['edit'].source);
		//return;,
		props.formFunctions.requests.push(Loader.load(	
			'${App.config.api}', 
			{
				user_name:props.user.user_name,
				jwt:props.user.jwt,
				className:'auth.User',
				action:'save',
				filter:'user_name|${props.user.user_name}',
				dataSource:Serializer.run(dataAccess['edit'].source)
				//dataSource:Serializer.run(filterMap(state.values, skeys))
			},
			function(data:Array<Map<String,String>>)
			{
				trace(data);
				//TODO: ADD SAVED ACTION
				//props.parentForm.setStateFromChild({dataTable:data, loading:false});
				//setState({dataTable:[data], loading:false});					
			}
		));
	}
	
	function updateMenu(?viewClassPath:String):SMenuProps
	{
		var sideMenu = state.sideMenu;
		sideMenu.menuBlocks['users'].isActive = true;
		for(mI in sideMenu.menuBlocks['users'].items)
		{
			switch(mI.action)
			{
				case 'editTableFields':
					mI.disabled = state.selectedRows.length==0;
				case 'save':
					mI.disabled = state.clean;
				default:

			}			
		}		
		return sideMenu;
	}
	
	function renderContent():ReactFragment
	{
		trace(props.match.params.action);
		return switch(props.match.params.action)
		{
			case "edit":		
				props.formFunctions.renderElements(state);
			case "changePassword":
				jsx('
				<>
					${renderErrors('changePassword')}
					<div className="formField">
						<label className="required">Aktuelles Passwort</label>
						<input name="pass" type="password"  onChange=${state.handleChange} autoFocus="true" ref=${autoFocus}/>
					</div>	
					<div className="formField">
						<label className="required">Neues Passwort</label>
						<input name="new_pass" type="password" onChange=${state.handleChange}/>
					</div>				
					<div className="formField">
						<label className="required">Neues Passwort bestätigen</label>
						<input name="new_pass_confirm" type="password" onChange=${state.handleChange}/>
					</div>
				</>				
				');
			default:
				null;
		}
	}

	function renderErrors(name:String):ReactFragment
	{
		trace(name+':'+state.errors.exists(name));
		if(state.errors.exists(name))
		return jsx('
		<div  className="formField">
			${state.errors.get(name)}
		</div>
		');
		return null;
	}
	
	override function render()
	{		
		if(state.values != null)
		trace(state.values);
		return jsx('
			<div className="tabComponentForm"  >
				<form className="form60">
					${renderContent()}
				</form>					
			</div>
		');
	}
	
}
