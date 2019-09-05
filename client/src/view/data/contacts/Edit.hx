package view.data.contacts;
import haxe.Json;
import js.lib.Promise;
import haxe.ds.IntMap;
import action.AppAction;
import action.DataAction;
import action.async.DBAccess;
import js.html.HTMLOptionsCollection;
import js.html.HTMLPropertiesCollection;
import me.cunity.debug.Out.DebugOutput;
import js.html.Document;
import js.Browser;
import js.html.Window;
import js.html.HTMLCollection;
import js.html.HTMLFormControlsCollection;
import js.html.SelectElement;
import haxe.macro.Type.Ref;
import js.html.InputElement;
import react.React;
import js.html.Element;
import js.html.Event;
import js.html.FormElement;
import react.router.RouterMatch;
import state.AppState;
import haxe.Constraints.Function;
import react.ReactComponent;
import react.ReactEvent;
import react.ReactRef;
import react.ReactMacro.jsx;
import react.ReactUtil.copy;
import shared.DbData;
import shared.DBMetaData;
import view.shared.FormBuilder;
import view.shared.FormField;
import state.FormState;
import model.contacts.ContactsModel;
import view.shared.SMItem;
import view.shared.SMenuProps;
import view.shared.io.FormApi;
import view.shared.io.DataFormProps;
import view.shared.io.DataAccess;
import loader.BinaryLoader;
import view.table.Table;
import model.Contact;

using  shared.Utils;
using Lambda;

/**
 * 
 */

class Edit extends ReactComponentOf<DataFormProps,FormState>
{
	public static var menuItems:Array<SMItem> = [
		{label:'Auswahl',action:'get',section: 'List'},
		{label:'Bearbeiten',action:'edit'},
		{label:'Neu', action:'create'},
		{label:'Löschen',action:'delete'}
	];
	
	var dataDisplay:Map<String,DataState>;
	var dataAccess:DataAccess;	
	var dbData: shared.DbData;
	var dbMetaData:shared.DBMetaData;

	var formRef:ReactRef<FormElement>;
	var fieldNames:Array<String>;
	var actualState:Contact;
	
	public static var initialState:Contact;

	public function new(props) 
	{
		super(props);
		trace(props.match.params);
		initialState = {
			id:null,//2000328,
			edited_by: props.user.id,
			mandator: props.user.mandator
		};	

		//REDIRECT WITHOUT ID OR edit action
		if(props.match.params.id==null && ~/edit(\/)*$/.match(props.match.params.action) )
		{
			trace('nothing selected - redirect');
			var baseUrl:String = props.match.path.split(':section')[0];
			props.history.push('${baseUrl}List/get');
			return;
		}		
		dataAccess = ContactsModel.dataAccess;
		fieldNames = new Array();
		for(k in dataAccess['edit'].view.keys())
		{
			fieldNames.push(k);
		}	
		dataDisplay = ContactsModel.dataDisplay;
		trace('...' + Reflect.fields(props));
		formRef = React.createRef();
		if(props.match.params.id!=null)
			initialState.id = Std.parseInt(props.match.params.id);
		
		trace(props.dataStore.contactActData);
		trace(props.dataStore.contactData);
		if((initialState.id!=null && props.dataStore.contactData.exists(initialState.id)))
		{
			initialState = loadContactData(initialState.id);
			//actualState = copy(initialState);
			trace(actualState);		
			//OK we got the data
			actualState = view.shared.io.Observer.run(actualState, function(newState){
				actualState = newState;
				trace(actualState);
			});	
		}
		else {			
			//actualState = copy(initialState);
			trace(actualState);
		}
		
		state =  App.initEState({
			dataTable:[],
			formBuilder:new FormBuilder(this),
			initialState:initialState,
			loading:false,
			selectedRows:[],
			sideMenu:FormApi.initSideMenu2( this,
				{
					dataClassPath:'data.Contacts',
					label:'Bearbeiten',
					section: 'Edit',
					items: menuItems
				}					
				,{	
					section: props.match.params.section==null? 'Edit':props.match.params.section, 
					sameWidth: true
				}),	
			/*storeListener:App.store.subscribe(function(){
				trace(App.store.getState().dataStore);
			}),*/
			values:new Map<String,Dynamic>()
		},this);
		trace(state.initialState.id);
	}

