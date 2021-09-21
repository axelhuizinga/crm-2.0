package view.shared.io;

import action.AppAction;
import model.ORM;
import haxe.Constraints.Function;
import model.Contact;
import haxe.Json;
import action.async.DBAccess;
import state.AppState;
import haxe.ds.Map;
import js.html.Document;
import js.html.Event;
import js.html.FormElement;
import js.html.HTMLCollection;
import js.html.HTMLOptionsCollection;
import js.Browser;
import me.cunity.debug.Out;
import react.ReactComponent;
import react.ReactEvent;
import react.ReactMacro.jsx;
import react.ReactPaginate;
import react.ReactRef;
import react.ReactUtil;
import react.ReactUtil.copy;
import view.shared.FormBuilder;
import state.FormState;
import view.dashboard.model.DBSyncModel;
import view.shared.MItem;
import view.shared.io.FormApi;
import view.shared.io.DataFormProps;
import view.shared.io.DataAccess;
import view.table.Table;

class BaseForm
{
	//var comp:ReactComponentOf<DataFormProps,FormState>;

	//public static function addRecordings(state:FormState, recs:Array<Map<String,String>>){
	public static function addRecordings(state:FormState, recs:Array<Dynamic>){
		//trace(rec);
		var recItems:Array<MItem> = [];
		for(rec in recs) recItems.push(
		{
			//id:'returnDebitFile',
			label: rec.start_time,
			formField:{				
				//(rec['location'].contains('85.25.93.167')?
				src: StringTools.replace(rec.location,'85.25.93.167','pbx.pitverwaltung.de'),//:rec['location'])
				type:Audio
			}
		});
		//trace(state.mHandlers.length + '::' + state.sideMenu.menuBlocks[state.sideMenu.section].items.length);
		state.mHandlers = state.sideMenu.menuBlocks[state.sideMenu.section].items.concat(recItems.filter(function(mi:MItem) {
			//	TODO: WHY DO WE NEED THIS FILTER?
			//for(si in state.mHandlers){
			for(si in state.sideMenu.menuBlocks[state.sideMenu.section].items){			
				//trace(si);
				if(si.formField != null && si.formField.src.length >0){
					//trace(mi.formField.src + ' == ' + si.formField.src);
					if(mi.formField.src == si.formField.src){ 					
						return false;
					}
				}
			}
			return true;
		}));
		//{separator: true},		
		//trace(state.mHandlers.length + '::' + state.sideMenu.menuBlocks[state.sideMenu.section].items.length);
		//trace(state.mHandlers.toString());
		//{label: 'ID',formField: { name: 'id'}},
	}

	public static function compareStates(comp:Dynamic) {
		var dObj:ORM = cast(comp.state.actualState, ORM);
		for(f in Reflect.fields(dObj))
		{
			trace('$f:${Reflect.field(comp.state.actualState,f)}<==>${Reflect.field(comp.state.initialState,f)}<');
		}
	}

	public static function doChange(comp:Dynamic,name:String,value:Dynamic) {		
		//trace(comp.state.actualState);
		//trace(Type.getClassName(Type.getClass(comp)));
		//trace('$name: $value ');
		//if(comp.state.actual)
		//trace('$name: $value ' + Type.typeof(untyped comp.state.ormRefs.get('deals').orms.get(75)));
		if(name!=null && name!=''){
			trace(Reflect.getProperty(comp.state.actualState,name));
			Reflect.setProperty(comp.state.actualState,name,value);
			trace(Reflect.getProperty(comp.state.actualState,name));
		}
		return;
		//Reflect.setProperty(comp.state.actualState,name,value);
		trace(Reflect.field(comp.state.actualState, name));
		//Reflect.set(comp.state.actualState,name,value);
		//setState({comp.state.initialState:comp.state.actualState});
	}

	public static function filter(props:DataFormProps,?param:Dynamic):Dynamic {
		//TODO: Get mandator from user
		var filter:Dynamic = copy({mandator:'1'},param);		
		if(props.match.params.id!=null){
			filter.id = props.match.params.id;
		}
		return filter;
	}

	public static function copy(ob:Dynamic, ?ob2:Dynamic, useNull:Bool=false):Dynamic {
		var res:Dynamic = {};
		for(f in Reflect.fields(ob)){
			Reflect.setField(res,f,Reflect.field(ob,f));
		}
		for(f in Reflect.fields(ob2)){
			if(useNull || Reflect.field(ob2,f)!=null)
				Reflect.setField(res,f,Reflect.field(ob2,f));
		}
		return res;
	}

	/*public function handleChange(e:Event) get(BaseForm.filter(props, arg));
	{
		var el:Dynamic = e.target;
		trace(Type.typeof(el));
		//trace('${el.name}:${el.value}');
		if(el.name != '' && el.name != null)
		{
			trace('>>${el.name}=>${el.value}<<');
			//trace(comp.state.actualState);
			Reflect.setField(comp.state.actualState,el.name,el.value);
			trace(Reflect.field(comp.state.actualState, el.name));
		}	

		//trace(comp.state.actualState);
	}	*/	

	public static function initFieldNames(keys:Iterator<String>):Array<String> {
		var fieldNames = new Array();
		for(k in keys)
		{
			fieldNames.push(k);
		}		
		return fieldNames;
	}

	/**
	 * [Check if ORM data is modified]
	 * @param path 
	 * @param params 
	 * @return Bool
	 */	
	public static function ormsModified(cmp:Dynamic):Bool {
		var ormRefs:Map<String,ORMComps> = cast cmp.ormRefs;
		for(model=>ormRef in ormRefs.keyValueIterator()){
			for(orm in ormRef.orms.iterator())
				if(orm.modified())
					return true;
		}
		return false;
	}

	public static function warn(text:String) {
		App.store.dispatch(Status(Update( 
			{	className:'warn',
				text:text
			}
		)));
	}

	public function storeParams(path:String, params:Dynamic):Map<String,Map<String,String>>
	{
		var pMap = [
			for(f in Reflect.fields(params))
				f => Reflect.field(params, f)
		];
		return [path=>pMap];
	}

	public function restoreParams(m:Map<String,String>):Dynamic
	{
		var p:Dynamic = {};
		for(k=>v in m.keyValueIterator())
			Reflect.setField(p,k,v);
		return p;
	}

	/**
	 * PAGER HANDLING
	 */
	public static function renderPager(comp:Dynamic):ReactFragment
	{
		trace('pageCount=${comp.state.pageCount}');
		
		//trace(jsx('<div className="paginationContainer">React Paginate</div>'));
		return jsx('
		<div className="paginationContainer">
			<nav>
				<$ReactPaginate previousLabel=${'<'} breakLinkClassName=${'pagination-link'}
					pageLinkClassName=${'pagination-link'}					
					nextLinkClassName=${'pagination-next'}
					previousLinkClassName=${'pagination-previous'}
					nextLabel=${'>'}
					breakLabel=${'...'}
					breakClassName=${'break-me'}
					pageCount=${comp.state.pageCount}
					marginPagesDisplayed={2}
					pageRangeDisplayed={5}
					onPageChange=${function(data){
						trace('${comp.props.match.params.action}  ${data.selected}');
						var fun:Function = Reflect.field(comp,comp.props.match.params.action);
						if(Reflect.isFunction(fun))
						{
							Reflect.callMethod(comp,fun,[{page:data.selected}]);
						}
						//onPageChange(comp);
					}}
					containerClassName=${'pagination  is-small'}
					subContainerClassName=${'pages pagination'}
					activeLinkClassName=${'is-current'}/>
			</nav>	
		</div>		
		');
	}
	
}