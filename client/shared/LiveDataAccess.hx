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
			var aState:AppState = getState();
			//trace(aState.dataStore.selectedData);
			var sData = aState.dataStore.selectedData;
			if(props.id != null)
			//trace('sData.keys().hasNext():${sData.get(props.id)}');
			//trace(sData);
			//trace(props);
			switch(props.selectType)
			{
				case All:
					sData = new IntMap();
					for(k=>v in props.data.keyValueIterator())
						sData.set(k,v);
				case One:
					sData.set(props.id,props.data.get(props.id));
				case Unselect:
					sData.remove(props.id);
				case UnselectAll:
					sData = new IntMap();
				default:
					sData = new IntMap();
					sData.set(props.id,props.data.get(props.id));
			}
			var baseUrl:String = props.match.path.split(':section')[0];
			baseUrl = '${baseUrl}${props.match.params.section}/${props.match.params.action}';	
			aState.appWare.history.push('${baseUrl}/${FormApi.params(sData.keys().keysList())}');
			dispatch(DataAction.Select(props.data));
			/**
			 * 				var state = store.getState();
				var sData = state.dataStore.selectedData;
				var baseUrl:String = match.path.split(':section')[0];
				baseUrl = '${baseUrl}${match.params.section}/${match.params.action}';	
				state.appWare.history.push('${baseUrl}/${FormApi.params(sData.keys().keysList())}');
			 */
			return null;		
		});
	}

}