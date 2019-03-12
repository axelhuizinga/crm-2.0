package view.shared.io;

import model.AppState;
import redux.Redux.Dispatch;
import react.ReactEvent;
import react.router.ReactRouter;
import react.router.Route.RouteMatchProps;
import react.router.Route.RouteRenderProps;
import react.router.RouterMatch;
import shared.Utils;
import js.Syntax;
import shared.DbData;
import shared.DBMetaData;
import haxe.Constraints.Function;
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
import model.UserState;
import react.ReactDOM;

import view.shared.FormElement;
import view.shared.FormField;
import view.shared.Formprops;
import view.shared.OneOf;
import view.shared.SMenuProps;
import view.shared.SMItem;
import view.shared.io.DataFormProps;
import view.shared.io.DataAccess.DataView;
import view.table.Table.DataState;
import react.ReactComponent;
import react.ReactComponent.ReactFragment;
import react.ReactMacro.jsx;
import react.React;
import react.ReactRef;
import react.ReactType;
import react.ReactUtil;
import react.redux.form.LocalForm;
import react.redux.form.Control;
import react.redux.form.Control.*;
//import react.redux.form.ControlReset;
import react.redux.form.Errors;
import react.redux.form.Field;
import react.redux.form.Fieldset;

using Lambda;

/**
 * ...
 * @author axel@cunity.me
 */

class FormApi
{
	public var requests:Array<OneOf<HttpJs, XMLHttpRequest>>;	
	var dataAccess:DataAccess;
	var dbData:DbData;
	var dbMetaData:DBMetaData;
	var formColElements:Map<String,Array<FormField>>;
	//var dataDisplay:Map<String,Dataprops>;
	var _menuItems:Array<SMItem>;
	var _fprops:FormState;
	var modalFormTableHeader:ReactRef<DivElement>;
	var modalFormTableBody:ReactRef<DivElement>;
	var autoFocus:ReactRef<InputElement>;
	var initialprops:Dynamic;
	var props:DataFormProps;
	var section:String;
	
	public function new(?_props:DataFormProps) 
	{
		requests = [];
		//trace(props.match.params.section);

		props.sideMenu.itemHandler = itemHandler;
		//trace(props.sideMenu.itemHandler);
		 = {
			action:props.match.params.action,
			section:props.match.params.section,
			data:new StringMap(),
			clean:true,
			errors:new StringMap(),
			formFunctions:this,
			hasError:false,
			//handleChange:setChangeHandler(),
			//handleSubmit:setSubmitHandler(),
			mounted:false,
			sideMenu: props.sideMenu,
			selectedRows:new Array()
		};
		dbData = new DbData();
		//trace('>>>${props.match.params.action}<<<');
		if(false && props.match.params.action != null)
		{
			Reflect.callMethod(this, Reflect.field(this, props.match.params.action),null);
		}
	}	

	public function createpropsValuesArray(data:Array<Map<String,String>>, view:DataView):Array<Map<String,Dynamic>>
	{
		return [ for (r in data) createpropsValues(r, view) ];
	}
	
	public function createpropsValues(data:Map<String,Dynamic>, view:DataView):Map<String,Dynamic>
	{
		var vprops:Map<String,String> = new Map();
		trace(data.keys());
		trace(view.keys());
		for (k in data.keys())
		{
			if(view.exists(k))
			{
				vprops[k] = (view[k].displayFormat == null?data[k]:view[k].displayFormat(data[k]));
			}
		}
		trace(vprops);
		return vprops;
	}
		
	public function selectedRowsMap():Array<Map<String,String>>
	{
		//return [for (r in props.selectedRows) selectedRowMap(r)];
		return null;
	}
	
