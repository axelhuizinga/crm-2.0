package shared;

import haxe.ds.IntMap;
import react.router.RouterMatch;
import js.html.Blob;
import state.UserState;
import state.AppState;
import action.AppAction;
import action.async.DataAction;
import haxe.ds.Either;
import haxe.Serializer;
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

	public static function select(props:LiveDataProps) 
	{
		return Thunk.Action(function(dispatch:Dispatch, getState:Void->AppState){
			if(props.id == null)
				return null;
			var aState:AppState = getState();
			var tableRoot:Array<String> = FormApi.getTableRoot(props.match);
			trace(tableRoot);
			var sData:IntMap<Map<String,Dynamic>> = null;
			switch(tableRoot[1])
			{
				case 'Accounts':
					sData = aState.dataStore.accountData;					
					sData = selectType(props.id, props.data, sData, props.selectType);
					aState.appWare.history.push('${tableRoot[2]}/${FormApi.params(sData.keys().keysList())}');
					return dispatch(DataAction.SelectAccounts(props.data));				
				case 'Contacts':
					sData = aState.dataStore.contactData;
					sData = selectType(props.id, props.data, sData, props.selectType);
					trace('${tableRoot[2]}/${FormApi.params(sData.keys().keysList())}');
					aState.appWare.history.push('${tableRoot[2]}/${FormApi.params(sData.keys().keysList())}');
					return dispatch(DataAction.SelectContacts(props.data));
				case 'Deals':
					sData = aState.dataStore.dealData;
					sData = selectType(props.id, props.data, sData, props.selectType);
					aState.appWare.history.push('${tableRoot[2]}/${FormApi.params(sData.keys().keysList())}');
					return dispatch(DataAction.SelectDeals(props.data));
				default:
					return null;
			}		
		});
	}

	static function selectType(id:Dynamic,data:IntMap<Map<String,Dynamic>>,sData:IntMap<Map<String,Dynamic>>, sT:SelectType):IntMap<Map<String,Dynamic>>
	{
		switch(sT)
		{
			case All:
				sData = new IntMap();
				for(k=>v in data.keyValueIterator())
					sData.set(k,v);
			case One:
				sData.set(id,data.get(id));
			case Unselect:
				sData.remove(id);
			case UnselectAll:
				sData = new IntMap();
			default:
				sData = new IntMap();
				sData.set(id,data.get(id));
		}
		return sData;
	}

}