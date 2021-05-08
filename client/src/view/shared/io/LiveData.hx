package view.shared.io;

import tools.ClassInfo;
import action.DataAction;
import action.DataAction.SDataProps;
import action.async.CRUD;
import haxe.ds.IntMap;
import model.Deal;
import shared.DbData;
import js.lib.Promise;
import db.DBAccessProps;
import action.DataAction.SelectType;
import me.cunity.debug.Out;
import model.ORM;
import react.ReactComponent;
import react.ReactEvent;
import react.ReactMacro.jsx;
import react.ReactPaginate;
import react.ReactRef;
import react.ReactUtil;
import react.ReactUtil.copy;
import state.FormState;
import view.shared.io.DataFormProps;

using shared.Utils;

class LiveData {

	// Map Parent View classPath => Map model=>IntMap id=>FormView
	static var forms:Map<String, Map<String,IntMap<FormView>>> = new Map();

	public static var form = function(props:DataFormProps, view:ReactComponentOf<DataFormProps,FormState>):ReactFragment {
		return jsx('<div key="dummy">Dummy</div>');		
	}
	
	static function createFormView(props:DataFormProps, view:ReactComponentOf<DataFormProps,FormState>):FormView 
	{
		var formView:FormView = {
			form:form(props, view),
			orm:null,
			props: props,
			view: view
		};
		loadORM(			
			props.id,
			{
				classPath:'data.Deals',
				action:'get',
				filter:{id:props.id,mandator:1},
				resolveMessage:{
					success:'Spende ${props.id} wurde geladen',
					failure:'Spende ${props.id} konnte nicht geladen werden'
				},
				table:'deals',
				then: function(data:DbData){
					trace(data.dataRows.length); 
					if(data.dataRows.length==1)
					{
						var data = data.dataRows[0];
						trace(data);
						//if( mounted)
						var deal = new Deal(data);
						trace(deal.id);				
						//setState({loading:false, actualState:deal, initialData: copy(deal)});
						//state = copy(state, {loading:false});
						deal.state.actualState = deal;
						//state.actualStates.set(deal.id,deal);
						trace(untyped deal.state.actualState.id + ':' + deal.state.actualState.fieldsInitalized.join(','));
						//setState({});
						//trace(props.match);
						//trace(props.location.pathname + ':' + untyped state.actualState.amount);
						//trace(Reflect.fields(props));
						//trace(Reflect.fields(props.parentComponent.props));
						//props.history.replace(props.location.pathname.replace('open','update'));
						props.parentComponent.registerORM('deals',deal);
					}
				},
				dbUser:props.userState.dbUser,
				devIP:App.devIP
			});

		return formView;
	}

	public static function create(props:DataFormProps, view:ReactComponentOf<DataFormProps,FormState>):FormView 
	{	
		//var cL:Dynamic = Type.getClass(view);
		var viewPath:String = ClassInfo.classPath(view);
		if(viewPath!=null){
			//var viewPath = Type.getClassName(cL);
			trace('>${props.model}<');
			if(props !=null && props.model!= null){	
				trace(props.model);		
				if(forms.exists(viewPath)){
					// UPDATE
				}
				else
				{
					// CREATE
					forms.set(viewPath, [props.model=>[props.id=>createFormView(props, view)]]);
				}				 
				return forms.get(viewPath).get(props.model).get(props.id);
			}
		}
		return null;
	}

	/**
	 * 			load: function(param:DBAccessProps) return dispatch(CRUD.read(param)),
			loadData:function(id:Int = -1, me:Dynamic) return me.loadData(id),
			save: function(me:Dynamic) return me.update(),
	 * @param viewPath 
	 * @param orm 
	 * @param sType 
	 */