	function selectedRowMap(row:TableRowElement):Map<String,String>
	{
		var rM:Map<String,String> = [
			for (c in row.cells)
				c.dataset.name => c.innerHTML
		];
		rM['id'] = row.dataset.id;
		return rM;
	}

	
	function itemHandler(e:Event)
	{
		trace(cast(e.target, ButtonElement).getAttribute('data-action'));
		var but:ButtonElement = cast(e.target, ButtonElement);
		trace('${section}/${but.getAttribute("data-action")}');
		trace(props.history.location.pathname +':' + props.match.params.section);
		var basePath:String = props.match.path.split('/:')[0];
		props.history.push('$basePath/$section/${but.getAttribute("data-action")}');
		//trace(props.menuBlocks.toString());
	}

	function callMethod(method:String):Bool
	{
		var fun:Function = Reflect.field(this,method);
		if(Reflect.isFunction(fun))
		{
			Reflect.callMethod(this,fun,null);
			return true;
		}
		return false;
	}

	

	
	function getRouterMatch():RouterMatch
	{
		var rmp:RouteMatchProps = cast props.match;
		return ReactRouter.matchPath(props.history.location.pathname, rmp);		
	}

	public function handleChange(e:InputEvent)
	{
		var t:InputElement = cast e.target;
		trace('${t.name} ${t.value}');
		/*var vs = props.values;
		//trace(vs.toString());
		vs[t.name] = t.value;
		trace(vs.toString());
		//t.className = 'input';
		//Reflect.setField(s, t.name, t.value);
		//trace(props.dispatch == App.store.dispatch);
		//App.store.dispatch(AppAction.LoginChange(s));validate
		setprops({clean:false, sideMenu:updateMenu(),values:vs});
		//props.setpropsFromChild({clean:false});
		//trace(this.props);*/
	}
	
	public function handleSubmit(e:InputEvent)
	{
		e.preventDefault();
		//trace(props.dispatch); //return;
		//this.setprops({submitted:true});
		//props.dispatch(AppAction.Login("{user_name:props.user_name,pass:props.pass}"));
		//trace(props.dispatch);
		//props.submit({user_name:props.user_name, pass:props.pass,api:props.api});
		//trace(_dispatch == App.store.dispatch);
		//trace(App.store.dispatch(UserAction.loginReq(props)));
		//trace(props.dispatch(AppAction.LoginReq(props)));
	}	
	
