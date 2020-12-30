package view.data.contacts;
import db.DbRelation;
import db.DbQuery;
import db.DBAccessProps;
import action.async.CRUD;
import haxe.CallStack;
import me.cunity.debug.Out;
import haxe.rtti.Rtti;
import js.html.DOMStringMap;
import haxe.Json;
import js.lib.Promise;
import haxe.ds.IntMap;
import action.AppAction;
import action.DataAction;
import action.async.DBAccess;
import bulma_components.Button;
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
import redux.Redux.Dispatch;
import shared.DbData;
import shared.DBMetaData;
import view.shared.FormBuilder;
import view.shared.FormField;
import state.FormState;
import model.contacts.ContactsModel;
import view.shared.MItem;
import view.shared.MenuProps;
import view.shared.io.BaseForm;
import view.shared.io.FormApi;
import view.shared.io.DataFormProps;
import view.shared.io.DataAccess;
import loader.BinaryLoader;
import view.table.Table;
import model.Contact;

using  shared.Utils;
using Lambda;
using StringTools;

/**
 * 
 */
@:connect
class Edit extends ReactComponentOf<DataFormProps,FormState>
{
	public static var menuItems:Array<MItem> = [
		{label:'Schließen',action:'close'},		
		{label:'Speichern + Schließen',action:'update', then:'close'},
		{label:'Speichern',action:'update'},
		{label:'Zurücksetzen',action:'reset'}
	];
	var dataAccess:DataAccess;	
	var dataDisplay:Map<String,DataState>;
	var formApi:FormApi;
	var formBuilder:FormBuilder;
	var formFields:DataView;
	var formRef:ReactRef<FormElement>;
	var fieldNames:Array<String>;
	var baseForm:BaseForm;
	var contact:Contact;
	var dbData: shared.DbData;
	var dbMetaData:shared.DBMetaData;
	var mounted:Bool = false;

