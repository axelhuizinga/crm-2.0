package view.data.contacts;
import js.html.DOMStringMap;
import haxe.Json;
import js.lib.Promise;
import haxe.ds.IntMap;
import action.AppAction;
import action.DataAction;
import action.async.DBAccess;
import action.async.DBAccessProps;
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
import view.shared.io.BaseForm;
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

class Edit extends BaseForm//ReactComponentOf<DataFormProps,FormState>
{
	public static var menuItems:Array<SMItem> = [
		{label:'Schließen',action:'restore',section: 'List'},		
		{label:'Speichern + Schließen',action:'updateAndClose'},
		{label:'Speichern',action:'update'},
		{label:'Neu', action:'insert'},
		{label:'Löschen',action:'delete'}
	];
	
	var dbData: shared.DbData;
	var dbMetaData:shared.DBMetaData;

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
		initFieldNames(dataAccess['update'].view.keys());
		dataDisplay = ContactsModel.dataDisplay;
		trace('...' + Reflect.fields(props));
		formRef = React.createRef();
		if(props.match.params.id!=null)
			initialState.id = Std.parseInt(props.match.params.id);
		
		trace(props.dataStore.contactActData);
		trace(props.dataStore.contactData);
		// FOR NOW IGNORE THE dataStore and Observer
		if(initialState.id!=null && props.dataStore.contactData != null && props.dataStore.contactData.exists(initialState.id))
		{
			initialState = loadContactData(initialState.id);
			//actualState = copy(initialState);
			//select(props.data['id'], 
					//[Std.int(props.data['id'])=>props.data], props.parentComponent.props.match);
			trace(actualState);	
			//props.select(initialState.id,[initialState.id => initialState], props.match);
			//OK we got the data
		/*	actualState = view.shared.io.Observer.run(actualState, function(newState){
				actualState = newState;
				trace(actualState);
			});	*/
		}
		else if(initialState.id!=null && (props.dataStore.contactData == null || !props.dataStore.contactData.exists(initialState.id))){			
			//actualState = copy(initialState);
			trace(actualState);
			trace('no data - redirect');
			var baseUrl:String = props.match.path.split(':section')[0];
			props.history.push('${baseUrl}List/get');
			return;			
		}
		
		state =  App.initEState({
			dataTable:[],
			formBuilder:new FormBuilder(this),
			initialState:initialState,
			loading:false,
			handleSubmit:[
				{
					handler:handleSubmit,
					handlerAction:SubmitAndClose,
					label:'Speichern + Schließen',
				},
				{
					handler:handleSubmit,
					handlerAction:Submit,
					label:'Speichern',
				},
				{
					handler:handleSubmit,
					handlerAction:Close,
					label:'Schließen',
				}				
			],
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
		var c:Contact = new Contact({edited_by: props.user.id,mandator: 0});
		//{edited_by: props.user.id,mandator: 0};
		var data = props.dataStore.contactData.get(id);
		trace(data);
		
		//var m:Array<String> = Type.getInstanceFields(Type.getClass(c));//Reflect.fields(c);
		//trace(m.toString());


		for(k=>v in data.keyValueIterator())
		{
			try{
				//trace('$k:$v');
				Reflect.setField(c,k, v);
				}
			catch(ex:Dynamic)
			{
				trace(ex);
			}		
		}
		trace(c.creation_date);
		actualState = initialState = c.copy(data);
		trace(initialState);		
		/*actualState = view.shared.io.Observer.run(initialState, function(newState){
				actualState = newState;
			trace(actualState);
		});*/
		//props.select(initialState.id,[initialState.id => initialState], props.match);
		return initialState;
	}
	
	/*static function mapStateToProps(aState:AppState) 
	{
		trace(aState);
		return {
			user:aState.user
		};
	}*/
	
	public function delete(ev:ReactEvent):Void
	{
		trace(state.selectedRows.length);
		var data = state.formApi.selectedRowsMap(state);
	}
		
	override public function componentDidMount():Void 
	{	
		trace('mounted');
		//initSession();
	}
	
	override function shouldComponentUpdate(nextProps:DataFormProps, nextState:FormState) {
		trace('propsChanged:${nextProps!=props}');
		trace('stateChanged:${nextState!=state}');
		// FOR NOW IGNORE THE dataStore and Observer
		if(false && props.dataStore != null && actualState == null)
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
		return;
		var actData:IntMap<Map<String,Dynamic>> = [initialState.id => [
		for(f in Reflect.fields(actualState))
			f => Reflect.field(actualState,f)		
		]];
		trace(actData);
		App.store.dispatch(DataAction.SelectActContacts(actData));
	}

	override function handleSubmit(event:Event) {
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
		trace(state.initialState.id);
		/*{
			//trace('$name => $el');
			//trace(el.value);
		});		*/
		var doc:Document = Browser.window.document;

		var formElement:FormElement = cast(doc.querySelector('form[name="contact"]'),FormElement);
		var elements:HTMLCollection = formElement.elements;
		for(k in dataAccess['update'].view.keys())
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
		
		trace(initialState);
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
		//	table:'contacts',
			user:props.user
		};
		switch (props.match.params.action)
		{
			case 'insert':
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
			case 'update':
				Reflect.deleteField(aState,'creation_date');
				trace('${initialState.id} :: creation_date: ${aState.creation_date} ${state.initialState.creation_date}');
				//var initiallyLoaded = App.store.getState().dataStore.contactData.get(state.initialState.id);
				trace(initialState);
				for(f in fieldNames)
				{
					//KEEP FIELDS WITH VALUES CHANGED
					//trace('$f =>${Reflect.field(aState,f)}<=');
					
					//if(Reflect.field(aState,f)==initiallyLoaded[f])
					if(Reflect.field(aState,f)==Reflect.field(initialState,f))
						Reflect.deleteField(aState,f);
					else 
						trace('$f:${Reflect.field(aState,f)}==${Reflect.field(initialState,f)}<<');
				}
				trace(aState);
				trace(initialState);
				if(Reflect.fields(aState).length==0)
				{
					//TODO: NOCHANGE ACTION
					return;
				}
				dbaProps.dataSource = [
					"contacts" => [
						"data" => aState,
						"filter" => 'id|${initialState.id}'
					]
				];
				trace(dbaProps.dataSource["contacts"]["filter"]);
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
			case 'update':
				trace(state.handleSubmit);
				trace(actualState);
				/*var fields:Map<String,FormField> = [
					for(k in dataAccess['update'].view.keys()) k => dataAccess['update'].view[k]
				];*/
				(actualState==null ? state.formApi.renderWait():
				state.formBuilder.renderForm({
					handleSubmit:state.handleSubmit,
					fields:[
						for(k in dataAccess['update'].view.keys()) k => dataAccess['update'].view[k]
					],
					model:'contact',
					ref:formRef,
					title: 'Kontakt - Bearbeite Stammdaten' 
				},actualState));
				//null;
			case 'insert':
				trace(actualState);
				state.formBuilder.renderForm({
					handleSubmit:state.handleSubmit,
					fields:[
						for(k in dataAccess['update'].view.keys()) k => dataAccess['update'].view[k]
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
			case 'update':
			 //(state.loading || state.initialState.edited_by==0 ? state.formApi.renderWait():
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