package view.shared.io;

//import js.lib.Reflect;
import js.Browser;
import css.Overflow.OverflowCompo;
import haxe.Timer;
import state.AppState;
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
import state.UserState;
import react.ReactDOM;

import view.shared.FormInputElement;
import view.shared.FormField;
import state.FormState;
import view.shared.OneOf;
import view.shared.MenuProps;
import view.shared.MItem;
import view.shared.io.DataFormProps;
import view.shared.io.DataAccess.DataDisplay;
import data.DataState;
import react.ReactComponent;
import react.ReactComponent.ReactFragment;
import react.ReactMacro.jsx;
import react.React;
import react.ReactRef;
import react.ReactType;
import react.ReactUtil.copy;

using Lambda;
using shared.Utils;
using view.shared.io.Param;

/**
 * ...
 * @author axel@cunity.me
 */

class FormApi
{
	public var requests:Array<OneOf<HttpJs, XMLHttpRequest>>;	
	public var dataAccess:DataAccess;
	public var dbData:DbData;
	public var dbMetaData:DBMetaData;
	public var formColElements:Map<String,Array<FormField>>;
	//public var dataDisplay:Map<String,DataState>;
	public var _menuItems:Array<MItem>;
	public var fState:FormState;
	public var _fstate:FormState;
	public var modalFormTableHeader:ReactRef<DivElement>;
	public var modalFormTableBody:ReactRef<DivElement>;
	public var autoFocus:ReactRef<InputElement>;
	public var initialState:Dynamic;
	public var section:ReactComponent;
	var comp:ReactComponentOf<DataFormProps,FormState>;
	public var sM:MenuProps;
	
	public function new(rc:ReactComponentOf<DataFormProps,FormState>,?sM:MenuProps)
	{
		comp = rc;
		//requests = [];
		if(comp.props.match != null){
			trace(comp.props.match.path);
			//trace(comp.props.match.params.section);
		}

		if(rc.props != null)
		{
			//trace(rc.props.match);
			//trace(sM);
			this.sM = sM==null?rc.props.sideMenu:sM;
			//trace(rc.props.history);			
			//trace(this.sM);
		}
		//trace('>>>${props.match.params.action}<<<');
		//trace(Reflect.fields(sM));
		//if(rc.props.sideMenu != null)		trace(Utils.arrayKeysList(rc.props.sideMenu.items,'id'));
		//if(sM != null)		trace(Utils.arrayKeysList(sM.items,'id'));
		if(this.sM != null && this.sM.menuBlocks!= null && comp.props.match != null){
			
			//trace(Reflect.fields(this.sM).join('|'));
			if(comp.props.match.params.section != null && this.sM.menuBlocks.exists(comp.props.match.params.section)){
				//trace(this.sM.menuBlocks[comp.props.match.params.section].items[0]);
				trace(Utils.arrayKeysList(this.sM.menuBlocks[comp.props.match.params.section].items, 'id'));
			}
		}
	}	

	public function doAction(?defaultAction:String):Void
	{
		if(comp.props.match != null && (comp.props.match.params.action != null || defaultAction != null))
		{
			var action = (comp.props.match.params.action != null?comp.props.match.params.action:defaultAction);
            trace('going 2 call ${Type.getClassName(Type.getClass(comp))} ${action}');
			executeMethod(action);
		}
	}

	public function createStateValuesArray(data:Array<Map<String,String>>, view:DataDisplay):Array<Map<String,Dynamic>>
	{
		return [ for (r in data) createStateValues(r, view) ];
	}
	
	public function createStateValues(data:Map<String,Dynamic>, view:DataDisplay):Map<String,Dynamic>
	{
		var vState:Map<String,String> = new Map();
		trace(data.keys());
		trace(view.keys());
		for (k in data.keys())
		{
			if(view.exists(k))
			{				
				//vState[k] = (view[k].displayFormat == null?data[k]:view[k].displayFormat(data[k]));
				vState[k] = data[k];
			}
		}
		trace(vState);
		return vState;
	}
		
