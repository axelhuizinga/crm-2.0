package action.async;

import js.Browser;
import react.router.ReactRouter;
import js.lib.Promise;
import haxe.ds.StringMap;
import haxe.ds.IntMap;
import react.router.RouterMatch;
import js.html.Blob;
import state.UserState;
import state.AppState;
import action.AppAction;
import action.DataAction;
import haxe.ds.Either;

import haxe.http.HttpJs;
import state.DataAccessState;

import js.html.XMLHttpRequest;

import redux.Redux.Dispatch;
import redux.thunk.Thunk;
import shared.DbData;
import loader.BinaryLoader;
import view.shared.OneOf;
import view.shared.io.FormApi;

using shared.Utils;

/**
 * ...
 * @author axel@cunity.me
 */

class LiveDataAccess
{
	public static function create() {
		
	}

	public static function delete() {
		
	}

	public static function storeData(id:String, action:DataAction) 
	{
		return Thunk.Action(function(dispatch:Dispatch, getState:Void->AppState){
			if(id == null)
				return null;
			var aState:AppState = getState();
			trace(aState.dataStore.contactsData);
			switch (id)
			{
				case 'Contacts':
				switch(action)
				{
					case Restore:
					return dispatch(DataAction.Restore);
					default:
					return null;					
				}
				default:
				return null;
			}
		});
	}

	public static function select(props:LiveDataProps) 
	{
		return Thunk.Action(function(dispatch:Dispatch, getState:Void->AppState){
			if(props.id == null){
				trace(Reflect.fields(props).join('|'));
				return null;

			}

			var aState:AppState = getState();
			//trace(aState);
			var tableRoot:Array<String> = FormApi.getTableRoot();			
			trace(tableRoot);
			trace(Reflect.fields(aState));
			//trace(aState);
			trace(props.data);
			var sData:IntMap<Map<String,Dynamic>> = null;
			switch(tableRoot[1])
			{
				case 'Accounts':
					sData = aState.dataStore.accountData;					
					sData = selectType(props.id, props.data, sData, props.selectType);
					aState.locationStore.history.push('${tableRoot[2]}/${FormApi.params(sData.keys().keysList())}');
					return dispatch(DataAction.SelectAccounts(props.data));				
				case 'Contacts':
					sData = aState.dataStore.contactsData;
					//trace(sData);
					//trace(Type.getInstanceFields(Type.getClass(sData)));
					sData = selectType(props.id, props.data, sData, props.selectType);
					trace('${tableRoot[2]}/${FormApi.params(sData.keys().keysList())}');
					//trace(Type.getClassName(Type.getClass(props.component.state.sideMenuInstance)));
					//trace(props.component.state.sideMenu);
					if(props.component.state.sideMenuInstance!=null)
						 props.component.state.sideMenuInstance.enableItems('List',['edit','delete','selectionClear']);
					//trace(Reflect.fields(props.component.state).join('|'));
					//if(props.component != null){
					//aState.locationStore.history.push('${tableRoot[2]}#${FormApi.params(sData.keys().keysList())}',					{activeContactUrl:'${tableRoot[2]}#${FormApi.params(sData.keys().keysList())}'});
					return dispatch(DataAction.SelectContacts(sData));
					//return dispatch(DataAction.SelectContacts(props.data, props.selectType));
					//dispatch(LocationAction(Push()))
				case 'Deals':
					sData = aState.dataStore.dealData;
					//trace(sData);
					sData = selectType(props.id, props.data, sData, props.selectType);
					trace(sData);
					trace('${tableRoot[2]}/${FormApi.params(sData.keys().keysList())}');
					aState.locationStore.history.push('${tableRoot[2]}#${FormApi.params(sData.keys().keysList())}',
					{activeContactUrl:'${tableRoot[2]}#${FormApi.params(sData.keys().keysList())}'});
					return dispatch(DataAction.SelectDeals(props.data));
				case 'QC':
					//sData = aState.dataStore.qcData;
					//trace(sData);
					//trace(Type.getInstanceFields(Type.getClass(sData)));
					sData = selectType(props.id, props.data, aState.dataStore.qcData, props.selectType);
					trace('${tableRoot[2]}/${FormApi.params(sData.keys().keysList())}');
					trace(sData);
					//return dispatch(AppAction.Data(sData));					
					return dispatch(DataAction.SelectQCs(sData));					
					//aState.locationStore.history.push('${tableRoot[2]}#${FormApi.params(sData.keys().keysList())}',					{activeContactUrl:'${tableRoot[2]}#${FormApi.params(sData.keys().keysList())}'});
				default:
					return null;
			}		
		});
	}

