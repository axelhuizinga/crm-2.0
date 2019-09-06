package view.shared.io;

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
	public var _menuItems:Array<SMItem>;
	public var fState:FormState;
	public var _fstate:FormState;
	public var modalFormTableHeader:ReactRef<DivElement>;
	public var modalFormTableBody:ReactRef<DivElement>;
	public var autoFocus:ReactRef<InputElement>;
	public var initialState:Dynamic;
	public var section:ReactComponent;
	var comp:ReactComponentOf<DataFormProps,FormState>;
	var sM:SMenuProps;
	
	public function new(rc:ReactComponentOf<DataFormProps,FormState>,?sM:SMenuProps)
	{
		comp = rc;
		//trace(Type.getClass(comp));
		requests = [];
		if(rc.props != null)
		{
			//trace(rc.props.match);
			this.sM = sM==null?rc.props.sideMenu:sM;
			//trace(rc.props.history);			
		}
		//dbData = new DbData();
		//trace('>>>${props.match.params.action}<<<');
		trace(Reflect.fields(sM));

        //trace(dbData);
	}	

	public function doAction(?defaultAction:String):Void
	{
		if(comp.props.match != null && (comp.props.match.params.action != null || defaultAction != null))
		{
			var action = (comp.props.match.params.action != null?comp.props.match.params.action:defaultAction);
            trace('going 2 call ${Type.getClassName(Type.getClass(comp))} ${action}');
			callMethod(action);
		}
	}

	public function createStateValuesArray(data:Array<Map<String,String>>, view:DataView):Array<Map<String,Dynamic>>
	{
		return [ for (r in data) createStateValues(r, view) ];
	}
	
	public function createStateValues(data:Map<String,Dynamic>, view:DataView):Map<String,Dynamic>
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
		var action:String = cast(e.target, ButtonElement).getAttribute('data-action');
		var dataSet:DOMStringMap = cast(e.target, ButtonElement).dataset;
		trace(dataSet);
		callMethod(action, e);
	}

	public function callMethod(method:String, ?e:Event):Bool
	{
		//trace(Reflect.fields(e));
		var eTarget:Element = cast(e.target, Element);
		var targetSection = eTarget.dataset.section;
		trace(targetSection);
		if(targetSection != comp.props.match.params.section)
		{
			trace(comp.props.match.params.section);
			comp.props.history.push(getUrl(eTarget.dataset.action,targetSection));
			return true;
		}
		if(targetSection !=null)
		{
			trace(getUrl(eTarget.dataset.action));
			comp.props.history.push(getUrl(eTarget.dataset.action));
			return true;			
			var fun:Function = Reflect.field(section,method);
			if(Reflect.isFunction(fun))
			{
				Reflect.callMethod(section,fun,[e]);
				return true;
			}
			else 
				trace('$method not found in $section');			
		}
		var fun:Function = Reflect.field(comp,method);
		if(Reflect.isFunction(fun))
		{
			Reflect.callMethod(comp,fun,[e]);
			return true;
		}
		else 
			trace('$method not found');
		return false;
	}

	public function getUrl(?action:String,?targetSection:String):String
	{
		var match:RouterMatch = comp.props.match;
		var baseUrl:String = match.path.split(':section')[0];		
		var section = match.params.section;
		var id:String = (match.params.id==null||action=='insert'?'':'/${match.params.id}');
		return '${baseUrl}${targetSection==null?section:targetSection}/${action}${id}';
	}

	public static function getTableRoot(match:RouterMatch):Array<String>
	{
		var baseUrl:String = match.path.split('/:section')[0];
		var newUrl = '${baseUrl}/${match.params.section}/${match.params.action}';
		return ~/^\//.replace(baseUrl,'').split('/').concat([newUrl]);
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

	public function updateMenu(state:FormState,?viewClassPath:String):SMenuProps
	{
		var sideMenu = state.sideMenu;
		if(viewClassPath==null)
			return sideMenu;
		trace(sideMenu.menuBlocks);
		/*sideMenu.menuBlocks['bookmarks'].isActive = true;
		sideMenu.menuBlocks['bookmarks'].label='Lesezeichen';*/
		for(mI in sideMenu.menuBlocks['bookmarks'].items)
		{
			switch(mI.action)
			{		
				case 'update':
					mI.disabled = state.selectedRows.length==0;
				case 'save':
					mI.disabled = state.clean;
				default:

			}			
		}		
		//trace(sideMenu.menuBlocks['user'].items);	
		return sideMenu;
	}	
	
	public static function handleSubmit(e:InputEvent)
	{
		e.preventDefault();
	}	

	
	public function render(content:ReactFragment)
	{
		if(sM.section != null)//TODO: MONITOR PERFORMANCE + INTEGRITY SETTING SUBMENU SECTION HERE
		{
			trace(sM.section +':'+ comp.props.match.params.section);
			if(sM.section != comp.props.match.params.section && comp.props.match.params.section != null)
			 sM.section = comp.props.match.params.section;
		}
		return jsx('
			<div className="columns">
				${content}
				<$SMenu className="menu" ${...sM} ${...comp.props} itemHandler=${itemHandler} />
			</div>			
		');
	}
	
	public function renderField(name:String, k:Int, state:FormState):ReactFragment
	{
		var formField:FormField = state.fields[name];
		if(k==0)
			trace(state.handleChange);

		var field = switch(formField.type)
		{
			case Hidden:
				jsx('<input key=${Utils.genKey(k++)} name=${name} type="hidden" defaultValue=${state.values[name]} readOnly=${formField.disabled}/>');
			default:
				jsx('<input key=${Utils.genKey(k++)} name=${name} defaultValue=${state.values[name]} onChange=${formField.disabled?null:state.handleChange} readOnly=${formField.disabled}/>');
			
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
	
	public function storeFormState(field:String, val:Dynamic) {
		var match:RouterMatch = comp.props.match;
		var baseUrl:String = match.path.split(':section')[0];
		baseUrl = '${baseUrl}${match.params.section}/${match.params.action}';	
		var actualState = App.store.getState().formStates.get(comp.state.formStateKey);
		//Reflect.setField(actualState, field, val);
		//comp.setState({actualState: actualState});
		comp.props.parentComponent.props.storeFormChange(comp.state.formStateKey,copy(actualState,{field:val}));			
	}
	public function createElementsArray():ReactFragment
	{
		if(_fstate.dataTable.empty())
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

		for (dR in _fstate.dataTable)
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
				//trace(name + '=>' + Std.string(fF));
				formColElements[name].push({
					className:fF.className,
					name:name,
					//?label:String,
					value:fF.displayFormat == null?dR[name]: fF.displayFormat(dR[name]),
					//?dataBase:String, 
					//?dataTable:String,
					//?dataField:String,c
					displayFormat:fF.displayFormat,
					type:fF.type,
					disabled:fF.disabled,
					required:fF.required,
					handleChange:fF.handleChange,
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
			trace(fF.value);
				jsx('<input key=${Utils.genKey(k++)} name=${model}  disabled=${fF.disabled}/>');
			case Hidden:
				fF.primary ? null:
				jsx('<inputl key=${Utils.genKey(k++)} name=${model}  type="hidden"/>');
			case FormInputElement.Select:
				jsx('
				<select name=${model}>
				${renderSelectOptions(fF.value)}
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
		<div  key=${Utils.genKey(k++)} className="form-table-cell" style=${{minHeight:"0px",height:"0px",overflow:"hidden",padding:"0px 0.3rem"}}>
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
		if (_fstate.dataTable == null || _fstate.dataTable.length == 0)
			return null;
		return jsx('
		<section className="modal-card-body header" ref=${modalFormTableHeader}>
			<!-- Content Header ... -->
			${renderColumnHeaders()}
		</section>
		');
	}
	

	public function renderModalForm(fState:FormState):ReactFragment
	{
		_fstate = fState;
		trace(_fstate); 
		trace(App.modalBox);
		modalFormTableBody = React.createRef();
		App.modalBox.current.classList.toggle('is-active');
		var click:Function = function(_)App.modalBox.current.classList.toggle("is-active");
		var submit:Dynamic->Event->Void = function(tfd, ev){
			trace(tfd);
			if (_fstate.handleSubmit != null)
			{
				_fstate.handleSubmit(tfd);
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
	}

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
	}

	public function renderWait()
	{
			trace(Type.getClass(comp.state.values));
			//trace(comp.state.values != null && comp.state.values.get('loadResult' !=null));
			trace(comp.state.values.get('loadResult'));
			if(comp.state.values.get('loadResult') !=null)
			{
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

	public static function initSideMenu2(comp:Dynamic, sMb:SMenuBlock, sM:SMenuProps):SMenuProps
	{
		for(sI in sMb.items)
			if(sI.section == null)
				sI.section = sM.section;
		sM.menuBlocks = [sM.section => sMb];
		return sM;
	}

	public static function initSideMenu(comp:Dynamic, sMa:Array<SMenuBlock>, sM:SMenuProps):SMenuProps
	{
		var sma:SMenuBlock;
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