	function loadContactData(id:Int)
	{
		trace('loading:$id');
		if(id == null)
			return null;
		var c:Contact = {edited_by: props.user.id,mandator: 0};
		var data = props.dataStore.contactData.get(id);
		trace(data);
		for(k=>v in data.keyValueIterator())
		{
			Reflect.setField(c,k, v);
		}
		actualState = view.shared.io.Observer.run(c, function(newState){
				actualState = newState;
			trace(actualState);
		});
		return c;
	}
	
	static function mapStateToProps(aState:AppState) 
	{
		trace(aState);
		return {
			user:aState.user
		};
	}
	
	public function delete(ev:ReactEvent):Void
	{
		trace(state.selectedRows.length);
		var data = state.formApi.selectedRowsMap(state);
	}
		
	override public function componentDidMount():Void 
	{	
		Browser.window.addEventListener('beforeunload', sessionStore);
		var sessContacts = Browser.window.sessionStorage.getItem('contacts');
		if(sessContacts != null)
		{
			trace(Json.parse(sessContacts));
			actualState = Json.parse(sessContacts);
			trace(actualState);
			forceUpdate();
		}
		else if((initialState.id!=null && !App.store.getState().dataStore.contactData.exists(initialState.id)))
		{
			//DATA NOT IN STORE - LOAD IT
			App.store.dispatch(DBAccess.get({
				action:'get',
				className:'data.Contacts',
				table:'contacts',
				filter:	'id|${initialState.id}',
				user:App.store.getState().user
			}));
			//p.then(function ())
			//App.store.dispatch(AppAction.GlobalState('contacts',initialState.id));
			//untyped props.globalState('contacts',initialState.id);
			
		}
		else if(actualState==null){
			actualState = copy(initialState);
			actualState = view.shared.io.Observer.run(actualState, function(newState){
				actualState = newState;
				trace(actualState);
			});	
		}
		if(formRef.current != null)
		{
			//trace(Reflect.fields(formRef.current));
			formRef.current.addEventListener('keyup', handleChange);
			/*var formElement:Element = Browser.window.document.querySelector('form[name="contact"]');
			trace(Reflect.fields(formElement));*/
			formRef.current.addEventListener('mouseup', function(ev:Dynamic)
			{
				//trace(Reflect.fields(ev.originalTarget));
				trace(ev.target.value);
				//doChange(ev.target.name,ev.target.value);
			});
		}
	}
	
	override function shouldComponentUpdate(nextProps:DataFormProps, nextState:FormState) {
		trace('propsChanged:${nextProps!=props}');
		trace('stateChanged:${nextState!=state}');
		if(props.dataStore != null && actualState == null)
		{
			actualState = loadContactData(initialState.id);
			setState({
				initialState:actualState,
				actualState:actualState
			});
		}		
		if(nextState!=state)
			return true;
		return nextProps!=props;
	}

	override public function componentWillUnmount() {
		//state.storeListener();
		var actData:IntMap<Map<String,Dynamic>> = [initialState.id => [
		for(f in Reflect.fields(actualState))
			f => Reflect.field(actualState,f)		
		]];
		trace(actData);
		App.store.dispatch(DataAction.SelectActContacts(actData));
	}

	function sessionStore(){
		trace(actualState);
		Browser.window.sessionStorage.setItem('contacts',Json.stringify(actualState));
		Browser.window.removeEventListener('beforeunload', sessionStore);
	}
	
	public function doChange(name,value) {
		trace('$name: $value');
		if(name!=null && name!='')
		Reflect.setField(actualState,name,value);
		setState({initialState:actualState});
	}

	public function handleChange(e:Event) 
	{
		var el:Dynamic = e.target;
		//trace(Type.typeof(el));
		//trace('${el.name}:${el.value}');
		if(el.name != '' && el.name != null)
		{
			trace('>>${el.name}=>${el.value}<<');
			//trace(actualState);
			Reflect.setField(actualState,el.name,el.value);
			trace(actualState.last_name);
		}	

		//trace(actualState);
	}		