	public static function loadORM1(param:DBAccessProps, viewPath:String,?sType:SelectType = SelectType.One) {
		trace(viewPath +':' + forms.exists(viewPath));
		/*if(forms.exists(viewPath)){
			switch(sType){
				case One:
					forms.get(viewPath).orms.clear();
					forms.get(viewPath).orms.set(orm.id,orm);
				default:
					trace(sType);

			}
			
			trace(forms.get(viewPath).orms.keys().hasNext());
			//setState({ormRefs:ormRefs});
			//setState(copy(state,{ormRefs:ormRefs}));
			//state.ormRefs = ormRefs;
			trace(Reflect.fields(state));
			//setState({ormRefs:ormRefs});
		}
		else{
			trace('OrmRef $viewPath not found!');
		}*/
	}	

	public static function loadORM(id:Int, param:DBAccessProps):Void
	{
		trace('loading:$id');
		if(id == null)
			return;
		var p:Promise<DbData> = cast App.store.dispatch(CRUD.read(
			param
		));
		
		p.then(function(data:DbData)  trace(data));
		//p.then(function(data:DbData)  param.then(data));
		/*var p:Promise<DbData> = cast App.store.dispatch(CRUD.read(
			param
		));
		p.then(function(data:DbData){
			trace(data.dataRows.length); 
			if(data.dataRows.length==1)
			{
				var data = data.dataRows[0];
				trace(data);
				//if( mounted)
				var deal:Deal = new Deal(data);
				trace(deal.id);				
				/*setState({loading:false, actualState:deal, initialData: copy(deal)});
				//state = copy(state, {loading:false});
				deal.state.actualState = deal;
				state.actualStates.set(deal.id,deal);
				trace(untyped deal.state.actualState.id + ':' + deal.state.actualState.fieldsInitalized.join(','));
				//setState({});
				//trace(props.match);
				//trace(props.location.pathname + ':' + untyped state.actualState.amount);
				//trace(Reflect.fields(props));
				//trace(Reflect.fields(props.parentComponent.props));
				//props.history.replace(props.location.pathname.replace('open','update'));
				//props.parentComponent.registerORM('deals',deal);
			}
		});*/
	}	

	public static function registerORM(parent:Dynamic, refModel:String,orm:ORM) {
		if(parent.ormRefs.exists(refModel)){
			parent.ormRefs.get(refModel).orms.set(orm.id,orm);
			trace(refModel);
			parent.setState({ormRefs:parent.ormRefs});
			//setState(copy(state,{ormRefs:ormRefs}));
			//state.ormRefs = ormRefs;
			//trace(Reflect.fields(state));
			//setState({ormRefs:ormRefs});
		}
		else{
			trace('OrmRef $refModel not found!');
		}
	}

	public static function  select(props:SDataProps){
		var actPath:Array<String> = FormApi.getTableRoot(props.match);			
		trace(actPath);
		var sData:IntMap<Map<String,Dynamic>> = App.store.getState().dataStore.returnDebitsData;
		switch(actPath[1])
		{
			case 'ReturnDebits':
				sData = selectType(props.id, props.data, sData, props.selectType);
				//trace(sData);
				trace('${actPath[2]}/${Std.parseInt(props.data.get(props.id).get('deal_id')) }');
				trace(props.match.params);
				trace(props.match.path);
				App.store.getState().locationStore.history.push('${actPath[2]}/${FormApi.params(sData.keys().keysList())}',
				{activeContactUrl:'${actPath[2]}/${FormApi.params(sData.keys().keysList())}'});
				App.store.dispatch(DataAction.SelectReturnDebits(sData));
				//resolve(sData);//
				return sData;
			default:
				return null;
				//null;
				
		}					
	} 

	static function selectType(id:Int,data:IntMap<Map<String,Dynamic>>,sData:IntMap<Map<String,Dynamic>>, sT:SelectType):IntMap<Map<String,Dynamic>>
	{
		if(sData==null)
			sData = new IntMap();
		return switch(sT)
		{
			case All:
				for(k=>v in data.keyValueIterator())
					sData.set(k,v);
				sData;
			case One:
				[id => data.get(id)];
			case Unselect:
				sData.remove(id);
				sData;
			case UnselectAll:
				sData = new IntMap();
			default:
				trace(data);
				[id => data.get(id)];
		}	
	}
}