	static function selectType(id:Dynamic,data:IntMap<Map<String,Dynamic>>,sData:IntMap<Map<String,Dynamic>>, sT:SelectType):IntMap<Map<String,Dynamic>>
	{	//trace(Type.getInstanceFields(Type.getClass(sData)));
		return switch(sT)
		{
			case All:
				sData = new IntMap();
				for(k=>v in data.keyValueIterator())
					sData.set(k,v);
				sData;
			case One:
				/*sData.set(id,data.get(id));
				sData;*/
				[id => data.get(id)];
			case Unselect:
				sData.remove(id);
				sData;
			case UnselectAll:
				sData = new IntMap();
			default:
				trace(data);
				sData = new IntMap();
				sData.set(id,data.get(id));
				sData;
		}	
	}
	
	public static function  sSelect(props:SDataProps)
	{
		return Thunk.Action(function(dispatch:Dispatch, getState:Void->AppState){
			if(props.id == null)
				return null;
			trace(props.data);
			var aState:AppState = getState();
			var tableRoot:Array<String> = FormApi.getTableRoot();			
			trace(tableRoot);
			//trace(Reflect.fields(aState));
			//trace(aState);function(resolve, reject)
			//trace(props.data);
			var sData:IntMap<Map<String,Dynamic>> = null;
			return new Promise(function(resolve, reject){
				switch(tableRoot[1])
				{
					/*case 'Accounts':
						sData = aState.dataStore.accountData;					
						sData = sSelectType(props.id, props.data, sData, props.selectType);
						aState.locationStore.history.push('${tableRoot[2]}/${FormApi.params(sData.keys().keysList())}');
						return dispatch(DataAction.SelectAccounts(props.data));				
					case 'Contacts':
						sData = aState.dataStore.contactsData;
						//trace(sData);
						sData = selectType(props.id, props.data, sData, props.selectType);
						trace('${tableRoot[2]}/${FormApi.params(sData.keys().keysList())}');
						trace(sData);
						aState.locationStore.history.push('${tableRoot[2]}#${FormApi.params(sData.keys().keysList())}',
						{activeContactUrl:'${tableRoot[2]}#${FormApi.params(sData.keys().keysList())}'});
						//dispatch(LocationAction(Push()))
						return dispatch(DataAction.SelectContacts(props.data));
					case 'Deals':
						sData = aState.dataStore.dealData;
						//trace(sData);
						sData = selectType(props.id, props.data, sData, props.selectType);
						trace(sData);
						trace('${tableRoot[2]}/${FormApi.params(sData.keys().keysList())}');
						aState.locationStore.history.push('${tableRoot[2]}#${FormApi.params(sData.keys().keysList())}',
						{activeContactUrl:'${tableRoot[2]}#${FormApi.params(sData.keys().keysList())}'});
						return dispatch(DataAction.SelectDeals(props.data));*/
					case 'ReturnDebits':
						sData = sSelectType(props.id, props.data, sData, props.selectType);
						//trace(sData);
						//trace(Type.getClass(props.data));
						//if(props.data!=null&&props.data.exists(props.id))
						//trace('${tableRoot[2]}/${Std.parseInt(props.data.get(props.id).get('deal_id')) }');
						//trace(props.match.params);
						//trace(props.match.path);
						aState.locationStore.history.push('${tableRoot[2]}/${FormApi.params(sData.keys().keysList())}',
						{activeUrl:'${tableRoot[2]}/${FormApi.params(sData.keys().keysList())}'});
						dispatch(DataAction.SelectReturnDebits(sData));
						resolve(sData);//
					default:
						//return null;
						null;
						
				}
			});	
		});
	}

	static function sSelectType(id:Int,data:IntMap<Map<String,Dynamic>>,sData:IntMap<Map<String,Dynamic>>, sT:SelectType):IntMap<Map<String,Dynamic>>
	{
		trace(sT);
		trace(data);
		return switch(sT)
		{
			case All:
				sData = new IntMap();
				for(k=>v in data.keyValueIterator())
					sData.set(k,v);
				sData;
			case One:
				/*if(sData==null)
					sData = new IntMap();
				sData.set(id,data.get(id));
				sData;*/
				[id => data.get(id)];
			case Unselect:
				sData.remove(id);
				sData;
			case UnselectAll:
				sData = new IntMap();
			default:
				trace(data);
				sData = new IntMap();
				sData.set(id,data.get(id));
				sData;
		}	
	}

	static function sSelectType1(id:Dynamic,data:StringMap<Map<String,Dynamic>>,sData:StringMap<Map<String,Dynamic>>, sT:SelectType):StringMap<Map<String,Dynamic>>
	{
		return switch(sT)
		{
			case All:
				sData = new StringMap();
				for(k=>v in data.keyValueIterator())
					sData.set(k,v);
				sData;
			case One:
				if(sData==null)
					sData = new StringMap();
				sData.set(id,data.get(id));
				sData;
			case Unselect:
				sData.remove(id);
				sData;
			case UnselectAll:
				sData = new StringMap();
			default:
				trace(data);
				sData = new StringMap();
				sData.set(id,data.get(id));
				sData;
		}	
	}			
}