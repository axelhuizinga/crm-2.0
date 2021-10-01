package view.shared;

//import js.lib.Reflect;
//import model.FormInputElement;
import haxe.Serializer;
import haxe.Unserializer;
import db.DBAccessProps;
import db.DataSource;
import db.DbRelation;
import db.DbRelationProps;
import js.html.KeyboardEvent;
import shared.FindFields;
import js.html.Window;
import haxe.rtti.Meta;
import shared.Utils;
import js.html.FormElement;
import js.html.Element;
import js.html.FormData;
import js.html.FormDataIterator;
import js.html.SelectElement;
import view.shared.io.BaseForm;
import js.html.NodeList;
import js.html.Document;
import state.AppState;
import action.LocationAction;
import js.html.ButtonElement;
import js.html.Event;
import haxe.CallStack;
import me.cunity.debug.Out;
//import view.shared.io.DataAccessForm;
import js.Browser;
import js.html.DivElement;
import haxe.ds.StringMap;
import haxe.Constraints.Function;
import haxe.Timer;
import js.html.InputElement;

import react.ReactComponent;
//import react.ReactComponent.ReactComponentOf;
//import react.ReactComponent.ReactFragment;
import react.React;
import react.ReactType;
import react.ReactMacro.jsx;
import bulma_components.Button;
import react.ReactRef;
import redux.Redux.Dispatch;
import redux.react.ReactRedux;
import view.shared.FormInputElement;
import view.shared.MItem;
import view.shared.MenuBlock;
import view.shared.MenuProps;
import view.shared.MenuState;

using tools.ClassInfo;
using Lambda;

/**
 * ...
 * @author axel@cunity.me
 */

 typedef Filter = ReactType;

//@:connect
@:wrap(react.router.ReactRouter.withRouter)
//@:wrap(ReactRedux.connect(null,mapDispatchToProps))
class Menu extends ReactComponentOf<MenuProps,MenuState>
{
	var menuRef:ReactRef<DivElement>;
	var aW:Int;
	var hasFindForm:Bool;
	
	static function printProps(props:Dynamic):String{
		var dump:String = '';
		for(f in Reflect.fields(props)){
			if(f=='parentComponent'){
				var o = props.parentComponent;
				dump += 'parentComponent.props.match.url:' + o.props.match.url + "\n";
			}
			else
				dump += f + ':' + Std.string(Reflect.field(props, f)) + "\n";
		}
		return dump;
	}

	static function mapDispatchToProps(dispatch:Dispatch):MenuProps
    {
		
      	return {
				switchSection: function(url:String) {
					trace(url);
					dispatch(LocationAction.Push(url));
					//App.store.dispatch(LocationAction.Push(url));
				}
					//,
				//initChildren: function() dispatch()
			};
    }
	
	static function mapStateToProps(state:MenuState) {
		trace(Reflect.fields(state).join('|'));
		/*return {
			userState:aState.userState
		};*/
		return {};
	}

	function getMBA(mbs:Iterator<MenuBlock>):String{
		var mB:MenuBlock = null;
		while(mbs.hasNext()){
			mB = mbs.next();
			if(mB.isActive){
				return mB.label;
				break;
			}
		}
		return props.section;
	}

	public function new(props:MenuProps) 
	{
		super(props);
		//trace(props.menuBlocks);
		trace(Reflect.fields(props));		
		//trace(Reflect.fields(props.menuBlocks.iterator().next()));
		trace(Reflect.fields(props.menuBlocks.iterator().next()));
		var mbs:Iterator<MenuBlock> = props.menuBlocks.iterator();
		while(mbs.hasNext())
			trace(mbs.next().label);
		//var items:Array<MItem> = props.menuBlocks.iterator().next().items;
		var items:Array<MItem> = props.menuBlocks[props.section].items;
		//trace(props.section + ':' + (items==null?'nulll':Std.string(items[0])));
		props.parentComponent.state.sideMenuInstance = this;
		//trace(props.parentComponent.state.mHandlers);
		//var mBA:String = function() return 'x';
		/*var mBA:String = function():Null<String> {
		
				var mB:MenuBlock = null;
				while(mbs.hasNext()){
					mB = mbs.next();
					if(mB.isActive){
						return mB.label;
						break;
					}
				}
				return props.section;
			};*/
		menuRef = React.createRef();
		hasFindForm = false;
		state = {
			hidden:props.hidden||false,
			items: new StringMap(),
			menuBlockActive:getMBA(mbs)			//interactionStates: new StringMap()
		};
		//Out.dumpStack(CallStack.callStack());
		//trace('OK');
	}

