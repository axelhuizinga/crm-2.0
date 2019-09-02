package state;
import action.AppAction;
import haxe.ds.StringMap;
import history.Action;
import history.Location;
import state.AppState;
import react.ReactComponent;
import react.ReactUtil.copy;
import redux.Store;
import js.Promise;

/**
 * ...
 * @author axel@cunity.me
 */
class CState 
{
	static var store:Store<AppState>;
	
	public static function confirmTransition(message:String, callback:Bool->Void)
	{
		trace(message);
		if (store.getState().locationState.location.pathname == '/')
		{
			return callback(true);
		}
		callback(true);
	}
	
	public static function blockTransition(location:Location, action:Action):String
	{
		trace(location.pathname);
		trace(action);
		return location.pathname;
	}
	
	public static function historyChange(location:Location, action:Action):Bool
	{
		trace(location);
		trace(action);
		return false;
	}
	
	/*public static function addComponent(comp:ReactComponent):Void
	{
		var state:AppState = store.getState();
		var d:Promise<Dynamic> = store.dispatch(AppAction.AddComponent(
			comp.props.match.url.split('/')[1],
			{
				clean:true,
				matchUrl:comp.props.match.url,
				pathname:comp.props.history.location.pathname,
				formFields:new StringMap(),
				isMounted:true,
				lastMounted:Date.now()
			}
		));
		trace(Promise.resolve(d));
			//function(t:Dynamic){trace(t); }, 
			//function(t){trace ('oops:$t');}));
		trace(comp.props.history.location);
	}*/
	
	//function fulFill(
	
	public static function init(store:Store<AppState>)
	{
		CState.store = store;
		return;
		var state:AppState = store.getState();
		var unblock = state.locationState.history.block(blockTransition);
		trace(unblock);
		state.locationState.history.listen(CState.historyChange);
	}

}
//		)).then(fulFill:PromiseCallback<Dynamic, Dynamic>, ?reject:EitherType<Dynamic->Void,PromiseCallback<Dynamic, Dynamic>>)