	public function createElementsArray():ReactFragment
	{
		if(_fprops.dataTable.empty())
			return null;
		formColElements = new StringMap();
		addFormColumns();
		var fields:Iterator<String> = _fprops.fields.keys();
		var pID:String='';//PRIMARY ID
		for (name in fields)			
		{
			if(_fprops.fields[name].type == FormElement.Hidden && _fprops.fields[name].primary)
			{
				pID = name;
				break;		
			}
		}

		for (dR in _fprops.dataTable)
		{
			fields = _fprops.fields.keys();
			//trace('>>>${dR['id']}<<<');
			for (name in fields)			
			{
				//var primaryId:String = '';
				if(_fprops.fields[name].type == FormElement.Hidden)
				{
					continue;
				}
					
				var fF:FormField = _fprops.fields[name];
				//trace(name + '=>' + Std.string(fF));
				formColElements[name].push({
					className:fF.className,
					name:name,
					primaryId:pID==''?'':dR[pID],
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
		var fields:Iterator<String> = _fprops.fields.keys();
		for(name in fields)
		{
			if (_fprops.fields[name].type == FormElement.Hidden)
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
			<div key=${Utils.genKey(name +'_' + col++)} className="col" data-name=${name}>${renderRows(name)}</div>'));
		}
		return cols;
	}
	
	function renderColumnHeaders():ReactFragment
	{
		var fields:Iterator<String> = _fprops.fields.keys();
		var cols:Array<ReactFragment> = [];
		var c:Int = 0;
		for(name in fields)
		{
			if (_fprops.fields[name].type == FormElement.Hidden)
				continue;			
			var formField:FormField = _fprops.fields[name];		
			cols.push( jsx('
			<div key=${Utils.genKey(c++)} className="col">
			<div className="form-table-cell">
			<div className="header" data-name=${name}>${formField.label}</div>
			</div>
			</div>
			'));
		}
		return cols;
	}
	
	function renderRowCell(fF:FormField,k:Int):ReactFragment
	{
		//trace(fF.value);
		var model:String = '.${fF.primaryId}.${fF.name}';
		return switch(fF.type)
		{
			case Checkbox:
			trace(fF.value);
				jsx('<$ControlCheckbox key=${Utils.genKey(k++)} model=${model}  controlProps=${{readOnly:fF.readonly}}/>');
			case Hidden:
				fF.primary ? null:
				jsx('<$Control key=${Utils.genKey(k++)} model=${model}  controlProps=${{readOnly:fF.readonly,type:"hidden"}}/>');
			case FormElement.Select:
				jsx('
				<$ControlSelect model=${model}  >
				${renderSelectOptions(fF.value)}
				</$ControlSelect>
				');
			default:
				jsx('<$Control key=${Utils.genKey(k++)} model=${model} controlProps=${{readOnly:fF.readonly,type:"hidden",onChange:fF.readonly?null:fF.handleChange}}/>');
			
		}		
	}
//style=${{visibility:"collapse"}} 
	function renderRows(name:String):ReactFragment
	{		
		var elements:Array<ReactFragment> = [];
		var k:Int = 0;
		//trace(name);
		elements.push( jsx('
		<div  key=${Utils.genKey(k++)} className="form-table-cell" style=${{minHeight:"0px",height:"0px",overflow:"hidden",padding:"0px 0.3rem"}}>
		<div className = "header" data-name= ${name}>${_fprops.fields[name].label}</div>
		</div>'));		
		for (fF in formColElements[name])
		{
			//trace(_fprops.valuesArray[k]);
			//trace(fF);
			elements.push(
			jsx('
			<div key=${Utils.genKey(k++)} className="form-table-cell">${renderRowCell(fF, k++)}</div>
			'));		
		}		
		return elements;
	}
	
	public function renderSelectOptions(fel:FormElement):ReactFragment
	{
		var sel:String = cast fel;
		var opts:Array<String> = AbstractEnumTools.getValues(FormElement).map(function(fE:FormElement) return cast fE);
		//trace(sel);		trace(opts);selected=${opt==sel}
		var rOpts:Array<ReactFragment> = [];
		var k:Int=0;
		for (opt in opts)
			rOpts.push(jsx('
			<option key=${Utils.genKey(k++)}>$opt</option>
			'));
		return rOpts;
	}
	
	function renderModalFormBodyHeader():ReactFragment
	{
		modalFormTableHeader = React.createRef();
		if (_fprops.dataTable == null || _fprops.dataTable.length == 0)
			return null;
		return jsx('
		<section className="modal-card-body header" ref=${modalFormTableHeader}>
			<!-- Content Header ... -->
			${renderColumnHeaders()}
		</section>
		');
	}

	function renderField(name:String, k:Int, state:FormState):ReactFragment
	{
		var formField:FormField = state.fields[name];
		if(k==0)
			trace(state.handleChange);

		var field = switch(formField.type)
		{
			case Hidden:
				jsx('<input key=${Utils.genKey(k++)} name=${name} type="hidden" defaultValue=${state.values[name]} readOnly=${formField.readonly}/>');
			default:
				jsx('<input key=${Utils.genKey(k++)} name=${name} defaultValue=${state.values[name]} onChange=${formField.readonly?null:state.handleChange} readOnly=${formField.readonly}/>');
			
		};
		return formField.type == Hidden? field:[jsx('<label key=${Utils.genKey(k++)}>${formField.label}</label>'), field];
	}
	
	public function renderElements(cState:FormState):ReactFragment
	{
		if(cState.data.empty())
			return null;
		var fields:Iterator<String> = cState.fields.keys();
		var elements:Array<ReactFragment> = [];
		var k:Int = 0;
		for (field in fields)
		{
			elements.push(
				jsx('<div key=${Utils.genKey(k++)} className=${cState.fields[field].type==Hidden?null:"formField"} >${renderField(field, k, cState)}</div>'));
		}
		return elements;
	}	

	public function renderModalForm(fprops:FormState):ReactFragment
	{
		_fprops = fprops;
		trace(_fprops); 
		trace(App.modalBox);
		modalFormTableBody = React.createRef();
		App.modalBox.current.classList.toggle('is-active');
		var click:Function = function(_)App.modalBox.current.classList.toggle("is-active");
		var submit:Dynamic->Event->Void = function(tfd, ev){
			trace(tfd);
			if (_fprops.handleSubmit != null)
			{
				_fprops.handleSubmit(tfd);
			}
		};

		return ReactDOM.render( 
			jsx('
		<>
		  	<div className="modal-background" onClick=${click}></div>
		   	<div className="modal-card">
			   	<LocalForm onSubmit=${submit} model=${fprops.model} initialState=${fprops.initialState} >
					<header className="modal-card-head">
					<p className="modal-card-title">${_fprops.title}</p>
					<button className="delete" aria-label="close" onClick=${click} ></button>
					</header>
					${renderModalFormBodyHeader()}
					<div className="modal-card-body"  ref=${modalFormTableBody}>					
					<!-- Content ... -->
						${_fprops.data.empty()? createElementsArray():renderElements(_fprops)}
					</div>
					<footer className="modal-card-foot">
					<ControlButton controlProps=${{className:"button is-success", type:"submit"}} model=${fprops.model} >Speichern</ControlButton>
					<ControlReset controlProps=${{className:"button"}} model=${fprops.model}>Reset</ControlReset>
					</footer>
				</LocalForm>
			</div>
		</> 
		'), App.modalBox.current, adjustModalFormColumns);
	}

	function renderModalScreen(content:ReactFragment):ReactFragment
	{
		trace(App.modalBox);
		modalFormTableBody = React.createRef();
		App.modalBox.current.classList.toggle('is-active');
		var click:Function = function(_)App.modalBox.current.classList.toggle("is-active");

		return ReactDOM.render( 
			jsx('
		<>
		  	<div className="modal-background" onClick=${click}></div>
		   	<div className="modal-card">
				<header className="modal-card-head">
				<p className="modal-card-title">dada...</p>
				<button className="delete" aria-label="close" onClick=${click} ></button>
				</header>
				
				<div className="modal-card-body"  ref=${modalFormTableBody}>					
				<!-- Content ... -->
					${content}
				</div>
			</div>
		</> 
		'), App.modalBox.current);
	}
	

	function adjustModalFormColumns()
	{
		trace(modalFormTableHeader.current);
		//return;
		trace(modalFormTableBody.current.children);
		var bodyCols:HTMLCollection = modalFormTableBody.current.children;
		var headerCols:HTMLCollection = modalFormTableHeader.current.children;
		trace(bodyCols);
		if(bodyCols==null)
			return;
		var i:Int = 0;
		for (child in bodyCols)
		{
			//trace(child.classList + ':' + child.offsetWidth);
			headerCols.item(i++).setAttribute('style', 'width:' + child.offsetWidth + 'px');
			//child.setAttribute('style', 'width:' + child.offsetWidth + 'px');
			//trace('${"set child" + i + "to:" + child.offsetWidth + "=>"}'+ headerCols[i-1].offsetWidth);
		}
	}

	
	public static function localDate(?d:String):String
	{
		if(d==null)
		{
			d = Date.now().toString();
		}
		trace(d);
		trace(Syntax.code("Date.parse({0})",d));
		return DateTools.format(Date.fromTime(Syntax.code("Date.parse({0})",d)), "%d.%m.%Y %H:%M");
		return DateTools.format(Date.fromString(d), "%d.%m.%Y %H:%M");
	}
	
	public function obj2map(obj:Dynamic, ?fields:Array<String>):Map<String,Dynamic>
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
	
	public function filterMap(m:Map<String,Dynamic>, keys:Array<String>):Map<String,Dynamic>
	{
		var r:Map<String,Dynamic> = new Map();
		for (k in keys)
		{
			r.set(k, m.get(k));
		}
		return r;
	}

	static var ky:Dynamic->haxe.PosInfos->String = Utils.genKey;
}