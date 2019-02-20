package view.shared.io;

import js.Syntax;
import shared.DbData;
import haxe.Constraints.Function;
import haxe.EnumTools;
import haxe.ds.Either;
import haxe.ds.Map;
import haxe.ds.StringMap;
import haxe.http.HttpJs;
import js.html.*;
import js.html.Event;
import js.html.HTMLCollection;
import js.html.InputElement;
import js.html.InputEvent;
import js.html.TableRowElement;
import js.html.XMLHttpRequest;
import macrotools.AbstractEnumTools;
import react.ReactDOM;
import react.addon.intl.IntlMixin;
import view.shared.BaseForm;
import view.shared.BaseForm.FormElement;
import view.shared.BaseForm.FormField;
import view.shared.BaseForm.FormState;
import view.shared.BaseForm.FormProps;
import view.shared.BaseForm.OneOf;
import view.shared.SMenu.SMenuProps;
import view.shared.SMenu.SMItem;
import view.shared.io.DataAccess.DataView;
import view.table.Table.DataState;
import react.PureComponent.PureComponentOf;
import react.ReactComponent.ReactFragment;
import react.ReactMacro.jsx;
import react.React;
import react.ReactRef;
import react.ReactUtil;
import redux.Redux;

using Lambda;

/**
 * ...
 * @author axel@cunity.me
 */

typedef DataFormProps =
{
	>FormProps,
	?fullWidth:Bool,
	?setStateFromChild:FormState->Void,
}

class DataAccessForm1 extends PureComponentOf<DataFormProps,FormState>
{
	var mounted:Bool;
	var requests:Array<OneOf<HttpJs, XMLHttpRequest>>;	
	var dataAccess:DataAccess;
	var dbData:DbData;
	var formColElements:Map<String,Array<FormField>>;
	var dataDisplay:Map<String,DataState>;
	var _menuItems:Array<SMItem>;
	var _fstate:FormState;
	var modalFormTableHeader:ReactRef<DivElement>;
	var modalFormTableBody:ReactRef<DivElement>;
	var autoFocus:ReactRef<InputElement>;
	
	public function new(?props:DataFormProps) 
	{
		super(props);
		mounted = false;
		requests = [];
		if(props != null)
		trace(props.match);
		state = {
			data:new StringMap(),
			clean:true,
			errors:new StringMap(),
			hasError:false,
			handleChange:setChangeHandler(),
			handleSubmit:setSubmitHandler(),
			sideMenu: props.sideMenu,
			selectedRows:new Array()
		};
		dbData = new DbData();
	}

	function createStateValuesArray(data:Array<Map<String,String>>, view:DataView):Array<Map<String,String>>
	{
		return [ for (r in data) createStateValues(r, view) ];
	}
	
	function createStateValues(data:Map<String,String>, view:DataView):Map<String,String>
	{
		var vState:Map<String,String> = new Map();
		trace(data.keys());
		trace(view.keys());
		for (k in data.keys())
		{
			if(view.exists(k))
			{
				vState[k] = (view[k].displayFormat == null?data[k]:view[k].displayFormat(data[k]));
			}
		}
		trace(vState);
		return vState;
	}
		
	function selectedRowsMap():Array<Map<String,String>>
	{
		return [for (r in state.selectedRows) selectedRowMap(r)];
	}
	
	function selectedRowMap(row:TableRowElement):Map<String,String>
	{
		var rM:Map<String,String> = [
			for (c in row.cells)
				c.dataset.name => c.innerHTML
		];
		return rM;
	}
	
	function setChangeHandler():InputEvent->Void
	{
		if (props.handleChange)
		{
			if (props.handleChangeByParent != null)
				return props.handleChangeByParent;
			return handleChange;
		}
		return null;
	}

	function setSubmitHandler():InputEvent->Void
	{
		if (props.handleSubmit)
		{
			if (props.handleSubmitByParent != null)
				return props.handleSubmitByParent;
			return handleSubmit;
		}
		return null;
	}
	
	public function setStateFromChild(newState:FormState)
	{
		newState = ReactUtil.copy(newState, {sideMenu:updateMenu()});
		setState(newState);
		//trace(newState);
	}
	
	override public function componentDidMount():Void 
	{
		mounted = true;
		trace(mounted);
	}
	
	override public function componentWillUnmount()
	{
		mounted=false;
		for (r in requests)
		{
			switch(r)
			{
				//HttpJs
				case Left(v): v.cancel();
				//XMLHttpRequest
				case Right(v): v.abort();
			}			
		}
	}
	
	function handleChange(e:InputEvent)
	{
		var t:InputElement = cast e.target;
		//trace('${t.name} ${t.value}');
		var vs = state.values;
		//trace(vs.toString());
		vs[t.name] = t.value;
		trace(vs.toString());
		//t.className = 'input';
		//Reflect.setField(s, t.name, t.value);
		//trace(props.dispatch == App.store.dispatch);
		//App.store.dispatch(AppAction.LoginChange(s));validate
		setState({clean:false, sideMenu:updateMenu(),values:vs});
		//props.setStateFromChild({clean:false});
		//trace(this.state);
	}
	