	public function enableItems(section:String, ids:Array<String>, ?enable:Bool = true):Void{
		trace(section+':'+ids.join('|'));
		if(props.menuBlocks.exists(section)){
			var mB:MenuBlock = props.menuBlocks[section];
			//trace(mB.items);
			for(mI in mB.items){
				for(id in ids){
					if(mI.id == id){						
						enableBlockItem(section,id,enable);
					}
				}				
			}			
		}
	}

	public function enableBlockItem(block:String,id:String,?enable:Bool = true):Bool
	{
		//trace(state.items.keyNames().join('|'));
		//trace('$id $enable');
		if(!props.menuBlocks.exists(block)||!state.items.exists(id))
			return null;
		var item = Utils.getByKey(props.menuBlocks.get(block).items,id);
		if(item == null){
			return null;
		}
		if(item.formField!=null&&item.formField.submit!=null){
			//trace('looking4:#${item.id+"_submit"}');
			var submit = Browser.document.querySelector('#${item.id+"_submit"}');
			if(enable){
				submit.removeAttribute('disabled');
				submit.addEventListener('click',item.handler);
			}
			else
				submit.setAttribute('disabled',enable?'false':'true');
			//trace(item.handler);
			//trace(getEventListeners(submit)))
		}
		item.disabled = !enable;
		//trace('$id: ${item.disabled}');
		return !item.disabled;
	}	

	public function enableItem(id:String,?enable:Bool = true):Bool
	{
		//trace(state.items.keyNames().join('|'));
		trace('$id $enable');
		if(!state.items.exists(id))
			return null;
		var item = state.items.get(id);
		if(item.formField!=null&&item.formField.submit!=null){
			trace('looking4:#${item.id+"_submit"}');
			var submit = Browser.document.querySelector('#${item.id+"_submit"}');
			if(enable){
				submit.removeAttribute('disabled');
				submit.addEventListener('click',item.handler);
			}
			else
				submit.setAttribute('disabled',enable?'false':'true');
			trace(item.handler);
			//trace(getEventListeners(submit)))
		}
		item.disabled = !enable;
		trace('$id: ${item.disabled}');
		return !item.disabled;
	}

	function clear(evt:Event) {
		evt.preventDefault();
		var form:FormElement = untyped evt.target.form;
		form.reset();
		/*var inputs:NodeList = Browser.document.querySelectorAll('.formRow input');
		var el:InputElement;
		for(i in 0...inputs.length){
			el = cast( inputs[i], InputElement);			
			el.value = '';
		}
		var selects:NodeList = Browser.document.querySelectorAll('.formRow select');
		var sel:SelectElement;
		for(i in 0...selects.length){
			sel = cast(selects[i], SelectElement);
			for(o in 0...sel.options.length){
				if(sel.options[o].defaultSelected)
					sel.options[o].selected = true
			}
		}*/

	}

	function find(evt:Event) {
		evt.preventDefault();
		//trace(untyped evt.target.form);
		//trace(Reflect.fields(props.menuBlocks[props.section].items[0]).join('|'));
		//trace(Reflect.fields(props.menuBlocks[props.section]).join('|'));
		trace(props.menuBlocks[props.section].dataClassPath);
		//trace(props.menuBlocks[props.section]);
		//return;
		//trace(Reflect.fields(props.parentComponent.props).join('|'));
		//trace(Reflect.fields(props.parentComponent.state.sideMenu).join('|'));
		//trace(Reflect.fields(Meta.getFields(props.parentComponent.state.sideMenu.orm)).join('|'));
		//trace(props.parentComponent.state.sideMenu.orm._meta_fields);
		var form:FormElement = untyped evt.target.form;
		
		//trace(form.dataset);
		trace(Reflect.fields(form.dataset).join('|'));
		var fD:FormData = new FormData(form);
		if(Reflect.isFunction(Reflect.field(props.parentComponent, 'find'))){
			return props.parentComponent.find(fD);
		}
		//var fDe:FormDataIterator = fD.entries();
		//while(e:Dynamic = fDe.next())
		fD.forEach(function(d:Dynamic) {
			//trace(d);
		});
		//trace(fD.getAll('*'));
		var inputs:NodeList = Browser.document.querySelectorAll('.formRow input');
		trace(inputs.length);
		//trace(props.menuBlocks[props.section].items);
		var el:InputElement;
		var param:Dynamic = {};
		for(i in 0...inputs.length){
			el = cast( inputs[i], InputElement);
			//trace(i+':'+ el.name + '::' + el.value);
			if(el.value!='')
			el.value = findFormat(el.name, el.value);
			if(StringTools.trim(el.value)!='')
				Reflect.setField(param, el.name,
					matchFormat(el.name,el.value));
		}		
		
		//return props.parentComponent.get(buildDataSource();
		return props.parentComponent.get(buildDataSource(param));
	}	