	function handleSubmit(event:Event) {
		//trace(Reflect.fields(event));
		//trace(Type.typeof(event));
		event.preventDefault();
		//var target:FormElement = cast(event.target, FormElement);
		//var elements:HTMLCollection = target.elements;
		//trace(elements.each(function(name:String, el:Dynamic)
		//trace(elements.dynaMap());
		//trace(state.actualState);
		trace(state.initialState.id);
		/*{
			//trace('$name => $el');
			//trace(el.value);
		});		*/
		var doc:Document = Browser.window.document;

		var formElement:FormElement = cast(doc.querySelector('form[name="contact"]'),FormElement);
		var elements:HTMLCollection = formElement.elements;
		for(k in dataAccess['edit'].view.keys())
		{
			if(k=='id')
				continue;
			try 
			{
				var item:Dynamic = elements.namedItem(k);
				//trace('$k => ${item.type}:' + item.value);
				Reflect.setField(actualState, item.name, switch (item.type)
				{
					//case DateControl|DateTimrControl:

					case 'checkbox':
					//trace('${item.name}:${item.checked?true:false}');
					item.checked?1:0;
					case 'select-multiple'|'select-one':
					var sOpts:HTMLOptionsCollection = item.selectedOptions;
					//trace (sOpts.length);
					sOpts.length>1 ? [for(o in 0...sOpts.length)sOpts[o].value ].join('|'):item.value;
					default:
					//trace('${item.name}:${item.value}');
					item.value;
				});			
			}
			catch(ex:Dynamic)
			{
				trace(ex);
			}
		}
		//setState({actualState: actualState});
		trace(actualState);
		update(actualState);
	}


	function update(aState:Dynamic)
	{
		trace(Reflect.fields(aState));
		var dbaProps:DBAccessProps = 
		{
			action:'update',
			className:'data.Contacts',
			dataSource:null,
			table:'contacts',
			user:props.user
		};
		switch (props.match.params.action)
		{
			case 'create':
				for(f in fieldNames)
				{
					trace('$f =>${Reflect.field(aState,f)}<=');
					if(Reflect.field(aState,f)=='')
						Reflect.deleteField(aState,f);
				}
				Reflect.deleteField(aState,'id');
				Reflect.deleteField(aState,'creation_date');				
				dbaProps.dataSource = [
					"contacts" => [
						"data" => aState,
						"fields" => Reflect.fields(aState).join(',')
					]
				];
			case 'delete'|'get':
				dbaProps.dataSource = [
					"contacts" => [
						"filter" => 'id|${state.initialState.id}'
					]
				];	
			case 'edit':
				for(f in fieldNames)
				{
					//KEEP FIELDS WITH VALUES SET
					//trace('$f =>${Reflect.field(aState,f)}<=');
					if(Reflect.field(aState,f)=='')
						Reflect.deleteField(aState,f);
				}
				dbaProps.dataSource = [
					"contacts" => [
						"data" => aState,
						"filter" => 'id|${state.initialState.id}'
					]
				];
		}
		App.store.dispatch(DBAccess.execute(dbaProps));

		//props.parentComponent.props.edit(dbaProps);
	}

	function renderResults():ReactFragment
	{
		trace(props.match.params.section + '/' + props.match.params.action + ' state.dataTable:' + Std.string(state.dataTable != null));
		//trace('###########loading:' + state.loading);
		trace('########### action:' + props.match.params.action);

		return switch(props.match.params.action)
		{
			case 'edit':
				//trace(initialState);
				trace(actualState);
				/*var fields:Map<String,FormField> = [
					for(k in dataAccess['edit'].view.keys()) k => dataAccess['edit'].view[k]
				];*/
				(actualState==null ? state.formApi.renderWait():
				state.formBuilder.renderForm({
					handleSubmit:handleSubmit,
					fields:[
						for(k in dataAccess['edit'].view.keys()) k => dataAccess['edit'].view[k]
					],
					model:'contact',
					ref:formRef,
					title: 'Kontakt - Bearbeite Stammdaten' 
				},actualState));
				//null;
			case 'create':
				trace(actualState);
				state.formBuilder.renderForm({
					handleSubmit:handleSubmit,
					fields:[
						for(k in dataAccess['edit'].view.keys()) k => dataAccess['edit'].view[k]
					],
					model:'contact',
					ref:formRef,
					title: 'Kontakt - Neue Stammdaten' 
				},actualState);
			default:
				null;
		}
	}
	
	override function render():ReactFragment
	{
		trace(props.match.params.action);		
		//trace('state.loading: ${state.loading}');		
		return switch(props.match.params.action)
		{	
			case 'edit':
			 //(state.loading || state.initialState.edited_by==0 ? state.formApi.renderWait():
				state.formApi.render(jsx('
						${renderResults()}
				'));	
			case 'create':
				state.formApi.render(jsx('
						${renderResults()}
				'));		
			default:
				state.formApi.render(jsx('
						${renderResults()}
				'));			
		}
	}
	
	function updateMenu(?viewClassPath:String):SMenuProps
	{
		var sideMenu = state.sideMenu;
		trace(sideMenu.section);
		for(mI in sideMenu.menuBlocks['Contact'].items)
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

}