	function selectAllRows(unselect:Bool = false)
	{
		for (r in state.selectedRows)
		{
			if (unselect)
				r.classList.remove('is-selected');
			else
				r.classList.add('is-selected');
		}
	}
	
	function updateMenu(?viewClassPath:String):SMenuProps
	{
		trace('subclass task');
		return null;
	}
	
	function handleSubmit(e:InputEvent)
	{
		e.preventDefault();
		//trace(props.dispatch); //return;
		this.setState({submitted:true});
		//props.dispatch(AppAction.Login("{user_name:state.user_name,pass:state.pass}"));
		//trace(props.dispatch);
		//props.submit({user_name:state.user_name, pass:state.pass,api:props.api});
		//trace(_dispatch == App.store.dispatch);
		//trace(App.store.dispatch(AsyncUserAction.loginReq(state)));
		//trace(props.dispatch(AppAction.LoginReq(state)));
	}	

	
	override function render()
	{
		return null;		
	}
	
	function renderField(name:String, k:Int):ReactFragment
	{
		var formField:FormField = state.fields[name];
		if(k==0)
			trace(state.handleChange);

		var field = switch(formField.type)
		{
			case Hidden:
				jsx('<input key={k++} name=${name} type="hidden" defaultValue=${state.values[name]} readOnly=${formField.readonly}/>');
			default:
				jsx('<input key={k++} name=${name} defaultValue=${state.values[name]} onChange=${formField.readonly?null:state.handleChange} readOnly=${formField.readonly}/>');
			
		};
		return formField.type == Hidden? field:[jsx('<label key={k++}>${formField.label}</label>'), field];
	}
	
	function renderElements():ReactFragment
	{
		if(state.data.empty())
			return null;
		var fields:Iterator<String> = state.fields.keys();
		var elements:Array<ReactFragment> = [];
		var k:Int = 0;
		for (field in fields)
		{
			elements.push(jsx('<div key=${k} className=${state.fields[field].type==Hidden?null:"formField"} >${renderField(field, k++)}</div>'));
		}
		return elements;
	}
	
	function createElementsArray():ReactFragment
	{
		if(_fstate.dataTable.empty())
			return null;
		formColElements = new StringMap();
		addFormColumns();
		for (dR in _fstate.dataTable)
		{
			var fields:Iterator<String> = _fstate.fields.keys();
			for (name in fields)			
			{
				if(_fstate.fields[name].type == FormElement.Hidden)
					continue;
				var fF:FormField = _fstate.fields[name];
				//trace(name + '=>' + Std.string(fF));
				formColElements[name].push({
					className:fF.className,
					name:name,
					//?label:String,
					value:fF.displayFormat == null?dR[name]: fF.displayFormat(dR[name]),
					//?dataBase:String, 
					//?dataTable:String,
					//?dataField:String,
					displayFormat:fF.displayFormat,
					type:fF.type,
					readonly:fF.readonly,
					required:fF.required,
					handleChange:fF.handleChange,
					placeholder:fF.placeholder,
					validate:fF.validate
				});
			}
		}
		return renderColumns();
	}
	
	function addFormColumns():Void
	{
		var fields:Iterator<String> = _fstate.fields.keys();
		for(name in fields)
		{
			if (_fstate.fields[name].type == FormElement.Hidden)
				continue;
			formColElements[name] = new Array();
		}
	}
	
