package store;
import me.cunity.debug.Out;
import action.StatusAction;
import action.async.UserAccess;
import state.UserState;
import action.DataAction;
import react.ReactSharedInternals.Update;
import App;
import action.AppAction;
import haxe.Http;
import haxe.Json;
import haxe.Constraints.Function;
import haxe.ds.StringMap;
import js.Browser;
import js.Cookie;
import js.Promise;
import react.ReactUtil.copy;
import redux.IMiddleware;
import redux.IReducer;
import redux.StoreMethods;
import react.router.ReactRouter;
import history.BrowserHistory;
import history.History;
import state.CState;
import state.AppState;
import state.StatusState;
import Webpack.*;
using StringTools;
using shared.Utils;
/**
 * ...
 * @author axel@cunity.me
 */

class AppStore 
	implements IReducer<AppAction, AppState>
	implements IMiddleware<AppAction, AppState>
{
	public var initState:AppState;
		
	public var store:StoreMethods<AppState>;
	
	public function new() 
	{
		//var user = new UserStore();
		initState = {			 
			status: {
				date:Date.now(),
				path: Browser.location.pathname,
				text: '',
				userState:null
			},
			userState:null
		};
		trace(store);
	}
	
	public function reduce(state:AppState, action:AppAction):AppState
	{
		trace(Reflect.fields(state));
		trace(action);
		return switch(action)
		{
			case ApplySubState(subState):
				copy(state,subState);
			case Data(dataAction):
				trace(dataAction);
				switch (dataAction)
				{
					case ContactsLoaded(data):
					trace(data.dataRows);
					copy(state,
						{dataStore:{contactsDbData:data}});
					case QCsLoaded(data):
						trace(data.dataRows.length);
						copy(state,							
							{dataStore:{qcData:Utils.dynArray2IntMap(data.dataRows,'lead_id')}});
							//{dataStore:{qcData:data}});
					default:
						state;
				}
			/*case Status(action):
				copy(state,
					{status:{text:'666'}});				
			case FormChange(cfp, fState):
				var formStates = state.formStates;
				if(formStates.exists(cfp))
				{
					formStates.set(cfp, copy(formStates.get(cfp),fState));
				}
				else
				{
					formStates.set(cfp,fState);
				}
				copy(state,{
					formStates:formStates
				});		*/
			default:
				state;
		}
	}
	
	public function middleware(action:AppAction, next:Void -> Dynamic)
	{
		return switch(action)
		{			
			/*case GlobalState(key, value):
				trace('eating global $key=>$value');
				next();
			//case DataLoaded(component:String,sData:IntMap<Map<String,Dynamic>>):
			case DataLoaded(component,sData):
				next();
			*/	
			case Status(action):
				//trace(action);
				//store.dispatch(action);
				next();
			/*	
				
			case Status(status):
				trace(status);
				//Out.dumpStack(CallStack.callStack());ReduxAction
				//store.dispatch(StatusAction.Status(status));
				next();
			case Data(action):
				//store.dispatch(action);		
				next();
			//case Thunk.Action(f):
				//store.dispatch(action);
			case Status(action):	
				store.dispatch(action);
			case Location(action):
				store.dispatch(action);*/
			case User(action):
				store.dispatch(action);
				//next();
			//default: next();
			default: 
				//trace(action);
				//store.dispatch(action);
				next();
				//store.dispatch(action);
		}
	}
	
}