	public function selectedRowsMap(state:FormState):Array<Map<String,String>>
	{
		return [for (r in state.selectedRows) selectedRowMap(r)];
	}
	
	public function selectedRowMap(row:TableRowElement):Map<String,String>
	{
		var rM:Map<String,String> = [
			for (c in row.cells)
				c.dataset.name => c.innerHTML
		];
		rM['id'] = row.dataset.id;
		return rM;
	}

	public static function dyn2map(d:Dynamic):Map<String,Dynamic> 
	{
		if(d==null)
			return null;
		return [
			for(f in Reflect.fields(d))
				f => Reflect.field(d, f)
		];
		
	}
	
	/*public function setStateFromChild(newState:FormState)
	{
		newState = ReactUtil.copy(newState, {sideMenu:updateMenu(newState)});
		//setState(newState);
		trace(newState);
	}*/

	public function setSectionComponent(s:ReactComponent) {
		section = s;
	}
	
	public function itemHandler(e:Event)
	{
		//trace(Reflect.fields(e));
		e.preventDefault();
		var action:String = cast(e.target, ButtonElement).getAttribute('data-action');
		trace(action);
		callMethod(action, e);
	}

	public function callMethod(method:String, ?e:Event):Bool
	{
		///trace(Reflect.fields(e));
		var eTarget:Element = cast(e.target, Element);
		//trace(Type.typeof(eTarget));
		var targetSection = eTarget.dataset.section;
		//trace('>>$targetSection<< ${comp.props.match.params.section}');
		if(targetSection=='Edit' && comp.state.dataGrid != null){
			//checkSelection
			if(!comp.state.dataGrid.state.selectedRows.keys().hasNext())
			{
				trace(comp.state.dataGrid.state.selectedRows.toString());
				return false;
			}
			//comp.checkSelection();
			//if(App.store.getState().)
		}
		if(eTarget.dataset.then != null)
			comp.props.location.state.extend({then:eTarget.dataset.then});
		if(comp.props.location.state != null)	
			trace(comp.props.location.state);
		
		if(targetSection !=null && targetSection != comp.props.match.params.section)
		{
			trace('$targetSection.$method');

			if(method=='reset' && comp.props.location.state!=null&&comp.props.location.state.activeContactUrl!=null)
			{
				trace('goBack');
				comp.props.history.goBack();
				return true;
			}
			comp.props.history.push(getUrl(eTarget.dataset.action,targetSection),comp.props.location.state);
			return true;
		}
		if(targetSection !=null)
		{
			trace(getUrl(eTarget.dataset.action));
			trace(Type.getClassName(Type.getClass(comp)));
		}
		var formEl:FormElement = untyped e.target.form;
		if (formEl != null)	trace(formEl);
		return executeMethod(method,  (formEl != null? new FormData(formEl):null));
	}

	function executeMethod(method:String, ?r:Dynamic) {
		trace(method);		
		trace(r);		
		//trace( Type.getInstanceFields(Type.getClass(comp)).join('|'));
		//trace(Type.typeof(comp));
		var fun:Function = Reflect.field(comp,method);
		if(Reflect.isFunction(fun))
		{
			Reflect.callMethod(comp,fun,[r]);
			return true;
		}
		trace('$method is not a function');
		return false;
	}

	public function getUrl(?action:String,?targetSection:String):String
	{
		var match:RouterMatch = comp.props.match;
		var baseUrl:String = match.path.split(':section')[0];		
		var section = match.params.section;
		//var id:String = (match.params.id==null||action=='insert'?'':'/${match.params.id}');
		//trace(comp.props.location);
		var id:String = (comp.props.location.hash==''||action=='insert'?'':'/${comp.props.location.hash.substr(1)}');
		return '${baseUrl}${targetSection==null?section:targetSection}/${action}${id}';
	}