	function buildDataSource(param:DBAccessProps):DBAccessProps {

		var dS:Map<String,DbRelationProps> = [
			props.menuBlocks[props.section].dbTableName => {
				'alias' : props.menuBlocks[props.section].alias,
				'fields': ''
			}
		];		
		for(item in props.menuBlocks[props.section].items){
			if(item.formField !=null){
				if(item.formField.dbTableName!=null){
					//USE ITEM TABLE
					if(dS.exists(item.formField.dbTableName)){
						dS.get(item.formField.dbTableName).fields = dS.get(item.formField.dbTableName).fields + ',' + item.formField.name;
					}
					else {
						//CREATE
						dS.set(item.formField.dbTableName,{
							'alias':  item.formField.alias,
							'fields': item.formField.name
						});
					}
				}
				else{
					// USE BLOCK TABLE
					dS.get(props.menuBlocks[props.section].dbTableName).fields = dS.get(props.menuBlocks[props.section].dbTableName).fields == ''? item.formField.name: dS.get(props.menuBlocks[props.section].dbTableName).fields + ',' + item.formField.name;
				}
			}
		}
		trace(Type.typeof(dS));
		trace(dS);
		var dsk:Int = 0;
		var ki:Iterator<String> = dS.keys();
		while(ki.hasNext()){
			ki.next();
			dsk++;
		}
		param.filter = BaseForm.filter(props.parentComponent.props,param);
		trace(dsk);
		if(dsk>1)
			param.dbRelations = DbRelation.fromMap(cast dS).tables;//.copy();
		else
			param.dataSource = cast dS;//ONE TABLE
		return param;
		//return BaseForm.copy(param,{dataSource:dS});
	}

	function fieldAlias(name:String):String {
		//?already aliased
		if(name.indexOf('.')>-1)
			return name;
		for(item in props.menuBlocks[props.section].items){
			if(item.formField.name==name)
				return (
					item.formField.alias==null ? props.menuBlocks[props.section].alias : item.formField.alias
				) + '.$name';
		}
		return props.menuBlocks[props.section].alias + '.$name';
	}

	function findFormat(name:String, v:String):String {
		var items:Array<MItem> = props.menuBlocks[props.section].items;//cast props.parentComponent.state.sideMenu.orm.menuItems;
		if(items==null){
			trace(name);
			return v;
		}
		for(item in items){
			if(item.formField!=null && item.formField.findFormat != null && item.formField.name == name)
			{
				trace('$name.findFormat returned:' + item.formField.findFormat(v));
				//trace('$name.findFormat returned:' + Reflect.callMethod(item.formField,item.formField.findFormat,[v]));

				return item.formField.findFormat(v);
			}
		}
		return v;
	}

	function matchFormat(name:String, v:String):String {
		var items:Array<MItem> = props.menuBlocks[props.section].items;//cast props.parentComponent.state.sideMenu.orm.menuItems;
		if(items==null){
			trace(name);
			return v;
		}
		for(item in items){
			if(item.formField!=null && item.formField.matchFormat != null && item.formField.name == name)
			{
				trace('$name.matchFormat returned:' + item.formField.matchFormat(v));
				//trace('$name.matchFormat returned:' + Reflect.callMethod(item.formField,item.formField.matchFormat,[v]));

				return item.formField.matchFormat(v);
			}
		}
		return v;
	}

