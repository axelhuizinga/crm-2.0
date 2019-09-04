package action.async;

import state.State;

import action.Thunk;
import action.ConfigAction;

import js.Browser.console;

class ConfigThunk {

    static public function init(cb : Void -> Void) : Thunk {
        return function initThunk(dispatch, getState) {
            var config : dto.Parameters = CompileTime.parseJsonFile("app/config/parameters.json");
            var a : ReduxAction = new ConfigReduxAction(ReceiveLaunchParams(config));
            dispatch(a);
            cb();
        }
    }
}