	function renderColumns():ReactFragment
	{
		var fields:Iterator<String> = formColElements.keys();
		var cols:Array<ReactFragment> = [];
		var col:Int = 0;
		for(name in fields)
		{
			cols.push( jsx('
			<div key=${col++} className="col" data-name=${name}>${renderRows(name)}</div>'));
		}
		return cols;
	}
	
	function renderColumnHeaders():ReactFragment
	{
		var fields:Iterator<String> = _fstate.fields.keys();
		var cols:Array<ReactFragment> = [];
		for(name in fields)
		{
			if (_fstate.fields[name].type == FormElement.Hidden)
				continue;			
			var formField:FormField = _fstate.fields[name];		
			cols.push( jsx('
			<div className="col">
			<div className="form-table-cell">
			<div className="header" data-name=${name}>${formField.label}</div>
			</div>
			</div>
			'));
		}
		return cols;
	}
	
	function renderRowCells(fF:FormField,r:Int):ReactFragment
	{
		return switch(fF.type)
			{
				case Checkbox:
				trace(fF.value);
					jsx('<input key={r} name=${fF.name} type="checkbox" defaultValue=${fF.value==null?'off':'on'} readOnly=${fF.readonly}/>');
				case Hidden:
					jsx('<input key={r} name=${fF.name} type="hidden" defaultValue=${fF.value} readOnly=${fF.readonly}/>');
				case BaseForm.FormElement.Select:
					jsx('
					<select name=${fF.name} defaultValue=${fF.value}>
					${renderSelectOptions(fF.value)}
					</select>
					');
				default:
					jsx('<input key={r} name=${fF.name} defaultValue=${fF.value} onChange=${fF.readonly?null:fF.handleChange} readOnly=${fF.readonly}/>');
				
			}		
	}
//style=${{visibility:"collapse"}} 
	function renderRows(name:String):ReactFragment
	{		
		var elements:Array<ReactFragment> = [];
		var r:Int = 0;
		trace(name);
		elements.push( jsx('
		<div className="form-table-cell" style=${{minHeight:"0px",height:"0px",overflow:"hidden",padding:"0px 0.3rem"}}>
		<div className = "header" data-name= ${name}>${_fstate.fields[name].label}</div>
		</div>'));		
		for (fF in formColElements[name])
		{
			//trace(_fstate.valuesArray[r]);
			//trace(fF);
			elements.push(
			jsx('
			<div className="form-table-cell">${renderRowCells(fF, r++)}</div>
			'));		
		}		
		return elements;
	}
	
	function renderSelectOptions(fel:FormElement):ReactFragment
	{
		var sel:String = cast fel;
		var opts:Array<String> = AbstractEnumTools.getValues(FormElement).map(function(fE:FormElement) return cast fE);
		//trace(sel);		trace(opts);selected=${opt==sel}
		var rOpts:Array<ReactFragment> = [];
		for (opt in opts)
			rOpts.push(jsx('
			<option >$opt</option>
			'));
		return rOpts;
	}
	
	function renderModalFormBodyHeader():ReactFragment
	{
		modalFormTableHeader = React.createRef();
		if (_fstate.dataTable == null || _fstate.dataTable.length == 0)
			return null;
		return jsx('
		<section className="modal-card-body header" ref=${modalFormTableHeader}>
			<!-- Content Header ... -->
			${renderColumnHeaders()}
		</section>
		');
	}
	
	function renderModalForm(fState:FormState):ReactFragment
	{
		_fstate = fState;
		modalFormTableBody = React.createRef();
		App.modalBox.classList.toggle('is-active');
		var click:Function = function(_)App.modalBox.classList.toggle("is-active");
		var submit:Function = function(_){
			if (_fstate.handleSubmit != null)
			{
				var fD:FormData = new FormData(cast modalFormTableBody.current);
				trace(fD);
				_fstate.handleSubmit(fD);
				//_fstate.handleSubmit(cast modalFormTableBody.current);
				//_fstate.handleSubmit(cast(modalFormTableBody.current, js.html.FormElement).elements);
			}
			App.modalBox.classList.toggle("is-active"); 					  
		}
		return ReactDOM.render( 
			jsx('
		<>
		  	<div className="modal-background" onClick=${click}></div>
		   	<div className="modal-card">
				<header className="modal-card-head">
				  <p className="modal-card-title">${_fstate.title}</p>
				  <button className="delete" aria-label="close" onClick=${click}></button>
				</header>
				${renderModalFormBodyHeader()}
				<form className="modal-card-body" ref=${modalFormTableBody}>
				  <!-- Content ... -->
					${_fstate.data.empty()? createElementsArray():renderElements()}
				</form>
				<footer className="modal-card-foot">
				  <button className = "button is-success" 
				  onClick = ${submit} > Speichern</button>
				  <button className="button" onClick=${click}>Schließen</button>
				</footer>
			</div>
		</> 
		'), App.modalBox, adjustModalFormColumns);
	}

	function adjustModalFormColumns()
	{
		trace(modalFormTableHeader);
		var bodyCols:HTMLCollection = modalFormTableBody.current.children;
		var headerCols:HTMLCollection = modalFormTableHeader.current.children;
		var i:Int = 0;
		for (child in bodyCols)
		{
			//trace(child.classList + ':' + child.offsetWidth);
			headerCols.item(i++).setAttribute('style', 'width:' + child.offsetWidth + 'px');
			//child.setAttribute('style', 'width:' + child.offsetWidth + 'px');
			//trace('${"set child" + i + "to:" + child.offsetWidth + "=>"}'+ headerCols[i-1].offsetWidth);
		}
	}
	
	static function localDate(d:String):String
	{
		trace(d);
		trace(Syntax.code("Date.parse({0})",d));
		return DateTools.format(Date.fromTime(Syntax.code("Date.parse({0})",d)), "%d.%m.%Y %H:%M");
		return DateTools.format(Date.fromString(d), "%d.%m.%Y %H:%M");
	}
	
	function obj2map(obj:Dynamic, ?fields:Array<String>):Map<String,Dynamic>
	{
		var m:Map<String,Dynamic> = new Map();
		if (fields == null)
			fields = Reflect.fields(obj);
		for (field in fields)
		{
			m.set(field, Reflect.field(obj, field));
		}
		return m;
	}
	
	function filterMap(m:Map<String,Dynamic>, keys:Array<String>):Map<String,Dynamic>
	{
		var r:Map<String,Dynamic> = new Map();
		for (k in keys)
		{
			r.set(k, m.get(k));
		}
		return r;
	}
	
	public function save(evt:Event)
	{
		evt.preventDefault();
		trace('your subclass has to override me to save anything!');
	}
}