	function renderHeader():ReactFragment
	{
		if (props.menuBlocks.empty())
			return null;
		var header:Array<ReactFragment> = new Array();
		var i:Int = 1;		
		trace(props.section);
		props.menuBlocks.iter(function(block:MenuBlock) {
			//trace(block.label + '::' + block.onActivate + ':' +check);
			//trace(props.section + '::' + block.section + ':' +check);//data-classpath=${block.viewClassPath}
			header.push( jsx('
			<input type="radio" key=${i}  value=${block.section} id=${"sMenuPanel-"+(i++)} name="accordion-select" checked=${state.menuBlockActive==block.section}  
				onChange=${switchContent} data-section=${block.section} />
			'));
		});
		return header;
	}

	function renderPanels():ReactFragment
	{
		if (props.menuBlocks.empty())
			return null;
		var style:Dynamic = null;
		style = {
			minWidth:App.config.sidebarDims.minWidth,
			maxWidth:App.config.sidebarDims.maxWidth
		};
		style = null;
		//var className = ''; 'panel-block';
		if(props.sameWidth && state.sameWidth>0) {
			//style = {width:'${state.sameWidth}px'};
		}
		var i:Int = 1;
		//style = null;
		var panels:Array<ReactFragment> = [];
		//var panels:Array<ReactFragment> = props.menuBlocks.mapi(renderPanel).array();
		//trace(props.menuBlocks);		
		props.menuBlocks.iter(function(block:MenuBlock)
		{
			//trace(block.handlerInstance);
			panels.push( jsx('	
			<div className="panel" key=${"pa"+i} style=${style}>
				<label className="panel-heading" htmlFor=${"sMenuPanel-"+i}>${block.label}</label>
				<div id=${"pblock" + i} className=${"panel-block body-"+(i++)} children=${renderBlock(block,i)}></div>
			</div>		
			'));
		} );
		//trace(panels.length);
		return panels;
	}	
	
	function renderBlock(block:MenuBlock, i:Int):ReactFragment
	{
		//trace(block);
		var items:ReactFragment = renderItems(block);
		if(block.hasFindForm){
			var blockData:String = '';
			if(block.dbTableName != null){
				blockData = 'data-tableName=${block.dbTableName} data-alias=${block.alias}';
			}
			return jsx('<form data-db-table-name=${block.dbTableName} data-alias=${block.alias} name=${block.dataClassPath} key=${"f_"+i}>$items</form>');
		}
		else{
			return jsx('<>${items}</>');
		}
	}

	function renderItemForm(formFields:Array<FormField>):ReactFragment{
		var formFieldElements:Array<ReactFragment> = [];
		var i = 0;
		for(fF in formFields){
			trace(fF.type);
			formFieldElements.push(
				switch(fF.type){
					case Checkbox:
						jsx('<span key=${"l_"+(i++)}>${fF.label}<input type="checkbox" name=${fF.name} /></span>');
					case Radio: 
						var o:Int = 0;
						var options:ReactFragment = [
						for(k=>v in fF.options.keyValueIterator()){
							jsx('<span key=${"o_"+(o++)}>${v} <input type="radio" name=${fF.name} value=${v} /></span>');
						}];
						jsx('<div className="formRow" key=${"fr_"+(i++)} >
						<label key=${"l_"+i}>${fF.label}</label><div  key=${"opt_"+i} className="formRow2">$options</div>
						</div>');	
					default:
						null;					
				}
			);
		}
		return formFieldElements;
	}

	function renderItems(block:MenuBlock):ReactFragment
	{
		var items:Array<MItem> = block.items;
		if (items == null || items.length == 0)
			return null;
		var B:ReactType = ${bulma_components.Button};
		var i:Int = 1;
		var rItems =  items.map(function(item:MItem):ReactFragment
		{
			if(item.id != null && !state.items.exists(item.id))
			{
				//REGISTER ITEM INTERACTIONSTATE
				state.items.set(item.id, item);
			}
			else{
				if(item.id == null && item.action != null && !state.items.exists(item.action)){
					item.id = item.action;
					state.items.set(item.id, item);
				}
			}

			if(item.separator){ return jsx('<hr key=${"s_"+i++} className="menuSeparator"/>');}
			var type:FormInputElement;
			type = (item.formField==null?Button:(item.formField.type==null?FormInputElement.Text: item.formField.type));
			//trace(i + ':' + type);
			var dis:Bool = !(item.disabled==null||item.disabled==false);
			if(false&&item.formField!=null && item.formField.findFormat !=null)
				trace(item);
			//if(type!=Button)
				//block.hasFindForm = true;
			var itemData:String = '';
			var itemFormField:FormField = item.formField;
			if(itemFormField != null && itemFormField.dbTableName != null){
				itemData = 'data-tableName=${itemFormField.dbTableName} data-alias=${itemFormField.alias}';
				trace(itemFormField);
			}
			return switch(type)
			{
				case Radio: 
					var o:Int = 0;
					var options:ReactFragment = [
					for(k=>v in item.formField.options.keyValueIterator()){
						jsx('<span key=${"o_"+(o++)Y}>${v} <input type="radio"  name=${item.formField.name} value=${v} /></span>');
					}];
					(item.className=="formNoLabel"?
					jsx('<div className="formNoLabel" key=${"fr_"+(i++)} ><div>$options</div></div> '):
					jsx('<div className="formRow" key=${"fr_"+(i++)} >
					<label key=${"l_"+i}>${item.label}</label><div  key=${"opt_"+i} className="formRow2">$options</div>
					</div>'));	
				/*case File:
					jsx('<div key=${"uf"+(i++)}  id="uploadForm"   className="uploadBox" >
					<input  id=${item.formField.name} type="file" name=${item.formField.name} onChange=${item.formField.handleChange} className="fileinput"  />
					<label htmlFor=${item.formField.name} className="button" >${item.label}</label>
					<Button onClick=${item.handler} data-action=${item.action}
				data-section=${item.section} disabled=${item.disabled}>${item.formField.submit}</Button>
				</div>');<div class="recordings">         <span class="label">2021-08-03 09:24:52 </span><br>     <audio controls="" preload="metadata">      <source src="https://pbx.pitverwaltung.de/RECORDINGS/MP3/2021-08-03/20210803-092450_306636275_POSTSTATUS-all.mp3" type="audio/mpeg">     </audio><br>        </div>*/
				
				case Audio:
					// htmlFor=${item.formField.name} ${itemData}
					jsx('<div  key=${"uf"+(i++)}  id="findForm_${i}"   className="formRow1" >         
					<div key=${"l_"+i}>${item.label}</div> 
					<audio  key=${"a_"+i} id="aud_${i}" controls="1" preload="metadata" >
					<source src=${item.formField.src} type="audio/mpeg"/>     
					</audio>
					</div>');

				case Text:
					jsx('<div key=${"uf"+(i++)}  id="findForm_${i}"   className=${item.className==null?"formRow":item.className} >
					<label htmlFor=${item.formField.name}  key=${"l_"+i}>${item.label}</label>
					<input data-alias=${itemFormField.alias} data-db-table-name=${itemFormField.dbTableName} id=${item.formField.name} type="text" name=${item.formField.name} onChange=${item.formField.handleChange} onKeyPress=${function(e:KeyboardEvent){
						//trace(e.charCode);
						if(e.charCode==13) find(e);
					} } className="input"  key=${"i_"+i} />
				</div>');
				case Upload:
					//trace(item.formField.handleChange);		
					trace(item.handler);
					if(item.options!=null&&item.options.length==1&&item.options[0].multiple){
						//jsx('');
						jsx('<div key=${"up"+(i++)}  id="uploadForm"  className="uploadBox" >
						<input id=${item.formField.name} type="file" name=${item.formField.name} onChange=${item.formField.handleChange} className="fileinput" multiple />
						<label htmlFor=${item.formField.name} className="button" >${item.label}</label>
						<button onClick=${item.handler} data-action=${item.action} id=${item.id+"_submit"} className="act" 
					data-section=${item.section} disabled=${dis} >${item.formField.submit}</button>
					</div>');
					}
					else
					jsx('<div key=${"up"+(i++)}  id="uploadForm"  className="uploadBox" >
					<input id=${item.formField.name} type="file" name=${item.formField.name} onChange=${item.formField.handleChange} className="fileinput" $multi />
					<label htmlFor=${item.formField.name} className="button" >${item.label}</label>
					<$B onClick=${item.handler} data-action=${item.action}
				data-section=${item.section} disabled=${dis} >${item.formField.submit}</$B>
				</div>');

				default:
					//trace('key:${"bu"+(i)}');
					if(item.options!=null&&item.options.length>0){

						jsx('<form key=${"bu"+(i++)} name=${item.action}>
						${renderItemForm(item.options)}
						<$B key=${"bu"+(i++)} onClick=${item.handler==null?props.itemHandler:item.handler} data-action=${item.action} data-then=${item.then} data-section=${item.section} disabled=${dis}>${item.label}</$B>
						</form>');
					}
					else
						jsx('<$B key=${"bu"+(i++)} onClick=${item.handler==null?props.itemHandler:item.handler} data-action=${item.action} data-then=${item.then} 					data-section=${item.section} disabled=${dis} >${item.label}</$B>');
			}
		});
		if(block.hasFindForm){			
			rItems.push(jsx('<$B key=${"bu"+(i++)} onClick=${find} data-action="find" data-then=${null}>Finden</$B>'));
			rItems.push(jsx('<$B key=${"bu"+(i++)} onClick=${clear} data-action="clear" data-then=${null}>Zurücksetzen</$B>'));
		}
		//trace(state.items.keyNames());
		return rItems;
	}
	
	override public function render()
	{
		//trace(Reflect.fields(props));
		if(props.menuBlocks == null)
		return null;
		//if(props.parentComponent != null)
		//trace(props.menuBlocks.keys());
		//trace(props.menuBlocks.get('Edit'));
			//trace(Type.getClassName(Type.getClass(props.parentComponent)));
		//trace(props.basePath);
		//menuRef = React.createRef();
		var style:Dynamic = null;
		if(true&&props.sameWidth && state.sameWidth == null)//sameWidth
		{
			style = {
				visibility: 'hidden'
			};
		}
		style = {
			//minWidth:App.config.sidebarDims.minWidth,
			width:App.config.sidebarDims.maxWidth
		}
		return jsx('
		<div className="sidebar is-right"  style=${style} > 
			<aside className="menu" ref=${menuRef}>
				${renderHeader()}
				${renderPanels()}
			</aside>
		</div>	
		');
	}

	public function switchContent(reactEventSource:Dynamic)
	{
		//var viewClassPath:String = reactEventSource.target.getAttribute('data-classpath');
		var switchSection:String = reactEventSource.target.getAttribute('data-section');
		var sPat:EReg = new EReg('(${props.section}_*)$','');
		//trace( 'state.viewClassPath:${state.viewClassPath} viewClassPath:$viewClassPath');
		//trace( 'state.section:${state.section} section:$section');
		//trace(menuRef.get_current().outerHTML);
		//if (section != props.section)
		if (!sPat.match(switchSection))
		//if (state.viewClassPath != viewClassPath)
		{
			//var menuBlocks:
			var basePath:String = props.match.path.split('/:')[0];
			//trace(props.location.pathname);
			props.history.push('$basePath/$switchSection');
		
			//props.switchSection('$basePath/$switchSection');
			//trace(props.history.location.pathname);
			//props.history.push(props.match.url + '/' + viewClassPath);
		}
		else{
			var mP:MenuProps = cast props.parentComponent.state.sideMenu;//, MenuProps.menuBlocks[]
			/*for(k=>v in mP.menuBlocks.keyValueIterator()){
				if(k==sPat.matched(0))
					v.isActive = true;
				else
					v.isActive = false;
			}*/
			//props.parentComponent.setState({});
			trace(mP.menuBlocks[sPat.matched(0)].isActive);
			//trace(props.parentComponent.state.sideMenu.menuBlocks[sPat.matched(0)]);
			trace(sPat.matched(0) );
			mP.menuBlocks[sPat.matched(0)].isActive = true;
			setState({
				menuBlockActive: switchSection
			});
			//var check:Bool =  props.mBshowActive ? block.isActive : props.section==block.section;
			/*block.section**/
		}
	}

	function layout()
	{
		var i:Int = 0;
		var activePanel:Int = null;
		aW = menuRef.current.getElementsByClassName('panel').item(0).offsetWidth;
		trace(aW);//
		/*if(state.sameWidth==null)
		this.setState({sameWidth:aW},function (){
			trace("what's up?");
		});*/
	}
	
	override public function componentDidMount():Void 
	{
		if(props.parentComponent.state.sideMenu==null){
			//trace(Type.getClass(props.parentComponent));
			return;
		}
		//trace(Type.getClass(props.parentComponent));
		//trace(printProps(props));
		props.parentComponent.state.sideMenu.instance = this;
		if(props.sameWidth && state.sameWidth == null)
		{
			//Timer.delay(layout,800);
			//trace(menuRef.current.offsetWidth);
			//layout();
			//trace(menuRef.current.offsetWidth);
		}
	}
	
	override public function componentDidUpdate(prevProps:MenuProps, prevState:MenuState):Void 
	{
		//super.componentDidUpdate(prevProps, prevState);
	}
}