	//public static function getTableRoot(match:RouterMatch):Array<String>
	public static function getTableRoot():Array<String>
	{
		//trace(match);var match = ReactRouter.matchPath(Browser.location.pathname,{});
		//trace(Reflect.fields(props).join('|'));
		var tR:Array<String> = Browser.location.pathname.split('/');
		//remove leading empty el
		tR.shift();
		trace(tR.toString());		
		//return tR.push(Browser.location.pathname);
		return tR.concat([Browser.location.pathname]);
		/*trace(Reflect.fields(match).join('|'));
		var baseUrl:String = match.path.split('/:section')[0];
		var newUrl = '${baseUrl}/${match.params.section}/${match.params.action}';
		return ~/^\//.replace(baseUrl,'').split('/').concat([newUrl]);*/
	}

	public function toParams(to:String):String
	{
		var id:String = comp.props.match.params.id;
		return id==null?'':'/$id';
	}
	
	public function selectAllRows(state:FormState,unselect:Bool = false)
	{
		for (r in state.selectedRows)
		{
			if (unselect)
				r.classList.remove('is-selected');
			else
				r.classList.add('is-selected');
		}
	}
	
	public static function mHandlers(e:InputEvent)
	{
		e.preventDefault();
		trace(Type.getClass(e.target));
	}
	