	public function new(props) 
	{
		super(props);
		/*var menuItems:Array<MItem> = [
			{label:'Schließen',action:'close'},		
			{label:'Speichern + Schließen',action:'update', actions:[update,close]},
			{label:'Speichern',action:'update'},
			{label:'Zurücksetzen',action:'reset',onlySm: false}
		];		*/
		baseForm = new BaseForm(this);
		trace(props.match.params);
		//REDIRECT WITHOUT ID OR edit action
		if(props.match.params.id==null && ~/open(\/)*$/.match(props.match.params.action) )
		{
			trace('nothing selected - redirect');
			var baseUrl:String = props.match.path.split(':section')[0];
			props.history.push('${baseUrl}List/get');
			return;
		}		
		dataAccess = ContactsModel.dataAccess;
		fieldNames = baseForm.initFieldNames(dataAccess['open'].view.keys());
		dataDisplay = ContactsModel.dataDisplay;
		
		if(props.dataStore.contactData != null)
			trace(props.dataStore.contactData.keys().next());
				
		state =  App.initEState({
			//dataTable:[],
			actualState:null,
			initialData:null,
			loading:false,
			mHandlers:menuItems,
			selectedRows:[],
			sideMenu:FormApi.initSideMenu( this,
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
		
		trace(state.initialData);
		//trace(state.initialData.id);
		//loadContactData(Std.parseInt(props.match.params.id));
	}

	public function close() {
		// TODO: CHECK IF MODIFIED + ASK FOR SAVING / DISCARDING
		//var baseUrl:String = props.match.path.split(':section')[0];
		props.history.push('${props.match.path.split(':section')[0]}List/get');
	}

	function loadContactData(id:Int):Void
	{
		trace('loading:$id');
		if(id == null)
			return;
		var p:Promise<DbData> = props.load(
			{
				classPath:'data.Contacts',
				action:'get',
				filter:{id:id,mandator:1},
				resolveMessage:{
					success:'Kontakt ${id} wurde geladen',
					failure:'Kontakt ${id} konnte nicht geladen werden'
				},
				table:'contacts',
				dbUser:props.userState.dbUser,
				devIP:App.devIP
			}
		);
		p.then(function(data:DbData){
			trace(data.dataRows.length); 
			if(data.dataRows.length==1)
			{
				var data = data.dataRows[0];
				trace(data);	
				//if( mounted)
				var contact:Contact = new Contact(data);
				trace(contact.id);
				setState({loading:false, actualState:contact, initialData:copy(contact)});
				trace(untyped state.actualState.id + ':' + state.actualState.fieldsInitalized.join(','));
				//setState({initialData:copy(state.actualState)});
				trace(props.location.pathname + ':' + untyped state.actualState.date_of_birth);
				props.history.replace(props.location.pathname.replace('open','update'));
			}
		});
	}
	
	/*static function mapStateToProps(aState:AppState) 
	{
		trace(aState);
		return {
			userState:aState.user
		};
	}*/
	
	public function delete(ev:ReactEvent):Void
	{
		trace(state.selectedRows.length);
		var data = state.formApi.selectedRowsMap(state);
	}

	public function update2():Void
	{
		var data2save = state.actualState.allModified();
		//{edited_by:props.userState.dbUser.id}
	}
		
	override public function componentDidMount():Void 
	{	
		trace('mounted:' + mounted);
		mounted = true;
		loadContactData(Std.parseInt(props.match.params.id));
		//initSession();
	}
	
	/*override function shouldComponentUpdate(nextProps:DataFormProps, nextState:FormState) {
		trace('propsChanged:${nextProps!=props} stateChanged:${nextState!=state}');				
		if(nextState!=state)
			return true;
		return nextProps!=props;
	}*/

	override public function componentWillUnmount() {
		//state.storeListener();
		return;
		var actData:IntMap<Map<String,Dynamic>> = [state.initialData.id => [
		for(f in Reflect.fields(state.actualState))
			f => Reflect.field(state.actualState,f)		
		]];
		trace(actData);
		App.store.dispatch(DataAction.SelectActContacts(actData));
	}

	function mHandlers3(event:Event) {
		//trace(Reflect.fields(event));
		//trace(Type.typeof(event));
		event.preventDefault();
		//var target:FormElement = cast(event.target, FormElement);
		var target:InputElement = cast(event.target, InputElement);
		//trace(Reflect.fields(target));
		trace(target.value);
		var dataSet:DOMStringMap = target.dataset;
		trace(dataSet.action);
		//var elements:HTMLCollection = target.elements;
		//trace(elements.each(function(name:String, el:Dynamic)
		//trace(elements.dynaMap());
		//trace(state.actualState);
		trace(state.initialData.id);
		/*{
			//trace('$name => $el');
			//trace(el.value);
		});		
		var doc:Document = Browser.window.document;

		var formElement:FormElement = cast(doc.querySelector('form[name="contact"]'),FormElement);
		var elements:HTMLCollection = formElement.elements;
		for(k in dataAccess['open'].view.keys())
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
		compareStates();
		//trace(initialData);
		//trace(actualState);*/
		//open();
	}


	function update()
	{
		//trace(Reflect.fields(aState));
		if(state.actualState != null)
			trace('length:' + state.actualState.fieldsModified.length + ':' + state.actualState.fieldsModified.join('|') );
		if(state.actualState == null || state.actualState.fieldsModified.length==0)
			return;
		var data2save = state.actualState.allModified();
		var doc:Document = Browser.window.document;

		var formElement:FormElement = cast(doc.querySelector('form[name="contact"]'),FormElement);
		var elements:HTMLCollection = formElement.elements;
		var aState:Dynamic = copy(state.actualState);
		var dbaProps:DBAccessProps = 
		{
			action:'update',
			classPath:'data.Contacts',
			dataSource:null,
		//	table:'contacts',
			userState:props.userState
		};
		var dbQ:DBAccessProps = {
			classPath:'data.Contacts',
			action:'update',
			data:data2save,
			filter:{id:state.actualState.id,mandator:1},
			resolveMessage:{
				success:'Kontakt ${state.actualState.id} wurde aktualisiert',
				failure:'Kontakt ${state.actualState.id} konnte nicht aktualisiert werden'
			},
			table:'contacts',
			dbUser:props.userState.dbUser,
			devIP:App.devIP
		}
		trace(props.match.params.action);
		switch (props.match.params.action)
		//switch ('update')
		{
			case 'insert':
				for(f in fieldNames)
				{
					trace('$f =>${Reflect.field(aState,f)}<=');
					if(Reflect.field(aState,f)=='')
						Reflect.deleteField(aState,f);
				}
				//Reflect.deleteField(aState,'id');
				//Reflect.deleteField(aState,'creation_date');				
				/*dbaProps.dataSource = [
					"contacts" => [
						"data" => aState,
						"fields" => contact.fieldsModified
					]
				];*/
			case 'delete'|'get':
				dbaProps.dataSource = [
					"contacts" => [
						"filter" => {id:state.initialData.id}
					]
				];	
			case 'update':
				//Reflect.deleteField(aState,'creation_date');
				trace('${state.initialData.id} :: creation_date: ${aState.creation_date} ${state.initialData.creation_date}');
				//var initiallyLoaded = App.store.getState().dataStore.contactData.get(state.initialData.id);
				//trace();
				if(state.actualState != null)
				trace(state.actualState.modified() + ':${state.actualState.fieldsModified}');
				/*for(f in fieldNames)
				{
					//UPDATE FIELDS WITH VALUES CHANGED
					if(Reflect.field(aState,f)!=Reflect.field(state.initialData,f))
					{
						trace('$f:${Reflect.field(aState,f)}==${Reflect.field(state.initialData,f)}<<');
						Reflect.setProperty(contact, f, Reflect.field(aState,f));
						contact.modified(f);
					}						
				}*/
				//trace(aState);
				trace(state.actualState.id);
				if(!state.actualState.modified())
				{
					//TODO: NOCHANGE ACTION => Display Feedback nothing to save
					trace('nothing modified');
					return;
				}
				trace(state.actualState.allModified());
				dbaProps.dataSource = [
					"contacts" => [
						"data" => state.actualState.allModified(),
						"filter" => {id:state.actualState.id}
					]
				];
				trace(dbaProps.dataSource["contacts"]["filter"]);
		}
		//App.store.dispatch(CRUD.update(dbaProps));
		App.store.dispatch(CRUD.update(dbQ));
		
		//App.store.dispatch(DBAccess.execute(dbaProps));
	}

	function renderResults():ReactFragment
	{
		trace(props.match.params.section + '/' + props.match.params.action + ' state.dataTable:' + Std.string(state.actualState != null));
		//trace('###########loading:' + state.loading);
		trace('########### action:' + props.match.params.action);

		return switch(props.match.params.action)
		{
			case 'open'|'update':
				//trace(state.mHandlers);
				trace(state.actualState.id);
				/*var fields:Map<String,FormField> = [
					for(k in dataAccess['open'].view.keys()) k => dataAccess['open'].view[k]
				];*/
				(state.actualState==null ? state.formApi.renderWait():
				state.formBuilder.renderForm({
					mHandlers:state.mHandlers,
					fields:[
						for(k in dataAccess['open'].view.keys()) k => dataAccess['open'].view[k]
					],
					model:'contact',
					ref:formRef,
					title: 'Kontakt - Bearbeite Stammdaten' 
				},state.actualState));
				//null;
			case 'insert':
				trace(state.actualState);
				state.formBuilder.renderForm({
					mHandlers:state.mHandlers,
					fields:[
						for(k in dataAccess['open'].view.keys()) k => dataAccess['open'].view[k]
					],
					model:'contact',
					ref:formRef,
					title: 'Kontakt - Neue Stammdaten' 
				},state.actualState);
			default:
				null;
		}
	}
	
	override function render():ReactFragment
	{
		trace(props.match.params.action);		
		if(state.initialData==null)
			return null;
		//trace('state.loading: ${state.loading}');		
		return switch(props.match.params.action)
		{	
			case 'open':
			 //(state.loading || state.initialData.edited_by==0 ? state.formApi.renderWait():
				state.formApi.render(jsx('
						${renderResults()}
				'));	
			case 'insert':
				state.formApi.render(jsx('
						${renderResults()}
				'));		
			default:
				state.formApi.render(jsx('
						${renderResults()}
				'));			
		}
	}
	
	/*function updateMenu(?viewClassPath:String):MenuProps
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
	}*/

	static function mapDispatchToProps(dispatch:Dispatch) {
		trace('here we should be ready to load');
        return {
            load: function(param:DBAccessProps) return dispatch(CRUD.read(param))
        };
	}
		
	static function mapStateToProps(aState:AppState) 
	{
		return {
			userState:aState.userState
		};
	}
		
}