	public function render(content:ReactFragment, err:ReactFragment = null)
	{
		if(sM==null || sM.menuBlocks == null){
			trace(Type.typeof(content));
			return jsx('
				<div className="columns">
					<div className="formsContainer">
					${content}
					</div>
					${err}
				</div>			
			');
			return null;
		}
		if(sM.menuBlocks.exists(sM.section)){
			var mB:MenuBlock = sM.menuBlocks.get(sM.section);
			if(comp.state.mHandlers != null && comp.state.mHandlers.length>mB.items.length){
				mB.items = comp.state.mHandlers;
				sM.menuBlocks.set(sM.section, mB);				
			}
			//trace(sM.menuBlocks.get(sM.section).items[0]);
		}
					
		if(sM.section != null)//TODO: TEST PERFORMANCE + INTEGRITY SETTING SUBMENU SECTION HERE
		{
			trace(sM.section +':'+ comp.props.match.params.section);
			if(sM.section != comp.props.match.params.section && comp.props.match.params.section != null)
			 sM.section = comp.props.match.params.section;
		}
		return jsx('
			<div className="columns">
				<div className="formsContainer">
				${content}
				</div>
				<$Menu className="menu" ${...sM} parentComponent=${comp} itemHandler=${itemHandler} />
				${err}
			</div>			
		');
	}///${...comp.props}
	
	public function renderField(name:String, k:Int, state:FormState):ReactFragment
	{
		var formField:FormField = state.fields[name];
		if(k==0)
			trace(state.handleChange);

		//var field:ReactFragment =  
		return switch(formField.type)
		{
			case Hidden:
				jsx('<input key=${Utils.genKey(k++)} name=${name} type="hidden" defaultValue=${state.values[name]} readOnly=${formField.disabled}/>');
			default:
				[jsx('<label key=${Utils.genKey(k++)}>${formField.label}</label>'), jsx('<input key=${Utils.genKey(k++)} name=${name} defaultValue=${state.values[name]} onChange=${formField.disabled?null:state.handleChange} readOnly=${formField.disabled}/>')];
			
		};
		//return formField.type == Hidden? field:
			//[jsx('<label key=${Utils.genKey(k++)}>${formField.label}</label>'), field];
	}
	
	public function renderElements(cState:FormState):ReactFragment
	{
		trace(cState.data.empty());
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

	public function createElementsArray():ReactFragment
	{
		if(_fstate.dbTable.empty())
			return null;
		formColElements = new StringMap();
		addFormColumns();
		var fields:Iterator<String> = _fstate.fields.keys();
		var pID:String='';//PRIMARY ID
		for (name in fields)			
		{
			if(_fstate.fields[name].type == FormInputElement.Hidden && _fstate.fields[name].primary)
			{
				pID = name;
				break;		
			}
		}

		for (dR in _fstate.dbTable)
		{
			fields = _fstate.fields.keys();
			//trace('>>>${dR['id']}<<<');
			for (name in fields)			
			{
				//public var primaryId:String = '';
				if(_fstate.fields[name].type == FormInputElement.Hidden)
				{
					continue;
				}
					
				var fF:FormField = _fstate.fields[name];
				if(name=='geburts_datum')
				trace(name + '=>' + Std.string(fF.displayFormat));
				formColElements[name].push({
					className:fF.className,
					name:name,
					//?label:String,
					value: Std.string(dR[name]),
					//value:fF.displayFormat == null?dR[name]: fF.displayFormat(dR[name]),
					//?dataBase:String, 
					//?dbTable:String,
					//?dataField:String,c
					displayFormat:fF.displayFormat,
					type:fF.type,
					disabled:fF.disabled,
					required:fF.required,
					//handleChange:fF.handleChange,
					placeholder:fF.placeholder,
					validate:fF.validate
				});
			}
		}
		return renderColumns();
	}
	
	public function addFormColumns():Void
	{
		var fields:Iterator<String> = _fstate.fields.keys();
		for(name in fields)
		{
			if (_fstate.fields[name].type == FormInputElement.Hidden)
				continue;
			formColElements[name] = new Array();
		}
	}
	
	public function renderColumns():ReactFragment
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
	
	public function renderColumnHeaders():ReactFragment
	{
		var fields:Iterator<String> = _fstate.fields.keys();
		var cols:Array<ReactFragment> = [];
		var c:Int = 0;
		for(name in fields)
		{
			if (_fstate.fields[name].type == FormInputElement.Hidden)
				continue;			
			var formField:FormField = _fstate.fields[name];		
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
	
	public function renderRowCell(fF:FormField,k:Int):ReactFragment
	{
		//var model:String = '.${fF.primaryId}.${fF.name}';
		var model:String = fF.name;
		
		return switch(fF.type)
		{
			case Checkbox:
			//trace(fF.value);
				jsx('<input key=${Utils.genKey(k++)} name=${model}  disabled=${fF.disabled}/>');
			case Hidden:
				fF.primary ? null:
				jsx('<inputl key=${Utils.genKey(k++)} name=${model}  type="hidden"/>');
			case FormInputElement.Select:
				jsx('
				<select name=${model}>
				${renderSelectOptions(cast(fF.value))}
				</select>
				');
			default:
				jsx('<input key=${Utils.genKey(k++)} name=${model} type="hidden"/>');
			
		}		
	}
//style=${{visibility:"collapse"}} 
	public function renderRows(name:String):ReactFragment
	{		
		var elements:Array<ReactFragment> = [];
		var k:Int = 0;
		//trace(name);
		elements.push( jsx('
		<div  key=${Utils.genKey(k++)} className="form-table-cell" style=${{minHeight:"0px",height:"0px",overflow:OverflowCompo.Hidden,padding:"0px 0.3rem"}}>
		<div className = "header" data-name= ${name}>${_fstate.fields[name].label}</div>
		</div>'));		
		for (fF in formColElements[name])
		{
			//trace(_fstate.valuesArray[k]);
			//trace(fF);
			elements.push(
			jsx('
			<div key=${Utils.genKey(k++)} className="form-table-cell">${renderRowCell(fF, k++)}</div>
			'));		
		}		
		return elements;
	}
	
	public static function renderSelectOptions(fel:FormInputElement):ReactFragment
	{
		var sel:String = cast fel;
		var opts:Array<String> = AbstractEnumTools.getValues(FormInputElement).map(function(fE:FormInputElement) return cast fE);
		//trace(sel);		trace(opts);selected=${opt==sel}
		var rOpts:Array<ReactFragment> = [];
		var k:Int=0;
		for (opt in opts)
			rOpts.push(jsx('
			<option key=${Utils.genKey(k++)}>$opt</option>
			'));
		return rOpts;
	}
	
	public function renderModalFormBodyHeader():ReactFragment
	{
		modalFormTableHeader = React.createRef();
		if (_fstate.dbTable == null || _fstate.dbTable.length == 0)
			return null;
		return jsx('
		<section className="modal-card-body header" ref=${modalFormTableHeader}>
			<!-- Content Header ... -->
			${renderColumnHeaders()}
		</section>
		');
	}
	

	/*public function renderModalForm(fState:FormState):ReactFragment
	{
		_fstate = fState;
		trace(_fstate); 
		trace(App.modalBox);
		modalFormTableBody = React.createRef();
		App.modalBox.current.classList.toggle('is-active');
		var click:Function = function(_)App.modalBox.current.classList.toggle("is-active");
		var submit:Dynamic->Event->Void = function(tfd, ev){
			trace(tfd);
			if (_fstate.mHandlers != null)
			{
				_fstate.mHandlers[0].handler(tfd);
			}
		};

		return ReactDOM.render( 
			jsx('
		<>
		  	<div className="modal-background" onClick=${click}></div>
		   	<div className="modal-card">
			   	<form onSubmit=${submit} model=${fState.model} initialState=${fState.initialState} >
					<header className="modal-card-head">
					<p className="modal-card-title">${_fstate.title}</p>
					<button className="delete" aria-label="close" onClick=${click} ></button>
					</header>
					${renderModalFormBodyHeader()}
					<div className="modal-card-body"  ref=${modalFormTableBody}>					
					<!-- Content ... -->
						${_fstate.data.empty()? createElementsArray():renderElements(_fstate)}
					</div>
					<footer className="modal-card-foot">
					<input className="button is-success" type="submit" value="Speichern"/>
					<input className="button" type = "reset" value="Reset"/>
					</footer>
				</form>
			</div>
		</> 
		'), App.modalBox.current, adjustModalFormColumns);
	}*/

	public function renderModalScreen(content:ReactFragment):ReactFragment
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
	

	public function adjustModalFormColumns()
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

	function closeWait():Void
	{
		comp.setState({loading:false});
		trace('Done waiting');
	}

	public function renderWait()
	{
			//trace(comp.state);
			//trace(Type.getClass(comp));
			//trace(comp.state.values != null && comp.state.values.get('loadResult' !=null));
			//trace(comp.state.values.get('loadResult'));
			if(comp.state.values != null && comp.state.values.get('loadResult') !=null)
			{
				trace(comp.state.values.get('closeAfter')!=-1?'Y':'N');
				if(comp.state.values.get('closeAfter')!=-1)
				var t:Timer = Timer.delay(closeWait,
					(comp.state.values.get('closeAfter')!=null?comp.state.values.get('closeAfter'):8000));
				return jsx('
			<div className="loader-screen">
				<div className="loader-box">
					<div className="loader-content" >
						${comp.state.values.get('loadResult')}
					</div>
				</div>
			</div>
				');
			}
			else return	jsx('
			<div className="loader-screen" >
				<div className="loader-box">
			  		<div className="loader loader-content"  
					  style=${{width:'6rem', height:'6rem', margin:'auto', borderWidth:'0.64rem'}}/>
			  	</div>
			</div>
			');			
	}	

	public static function params(ids:Array<Int>):String {
		return ids.pInts();
	}

	public static function sParams(ids:Array<String>):String {
		return ids.pStrings();
	}	

	public static function initSideMenu(comp:Dynamic, sMb:MenuBlock, sM:MenuProps):MenuProps
	{
		return initSideMenuMulti(comp,[sMb],sM);
	}

	public static function initSideMenuMulti(comp:Dynamic, sMa:Array<MenuBlock>, sM:MenuProps):MenuProps
	{
		var sma:MenuBlock;
		/*sM.items = [];
		for (sma in sMa)
			sM.items = sM.items.concat(sma.items);
		if(sM.items.length>0)
			trace(sM.items[0]);*/
		sM.menuBlocks = [
			for (sma in sMa)
				sma.section => sma
		];
		return sM;
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
	
	public static function obj2map(obj:Dynamic, ?fields:Array<String>):Map<String,Dynamic>
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
	
	public static function filterMap(m:Map<String,Dynamic>, keys:Array<String>):Map<String,Dynamic>
	{
		var r:Map<String,Dynamic> = new Map();
		for (k in keys)
		{
			r.set(k, m.get(k));
		}
		return r;
	}

	public var ky:Dynamic->haxe.PosInfos->String = Utils.genKey;


}